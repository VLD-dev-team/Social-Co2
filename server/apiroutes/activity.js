const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const verifyAuthToken = require('../utils/requireAuth.js');
const admin = require('firebase-admin');

router.route('/*')
    .all((req, res, next) => verifyAuthToken(req, res, next));

router.route('/:activityId')
    .get(async (req, res) => {
        try {
            const userID = req.headers.userid;
            const activityId = req.body.activityId;

            if (typeof userID !== 'string') {
                const response = {
                        error : true,
                        error_message : 'Invalid user ID',
                        error_code : 1
                }
                return res.status(400).json(response);
            }
            if (isNaN(activityId)) {
                const response = {
                        error : true,
                        error_message : 'Invalid activity ID',
                        error_code : 12
                }
                return res.status(400).json(response);
            }
            const sqlQuery = `SELECT * FROM activities WHERE userID = ? AND activityID = ?`;
            const sqlResult = await executeQuery(sqlQuery, [userID, activityId]);

            if (sqlResult.length > 0){
                const response = {
                    activityData : {
                        activityID : sqlResult[0].activityID,
                        userID : sqlResult[0].userID,
                        activityType : sqlResult[0].activityType,
                        activityCO2Impact : sqlResult[0].activityCO2Impact,
                        activityPollutionImpact : sqlResult[0].activityPollutionImpact,
                        activityName : sqlResult[0].activityName,
                        activityTimestamp : sqlResult[0].activityTimestamp
                    },
                    status : 200,
                    type : 'response'
                }
                return req.status(200).json(response)
            }else {
                const response = {
                        error : true,
                        error_message : 'Activity or User not found in SQL database',
                        error_code : 13
                }
                return res.status(404).json(response);
            }
        } catch (error) {
            console.error('Error retrieving activity data:', error);
            const response = {
                    error : true,
                    error_message : 'Internal Server Error',
                    error_code : 2
            }
            return res.status(500).json(response);
        }
    })
    .post(async (req, res) => {
        try {
            const userID = req.headers.userid;
            const activityType = req.body.activityType;
            const activityCO2Impact = req.body.activityCO2Impact;
            const activityPollutionImpact = req.body.activityPollutionImpact;
            const activityName = req.body.activityName;
            const activityTimestamp = req.body.activityTimestamp;

            if (typeof userID !== 'string') {
                const response = {
                        error : true,
                        error_message : 'Invalid user ID',
                        error_code : 1
                }
                return res.status(400).json(response);
            }
            if (typeof activityType !== 'string') {
                const response = {
                        error : true,
                        error_message : 'Invalid activityType',
                        error_code : 14
                }
                return res.status(400).json(response);
            }
            if (isNaN(activityCO2Impact)) {
                const response = {
                        error : true,
                        error_message : 'Invalid activityCO2Impact',
                        error_code : 15
                }
                return res.status(400).json(response);
            }
            if (isNaN(activityPollutionImpact)) {
                const response = {
                        error : true,
                        error_message : 'Invalid activityPollutionImpact',
                        error_code : 16
                }
                return res.status(400).json(response);
            }
            if (typeof activityName !== 'string') {
                const response = {
                        error : true,
                        error_message : 'Invalid activityName',
                        error_code : 17
                }
                return res.status(400).json(response);
            }

            const insertQuery = `
                INSERT INTO activities (userID, activityType, activityCO2Impact, activityPollutionImpact, activityName, activityTimestamp)
                VALUES (?, ?, ?, ?, ?, ?)
            `;
            const insertResult = await executeQuery(insertQuery, [userID, activityType, activityCO2Impact, activityPollutionImpact, activityName, activityTimestamp]);

            if (insertResult.affectedRows > 0) {
                const activityID = insertResult.insertId;
                const response = {
                        activityID : activityID,
                        userID : userID,
                        activityType : activityType,
                        activityCO2Impact : activityCO2Impact,
                        activityPollutionImpact : activityPollutionImpact,
                        activityName : activityName,
                        activityTimestamp : activityTimestamp
                }
                return res.status(200).json(response);
            } else {
                const response = {
                        error : true,
                        error_message : 'Failed to insert activity',
                        error_code : 18
                }
                return res.status(500).json(response);
            }
        } catch (error) {
            console.error('Error creating activity:', error);
            const response = {
                    error : true,
                    error_message : 'Internal Server Error',
                    error_code : 2
            }
            return res.status(500).json(response);
        }
    })
    .put(async (req, res) => {
        try {
            const userID = req.headers.userid;
            const activityId = req.params.activityId;
            const activityType = req.body.activityType;
            const activityCO2Impact = req.body.activityCO2Impact;
            const activityPollutionImpact = req.body.activityPollutionImpact;
            const activityName = req.body.activityName;
            const activityTimestamp = req.body.activityTimestamp;

            if (typeof userID !== 'string' || isNaN(activityId)) {
                const response = {
                        error : true,
                        error_message : 'Invalid user ID or activity ID',
                        error_code : 19
                }
                return res.status(400).json(response);
            }

            const permissionQuery = `SELECT * FROM activities WHERE userID = ? AND activityID = ?`;
            const permissionResult = await executeQuery(permissionQuery, [userID, activityId]);

            if (permissionResult.length === 0) {
                const response = {
                        error : true,
                        error_message : 'Permission denied: User does not own this activity',
                        error_code : 20
                }
                return res.status(403).json(response);
            }

            const updateQuery = `
                UPDATE activities
                SET activityType = ?, activityCO2Impact = ?, activityPollutionImpact = ?,
                    activityName = ?, activityTimestamp = ?
                WHERE userID = ? AND activityID = ?
            `;
            const updateResult = await executeQuery(updateQuery, [activityType, activityCO2Impact, activityPollutionImpact, activityName, activityTimestamp, userID, activityId]);

            if (updateResult.affectedRows > 0) {
                const response = {
                        activityID: activityId,
                        userID : userID,
                        activityType : activityType,
                        activityCO2Impact : activityCO2Impact,
                        activityPollutionImpact : activityPollutionImpact,
                        activityName : activityName,
                        activityTimestamp : activityTimestamp
                }
                return res.status(200).json(response);
            } else {
                const response = {
                        error : true,
                        error_message : 'Failed to update activity',
                        error_code : 21
                }
                return res.status(500).json(response);
            }
        } catch (error) {
            console.error('Error updating activity:', error);
            const response = {
                    error : true,
                    error_message : 'Internal Server Error',
                    error_code : 2
            }
            return res.status(500).json(response);
        }
    })
    .delete(async (req, res) => {
        try {
            const userID = req.headers.userid;
            const activityId = req.params.activityId;

            if (typeof userID !== 'string' || isNaN(activityId)) {
                const response = {
                        error : true,
                        error_message : 'Invalid user ID or activity ID',
                        error_code : 19
                }
                return res.status(400).json(response);
            }

            const permissionQuery = `SELECT * FROM activities WHERE userID = ? AND activityID = ?`;
            const permissionResult = await executeQuery(permissionQuery, [userID, activityId]);

            if (permissionResult.length === 0) {
                const response = {
                        error : true,
                        error_message : 'Permission denied: User does not own this activity',
                        error_code : 20
                }
                return res.status(403).json(response);
            }

            const deleteQuery = `DELETE FROM activities WHERE userID = ? AND activityID = ?`;
            const deleteResult = await executeQuery(deleteQuery, [userID, activityId]);

            if (deleteResult.affectedRows > 0) {
                const response = {
                    message : 'Activity deleted successfully',
                    status : 200,
                }
                return res.status(200).json(response);
            } else {
                const response = {
                        error : true,
                        error_message : 'Failed to delete activity',
                        error_code : 21
                }
                return res.status(500).json(response);
            }
        } catch (error) {
            console.error('Error deleting activity:', error);
            const response = {
                    error : true,
                    error_message : 'Internal Server Error',
                    error_code : 2
            }
            return res.status(500).json(response);
        }
    });




module.exports = router;


    
