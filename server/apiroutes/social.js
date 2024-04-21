const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const verifyAuthToken = require('../utils/requireAuth.js');
const notificationHandler = require('../utils/notificationHandler.js'); // Importez le gestionnaire de notifications
const socketManager = require('../utils/socketManager.js'); // Importez le gestionnaire de sockets pour accéder à `io`
const admin = require('firebase-admin');


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
                if (typeof postData.displayName !== "string"){
                    surname = null
                }
                if (typeof postData.photoURL !== "string"){
                    photoURL = null
                }
                const getLikeBool = `
                SELECT *
                FROM likes
                WHERE userID = ? AND postID = ?;`;
                const getLikeBoolResult = await executeQuery(getLikeBool, [postData.uid,post.postID]);
                let like = false
                if (getLikeBoolResult.length > 0){
                    like = true
                }
                return {
                    uid: postData.uid,
                    name: surname,
                    photoURL: photoURL,
                    postID : post.postID,
                    postTextContent : post.postTextContent,
                    postMediaContentURL : post.postMediaContentURL,
                    postLinkedActivity : post.postLinkedActivity,
                    postLikesNumber : post.postLikesNumber,
                    postCreatedAt : post.postCreatedAt,
                    postCommentsNumber : post.postCommentsNumber,
                    postType : post.postType,
                    like : like
                };
            }));


        const response = {
            feed: feed,
            message : "posts was loading succesfully !"
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
                    error : true,
                    error_message : 'Invalid user ID or post ID',
                    error_code : 5
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
                userID : userID,
                postID : postID,
                message : 'user has dislike the post'
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
                // const io = socketManager.getIO();
                // notificationHandler.handleNewNotification(io, { userID: postOwnerID, notificationContent });

                const NbLikesQuery = `SELECT postLikesNumber FROM posts WHERE postID = ? ;`;
                const NbLikesQueryResult = await executeQuery(NbLikesQuery, [postID]);

                const response = {
                        NbLikes : NbLikesQueryResult
                }
                return res.status(200).json(response);
        }

        const response = {
                error : true,
                error_message : 'Failed to process like',
                error_code : 7
        }
        return res.status(500).json(response);
    });


router.route('/comments') // Route pour charger les commentaires
    .get (async (req,res) => {
        const postID = req.query.postid;

        if(isNaN(postID)){
            const response = {
                error : true,
                error_message : 'Invalid postID',
                error_code : 9
        }
        return res.status(400).json(response);
        }

        const authUser = await admin.auth().getUser(userID);

        const selectQuery = `SELECT * FROM comments JOIN users ON comments.userID = users.userID WHERE postID = ?;`
        const selectResult = await executeQuery(selectQuery, [postID])

        if (selectResult.length > 0){
            let response = {};
            for (let each of selectResult) {
                const authUser = await admin.auth().getUser(each.userID);
                response[authUser.displayName] = selectResult[each];
            }
            const reponse = {
                comments: response
            }
            return res.status(200).json(reponse);
        }
        const response = {
            error : true,
            error_message : 'Failed to process comment',
            error_code : 10
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
                        error : true,
                        error_message : 'Invalid user ID, post ID, or comment content',
                        error_code : 9
                }
                return res.status(400).json(response);
            }

            // Insertion du commentaire dans la table comments
            const insertCommentQuery = `INSERT INTO comments (userID, postID, commentTextContent, commentCreatedAt) VALUES (?, ?, ?, CURRENT_TIMESTAMP) ;`;
            const insertCommentResult = await executeQuery(insertCommentQuery, [userID, postID, commentTextContent]);

            if (insertCommentResult.affectedRows > 0) {
                // Mise à jour du nombre de commentaires dans la table posts
                await executeQuery(`UPDATE posts SET postCommentsNumber = postCommentsNumber + 1 WHERE postID = ? ;`, [postID]);

                // Récupération du propriétaire du post
                const [postOwner] = await executeQuery(`SELECT userID FROM posts WHERE postID = ? ;`, [postID]);

                if (postOwner) {
                    const { userID: postOwnerID } = postOwner;

                    // Récupération du nom de l'utilisateur qui a commenté
                    const [commenterInfo] = await executeQuery(`SELECT userName FROM users WHERE userID = ? ;`, [userID]);

                    if (commenterInfo) {
                        const { userName: commenterName } = commenterInfo;

                        // Insertion de la notification dans la table notifications
                        const notificationContent = `${commenterName} a commenté votre publication.`;
                        const notificationTitle = 'Nouveau commentaire';
                        const notificationStatus = 'unread';

                        await executeQuery(`INSERT INTO notifications (userID, notificationContent, notificationTitle, notificationStatus) VALUES (?, ?, ?, ?) ;`, [postOwnerID, notificationContent, notificationTitle, notificationStatus]);

                        // Émission de la notification via Socket.io
                        const io = socketManager.getIO();
                        notificationHandler.handleNewNotification(io, { userID: postOwnerID, notificationContent });

                        const response = {
                                userID : postOwnerID,
                                notificationContent : notificationContent,
                                notificationTitle : notificationTitle,
                                notificationStatus : notificationStatus
                        }
                        return res.status(200).json(response);
                    }
                }
                const response = {
                        error : true,
                        error_message : 'Failed to process comment',
                        error_code : 10
                }
                return res.status(500).json(response);
            } else {
                const response = {
                        error : true,
                        error_message : 'Failed to add comment',
                        error_code : 11
                }
                return res.status(500).json(response);
            }
    });


