const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const verifyAuthToken = require('../utils/requireAuth.js');
const notificationHandler = require('../utils/notificationHandler.js'); // Importez le gestionnaire de notifications
const socketManager = require('../utils/socketManager.js'); // Importez le gestionnaire de sockets pour accéder à `io`

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


        const response = feedResult;
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
            const [likerInfo] = await executeQuery(`SELECT userName FROM users WHERE userID = ? ;`, [userID]);

            if (likerInfo) {
                const { userName: likerName } = likerInfo;

                // Insertion de la notification dans la table notifications
                const notificationContent = `${likerName} a aimé votre publication.`;
                const notificationTitle = 'Nouveau like';
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
            } else {
                const response = {
                    error : true,
                    error_message : ' Invalid user ID, post ID, or comment content ',
                    error_code : 9
                }
                return res.status(500).json(response);
            }
        }

        const response = {
                error : true,
                error_message : 'Failed to process like',
                error_code : 7
        }
        return res.status(500).json(response);
    });


router.route('/comments')
    .get (async (req,res) => {
        const postID = req.body.postid;

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
            return res.status(200).json(response);
        }
        const response = {
            error : true,
            error_message : 'Failed to process comment',
            error_code : 10
        }
        return res.status(500).json(response);
    })
    .post(async (req, res) => {
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
    .post(async (req,res)=> {
        
    })

module.exports = router;
