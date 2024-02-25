const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const verifyAuthToken = require('../utils/requireAuth.js');
const admin = require('firebase-admin');

router.route('/*')
    .all((req, res, next) => verifyAuthToken(req, res, next));

router.route('/like')
    .post(async (req, res) => {
        try {
            const userID = req.headers.id;
            const postID = req.body.postID;

            if (typeof userID !== 'string' || isNaN(postID)) {
                return res.status(400).send('Invalid user ID or post ID');
            }

            // Vérification de si l'utilisateur a déjà liké ce post
            const checkLikeQuery = `SELECT * FROM likes WHERE userID = ? AND postID = ?`;
            const checkLikeResult = await executeQuery(checkLikeQuery, [userID, postID]);

            if (checkLikeResult.length > 0) {
                return res.status(400).send('User has already liked this post');
            }

            // Insertion du like dans la table likes
            const insertLikeQuery = `INSERT INTO likes (userID, postID) VALUES (?, ?)`;
            const insertLikeResult = await executeQuery(insertLikeQuery, [userID, postID]);

            if (insertLikeResult.affectedRows > 0) {
                // Mise à jour du nombre de likes dans la table posts
                const updatePostLikesQuery = `UPDATE posts SET postLikesNumber = postLikesNumber + 1 WHERE postID = ?`;
                await executeQuery(updatePostLikesQuery, [postID]);

                // Récupération du propriétaire du post
                const getPostOwnerQuery = `SELECT userID FROM posts WHERE postID = ?`;
                const postOwnerResult = await executeQuery(getPostOwnerQuery, [postID]);

                if (postOwnerResult.length > 0) {
                    const postOwnerID = postOwnerResult[0].userID;

                    // Récupération du nom de l'utilisateur qui a liké
                    const getLikerNameQuery = `SELECT userName FROM users WHERE userID = ?`;
                    const likerNameResult = await executeQuery(getLikerNameQuery, [userID]);

                    if (likerNameResult.length > 0) {
                        const likerName = likerNameResult[0].userName;

                        // Insertion de la notification dans la table notifications
                        const notificationContent = `${likerName} a aimé votre publication.`;
                        const notificationTitle = 'Nouveau like';
                        const notificationStatus = 'unread';

                        const insertNotificationQuery = `
                            INSERT INTO notifications (userID, notificationContent, notificationTitle, notificationStatus)
                            VALUES (?, ?, ?, ?)
                        `;
                        await executeQuery(insertNotificationQuery, [postOwnerID, notificationContent, notificationTitle, notificationStatus]);

                        return res.status(200).send('Like added successfully');
                    }
                }

                return res.status(500).send('Failed to get liker name');
            } else {
                return res.status(500).send('Failed to add like');
            }
        } catch (error) {
            console.error('Error adding like:', error);
            return res.status(500).send('Internal Server Error');
        }
    });

module.exports = router;
