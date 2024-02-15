// Gestionnaire de routes

/* Plan du site

- * (get) 404
- / (get) Application React
- /api (get)
    - /websocket (socket.io)
        - score
        - messages
        - notifications
        - conversations
    - /user (get)
        - /activities (get)
    - /activity (get) & (post) & (put) & (delete)
    - /friends (post) & (delete) & (get)
    - 





*/

// importation des modules
const express = require('express');
const router = express.Router();

// on importe les fonctions des routes
const home = require('./home.js');

// définition des routes

/// Pages principale de l'espace de travail
router.use('/home', home);

module.exports = router;