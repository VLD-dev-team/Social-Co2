const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const verifyAuthToken = require('../utils/requireAuth.js');
const admin = require('firebase-admin');

router.route('/*')
    .all((req, res, next) => verifyAuthToken(req, res, next));

router.route('/activity/:activityId')
    .get(async (req, res) => {
        try {
            const userID = req.headers.id;
            const activityId = req.body.activityId;

            if (typeof userID !== 'string') {
                return res.status(400).send('Invalid user ID');
            }
            if (isNaN(activityId)) {
                return res.status(400).send('Invalid activity ID');
            }
            const sqlQuery = `SELECT * FROM activities WHERE userID = ? AND activityID = ?`;
            const sqlResult = await executeQuery(sqlQuery, [userID, activityId]);

            if (sqlResult.length > 0){
                const activityData = {
                    activityID : sqlResult[0].activityID,
                    userID : sqlResult[0].userID,
                    activityType : sqlResult[0].activityType,
                    activityCO2Impact : sqlResult[0].activityCO2Impact,
                    activityPollutionImpact : sqlResult[0].activityPollutionImpact,
                    activityName : sqlResult[0].activityName,
                    activityTimestamp : sqlResult[0].activityTimestamp
                }

                return req.status(200).json(activityData)
            }else {
                return res.status(404).send('Activity or User not found in SQL database');
            }
        } catch (error) {
            console.error('Error retrieving activity data:', error);
            return res.status(500).send('Internal Server Error');
        }
    })
    .post(async (req, res) => {
        try {
            const userID = req.headers.id;
            const activityType = req.body.activityType;
            const activityCO2Impact = req.body.activityCO2Impact;
            const activityPollutionImpact = req.body.activityPollutionImpact;
            const activityName = req.body.activityName;
            const activityTimestamp = req.body.activityTimestamp;

            if (typeof userID !== 'string') {
                return res.status(400).send('Invalid user ID');
            }
            if (typeof activityType !== 'string') {
                return res.status(400).send('Invalid activityType');
            }
            if (isNaN(activityCO2Impact)) {
                return res.status(400).send('Invalid activityCO2Impact');
            }
            if (isNaN(activityPollutionImpact)) {
                return res.status(400).send('Invalid activityPollutionImpact');
            }
            if (typeof activityName !== 'string') {
                return res.status(400).send('Invalid activityName');
            }

            const insertQuery = `
                INSERT INTO activities (userID, activityType, activityCO2Impact, activityPollutionImpact, activityName, activityTimestamp)
                VALUES (?, ?, ?, ?, ?, ?)
            `;
            const insertResult = await executeQuery(insertQuery, [userID, activityType, activityCO2Impact, activityPollutionImpact, activityName, activityTimestamp]);

            if (insertResult.affectedRows > 0) {
                const activityID = insertResult.insertId;

                const activityData = {
                    activityID,
                    userID,
                    activityType,
                    activityCO2Impact,
                    activityPollutionImpact,
                    activityName,
                    activityTimestamp
                };

                return res.status(200).json(activityData);
            } else {
                return res.status(500).send('Failed to insert activity');
            }
        } catch (error) {
            console.error('Error creating activity:', error);
            return res.status(500).send('Internal Server Error');
        }
    })
    .put(async (req, res) => {
        try {
            const userID = req.headers.id;
            const activityId = req.params.activityId;
            const activityType = req.body.activityType;
            const activityCO2Impact = req.body.activityCO2Impact;
            const activityPollutionImpact = req.body.activityPollutionImpact;
            const activityName = req.body.activityName;
            const activityTimestamp = req.body.activityTimestamp;

            if (typeof userID !== 'string' || isNaN(activityId)) {
                return res.status(400).send('Invalid user ID or activity ID');
            }

            const permissionQuery = `SELECT * FROM activities WHERE userID = ? AND activityID = ?`;
            const permissionResult = await executeQuery(permissionQuery, [userID, activityId]);

            if (permissionResult.length === 0) {
                return res.status(403).send('Permission denied: User does not own this activity');
            }

            const updateQuery = `
                UPDATE activities
                SET activityType = ?, activityCO2Impact = ?, activityPollutionImpact = ?,
                    activityName = ?, activityTimestamp = ?
                WHERE userID = ? AND activityID = ?
            `;
            const updateResult = await executeQuery(updateQuery, [activityType, activityCO2Impact, activityPollutionImpact, activityName, activityTimestamp, userID, activityId]);

            if (updateResult.affectedRows > 0) {
                const activityData = {
                    activityID: activityId,
                    userID,
                    activityType,
                    activityCO2Impact,
                    activityPollutionImpact,
                    activityName,
                    activityTimestamp
                };

                return res.status(200).json(activityData);
            } else {
                return res.status(500).send('Failed to update activity');
            }
        } catch (error) {
            console.error('Error updating activity:', error);
            return res.status(500).send('Internal Server Error');
        }
    })
    .delete(async (req, res) => {
        try {
            const userID = req.headers.id;
            const activityId = req.params.activityId;

            if (typeof userID !== 'string' || isNaN(activityId)) {
                return res.status(400).send('Invalid user ID or activity ID');
            }

            const permissionQuery = `SELECT * FROM activities WHERE userID = ? AND activityID = ?`;
            const permissionResult = await executeQuery(permissionQuery, [userID, activityId]);

            if (permissionResult.length === 0) {
                return res.status(403).send('Permission denied: User does not own this activity');
            }

            const deleteQuery = `DELETE FROM activities WHERE userID = ? AND activityID = ?`;
            const deleteResult = await executeQuery(deleteQuery, [userID, activityId]);

            if (deleteResult.affectedRows > 0) {
                return res.status(200).send('Activity deleted successfully');
            } else {
                return res.status(500).send('Failed to delete activity');
            }
        } catch (error) {
            console.error('Error deleting activity:', error);
            return res.status(500).send('Internal Server Error');
        }
    });




module.exports = router;


    
