const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const verifyAuthToken = require('../utils/requireAuth.js');

router.route('/*')
    .all((req, res, next) => verifyAuthToken(req, res, next));

router.route('/')
    .get(async (req,res) => {
        try {
            sqlQueryActivity = `
            SELECT * FROM activities 
            WHERE userID = ? 
            ORDER BY activityTimestamp DESC, activityType ASC
            LIMIT 200 ;`;
            selectQueryActivityResult = await executeQuery(sqlQueryActivity,[userID])
            const rapport = selectQueryActivityResult
            return res.status(200).json(rapport)
        } catch (error) {
            console.error('Error retrieving notifications:', error);
            const response = {
                    error : true,
                    error_message : 'Internal Server Error',
                    error_code : 2
            }
            return res.status(500).json(response);
        }
    });

module.exports = router