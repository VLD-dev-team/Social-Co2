const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const verifyAuthToken = require('../utils/requireAuth.js');

router.route('/*')
    .all((req, res, next) => verifyAuthToken(req, res, next));
    
router.route('/')
    .get(async (req, res) => {
        try {
            const userID = req.headers.userid;
            const actionType = req.query.actionType;

            if (typeof actionType !== 'string') {
                const response = {
                    error: true,
                    error_message: 'Invalid Data',
                    error_code: 33
                };
                return res.status(400).json(response);
            }

            let friends = [];

            if (actionType === "request send") {
                // Requête pour obtenir les amis dont la demande d'amitié a été envoyée
                const getFriendsQuery = `SELECT userID FROM users JOIN friends ON users.userID = friends.userID2 WHERE userID1 = ? AND friendshipStatus = "21" ;`;
                const friends1 = await executeQuery(getFriendsQuery, [userID]);
                const getFriendsQuery2 = `SELECT userID FROM users JOIN friends ON users.userID = friends.userID1 WHERE userID2 = ? AND friendshipStatus = "12" ;`;
                const friends2 = await executeQuery(getFriendsQuery2, [userID]);
                friends = friends1.concat(friends2);
            } else if (actionType === "request receive") {
                // Requête pour obtenir les amis en attente
                const getFriendsQuery = `SELECT * FROM friends WHERE userID1 = ? AND friendshipStatus = "12" ;`;
                const friends1 = await executeQuery(getFriendsQuery, [userID]);
                const getFriendsQuery2 = `SELECT * FROM friends WHERE userID2 = ? AND friendshipStatus = "21" ;`;
                const friends2 = await executeQuery(getFriendsQuery2, [userID]);
                friends = friends1.concat(friends2);
            } else if (actionType === "block") {
                // Requête pour obtenir les personnes bloquées
                const getFriendsQuery = `SELECT * FROM friends WHERE userID1 = ? AND (friendshipStatus = "31" OR friendshipStatus = "33") ;`;
                const friends1 = await executeQuery(getFriendsQuery, [userID]);
                const getFriendsQuery2 = `SELECT * FROM friends WHERE userID2 = ? AND (friendshipStatus = "13" OR friendshipStatus = "33") ;`;
                const friends2 = await executeQuery(getFriendsQuery2, [userID]);
                friends = friends1.concat(friends2);
            } else if (actionType === "friends") {
                // Requête pour obtenir ses amis
                const getFriendsQuery = `SELECT * FROM friends WHERE userID1 = ? AND friendshipStatus = "22" ;`;
                const friends1 = await executeQuery(getFriendsQuery, [userID]);
                const getFriendsQuery2 = `SELECT * FROM friends WHERE userID2 = ? AND friendshipStatus = "22" ;`;
                const friends2 = await executeQuery(getFriendsQuery2, [userID]);
                friends = friends1.concat(friends2);
            }

            // Récupération des informations utilisateur à partir de Firebase
            const usersPromises = friends.map(async (friend) => {
                const friendID = friend.userID1 === userID ? friend.userID2 : friend.userID1;
                const userRecord = await admin.auth().getUser(friendID);
                return {
                    userID: userRecord.uid,
                    name: userRecord.displayName,
                    photoURL: userRecord.photoURL
                };
        });
            const users = await Promise.all(usersPromises);
    
            return res.status(200).json(users);
        } catch (error) {
            console.error('Error retrieving friends:', error);
            const response = {
                error: true,
                error_message: 'Internal Server Error',
                error_code: 2
            };
            return res.status(500).json(response);
        }
    })
    .post(async (req,res) => {
        try {
            // On recupère les données nécessaires
            const userID = req.headers.userid;
            const actionType = req.query.actionType;
            const friendID = req.query.friendID;
            // Vérification du typage
            if (typeof actionType !== 'string' || typeof userID !== 'string') {
                const response = {
                    error: true,
                    error_message: 'Invalid Data',
                    error_code: 33
                };
                return res.status(400).json(response);
            }
            // -add : pour envoyer une demande d'ami
            // - block : pour bloquer
            // - accept : pour accepter la demande d'ami si il y en a une
            // - refuse
            // - deblock
            
            // Pour ajouter un ami
            if (actionType == "add"){
                const sqlFriend = `SELECT * FROM friends WHERE (userID1 = ? AND userID2 = ?) OR (userID1 = ? AND userID2 = ?) ;`;
                const sqlFriendResult = await executeQuery(sqlFriend, [userID, friendID, userID, friendID]);
                if (sqlFriendResult.length > 0){
                    const response = {
                        error: true,
                        error_message: 'Friendship already exist',
                        error_code: 35
                    };
                    return res.status(400).json(response);
                }
                const sqlQuery = `INSERT INTO friends (userID1, userID2, friendshipStatus) VALUES (?, ?, ?);`;
                const sqlResult = await executeQuery(sqlQuery, [userID, friendID, "21"]);
                if (sqlResult.affectedRows > 0){
                    const response = {
                        message : "Request send",
                        status : 200,
                    }
                    return res.status(200).json(response);
                } else {
                    const response = {
                        error: true,
                        error_message: 'Internal Server Error',
                        error_code: 2
                    };
                    return res.status(400).json(response);
                }
            }
            if (actionType == "block"){
                const sqlFriend = `SELECT * FROM friends WHERE userID1 = ? AND userID2 = ? ;`;
                const sqlFriendResult = await executeQuery(sqlFriend, [userID, friendID]);
                if (sqlFriendResult.length > 0){
                    let FriendshipStatus = sqlFriendResult.friendshipStatus
                    FriendshipStatus[0] = "3";
                    const sqlQuery = `UPDATE friends SET friendshipStatus = ? WHERE userID1 = ? AND userID2 = ?;`;
                    const sqlResult = await executeQuery(sqlQuery, [FriendshipStatus, userID, friendID]);
                    if (sqlResult.affectedRows > 0){
                        const response = {
                            message : "User block successfuly",
                            status : 200,
                        }
                        return res.status(200).json(response);
                    } else {
                        const response = {
                            error: true,
                            error_message: 'Internal Server Error',
                            error_code: 2
                        };
                        return res.status(400).json(response);
                    }
                } else {
                    const sqlFriend = `SELECT * FROM friends WHERE userID1 = ? AND userID2 = ? ;`;
                    const sqlFriendResult = await executeQuery(sqlFriend, [friendID, userID]);
                    if (sqlFriendResult.length > 0){
                        let FriendshipStatus = sqlFriendResult.friendshipStatus
                        FriendshipStatus[1] = "3";
                        const sqlQuery = `UPDATE friends SET friendshipStatus = ? WHERE userID1 = ? AND userID2 = ?;`;
                        const sqlResult = await executeQuery(sqlQuery, [FriendshipStatus, userID, friendID]);
                        if (sqlResult.affectedRows > 0){
                            const response = {
                                message : "User block successfuly",
                                status : 200,
                            }
                            return res.status(200).json(response);
                        } else {
                            const response = {
                                error: true,
                                error_message: 'Internal Server Error',
                                error_code: 2
                            };
                            return res.status(400).json(response);
                        }

                    } else {
                        const sqlQuery = `INSERT INTO friends (userID1, userID2, friendshipStatus) VALUES (?, ?, ?);`;
                        const sqlResult = await executeQuery(sqlQuery, [userID, friendID, "30"]);
                        if (sqlResult.affectedRows > 0){
                            const response = {
                                message : "User block",
                                status : 200,
                            }
                            return res.status(200).json(response);
                        } else {
                            const response = {
                                error: true,
                                error_message: 'Internal Server Error',
                                error_code: 2
                            };
                            return res.status(400).json(response);
                        }
                    }
                }
            }

        } catch (error) {
            console.error('Error retrieving friends:', error);
            const response = {
                error: true,
                error_message: 'Internal Server Error',
                error_code: 2
            };
            return res.status(500).json(response);
        }
    })

