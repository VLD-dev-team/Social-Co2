const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const { verifyAuthToken } = require('../utils/requireAuth.js');
const { newNotif } = require('../websocket/notificationHandler.js'); // Importez le gestionnaire de notifications
const admin = require('firebase-admin');
const getDay = require('../utils/getDay.js')



router.route('/*')
    .all((req, res, next) => verifyAuthToken(req, res, next));

router.route('/feed')
    .get(async (req, res) => {
        // Chargement du feed
        const userID = req.headers.userid;

        const getFriendsQuery = `
            SELECT userID1, userID2
            FROM friends
            WHERE (userID1 = ? OR userID2 = ?) AND friendshipStatus = '22' ;
        `;
        const friendsResult = await executeQuery(getFriendsQuery, [userID, userID]);

        // Extraire les IDs des amis (-:
        const friendIDs = friendsResult.map(friendship => {
            return friendship.userID1 === userID ? friendship.userID2 : friendship.userID1;
        });

        friendIDs.push(userID);

        // Il nous faut nos posts et ceux de nos amis
        const getFeedQuery = `
            SELECT *
            FROM posts
            WHERE userID IN (?)
            ORDER BY postCreatedAt DESC ;`;
        const feedResult = await executeQuery(getFeedQuery, [friendIDs]);


        const feed = await Promise.all(feedResult.map(async (post) => {
            const postData = await admin.auth().getUser(post.userID);
            let surname = postData.displayName;
            let photoURL = postData.photoURL;
            if (typeof postData.displayName !== "string") {
                surname = null
            }
            if (typeof postData.photoURL !== "string") {
                photoURL = null
            }
            const getLikeBool = `
                SELECT *
                FROM likes
                WHERE userID = ? AND postID = ?;`;
            const getLikeBoolResult = await executeQuery(getLikeBool, [postData.uid, post.postID]);
            let like = false
            if (getLikeBoolResult.length > 0) {
                like = true
            }
            let postLinkedActivityStr = post.postLinkedActivity;
            let postLinkedActivity = {};
            if (postLinkedActivityStr !== null && typeof postLinkedActivityStr === 'string') {
                // Expression régulière pour extraire les paires clé-valeur
                const regex = /"([^"]+)":\s*([^,}]+)/g;
                let match;
                while ((match = regex.exec(postLinkedActivityStr)) !== null) {
                    const key = match[1];
                    let value = match[2];
                    // Traitement spécial pour les valeurs non numériques
                    if (!/^-?\d+$/.test(value)) {
                        // On supp les espaces et les guillemets
                        value = value.trim().replace(/^"(.*)"$/, '$1');
                    } else {
                        // On convertit les valeurs numériques en nombre
                        value = Number(value);
                    }
                    postLinkedActivity[key] = value;
                }
                // On remplace notre date par une date ISO valide
                // const date = new Date(postLinkedActivity["activityTimestamp"]);
                // const isoDateString = date.toISOString();
                // postLinkedActivity["activityTimestamp"] = isoDateString
            }

            return {
                uid: postData.uid,
                name: surname,
                photoURL: photoURL,
                postID: post.postID,
                postTextContent: post.postTextContent,
                postMediaContentURL: post.postMediaContentURL,
                postLinkedActivity: postLinkedActivity,
                postLikesNumber: post.postLikesNumber,
                postCreatedAt: post.postCreatedAt,
                postCommentsNumber: post.postCommentsNumber,
                postType: post.postType,
                like: like
            };
        }));


        const response = {
            feed: feed,
            message: "posts was loading succesfully !"
        };
        return res.status(200).json(response);
    });

