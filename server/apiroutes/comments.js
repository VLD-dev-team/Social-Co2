const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const verifyAuthToken = require('../utils/requireAuth.js');
const notificationHandler = require('../utils/notificationHandler.js'); // Importez le gestionnaire de notifications
const socketManager = require('../utils/socketManager.js'); // Importez le gestionnaire de sockets pour accéder à `io`

router.route('/*')
    .all((req, res, next) => verifyAuthToken(req, res, next));

router.route('/')
    .post(async (req, res) => {
        try {
            const userID = req.headers.id;
            const postID = req.body.postID;
            const commentTextContent = req.body.commentTextContent;

            if (typeof userID !== 'string' || isNaN(postID) || typeof commentTextContent !== 'string') {
                const response = {
                    errorJSON : {
                        error : true,
                        error_message : 'Invalid user ID, post ID, or comment content',
                        error_code : 400
                    },
                    status : 400,
                    type : 'error'
                }
                return res.status(400).json(response);
            }

            // Insertion du commentaire dans la table comments
            const insertCommentQuery = `INSERT INTO comments (userID, postID, commentTextContent, commentCreatedAt) VALUES (?, ?, ?, CURRENT_TIMESTAMP)`;
            const insertCommentResult = await executeQuery(insertCommentQuery, [userID, postID, commentTextContent]);

            if (insertCommentResult.affectedRows > 0) {
                // Mise à jour du nombre de commentaires dans la table posts
                await executeQuery(`UPDATE posts SET postCommentsNumber = postCommentsNumber + 1 WHERE postID = ?`, [postID]);

                // Récupération du propriétaire du post
                const [postOwner] = await executeQuery(`SELECT userID FROM posts WHERE postID = ?`, [postID]);

                if (postOwner) {
                    const { userID: postOwnerID } = postOwner;

                    // Récupération du nom de l'utilisateur qui a commenté
                    const [commenterInfo] = await executeQuery(`SELECT userName FROM users WHERE userID = ?`, [userID]);

                    if (commenterInfo) {
                        const { userName: commenterName } = commenterInfo;

                        // Insertion de la notification dans la table notifications
                        const notificationContent = `${commenterName} a commenté votre publication.`;
                        const notificationTitle = 'Nouveau commentaire';
                        const notificationStatus = 'unread';

                        await executeQuery(`INSERT INTO notifications (userID, notificationContent, notificationTitle, notificationStatus) VALUES (?, ?, ?, ?)`, [postOwnerID, notificationContent, notificationTitle, notificationStatus]);

                        // Émission de la notification via Socket.io
                        const io = socketManager.getIO();
                        notificationHandler.handleNewNotification(io, { userID: postOwnerID, notificationContent });

                        const response = {
                            notification : {
                                userID : postOwnerID,
                                notificationContent : notificationContent,
                                notificationTitle : notificationTitle,
                                notificationStatus : notificationStatus
                            },
                            status : 200,
                            type : 'response'
                        }
                        return res.status(200).json(response);
                    }
                }
                const response = {
                    errorJSON : {
                        error : true,
                        error_message : 'Failed to process comment',
                        error_code : 500
                    },
                    status : 500,
                    type : 'error'
                }
                return res.status(500).json(response);
            } else {
                const response = {
                    errorJSON : {
                        error : true,
                        error_message : 'Failed to add comment',
                        error_code : 500
                    },
                    status : 500,
                    type : 'error'
                }
                return res.status(500).json(response);
            }
        } catch (error) {
            console.error('Error adding comment:', error);
            const response = {
                errorJSON : {
                    error : true,
                    error_message : 'Internal Server Error',
                    error_code : 500
                },
                status : 500,
                type : 'error'
            }
            return res.status(500).json(response);
        }
    });

module.exports = router;
