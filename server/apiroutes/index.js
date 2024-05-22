// Gestionnaire de routes

/// importation des modules
const express = require('express');
const router = express.Router();
const cors = require('cors');

// on importe les fonctions des routes
const websocket = require('./websocket.js')
const user = require('./user.js')
const activity = require('./activity.js')
const activities = require('./activities.js')
const leaderboard = require('./leaderboard.js')
const social= require('./social.js')
const friends= require('./friends.js')
const rapport= require('./rapport.js')
const conversations = require('./conversations.js')
const messages = require('./messages.js');
const { executeQuery } = require('../utils/database.js');

/// Pages principale de l'espace de travail
router.use('/websocket', websocket);
router.use('/user', user);
router.use('/activity', activity);
router.use('/activities', activities);
router.use('/leaderboard', leaderboard);
router.use('/social', social);
router.use('/friends', friends);
router.use('/rapport', rapport);
router.use('/conversations', conversations);
router.use('/messages', messages);

/// définition des routes

// Route de l'api pour voir si la connection fonctionne bel et bien

router.get('/',async (req,res)=>{
    const response = {
        ping : 'Is check',
        status : 200,
        type : 'response'
    }
    return res.status(200).json(response);
})

module.exports = router;