router.route('/like')
    .post(async (req, res) => {
        // Pour liker un post
        const userID = req.headers.userid;
        const postID = req.body.postid;

        if (typeof userID !== 'string' || isNaN(postID)) {
            const response = {
                error: true,
                error_message: 'Invalid user ID or post ID',
                error_code: 5
            }
            return res.status(400).json(response);
        }

        // Vérification de si l'utilisateur a déjà liké ce post, si oui alors on envoie une erreur
        const checkLikeQuery = `SELECT * FROM likes WHERE userID = ? AND postID = ? ;`;
        const checkLikeResult = await executeQuery(checkLikeQuery, [userID, postID]);

        if (checkLikeResult.length > 0) {
            await executeQuery('DELETE FROM likes WHERE userID = ? AND postID = ? ;', [userID, postID])
            await executeQuery(`UPDATE posts SET postLikesNumber = postLikesNumber - 1 WHERE postID = ? ;`, [postID]);
            const response = {
                userID: userID,
                postID: postID,
                message: 'user has dislike the post'
            }
            return res.status(200).json(response)

        }

        // Insertion du like dans la table likes
        await executeQuery(`INSERT INTO likes (userID, postID) VALUES (?, ?);`, [userID, postID]);

        // Mise à jour du nombre de likes dans la table posts
        await executeQuery(`UPDATE posts SET postLikesNumber = postLikesNumber + 1 WHERE postID = ? ;`, [postID]);

        // Récupération du propriétaire du post
        const [postOwner] = await executeQuery(`SELECT userID FROM posts WHERE postID = ? ;`, [postID]);

        if (postOwner) {
            const { userID: postOwnerID } = postOwner;

            // Récupération du nom de l'utilisateur qui a liké
            let likerName = (await admin.auth().getUser(userID)).displayName;
            console.log(likerName)

            if (!likerName) {
                likerName = "Quelqu'un"
            }

            // Insertion de la notification dans la table notifications
            const notificationContent = `${likerName} a aimé votre publication.`;
            const notificationTitle = 'Nouveau like';
            const notificationStatus = 'unread';

            await executeQuery(`INSERT INTO notifications (userID, notificationContent, notificationTitle, notificationStatus) VALUES (?, ?, ?, ?) ;`, [postOwnerID, notificationContent, notificationTitle, notificationStatus]);

            // Émission de la notification via Socket.io
            await newNotif({ userID: postOwnerID, notificationContent });

            const NbLikesQuery = `SELECT postLikesNumber FROM posts WHERE postID = ? ;`;
            const NbLikesQueryResult = await executeQuery(NbLikesQuery, [postID]);

            const response = {
                NbLikes: NbLikesQueryResult
            }
            return res.status(200).json(response);
        }

        const response = {
            error: true,
            error_message: 'Failed to process like',
            error_code: 7
        }
        return res.status(500).json(response);
    });


router.route('/comments') // Route pour charger les commentaires
    .get(async (req, res) => {
        const postID = req.query.postid;
        const userID = req.headers.userid

        if (isNaN(postID)) {
            const response = {
                error: true,
                error_message: 'Invalid postID',
                error_code: 9
            }
            return res.status(400).json(response);
        }

        const authUser = await admin.auth().getUser(userID);

        const selectQuery = `SELECT * FROM comments JOIN users ON comments.userID = users.userID WHERE postID = ?;`
        const selectResult = await executeQuery(selectQuery, [postID])

        let response = {}; // On prépare la réponse
        if (selectResult.length > 0) {
            let comments = [];
            for (let each of selectResult) {
                const authUser = await admin.auth().getUser(each.userID);
                const element = {
                    "postID": each.postID,
                    "commentTextContent": each.commentTextContent,
                    "commentCreatedAt": each.commentCreatedAt,
                    "uid": authUser.uid,
                    "displayName": authUser.displayName,
                    "photoURL": authUser.photoURL
                };
                comments.push(element); // On ajoute chaque commentaire a la liste
            }
            response = {
                comments: comments,
                count: comments.length
            } // On renvoie le nombre de commentaire et la liste
            return res.status(200).json(response);
        }
        response = {
            error: true,
            error_message: 'Failed to process comment or no comments',
            error_code: 10
        }
        return res.status(500).json(response);
    })
    .post(async (req, res) => {
        // Pour creer un commentaire
        const userID = req.headers.userid;
        const postID = req.body.postid;
        const commentTextContent = req.body.commentTextContent;

        if (typeof userID !== 'string' || isNaN(postID) || typeof commentTextContent !== 'string') {
            const response = {
                error: true,
                error_message: 'Invalid user ID, post ID, or comment content',
                error_code: 9
            }
            return res.status(400).json(response);
        }

        // Insertion du commentaire dans la table comments
        const insertCommentQuery = `INSERT INTO comments (userID, postID, commentTextContent) VALUES (?, ?, ?) ;`;
        const insertCommentResult = await executeQuery(insertCommentQuery, [userID, postID, commentTextContent]);

        if (insertCommentResult.affectedRows > 0) {
            // Mise à jour du nombre de commentaires dans la table posts
            await executeQuery(`UPDATE posts SET postCommentsNumber = postCommentsNumber + 1 WHERE postID = ? ;`, [postID]);

            // Récupération du propriétaire du post
            const [postOwner] = await executeQuery(`SELECT userID FROM posts WHERE postID = ? ;`, [postID]);

            if (postOwner) {
                const { userID: postOwnerID } = postOwner;

                // Récupération du nom de l'utilisateur qui a commenté
                let commenterName = (await admin.auth().getUser(userID)).displayName;
                console.log(commenterName)

                if (!commenterName) {
                    commenterName = "Quelqu'un"
                }

                // Insertion de la notification dans la table notifications
                const notificationContent = `${commenterName} a commenté votre publication.`;
                const notificationTitle = 'Nouveau commentaire';
                const notificationStatus = 'unread';

                await executeQuery(`INSERT INTO notifications (userID, notificationContent, notificationTitle, notificationStatus) VALUES (?, ?, ?, ?) ;`, [postOwnerID, notificationContent, notificationTitle, notificationStatus]);

                // Émission de la notification via Socket.io
                await newNotif({ userID: postOwnerID, notificationContent });

                const response = {
                    userID: postOwnerID,
                    commentTextContent: commentTextContent
                }
                return res.status(200).json(response);

            }
            const response = {
                error: true,
                error_message: 'Failed to process comment',
                error_code: 10
            }
            return res.status(500).json(response);
        } else {
            const response = {
                error: true,
                error_message: 'Failed to add comment',
                error_code: 11
            }
            return res.status(500).json(response);
        }
    });