router.route('/search')
    .get(async (req, res) => {
        try {
            const userID = req.headers.userid;
            const friendshipID = req.query.friendshipid;

            // Requête pour rechercher une personne par son friendshipID
            const searchFriendQuery = `
                SELECT 
                    f.friendshipID,
                    f.userID1 AS friendID,
                    u.userName AS friendName,
                    f.friendshipStatus
                FROM friends f
                JOIN users u ON (f.userID1 = u.userID OR f.userID2 = u.userID) AND u.userID != ?
                WHERE f.friendshipID = ? ;`;

            const friend = await executeQuery(searchFriendQuery, [userID, friendshipID]);

            if (friend.length === 0) {
                const response = {
                        error : true,
                        error_message : 'Friend not found',
                        error_code : 27
                }
                return res.status(404).json(response);
            }
            const response = {
                friend : friend[0],
                status : 200,
            }
            return res.status(200).json(response);
        } catch (error) {
            console.error('Error searching friend:', error);
            const response = {
                    error : true,
                    error_message : 'Internal Server Error',
                    error_code : 2
            }
            return res.status(500).json(response);
        }
    });

router.route('/status')
    .post(async (req, res) => {
        try {
            const userID = req.headers.userid;
            const friendID = req.body.friendID;
            const friendshipStatus = req.body.friendshipStatus;

            // Vérifie si l'amitié existe déjà
            const checkFriendshipQuery = `
                SELECT friendshipID FROM friends
                WHERE (userID1 = ? AND userID2 = ?) OR (userID1 = ? AND userID2 = ?) ;
            `;
            const existingFriendship = await executeQuery(checkFriendshipQuery, [userID, friendID, friendID, userID]);

            if (existingFriendship.length > 0) {
                // Met à jour le statut de l'amitié existante
                const updateFriendshipQuery = `
                    UPDATE friends
                    SET friendshipStatus = ?
                    WHERE friendshipID = ?
                `;
                await executeQuery(updateFriendshipQuery, [friendshipStatus, existingFriendship[0].friendshipID]);

                const response = {
                    message : 'Friendship status updated successfully',
                    status : 200,
                }
                return res.status(200).json(response);
            } else {
                // Ajouter une nouvelle amitié
                const addFriendshipQuery = `
                    INSERT INTO friends (userID1, userID2, friendshipStatus)
                    VALUES (?, ?, ?) ;
                `;
                await executeQuery(addFriendshipQuery, [userID, friendID, friendshipStatus]);

                const response = {
                    message : 'Friendship added successfully',
                    status : 201,
                }
                return res.status(201).json(response);
            }
        } catch (error) {
            console.error('Error updating friendship status:', error);
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
            const friendID = req.body.friendID;

            // Supprimer l'amitié
            const deleteFriendshipQuery = `
                DELETE FROM friends
                WHERE (userID1 = ? AND userID2 = ?) OR (userID1 = ? AND userID2 = ?) ;
            `;
            const deleteResult = await executeQuery(deleteFriendshipQuery, [userID, friendID, friendID, userID]);

            if (deleteResult.affectedRows > 0) {
                const response = {
                    message : 'Friendship deleted successfully',
                    status : 200,
                }
                return res.status(200).json(response);
            } else {
                const response = {
                        error : true,
                        error_message : 'Friendship not found',
                        error_code : 28
                }
                return res.status(404).json(response);
            }
        } catch (error) {
            console.error('Error deleting friendship:', error);
            const response = {
                    error : true,
                    error_message : 'Internal Server Error',
                    error_code : 2
            }
            return res.status(500).json(response);
        }
    });
    


module.exports = router;
