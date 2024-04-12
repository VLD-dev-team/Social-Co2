const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const verifyAuthToken = require('../utils/requireAuth.js');
const admin = require('firebase-admin');

// router.route('/*')
//     .all((req, res, next) => verifyAuthToken(req, res, next));
    
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

            if (actionType === "request_send") {
                // Requête pour obtenir les amis dont la demande d'amitié a été envoyée
                const getFriendsQuery = `SELECT userID FROM users JOIN friends ON users.userID = friends.userID2 WHERE userID1 = ? AND friendshipStatus = "21" ;`;
                const friends1 = await executeQuery(getFriendsQuery, [userID]);
                const getFriendsQuery2 = `SELECT userID FROM users JOIN friends ON users.userID = friends.userID1 WHERE userID2 = ? AND friendshipStatus = "12" ;`;
                const friends2 = await executeQuery(getFriendsQuery2, [userID]);
                friends = friends1.concat(friends2);
            } else if (actionType === "request_receive") {
                // Requête pour obtenir les amis en attente
                const getFriendsQuery = `SELECT userID FROM users JOIN friends ON users.userID = friends.userID2 WHERE userID1 = ? AND friendshipStatus = "12" ;`;
                const friends1 = await executeQuery(getFriendsQuery, [userID]);
                const getFriendsQuery2 = `SELECT userID FROM users JOIN friends ON users.userID = friends.userID1 WHERE userID2 = ? AND friendshipStatus = "21" ;`;
                const friends2 = await executeQuery(getFriendsQuery2, [userID]);
                friends = friends1.concat(friends2);
            } else if (actionType === "block") {
                // Requête pour obtenir les personnes bloquées
                const getFriendsQuery = `SELECT userID FROM users JOIN friends ON users.userID = friends.userID2 WHERE userID1 = ? AND (friendshipStatus = "31" OR friendshipStatus = "33" OR friendshipStatus = "32") ;`;
                const friends1 = await executeQuery(getFriendsQuery, [userID]);
                const getFriendsQuery2 = `SELECT userID FROM users JOIN friends ON users.userID = friends.userID1 WHERE userID2 = ? AND (friendshipStatus = "13" OR friendshipStatus = "33" OR friendshipStatus = "23") ;`;
                const friends2 = await executeQuery(getFriendsQuery2, [userID]);
                friends = friends1.concat(friends2);
            } else if (actionType === "friends") {
                // Requête pour obtenir ses amis
                const getFriendsQuery = `SELECT userID FROM users JOIN friends ON users.userID = friends.userID2 WHERE userID1 = ? AND friendshipStatus = "22" ;`;
                const friends1 = await executeQuery(getFriendsQuery, [userID]);
                const getFriendsQuery2 = `SELECT userID FROM users JOIN friends ON users.userID = friends.userID1 WHERE userID2 = ? AND friendshipStatus = "22" ;`;
                const friends2 = await executeQuery(getFriendsQuery2, [userID]);
                friends = friends1.concat(friends2);
            }

            console.log(friends)

            // Récupération des informations utilisateur à partir de Firebase
            if (friends.length > 0 ){
                const usersPromises = friends.map(async (friend) => {
                    const friendID = friend.userID
                    const userRecord = await admin.auth().getUser(friendID);
                    let name = userRecord.displayName;
                    let photoURL = userRecord.photoURL;
                    if (typeof userRecord.displayName !== "string"){
                        name = null
                    }
                    if (typeof userRecord.photoURL !== "string"){
                        photoURL = null
                    }
                    return {
                        uid: userRecord.uid,
                        name: name,
                        photoURL: photoURL
                    };
            });
                const users = await Promise.all(usersPromises);
                console.log("users : ", users)

                const response = {
                    results : users
                }
                return res.status(200).json(response);
            } else {
                const users = friends
                console.log("users : ", users)

                const response = {
                    results : users
                }
                return res.status(200).json(response);
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
    .post(async (req,res) => {
        try {
            //TODO : Supprimer un ami & Supprimer une demande en attente

            // On recupère les données nécessaires
            const userID = req.headers.userid;
            const actionType = req.body.actionType;
            const friendID = req.body.friendid;

            // Vérification du typage
            if (typeof actionType !== 'string' || typeof userID !== 'string' || typeof friendID !== 'string') {
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
            // - refuse : pour refuser une demande d'ami
            // - deblock : pour débloquer un ami
            // - delete : pour supprimer un ami
            // - undo : pour annuler une demande
            
            // Pour ajouter un ami
            if (actionType == "add"){
                // On fait une petite vérification de si il y a déjà une relation entre ces 2 personnes
                const sqlFriend = `SELECT * FROM friends WHERE (userID1 = ? AND userID2 = ?) OR (userID1 = ? AND userID2 = ?) ;`;
                const sqlFriendResult = await executeQuery(sqlFriend, [userID, friendID, userID, friendID]);
                // Dans le cas où il y a déjà une relation
                if (sqlFriendResult.length > 0){
                    const response = {
                        error: true,
                        error_message: 'Friendship already exist',
                        error_code: 35
                    };
                    return res.status(400).json(response);
                }
                // Dans le cas où il n'y pas de relation existante
                // On ajoute une relation d'envoie de demande dans friends
                const sqlQuery = `INSERT INTO friends (userID1, userID2, friendshipStatus) VALUES (?, ?, ?);`;
                const sqlResult = await executeQuery(sqlQuery, [userID, friendID, "21"]);
                // Si il y a bien une ligne qui a été ajouté alors la requête a bien été envoyé
                if (sqlResult.affectedRows > 0){
                    const response = {
                        message : "Request send",
                        status : 200,
                    }
                    return res.status(200).json(response);
                // Sinon il y a une erreur
                } else {
                    const response = {
                        error: true,
                        error_message: 'Internal Server Error',
                        error_code: 2
                    };
                    return res.status(500).json(response);
                }
            }
            // Pour bloquer une personne
            if (actionType == "block"){
                // On regarde les relations userID - friendID
                const sqlFriend = `SELECT * FROM friends WHERE userID1 = ? AND userID2 = ? ;`;
                const sqlFriendResult = await executeQuery(sqlFriend, [userID, friendID]);
                // Si jamais il y a déjà une relation existante
                if (sqlFriendResult.length > 0){
                    // On met à jour la relation entre les 2 utilisateurs

                    let FriendshipStatus = sqlFriendResult[0].friendshipStatus.split('')
                    FriendshipStatus[0] = "3";
                    FriendshipStatus = FriendshipStatus.join().replaceAll(',' , '')


                    const sqlQuery = `UPDATE friends SET friendshipStatus = ? WHERE userID1 = ? AND userID2 = ?;`;
                    const sqlResult = await executeQuery(sqlQuery, [FriendshipStatus, userID, friendID]);
                    // Si on a pu mettre à jour la BDD alors l'utilisateur a bien été bloqué
                    if (sqlResult.affectedRows > 0){
                        const response = {
                            message : "User block successfuly",
                            status : 200,
                        }
                        return res.status(200).json(response);
                    // Si la BDD n'a pas été afecté alors, on renvoie une erreur
                    } else {
                        const response = {
                            error: true,
                            error_message: 'Internal Server Error',
                            error_code: 2
                        };
                        return res.status(500).json(response);
                    }
                // Sinon on regarde les relations friendID - userID
                } else {
                    const sqlFriend = `SELECT * FROM friends WHERE userID1 = ? AND userID2 = ? ;`;
                    const sqlFriendResult = await executeQuery(sqlFriend, [friendID, userID]);
                    // Si jamais une relation est bien existante alors on met à jour la table friends
                    if (sqlFriendResult.length > 0){
                        let FriendshipStatus = sqlFriendResult[0].friendshipStatus.split('')
                        FriendshipStatus[1] = "3";
                        FriendshipStatus = FriendshipStatus.join().replaceAll(',' , '')

                        const sqlQuery = `UPDATE friends SET friendshipStatus = ? WHERE userID1 = ? AND userID2 = ?;`;
                        const sqlResult = await executeQuery(sqlQuery, [FriendshipStatus, friendID, userID]);
                        // Si la MAJ a bien été effectué alors l'utilisateur a bien été bloqué
                        if (sqlResult.affectedRows > 0){
                            const response = {
                                message : "User block successfuly",
                                status : 200,
                            }
                            return res.status(200).json(response);
                        // Sinon alors il y a une erreut 
                        } else {
                            const response = {
                                error: true,
                                error_message: 'Internal Server Error',
                                error_code: 2
                            };
                            return res.status(500).json(response);
                        }
                    // Si il n'y a pas de relations existante alors le code sera le suivant "30"
                    } else {
                        // On ajoute une nouvelle relation dans la table friends
                        const sqlQuery = `INSERT INTO friends (userID1, userID2, friendshipStatus) VALUES (?, ?, ?);`;
                        const sqlResult = await executeQuery(sqlQuery, [userID, friendID, "30"]);
                        // Si l'ajout a bien été effectué alors tout est ok
                        if (sqlResult.affectedRows > 0){
                            const response = {
                                message : "User block",
                                status : 200,
                            }
                            return res.status(200).json(response);
                        // Sinon il y a une erreur
                        } else {
                            const response = {
                                error: true,
                                error_message: 'Internal Server Error',
                                error_code: 2
                            };
                            return res.status(500).json(response);
                        }
                    }
                }
            }
            // Pour accepter une demande d'ami
            if (actionType == "accept"){
                const sqlFriend = `SELECT * FROM friends WHERE userID1 = ? AND userID2 = ? AND friendshipStatus = "12" ;`;
                const sqlFriendResult = await executeQuery(sqlFriend, [userID, friendID]);
                // Si jamais une relation est bien existante alors on met à jour la table friends
                if (sqlFriendResult.length > 0){
                    const sqlQuery = `UPDATE friends SET friendshipStatus = "22" WHERE userID1 = ? AND userID2 = ?;`;
                    const sqlResult = await executeQuery(sqlQuery, [userID, friendID]);
                    if (sqlResult.affectedRows > 0){
                        const createConversationQuery = `INSERT INTO conversations (userID1, userID2, convName) VALUES (?, ?, ?);`;
                        const convName = `Conversation entre ${userID} et ${friendID}`;
                        const convResult = await executeQuery(createConversationQuery, [userID, friendID, convName]);
                        const response = {
                            message : "user accept succesfully",
                            status : 200
                        }
                        return res.status(200).json(response)
                    }else{
                        const response = {
                            error: true,
                            error_message: 'Internal Server Error',
                            error_code: 2
                        };
                        return res.status(500).json(response);
                    }


                } else {
                    const sqlFriend = `SELECT * FROM friends WHERE userID1 = ? AND userID2 = ? AND friendshipStatus = "21" ;`;
                    const sqlFriendResult = await executeQuery(sqlFriend, [friendID, userID]);
                    // Si jamais une relation est bien existante alors on met à jour la table friends
                    if (sqlFriendResult.length > 0){
                        const sqlQuery = `UPDATE friends SET friendshipStatus = "22" WHERE userID1 = ? AND userID2 = ?;`;
                        const sqlResult = await executeQuery(sqlQuery, [friendID, userID]);
                        if (sqlResult.affectedRows > 0){
                            const createConversationQuery = `INSERT INTO conversations (userID1, userID2, convName) VALUES (?, ?, ?);`;
                            const convName = `Conversation entre ${userID} et ${friendID}`;
                            const convResult = await executeQuery(createConversationQuery, [userID, friendID, convName]);
                            const response = {
                                message : "user accept succesfully",
                                status : 200
                            }
                            return res.status(200).json(response)
                        }else{
                            const response = {
                                error: true,
                                error_message: 'Internal Server Error',
                                error_code: 2
                            };
                            return res.status(500).json(response);
                        }
                    } else {
                        // Aucune relation trouvé
                        const response = {
                            error: true,
                            error_message: 'Friendship not found',
                            error_code: 28
                        };
                        return res.status(404).json(response);
                    }
                }
            }
            if (actionType == "refuse"){
                const sqlFriend = `SELECT * FROM friends WHERE userID1 = ? AND userID2 = ? AND friendshipStatus = "12" ;`;
                const sqlFriendResult = await executeQuery(sqlFriend, [userID, friendID]);
                // Si jamais une relation est bien existante alors on met à jour la table friends
                if (sqlFriendResult.length > 0){
                    const sqlQuery = `DELETE FROM friends WHERE userID1 = ? AND userID2 = ? ;`;
                    const sqlResult = await executeQuery(sqlQuery, [userID, friendID]);
                    if (sqlResult.affectedRows > 0){
                        const response = {
                            message : "user refuse succesfully",
                            status : 200
                        }
                        return res.status(200).json(response)
                    }else{
                        const response = {
                            error: true,
                            error_message: 'Internal Server Error',
                            error_code: 2
                        };
                        return res.status(500).json(response);
                    }


                } else {
                    const sqlFriend = `SELECT * FROM friends WHERE userID1 = ? AND userID2 = ? AND friendshipStatus = "21" ;`;
                    const sqlFriendResult = await executeQuery(sqlFriend, [friendID, userID]);
                    // Si jamais une relation est bien existante alors on met à jour la table friends
                    if (sqlFriendResult.length > 0){
                        const sqlQuery = `DELETE FROM friends WHERE userID1 = ? AND userID2 = ? ;`;
                        const sqlResult = await executeQuery(sqlQuery, [friendID, userID]);
                        if (sqlResult.affectedRows > 0){
                            const response = {
                                message : "user refuse succesfully",
                                status : 200
                            }
                            return res.status(200).json(response)
                        }else{
                            const response = {
                                error: true,
                                error_message: 'Internal Server Error',
                                error_code: 2
                            };
                            return res.status(500).json(response);
                        }
                    } else {
                        // Aucune relation trouvé
                        const response = {
                            error: true,
                            error_message: 'Friendship not found',
                            error_code: 28
                        };
                        return res.status(404).json(response);
                    } 
                }
            }
            if (actionType == "deblock"){
                console.log("Deblock activate")
                const sqlFriend = `SELECT * FROM friends WHERE userID1 = ? AND userID2 = ? AND (friendshipStatus = "31" OR friendshipStatus = "32" OR friendshipStatus = "33") ;`;
                const sqlFriendResult = await executeQuery(sqlFriend, [userID, friendID]);
                // Si jamais une relation est bien existante alors on met à jour la table friends
                if (sqlFriendResult.length > 0){
                    let FriendshipStatus = sqlFriendResult[0].friendshipStatus.split('')
                    FriendshipStatus[0] = "2";
                    FriendshipStatus = FriendshipStatus.join().replaceAll(',' , '')
                    const sqlQuery = `UPDATE friends SET friendshipStatus = ? WHERE userID1 = ? AND userID2 = ?;`;
                    const sqlResult = await executeQuery(sqlQuery, [FriendshipStatus, userID, friendID]);
                    // Si on a pu mettre à jour la BDD alors l'utilisateur a bien été bloqué
                    if (sqlResult.affectedRows > 0){
                        const response = {
                            message : "User deblock successfuly",
                            status : 200,
                        }
                        return res.status(200).json(response);
                    // Si la BDD n'a pas été afecté alors, on renvoie une erreur
                    } else {
                        const response = {
                            error: true,
                            error_message: 'Internal Server Error',
                            error_code: 2
                        };
                        return res.status(500).json(response);
                    }
                } else {
                    const sqlFriend = `SELECT * FROM friends WHERE userID1 = ? AND userID2 = ? AND (friendshipStatus = "13" OR friendshipStatus = "23" OR friendshipStatus = "33") ;`;
                    const sqlFriendResult = await executeQuery(sqlFriend, [friendID, userID]);
                    // Si jamais une relation est bien existante alors on met à jour la table friends
                    if (sqlFriendResult.length > 0){
                        let FriendshipStatus = sqlFriendResult[0].friendshipStatus.split('')
                        FriendshipStatus[1] = "2";
                        FriendshipStatus = FriendshipStatus.join().replaceAll(',' , '')
                        const sqlQuery = `UPDATE friends SET friendshipStatus = ? WHERE userID1 = ? AND userID2 = ?;`;
                        const sqlResult = await executeQuery(sqlQuery, [FriendshipStatus, userID, friendID]);
                        // Si la MAJ a bien été effectué alors l'utilisateur a bien été bloqué
                        if (sqlResult.affectedRows > 0){
                            const response = {
                                message : "User deblock successfuly",
                                status : 200,
                            }
                            return res.status(200).json(response);
                        // Sinon alors il y a une erreut 
                        } else {
                            const response = {
                                error: true,
                                error_message: 'Internal Server Error',
                                error_code: 2
                            };
                            return res.status(500).json(response);
                        }
                    } else {
                       // Aucune relation trouvé
                       const response = {
                            error: true,
                            error_message: 'Friendship not found or user not block',
                            error_code: 28
                        };
                        return res.status(404).json(response);
                    }
                } 
            }
            if (actionType == "delete"){
                const sqlFriend = `SELECT * FROM friends WHERE userID1 = ? AND userID2 = ? AND friendshipStatus = "22" ;`;
                const sqlFriendResult = await executeQuery(sqlFriend, [userID, friendID]);
                // Si jamais une relation est bien existante alors on met à jour la table friends
                if (sqlFriendResult.length > 0){
                    const sqlQuery = `DELETE FROM friends WHERE userID1 = ? AND userID2 = ? ;`;
                    const sqlResult = await executeQuery(sqlQuery, [userID, friendID]);
                    if (sqlResult.affectedRows > 0){
                        const response = {
                            message : "user delete succesfully",
                            status : 200
                        }
                        return res.status(200).json(response)
                    }else{
                        const response = {
                            error: true,
                            error_message: 'Internal Server Error',
                            error_code: 2
                        };
                        return res.status(500).json(response);
                    }


                } else {
                    const sqlFriend = `SELECT * FROM friends WHERE userID1 = ? AND userID2 = ? AND friendshipStatus = "22" ;`;
                    const sqlFriendResult = await executeQuery(sqlFriend, [friendID, userID]);
                    // Si jamais une relation est bien existante alors on met à jour la table friends
                    if (sqlFriendResult.length > 0){
                        const sqlQuery = `DELETE FROM friends WHERE userID1 = ? AND userID2 = ? ;`;
                        const sqlResult = await executeQuery(sqlQuery, [friendID, userID]);
                        if (sqlResult.affectedRows > 0){
                            const response = {
                                message : "user delete succesfully",
                                status : 200
                            }
                            return res.status(200).json(response)
                        }else{
                            const response = {
                                error: true,
                                error_message: 'Internal Server Error',
                                error_code: 2
                            };
                            return res.status(500).json(response);
                        }
                    } else {
                        // Aucune relation trouvé
                        const response = {
                            error: true,
                            error_message: 'Friendship not found',
                            error_code: 28
                        };
                        return res.status(404).json(response);
                    } 
                }
            }
            if (actionType == "undo"){
                const sqlFriend = `SELECT * FROM friends WHERE userID1 = ? AND userID2 = ? AND friendshipStatus = "21" ;`;
                const sqlFriendResult = await executeQuery(sqlFriend, [userID, friendID]);
                // Si jamais une relation est bien existante alors on met à jour la table friends
                if (sqlFriendResult.length > 0){
                    const sqlQuery = `DELETE FROM friends WHERE userID1 = ? AND userID2 = ? ;`;
                    const sqlResult = await executeQuery(sqlQuery, [userID, friendID]);
                    if (sqlResult.affectedRows > 0){
                        const response = {
                            message : "user undo succesfully",
                            status : 200
                        }
                        return res.status(200).json(response)
                    }else{
                        const response = {
                            error: true,
                            error_message: 'Internal Server Error',
                            error_code: 2
                        };
                        return res.status(500).json(response);
                    }


                } else {
                    const sqlFriend = `SELECT * FROM friends WHERE userID1 = ? AND userID2 = ? AND friendshipStatus = "21" ;`;
                    const sqlFriendResult = await executeQuery(sqlFriend, [friendID, userID]);
                    // Si jamais une relation est bien existante alors on met à jour la table friends
                    if (sqlFriendResult.length > 0){
                        const sqlQuery = `DELETE FROM friends WHERE userID1 = ? AND userID2 = ? ;`;
                        const sqlResult = await executeQuery(sqlQuery, [friendID, userID]);
                        if (sqlResult.affectedRows > 0){
                            const response = {
                                message : "user undo succesfully",
                                status : 200
                            }
                            return res.status(200).json(response)
                        }else{
                            const response = {
                                error: true,
                                error_message: 'Internal Server Error',
                                error_code: 2
                            };
                            return res.status(500).json(response);
                        }
                    } else {
                        // Aucune relation trouvé
                        const response = {
                            error: true,
                            error_message: 'Friendship not found',
                            error_code: 28
                        };
                        return res.status(404).json(response);
                    } 
                }
            }
            const response = {
                error: true,
                error_message: 'Invalid Data',
                error_code: 33
            };
            return res.status(400).json(response);
        } catch (error) {
            console.error('Error retrieving friends:', error);
            const response = {
                error: true,
                error_message: 'Internal Server Error',
                error_code: 2
            };
            return res.status(500).json(response);
        }
    });

router.route('/search')
    .get(async (req, res) => {
        const userID = req.headers.userid;
        const idSearch = req.query.idSearch;

        try {
            const listUsers = [];
            const listAllUsers = await admin.auth().listUsers();

            listAllUsers.users.forEach(async userRecord => {
                // On vérifie si idSearch correspond à un userID
                if (userRecord.uid.startsWith(idSearch) && userRecord.uid != userID) {
                    surname = userRecord.displayName ;
                    photoURL = userRecord.photoURL;
                    if (typeof userRecord.displayName !== "string"){
                        surname = null
                    }
                    if (typeof userRecord.photoURL !== "string"){
                        photoURL = null
                    }
                    const user = {
                        name: surname,
                        uid: userRecord.uid,
                        photoURL : photoURL
                    };
                    listUsers.push(user);
                }
                // On vérifie  si idSearch correspond à un nom d'utilisateur (début du nom)
                else if (userRecord.displayName!==undefined && userRecord.displayName.startsWith(idSearch) && userRecord.uid != userID) {
                    surname = userRecord.displayName ;
                    photoURL = userRecord.photoURL;
                    if (typeof userRecord.displayName !== "string"){
                        surname = null
                    }
                    if (typeof userRecord.photoURL !== "string"){
                        photoURL = null
                    }
                    const user = {
                        name: surname,
                        uid: userRecord.uid,
                        photoURL : photoURL
                    };
                    listUsers.push(user);
                }
            });
            const sqlFriend2 = `SELECT userID2 FROM friends WHERE userID1 = ? ;`;
            const sqlFriendResult2 = await executeQuery(sqlFriend2, [userID]);
            const sqlFriend1 = `SELECT userID1 FROM friends WHERE userID2 = ? ;`;
            const sqlFriendResult1 = await executeQuery(sqlFriend1, [userID]);
            for (user in listUsers){
                if (sqlFriendResult2.includes(user["uid"])){
                    const research = (element) => element = user
                    const index = listUsers.findIndex(research)
                    listUsers.splice(index,1)
                }
                if (sqlFriendResult1.includes(user["uid"])){
                    const research = (element) => element = user
                    const index = listUsers.findIndex(research)
                    listUsers.splice(index,1)
                }
            }
            return res.status(200).json({
                query: idSearch,
                results: listUsers
            });
        } catch (error) {
            console.error('Error searching for users:', error);
            const response = {
                error: true,
                error_message: 'Internal Server Error',
                error_code: 2
            };
            return res.status(500).json(response);
        }
    });


// Route status si besoin
router.route('/status')
    .post(async (req, res) => {
        try {
            const userID = req.headers.userid;
            const friendID = req.body.friendid;
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
