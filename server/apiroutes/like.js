const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const verifyAuthToken = require('../utils/requireAuth.js');
const notificationHandler = require('../utils/notificationHandler.js'); // Importez le gestionnaire de notifications
const socketManager = require('../utils/socketManager.js'); // Importez le gestionnaire de sockets pour accéder à `io`

router.route('/*')
    .all((req, res, next) => verifyAuthToken(req, res, next));

router.route('/like')
    .post(async (req, res) => {
        try {
            const userID = req.headers.userid;
            const postID = req.body.postID;

            if (typeof userID !== 'string' || isNaN(postID)) {
                const response = {
                        error : true,
                        error_message : 'Invalid user ID or post ID',
                        error_code : 5
                }
                return res.status(400).json(response);
            }

            // Vérification de si l'utilisateur a déjà liké ce post
            const checkLikeQuery = `SELECT * FROM likes WHERE userID = ? AND postID = ?`;
            const checkLikeResult = await executeQuery(checkLikeQuery, [userID, postID]);

            if (checkLikeResult.length > 0) {
                const response = {
                        error : true,
                        error_message : 'User has already liked this post',
                        error_code : 6
                }
                return res.status(400).json(response);
            }

            // Insertion du like dans la table likes
            await executeQuery(`INSERT INTO likes (userID, postID) VALUES (?, ?)`, [userID, postID]);

            // Mise à jour du nombre de likes dans la table posts
            await executeQuery(`UPDATE posts SET postLikesNumber = postLikesNumber + 1 WHERE postID = ?`, [postID]);

            // Récupération du propriétaire du post
            const [postOwner] = await executeQuery(`SELECT userID FROM posts WHERE postID = ?`, [postID]);

            if (postOwner) {
                const { userID: postOwnerID } = postOwner;

                // Récupération du nom de l'utilisateur qui a liké
                const [likerInfo] = await executeQuery(`SELECT userName FROM users WHERE userID = ?`, [userID]);

                if (likerInfo) {
                    const { userName: likerName } = likerInfo;

                    // Insertion de la notification dans la table notifications
                    const notificationContent = `${likerName} a aimé votre publication.`;
                    const notificationTitle = 'Nouveau like';
                    const notificationStatus = 'unread';

                    await executeQuery(`INSERT INTO notifications (userID, notificationContent, notificationTitle, notificationStatus) VALUES (?, ?, ?, ?)`, [postOwnerID, notificationContent, notificationTitle, notificationStatus]);

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
                    error_message : 'Failed to process like',
                    error_code : 7
            }
            return res.status(500).json(response);
        } catch (error) {
            console.error('Error adding like:', error);
            const response = {
                    error : true,
                    error_message : 'Internal Server Error',
                    error_code : 2
            }
            return res.status(500).json(response);
        }
    });

module.exports = router;
