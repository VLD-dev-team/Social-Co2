const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const verifyAuthToken = require('../utils/requireAuth.js');
const admin = require('firebase-admin');

router.route('/*')
    .all((req, res, next) => verifyAuthToken(req, res, next));

router.route('/comments')
    .post(async (req, res) => {
        try {
            const userID = req.headers.id;
            const postID = req.body.postID;
            const commentTextContent = req.body.commentTextContent;

            if (typeof userID !== 'string' || isNaN(postID) || typeof commentTextContent !== 'string') {
                return res.status(400).send('Invalid user ID, post ID, or comment content');
            }

            // Insertion du commentaire dans la table comments
            const insertCommentQuery = `INSERT INTO comments (userID, postID, commentTextContent, commentCreatedAt) VALUES (?, ?, ?, CURRENT_TIMESTAMP)`;
            const insertCommentResult = await executeQuery(insertCommentQuery, [userID, postID, commentTextContent]);

            if (insertCommentResult.affectedRows > 0) {
                // Mise à jour du nombre de commentaires dans la table posts
                const updatePostCommentsQuery = `UPDATE posts SET postCommentsNumber = postCommentsNumber + 1 WHERE postID = ?`;
                await executeQuery(updatePostCommentsQuery, [postID]);

                // Récupération du propriétaire du post
                const getPostOwnerQuery = `SELECT userID FROM posts WHERE postID = ?`;
                const postOwnerResult = await executeQuery(getPostOwnerQuery, [postID]);

                if (postOwnerResult.length > 0) {
                    const postOwnerID = postOwnerResult[0].userID;

                    // Récupération du nom de l'utilisateur qui a commenté
                    const getCommenterNameQuery = `SELECT userName FROM users WHERE userID = ?`;
                    const commenterNameResult = await executeQuery(getCommenterNameQuery, [userID]);

                    if (commenterNameResult.length > 0) {
                        const commenterName = commenterNameResult[0].userName;

                        // Insertion de la notification dans la table notifications
                        const notificationContent = `${commenterName} a commenté votre publication.`;
                        const notificationTitle = 'Nouveau commentaire';
                        const notificationStatus = 'unread';

                        const insertNotificationQuery = `
                            INSERT INTO notifications (userID, notificationContent, notificationTitle, notificationStatus)
                            VALUES (?, ?, ?, ?)
                        `;
                        await executeQuery(insertNotificationQuery, [postOwnerID, notificationContent, notificationTitle, notificationStatus]);

                        return res.status(200).send('Comment added successfully');
                    }
                }

                return res.status(500).send('Failed to get commenter name');
            } else {
                return res.status(500).send('Failed to add comment');
            }
        } catch (error) {
            console.error('Error adding comment:', error);
            return res.status(500).send('Internal Server Error');
        }
    });

module.exports = router;