router.route('/posts')
    .post( async (req, res) => {
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
                switch(mood){
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
                    userID : userID,
                    postType : postType,
                    postTextContent : Moodphrase,
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
                    userID : userID,
                    postType : postType,
                    postTextContent : postTextContent,
                    }
                break;
            case 'activite':
                // Vérification des paramètres activityType et activityCO2Impact
                const activityID = req.body.activityid
                
                if (!activityID || NaN(activityID)) {
                    const response = {
                        error: true,
                        error_message: 'Invalid activity ID',
                        error_code: 12
                    };
                    return res.status(400).json(response);
                }
                sqlQueryActivity = `SELECT * FROM activities WHERE activityID = ?`
                selectQueryActivityResult = await executeQuery(sqlQueryActivity,[activityID])
            
                const activityType = selectQueryActivityResult.activityType
                const activityCO2Impact = selectQueryActivityResult.activityCO2Impact
                const activityName = selectQueryActivityResult.activityName
                const activityTimestamp = selectQueryActivityResult.activityTimestamp
                sqlQuery = `INSERT INTO posts (userID, postLinkedActivity, postType) VALUES (?, ?, ?);`;
                sqlValues = [userID, JSON.stringify({activityType, activityCO2Impact, activityName, activityTimestamp }), 'activite'];
                response = {
                    message: 'Post has been created successfully.',
                    userID : userID,
                    postType : postType,
                    postLinkedActivity :  JSON.stringify({activityType, activityCO2Impact, activityName, activityTimestamp }),
                    }
                break;
            case 'rapport':
                sqlQueryActivity = `
                SELECT * FROM activities 
                WHERE userID = ? 
                ORDER BY activityTimestamp DESC, activityType ASC
                LIMIT 200 ;`
                selectQueryActivityResult = await executeQuery(sqlQueryActivity,[userID])
                const rapport = selectQueryActivityResult
                sqlQuery = `INSERT INTO posts (userID, postTextContent, postType) VALUES (?, ?, ?);`;
                sqlValues = [userID, JSON.stringify(rapport), 'rapport'];
                response = {
                    message: 'Post has been created successfully.',
                    userID : userID,
                    postType : postType,
                    postTextContent :  JSON.stringify(rapport),
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
