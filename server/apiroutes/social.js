const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const verifyAuthToken = require('../utils/requireAuth.js');

router.route('/*')
    .all((req, res, next) => verifyAuthToken(req, res, next));

router.route('/feed')
    .get(async (req, res) => {
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

            const getFeedQuery = `
                SELECT *
                FROM posts
                WHERE userID IN (?)
                ORDER BY postCreatedAt DESC ;`;
            const feedResult = await executeQuery(getFeedQuery, [friendIDs]);


            const response = feedResult;
            return res.status(200).json(response);
    });



module.exports = router;
