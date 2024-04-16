const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const verifyAuthToken = require('../utils/requireAuth.js');
const admin = require('firebase-admin');
const activityCalculator = require('../utils/activityCalculator.js')

// router.route('/*')
//     .all((req, res, next) => verifyAuthToken(req, res, next));
//     // Connection verification

router.route('/')
    .get(async (req, res) => {
        const userID = req.headers.userid;
        const activityID = req.headers.activityid;


        // Type verification
        if (typeof userID !== 'string') {
            const response = {
                    error : true,
                    error_message : 'Invalid user ID',
                    error_code : 1
            }
            return res.status(400).json(response);
        }
        if (isNaN(activityID)) {
            const response = {
                    error : true,
                    error_message : 'Invalid activity ID',
                    error_code : 12
            }
            return res.status(400).json(response);
        }

        // Retrieve all activity info
        const sqlQuery = `SELECT * FROM activities WHERE userID = ? AND activityID = ? ;`;
        const sqlResult = await executeQuery(sqlQuery, [userID, activityID]);


        // Return in JSON format
        if (sqlResult.length > 0){
            const response = {
                activityData : {
                    activityID : sqlResult[0].activityID,
                    userID : sqlResult[0].userID,
                    activityType : sqlResult[0].activityType,
                    activityCO2Impact : sqlResult[0].activityCO2Impact,
                    activityName : sqlResult[0].activityName,
                    activityTimestamp : sqlResult[0].activityTimestamp
                },
                status : 200,
                type : 'response'
            }
            return req.status(200).json(response)

        // If no corresponding activity is found, return an error
        }else {
            const response = {
                    error : true,
                    error_message : 'Activity or User not found in SQL database',
                    error_code : 13
            }
            return res.status(404).json(response);
        }
    })
    .post(async (req, res) => {
        // Adding an activity
        // Retrieve necessary data for activity creation

        const userID = req.headers.userid;
        const activityType = req.body.activityType;
        const activityName = req.body.activityName;
        const activityTimestamp = req.body.activityTimestamp;
        
        // Initialize variable to 0
        let activityCO2Impact = 0;
        // Calculate impact on score based on chosen activity type
        if (activityType == "trip"){
            let vehicle = req.body.activityVehicule
            if (vehicle == 'car'){
                const sqlQuery = 'SELECT car, hybrid FROM users WHERE userID = ? '
                const sqlResult = await executeQuery(sqlQuery, [userID])
                if (sqlQuery.hybrid){
                    if (sqlQuery.car == 1){
                        vehicle = 'Large hybrid car'
                    } else if (sqlQuery.car == 2){
                        vehicle = 'Medium hybrid car'
                    } else {
                        vehicle = 'Small hybrid car'
                    }
                } else {
                    if (sqlQuery.car == 1){
                        vehicle = 'Large car'
                    } else if (sqlQuery.car == 2){
                        vehicle = 'Medium car'
                    } else {
                        vehicle = 'Small car'
                    }
                }
            }
            const distance = parseInt(req.body.activityDistance);
            activityCO2Impact = activityCalculator.newTrip(vehicle, distance)
        } else if (activityType == "purchase"){
            const article = req.body.activityPurchase
            let condition = false
            if (article == "reusedclothes"){
                condition = true
            };
            activityCO2Impact = activityCalculator.newPurchase(article, condition)
        } else if (activityType == "meal"){
            const food = req.body.activityMealIngredients
            activityCO2Impact = activityCalculator.newMeal(food)
        } else if (activityType == "renovation"){
            const furniture = req.body.activityBuild
            activityCO2Impact = activityCalculator.renovation(furniture)
        } else if (activityType == "mail"){
            const mail_test = true
            activityCO2Impact = activityCalculator.inbox(mail_test)
        }else{
            const response = {
                error : true,
                error_message : 'Missing data',
                error_code : 31
            }
            return res.status(400).json(response);
        }

        // Once here, we should have activityCO2Impact, now apply the passive score function
        // For this, we need various user information
        // But before that, let's verify all data to prevent SQL injections

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
        if (typeof activityName !== 'string') {
            const response = {
                    error : true,
                    error_message : 'Invalid activityName',
                    error_code : 17
            }
            return res.status(400).json(response);
        }

        // All data has been verified, let's proceed with the calculation

        const selectQuery = `SELECT * FROM users WHERE userID = ?;`;
        const selectResult = await executeQuery(selectQuery, [userID]);

        if (selectResult.length === 0 ) {
            const response = {
                    error : true,
                    error_message : 'Permission denied: User does not own this activity',
                    error_code : 20
            }
            return res.status(403).json(response);
        } else {

            // Update the score
            let score = selectResult.score + activityCO2Impact
            // Then apply the passive score
            score = activityCalculator.passiveScore(activityCalculator.multiplier(selectResult.recycl, selectResult.nb_inhabitants, selectResult.surface, selectResult.garden, selectResult.multiplier, selectResult.heating), score)

            console.log(score)
            // We can now insert the activity into the activities table
            const insertQuery = `
            INSERT INTO activities (userID, activityType, activityCO2Impact, activityName, activityTimestamp)
            VALUES (?, ?, ?, ?, ?) ;`;
            const insertResult = await executeQuery(insertQuery, [userID, activityType, activityCO2Impact, activityName, activityTimestamp]);

            if (insertResult.affectedRows > 0) {
                
            // Update the user's score with the calculated one
            const updateQuery = `UPDATE users SET score = ? WHERE userID = ? ;`;
            const updateResult = await executeQuery(updateQuery, [parseInt(score) , userID]);
                
            // Return JSON
            const activityID = insertResult.insertId;
            const response = {
                activityID : activityID,
                userID : userID,
                activityType : activityType,
                activityCO2Impact : activityCO2Impact,
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
        }
    })
    .put(async (req, res) => {
        // Update an activity
        // Retrieve all data
        const userID = req.headers.userid;
        const activityId = parseInt(req.body.activityid);
        const activityType = req.body.activityType;
        const activityCO2Impact = parseFloat(req.body.activityCO2Impact);
        const activityName = req.body.activityName;
        const activityTimestamp = req.body.activityTimestamp;

        // Type verification

        if (typeof userID !== 'string' || isNaN(activityId)) {
            const response = {
                    error : true,
                    error_message : 'Invalid user ID or activity ID',
                    error_code : 19
            }
            return res.status(400).json(response);
        }

        // Check if activity already exists
        const permissionQuery = `SELECT * FROM activities WHERE userID = ? AND activityID = ? ;`;
        const permissionResult = await executeQuery(permissionQuery, [userID, activityId]);

        if (permissionResult.length === 0) {
            const response = {
                    error : true,
                    error_message : 'Permission denied: User does not own this activity',
                    error_code : 20
            }
            return res.status(403).json(response);
        }

        // Update activities table with new info

        const updateQuery = `
            UPDATE activities
            SET activityType = ?, activityCO2Impact = ?,
                activityName = ?, activityTimestamp = ?
            WHERE userID = ? AND activityID = ? ;
        `;
        const updateResult = await executeQuery(updateQuery, [activityType, activityCO2Impact, activityName, activityTimestamp, userID, activityId]);

        if (updateResult.affectedRows > 0) {
            const response = {
                    activityID: activityId,
                    userID : userID,
                    activityType : activityType,
                    activityCO2Impact : activityCO2Impact,
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
    })
    .delete(async (req, res) => {
        // Retrieve necessary info for deletion
        const userID = req.headers.userid;
        const activityId = parseInt(req.params.activityid);

        // Type verification

        if (typeof userID !== 'string' || isNaN(activityId)) {
            const response = {
                    error : true,
                    error_message : 'Invalid user ID or activity ID',
                    error_code : 19
            }
            return res.status(400).json(response);
        }

        // Permission check

        const permissionQuery = `SELECT * FROM activities WHERE userID = ? AND activityID = ? ;`;
        const permissionResult = await executeQuery(permissionQuery, [userID, activityId]);

        if (permissionResult.length === 0) {
            const response = {
                    error : true,
                    error_message : 'Permission denied: User does not own this activity',
                    error_code : 20
            }
            return res.status(403).json(response);
        }

        // Delete activity
        const deleteQuery = `DELETE FROM activities WHERE userID = ? AND activityID = ? ;`;
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
    });


router.route('/favorite')
    .post(async (req,res) => {
        const userID = req.headers.userid
        const activityID = parseInt(req.body.activityid);

        // Type verification

        if (typeof userID !== 'string' || isNaN(activityId)) {
            const response = {
                    error : true,
                    error_message : 'Invalid user ID or activity ID',
                    error_code : 19
            }
            return res.status(400).json(response);
        }

        // Permission check

        const permissionQuery = `SELECT * FROM activities WHERE userID = ? AND activityID = ? ;`;
        const permissionResult = await executeQuery(permissionQuery, [userID, activityID]);

        if (permissionResult.length === 0) {
            const response = {
                    error : true,
                    error_message : 'Permission denied: User does not own this activity',
                    error_code : 20
            }
            return res.status(403).json(response);
        } else {
            const insertQuery = `
            INSERT INTO recurrentActivities (activityID, userID, activityType, activityCO2Impact, activityName, activityTimestamp)
            VALUES (?, ?, ?, ?, ?, ?) ;`;
            const insertResult = await executeQuery(insertQuery, [activityID , userID, permissionResult.activityType, permissionResult.activityCO2Impact, permissionResult.activityName, permissionResult.activityTimestamp]);

            if (insertResult.affectedRows > 0) {
                const response = {
                    message : 'Activity added to favorites successfully',
                    status : 200,
                }
                return res.status(200).json(response);
            } else {
                const response = {
                    error : true,
                    error_message : 'Permission denied: User does not own this activity',
                    error_code : 20
                }
                return res.status(403).json(response);
            }
        }
    })
    .delete(async (req,res) => {
        const userID = req.headers.userid
        const activityID = parseInt(req.body.activityid)

        // Type verification

        if (typeof userID !== 'string' || isNaN(activityID)) {
            const response = {
                    error : true,
                    error_message : 'Invalid user ID or activity ID',
                    error_code : 19
            }
            return res.status(400).json(response);
        }

        // Permission check

        const permissionQuery = `SELECT * FROM activities WHERE userID = ? AND activityID = ? ;`;
        const permissionResult = await executeQuery(permissionQuery, [userID, activityID]);

        if (permissionResult.length === 0) {
            const response = {
                    error : true,
                    error_message : 'Permission denied: User does not own this activity',
                    error_code : 20
            }
            return res.status(403).json(response);
        } else {
            const deleteQuery = `DELETE FROM recurrentActivities WHERE activityID = ? AND userID = ? ;`;
            const deleteResult = await executeQuery(deleteQuery, [activityID , userID]);

            if (deleteResult.affectedRows > 0) {
                const response = {
                    message : 'Activity deleted from favorites successfully',
                    status : 200,
                }
                return res.status(200).json(response);
            } else {
                const response = {
                    error : true,
                    error_message : 'User does not have this activity in favorites',
                    error_code : 32
                }
                return res.status(400).json(response);
            }
        }
    });

module.exports = router;
