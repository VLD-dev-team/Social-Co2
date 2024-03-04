// Gestionnaire de routes

/* Plan des routes

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
        - /friends (get)
            - /search (get)
            - /status (post)
        - /notifications (get)
        - /social (get)
            - /feed (get)
            - /conversations (get) & (post)
                - /messages (get)
    - /activity (get) & (post) & (put) & (delete)
    - /like (post)
    - /comments (post)
*/

// importation des modules
const express = require('express');
const router = express.Router();

// on importe les fonctions des routes
const websocket = require('./websocket.js')
const user = require('./user.js')
const activity = require('./activity.js')
const like = require('./like.js')
const comments = require('./comments.js')
const activities = require('./userRoutes/activities.js')
const friends = require('./userRoutes/friends.js')
const notifications = require('./userRoutes/notifications.js')
const social = require('./userRoutes/social.js')
const notFoundRoute = require('./notFoundRoute.js');

// définition des routes

router.get('/',(req,res)=>{
    const response = {
        ping : 'Is check',
        status : 200,
        type : 'response'
    }
    return res.status(200).json(response);
})
  

/// Pages principale de l'espace de travail
router.use('/websocket', websocket);
router.use('/user', user);
router.use('/activity', activity);
router.use('/like', like);
router.use('/comments', comments);
router.use('/user/activities', activities);
router.use('/user/friends', friends);
router.use('/user/notifications', notifications);
router.use('/user/social', social);
router.use(notFoundRoute);

module.exports = router;