router.route('/posts')
    .post(async (req, res) => {
        const userID = req.headers.userid;
        const postType = req.body.postType;

        // Vérification des paramètres obligatoires
        if (!userID || !postType) {
            const response = {
                error: true,
                error_message: 'User ID and postType are required fields.',
                error_code: 1
            };
            return res.status(400).json(response);
        }

        // Création de la requête en fonction du postType pour éviter de définir plusieurs constantes
        let sqlQuery = '';
        let sqlValues = [];
        let response = {};

        switch (postType) { // On va gérer les différents types de posts
            case 'mood':
                const mood = req.body.mood
                // Vérification du paramètre moodPhrase
                if (!mood || typeof mood !== 'string') {
                    response = {
                        error: true,
                        error_message: 'moodType is required for postType "mood".',
                        error_code: 2
                    };
                    return res.status(400).json(response);
                }
                let Moodphrase = "";
                switch (mood) {
                    case 'Chanceux':
                        Moodphrase = Moodphrase + "Je suis d'humeur chanceuse aujourd'hui ! 🍀 🍀 🍀";
                        break;
                    case 'Heureux':
                        Moodphrase = Moodphrase + "Je suis heureux/se aujourd'hui ! 😃 😃 😃 "
                        break;
                    case 'Choqué':
                        Moodphrase = Moodphrase + "Je suis choqué/ée !!!! 😱 😱 😱 ";
                        break;
                    case 'Sans mots':
                        Moodphrase = Moodphrase + "Je suis sans mots de ce que je constate. 🤐 🤐 🤐 "
                        break;
                    case 'Hyper bien':
                        Moodphrase = Moodphrase + "Je suis trop trop bien aujourd'hui !!! 😁 😁 😁";
                        break;
                    case 'Malade':
                        Moodphrase = Moodphrase + "Je suis maladeeeee... 🤧 🤧 🤧  "
                        break;
                    case 'Bien':
                        Moodphrase = Moodphrase + "Je suis bieng ! 😀 😀 😀  ";
                        break;
                    case 'En colère':
                        Moodphrase = Moodphrase + "Je suis pas content !!! 😠 😠 😠"
                        break;
                    default:
                        response = {
                            error: true,
                            error_message: 'Invalid postType. Allowed values are "mood", "message", "activite", or "rapport".',
                            error_code: 6
                        };
                        return res.status(400).json(response);
                }
                sqlQuery = `INSERT INTO posts (userID, postTextContent, postType) VALUES (?, ?, ?);`;
                sqlValues = [userID, Moodphrase, 'mood'];
                response = {
                    message: 'Post has been created successfully.',
                    userID: userID,
                    postType: postType,
                    postTextContent: Moodphrase,
                }
                break;
            case 'message':
                // Vérification du paramètre postTextContent
                const postTextContent = req.body.postTextContent
                if (!postTextContent || typeof postTextContent !== 'string') {
                    response = {
                        error: true,
                        error_message: 'postTextContent is required for postType "message".',
                        error_code: 3
                    };
                    return res.status(400).json(response);
                }
                sqlQuery = `INSERT INTO posts (userID, postTextContent, postType) VALUES (?, ?, ?);`;
                sqlValues = [userID, postTextContent, 'message'];
                response = {
                    message: 'Post has been created successfully.',
                    userID: userID,
                    postType: postType,
                    postTextContent: postTextContent,
                }
                break;
            case 'activite':
                // Vérification des paramètres activityType et activityCO2Impact
                const activityID = req.body.activityid

                if (!activityID || isNaN(activityID)) {
                    const response = {
                        error: true,
                        error_message: 'Invalid activity ID',
                        error_code: 12
                    };
                    return res.status(400).json(response);
                }
                sqlQueryActivity = `SELECT * FROM activities WHERE activityID = ?`
                selectQueryActivityResult = await executeQuery(sqlQueryActivity, [activityID])
                console.log(selectQueryActivityResult)

                const activityType = selectQueryActivityResult[0].activityType
                const activityCO2Impact = selectQueryActivityResult[0].activityCO2Impact
                const activityName = selectQueryActivityResult[0].activityName
                const activityTimestamp = selectQueryActivityResult[0].activityTimestamp
                console.log({"activityType": activityType, "activityCO2Impact":activityCO2Impact, "activityName":activityName, "activityTimestamp":activityTimestamp})
                const postLinkedActivity = `{"activityType": ${activityType}, "activityCO2Impact": ${activityCO2Impact}, "activityName":${activityName}, "activityTimestamp":${activityTimestamp}}`
                console.log(postLinkedActivity);
                sqlQuery = `INSERT INTO posts (userID, postLinkedActivity, postType, postTextContent) VALUES (?, ?, ?, ?);`;
                sqlValues = [userID, postLinkedActivity, 'activite', req.body.postTextContent];
                response = {
                    message: 'Post has been created successfully.',
                    userID: userID,
                    postType: postType,
                    postLinkedActivity: {"activityType":activityType, "activityCO2Impact":activityCO2Impact, "activityName":activityName, "activityTimestamp":activityTimestamp},
                }
                break;
            case 'rapport':
                sqlQueryActivity = `
                SELECT * FROM activities 
                WHERE userID = ? 
                ORDER BY activityTimestamp DESC
                LIMIT 200 ;`;
                selectQueryActivityResult = await executeQuery(sqlQueryActivity,[userID])
                const rapport = {}
                const impact = {}
                if (selectQueryActivityResult.length > 0){
                    let maximum = selectQueryActivityResult[0].activityCO2Impact
                    let day = ""
                    for (activities in selectQueryActivityResult){
                        let rep = true
                        day = getDay(selectQueryActivityResult[activities].activityTimestamp)
                        console.log(day)
                        for (days in rapport){
                            if (day == days){
                                rapport[day].push(selectQueryActivityResult[activities])
                                impact[day] += selectQueryActivityResult[activities].activityCO2Impact
                                if (selectQueryActivityResult[activities].activityCO2Impact > maximum){
                                    maximum = selectQueryActivityResult[activities].activityCO2Impact
                                }
                                rep = false
                            }
                        }
                        if (rep == true){
                            rapport[day] = [selectQueryActivityResult[activities]]
                            impact[day] = selectQueryActivityResult[activities].activityCO2Impact
                            if (selectQueryActivityResult[activities].activityCO2Impact > maximum){
                                maximum = selectQueryActivityResult[activities].activityCO2Impact
                            }
                        }
                    }
                    const rapportDart = []
                    // Adaptation à dart
                    for (keys in rapport){
                        rapportDart.push({
                            "day" : keys,
                            "activities" : rapport[keys],
                            "impact" : impact[keys]
                        })
                    }
                    const rapportV1 = {
                        rapport : rapportDart,
                        impact : impact,
                        maximum : maximum
                    }

                    sqlQuery = `INSERT INTO posts (userID, postTextContent, postType) VALUES (?, ?, ?);`;
                    sqlValues = [userID, rapportV1, 'rapport'];
                    response = {
                        message: 'Post has been created successfully.',
                        userID: userID,
                        postType: postType,
                        postTextContent: rapportV1,
                    }
        
                } else {
                    response = {
                        rapport : {},
                        impact : {},
                        maximum : null,
                        message : "Aucune activité trouvée",
                        error : true
                    }
                }
                break;
            default:
                response = {
                    error: true,
                    error_message: 'Invalid postType. Allowed values are "mood", "message", "activite", or "rapport".',
                    error_code: 33
                };
                return res.status(400).json(response);
        }

        // Exécution de la requête SQL pour insérer le post dans la base de données
        try {
            const insertResult = await executeQuery(sqlQuery, sqlValues);
            if (insertResult.affectedRows > 0) {
                return res.status(201).json(response);
            } else {
                response = {
                    error: true,
                    error_message: 'Failed to create post',
                    error_code: 34
                };
                return res.status(500).json(response);
            }
        } catch (error) {
            console.error('Error creating post:', error);
            response = {
                error: true,
                error_message: 'Internal Server Error',
                error_code: 2
            };
            return res.status(500).json(response);
        }
    });


module.exports = router;
