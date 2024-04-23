const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const verifyAuthToken = require('../utils/requireAuth.js');

router.route('/*')
    .all((req, res, next) => verifyAuthToken(req, res, next));

router.route('/')
    .get(async (req,res) => {
        try {

            const userID = req.headers.userid;

            sqlQueryActivity = `
            SELECT * FROM activities 
            WHERE userID = ? 
            ORDER BY activityTimestamp DESC
            LIMIT 200 ;`;
            selectQueryActivityResult = await executeQuery(sqlQueryActivity,[userID])
            const rapport = {}
            const impact = {}
            if (selectQueryActivityResult.length > 0){
                let maximum = selectQueryActivityResult[0].activityCO2Impact
                for (activities in selectQueryActivityResult){
                    console.log(selectQueryActivityResult[activities])
                    let rep = true
                    const day = Date(selectQueryActivityResult[activities].activityTimestamp).split(" ")[0]
                    for (days in rapport){
                        if (day == days){
                            rapport[day].push(selectQueryActivityResult[activities])
                            impact[day] += selectQueryActivityResult[activities].activityCO2Impact
                            if (selectQueryActivityResult[activities].activityCO2Impact > maximum){
                                maximum = selectQueryActivityResult[activities].activityCO2Impact
                            }
                            rep = false
                        }
                    }
                    if (rep == true){
                        rapport[day] = [selectQueryActivityResult[activities]]
                        impact[day] = selectQueryActivityResult[activities].activityCO2Impact
                        if (selectQueryActivityResult[activities].activityCO2Impact > maximum){
                            maximum = selectQueryActivityResult[activities].activityCO2Impact
                        }
                    }
                }
                const response = {
                    rapport : rapport,
                    impact : impact,
                    maximum : maximum
                }
    
                return res.status(200).json(response)
            } else {
                const response = {
                    rapport : {},
                    impact : {},
                    maximum : null,
                    message : "Aucune activité trouvée",
                    error : true
                }
                return res.status(404).json(response)
            }

            
            
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