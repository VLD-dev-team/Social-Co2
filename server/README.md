# Partie serveur

## Sommaire

* Documentation Docker
  * La création du système avec le docker
  * Pourquoi utiliser ce système ?
* Documentation des Bases de données
  * La création de la base de donnée SQL de SCO2
* Notre système avec les API et les routes
  * Plan des routes
  * L'authentification
  * Les erreurs
  * Le système de messagerie
    * Socket.io
    * Pourquoi avoir utiliser ce procédé ?
* Documentation de l'API
* Test avec postman
* Ressources supplémentaires




## Documentation Docker

### La création du système avec le docker

Pour creer la BDD SQL, il faut utiliser un docker pour ce faire suivre les étapes suivantes :

1. Création d'un fichier docker-compose.yml à la racine du dossier server :

```yml
version: '3'
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    volumes:
      - ./app:/app
    environment:
      - FIREBASE_CREDENTIALS=./credentials/firebaseAdminCredentials.json
    depends_on:
      - mysql

  mysql:
    image: mysql:latest
    environment:
      MYSQL_ROOT_PASSWORD: process.env.BDDpsw
      MYSQL_DATABASE: process.env.BDDdatabase

```

2. Création du fichier Dockerfile à la racine du dossier server :

```Dockerfile
FROM node:14

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "app.js"]
```

3. Création d'un fichier .dockerignore, il faut mettre les éléments suivants à l'intérieur de celui-ci :

```.dockerignore
npm-debug.log
/node_modules
```

4. Création du docker via le terminal

```
docker run --name Docker-mysql -e MYSQL_ROOT_PASSWORD=MyLuckyluck6*ql -d mysql:latest

docker exec -it Docker-mysql bash

------------------------------------------------------------------------------------------
// Sans automatisation

docker build -t docker_sco2 .

docker run -p 3000:3000 docker_sco2

------------------------------------------------------------------------------------------
// Avec automatisation (server automatisé)

docker-compose up --build

docker-compose down

```

### Pourquoi utiliser ce système ?

L'installation de SQL service se fait directement sur la machine. A défaut de ne pas pouvoir l'installer, vous pouvez opter pour une machine virtuelle dans laquelle vous pourrez utiliser le docker ci dessus.

## Documentation des Bases de données

### La création de la base de donnée SQL de SCO2

1. Installation de mysql

```
apt-get install mysql
```

2. Lancement de mysql

```
mysql -u root -p
```

3. Création des tables

```sql

CREATE TABLE activities (
  activityID INT AUTO_INCREMENT,
  userID VARCHAR(255),
  activityType VARCHAR(255),
  activityCO2Impact INT,
  activityName VARCHAR(255),
  activityTimestamp TIMESTAMP ,
  PRIMARY KEY (activityID)
);

CREATE TABLE recurrentActivities (
  activityID INT AUTO_INCREMENT,
  userID varchar(255),
  activityType VARCHAR(255),
  activityCO2Impact FLOAT,
  activityName VARCHAR(255),
  activityTimestamp TIMESTAMP,
  PRIMARY KEY (activityID)
);

CREATE TABLE users (
  userID Varchar(255),
  score INT,
  recycl BOOLEAN,
  nb_inhabitants INT,
  area FLOAT,
  garden BOOLEAN,
  multiplier FLOAT,
  car INT,
  hybrid BOOLEAN,
  heating VARCHAR(255),
  PRIMARY KEY (userID)
);

CREATE TABLE friends (
  friendshipID INT AUTO_INCREMENT,
  userID1 VARCHAR(255),
  userID2 VARCHAR(255),
  friendshipStatus VARCHAR(255),
  PRIMARY KEY (friendshipID)
);

CREATE TABLE notifications (
  notificationID INT AUTO_INCREMENT,
  userID VARCHAR(255),
  notificationContent VARCHAR(255),
  notificationTitle VARCHAR(255),
  notificationStatus VARCHAR(255),
  PRIMARY KEY (notificationID)
);

CREATE TABLE conversations (
  convID INT AUTO_INCREMENT,
  userID1 VARCHAR(255),
  userID2 VARCHAR(255),
  convName VARCHAR(255),
  convCreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  convLastMessage INT,
  PRIMARY KEY (convID)
);

CREATE TABLE messages (
  messageID INT AUTO_INCREMENT,
  convID INT,
  messageSenderID VARCHAR(255),
  messageReceiverID VARCHAR(255),
  messageStatus VARCHAR(255),
  messageTextContent VARCHAR(255),
  messageMediaContentURL VARCHAR(255),
  messageCreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (messageID)
);

CREATE TABLE posts (
  postID INT AUTO_INCREMENT,
  userID VARCHAR(255),
  postTextContent VARCHAR(255) DEFAULT NULL,
  postMediaContentURL VARCHAR(255) DEFAULT NULL,
  postLinkedActivity VARCHAR(255) DEFAULT NULL,
  postLikesNumber INT DEFAULT 0,
  postCreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
  postCommentsNumber INT DEFAULT 0,
  postType VARCHAR(255),
  PRIMARY KEY (postID)
);

CREATE TABLE likes(
  postID int,
  userID varchar(255)
);

CREATE TABLE comments(
  userID varchar(255),
  postID int,
  commentTextContent varchar(255),
  commentCreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
```

## Notre système avec les API et les routes

### Plan des routes

- '*' (get) 404
- '/api' (get)
  - '/activity' (get & post & put & delete)
    - '/favorite' (post & delete)
  - '/activities' (get)
    - '/favorite' (get)
  - '/user' (get & post & put & delete)
    - '/activities' (get)
    - '/notifications' (get)
  - '/leaderboard'
    - '/friends' (get)
    - '/world' (get)
  - '/social'
    - '/feed' (get)
    - '/like' (post)
    - '/comments' (get & post)
    - '/posts' (post)
  - '/friends' (get & post)
    - '/search' (get)
  - '/rapport' (get)
  - '/conversations' (get)
  - '/messages (get)
  - '/websocket' (socket.io)


### L'authentification

Pour le système d'authentification, nous utilisons firebase. Pour ce faire, nous avons intégré le code suivant dans `app.js` : 

```js
// initialisation de firebase admin
var firebaseAdmin = require("firebase-admin");
var serviceAccount = require("./credentials/firebaseAdminCredentials.json");
firebaseAdmin.initializeApp({
  credential: firebaseAdmin.credential.cert(serviceAccount)
});
```

Cela nous servira à récupérer les données de firebase dans notre code.

Puis nous avons creer la fonction d'authentification dans le fichier `utils/requireAuth.js` :

```js
const admin = require('firebase-admin');
const jwt = require('jsonwebtoken');

// Middleware pour vérifier le token d'authentification
const verifyAuthToken = (req, res, next) => {
  const authToken = req.headers.authorization;

  if (!authToken) {
    const response = {
      error: true,
      error_message: 'Token not supplied',
      error_code: 29
    }
    return res.status(401).json(response);
  }

  // On vérifie le token avec firebase-admin
  admin.auth().verifyIdToken(authToken)
    .then(decodedToken => {
      const userIDFromToken = decodedToken.uid;

      // Récupérer le userID depuis le header
      const userIDFromHeader = req.headers.userid;

      // Comparer les userID
      if (userIDFromToken !== userIDFromHeader) {
          const response = {
            error: true,
            error_message: 'Invalid Token',
            error_code: 30
          }
        return res.status(401).json(response);
      }

      // Si les userID correspondent, ajoutez l'utilisateur à la demande
      req.user = decodedToken;
      next();
    })
    .catch(error => {
      console.error('Erreur de vérification du token Firebase:', error);
      const response = {
        error: true,
        error_message: 'Invalid Token',
        error_code: 30
      }
      return res.status(401).json(response);
    });
};

// On exporte le middleware pour l'utiliser
module.exports = verifyAuthToken;
```

Toute la documentation vis à vis de l'authentification de firebase est disponible sur le site de firebase.

### Les erreurs

Pour traiter les erreurs, nous avons identifiés chacunes des erreurs par un code d'erreur :

* Code d'erreur n°1 : Invalid user ID - Statut 400
* Code d'erreur n°2 : Internal Server Error - Statut 500
* Code d'erreur n°3 : User not found in SQL database - Statut 400
* Code d'erreur n°4 : Page not found - Statut 404
* Code d'erreur n°5 : Invalid user ID or post ID - Statut 400
* Code d'erreur n°6 : User has already liked this post - Statut 400
* Code d'erreur n°7 : Failed to process like - Statut 500
* Code d'erreur n°8 : User is already in database - Statut 400
* Code d'erreur n°9 : Invalid user ID, post ID, or comment content - Statut 400
* Code d'erreur n°10 : Failed to process comment - Statut 500
* Code d'erreur n°11 : Failed to add comment - Statut 500
* Code d'erreur n°12 : Invalid activity ID - Statut 400
* Code d'erreur n°13 : Activity or User not found in SQL database - Statut 404
* Code d'erreur n°14 : Invalid activityType - Statut 400
* Code d'erreur n°15 : Invalid activityCO2Impact - Statut 400
* Code d'erreur n°16 : Invalid activityPollutionImpact - Statut 400
* Code d'erreur n°17 : Invalid activityName - Statut 400
* Code d'erreur n°18 : Failed to insert activity - Statut 500
* Code d'erreur n°19 : Invalid user ID or activity ID - Statut 400
* Code d'erreur n°20 : Permission denied: User does not own this activity - Statut 403
* Code d'erreur n°21 : Failed to update activity - Statut 500
* Code d'erreur n°22 : Failed to delete activity - Statut 500
* Code d'erreur n°23 : Users are not friends or friendship status is not accepted. Conversation cannot be created. - Statut 400
* Code d'erreur n°24 : Conversation already exists. - Statut 400
* Code d'erreur n°25 : Failed to create conversation. - Statut 500
* Code d'erreur n°26 : You are not part of this conversation. - Statut 403
* Code d'erreur n°27 : Friend not found - Statut 404
* Code d'erreur n°28 : Friendship not found - Statut 404
* Code d'erreur n°29 : Token not supplied - Statut 401
* Code d'erreur n°30 : Invalid Token - Statut 401
* Code d'erreur n°31 : Donnée manquante - Statut 400
* Code d'erreur n°32 : User doesnt have this activity in favorite - Statut 400
* Code d'erreur n°33 : Invalid Data - Statut 400
* Code d'erreur n°34 : Failed to create post - Statut 400
* Code d'erreur n°35 : Friendship already exist - Statut 400




### Le système de messagerie

#### Socket.io

Pour utiliser le socket socket.io, nous avons creer un fichier `websocket.js` dans le dossier `apiroutes` qui va s'occuper de gérer les messages et les notifications.


```js
// Fichier websocket.js

const express = require('express');
const initializeSocket = require('../utils/socketManager.js');
const { createServer } = require("http");

const router = express.Router();

// Initialisation du serveur Socket.io
const server = createServer();
const io = initializeSocket(server);

router.use('/', (req, res, next) => {
    req.io = io;
    next();
});


module.exports = router;
```

```js
// Fichier socketManager.js

const socketIo = require('socket.io');
const { verifyAuthToken } = require('./requireAuth.js');
const { sendMessage } = require('./messageHandler.js');

// Fonction pour initialiser Socket.io avec le serveur Express
const initializeSocket = (server) => {
    const io = socketIo(server);

    // Gestion des connexions
    io.on('connection', (socket) => {
        console.log('User connected:', socket.id);

        // Gestion des déconnexions
        socket.on('disconnect', () => {
            console.log('User disconnected:', socket.id);
        });

        socket.on('sendMessage', async (data) => {
            try {
                // Vérification de l'authentification de l'utilisateur
                const userID = await verifyAuthToken(data.token);
    
                // Appel de la fonction sendMessage avec les données appropriées
                const result = await sendMessage(userID, data.receiver, data.message);
                
                // Émission d'événements au client une fois le message traité
                io.to(result.convID).emit('updateConv', {
                    convID: result.convID,
                    lastMessage: result.lastMessage,
                    unreadCount: result.unreadCount
                });
                io.to(result.convID).emit('newMessage', {
                    convID: result.convID,
                    lastMessage: result.lastMessage,
                    unreadCount: result.unreadCount
                });
    
                console.log(result);
            } catch (error) {
                console.error('Error sending message:', error);
                // Gérer les erreurs ici et émettre un événement d'erreur au client si nécessaire
                socket.emit('sendMessageError', { error: 'Failed to send message' });
            }
        });
    });

    // Middleware pour ajouter le socket à la demande Express
    io.use((socket, next) => {
        const userID = socket.handshake.auth.userID;
        if (userID) {
            socket.userID = userID;
            return next();
        }
        return next(new Error('Authentication error'));
    });

    return io;
};

module.exports = initializeSocket;

```

C'est dans ce fichier qu'on initialise le socket, qu'on creer le serveur pour communiqué en instantané. Cela nous permet d'écouter le côté client et dès qu'un message sera envoyé par l'intermédiaire de cette commande alors il sera immédiatement traité, et la conversation sera mise à jour en temps réel. Et c'est dans le fichier `messageHandler.js` que l'on envoie le message : 

```js
const { executeQuery } = require('./database.js');

// Fonction pour envoyer un message

const sendMessage = async (senderID, receiverID, messageTextContent) => {
    try {
        const checkFriendshipQuery = `
            SELECT friendshipStatus FROM friends
            WHERE (userID1 = ? AND userID2 = ?) OR (userID1 = ? AND userID2 = ?)
        `;
        const checkFriendshipResult = await executeQuery(checkFriendshipQuery, [senderID, receiverID, receiverID, senderID]);

        if (checkFriendshipResult.length === 0 || checkFriendshipResult[0].friendshipStatus !== '22') {
            // Si les utilisateurs ne sont pas amis ou le statut d'amitié n'est pas "22", renvoyer une erreur 400
            const error = new Error('Users are not friends or friendship status is not accepted. Conversation cannot be created.');
            error.status = 400;
            throw error;
        }

        const checkConversationQuery = `
            SELECT convID FROM conversations
            WHERE (userID1 = ? AND userID2 = ?) OR (userID1 = ? AND userID2 = ?)
        `;
        const checkConversationResult = await executeQuery(checkConversationQuery, [senderID, receiverID, receiverID, senderID]);

        if (checkConversationResult.length === 0) {
            const createConversationQuery = `
                INSERT INTO conversations (userID1, userID2, convCreatedAt)
                VALUES (?, ?, CURRENT_TIMESTAMP)
            `;
            const createConversationResult = await executeQuery(createConversationQuery, [senderID, receiverID]);

            if (createConversationResult.affectedRows === 0) {
                // Erreur 400 si la création de la conversation échoue
                const error = new Error('Failed to create conversation');
                error.status = 400;
                throw error;
            }
        }

        const convIDQuery = `
            SELECT convID FROM conversations
            WHERE (userID1 = ? AND userID2 = ?) OR (userID1 = ? AND userID2 = ?)
        `;
        const convIDResult = await executeQuery(convIDQuery, [senderID, receiverID, receiverID, senderID]);

        if (convIDResult.length === 0) {
            // Erreur 400 si l'obtention de l'ID de la conversation échoue
            const error = new Error('Failed to get conversation ID');
            error.status = 400;
            throw error;
        }

        const convID = convIDResult[0].convID;

        const insertMessageQuery = `
            INSERT INTO messages (convID, messageSenderID, messageTextContent, messageCreatedAt, messageStatus)
            VALUES (?, ?, ?, CURRENT_TIMESTAMP, 'unread')
        `;
        const insertMessageResult = await executeQuery(insertMessageQuery, [convID, senderID, messageTextContent]);

        if (insertMessageResult.affectedRows === 0) {
            // Erreur 400 si l'insertion du message échoue
            const error = new Error('Failed to insert message');
            error.status = 400;
            throw error;
        }

        const createNotificationQuery = `
            INSERT INTO notifications (userID, notificationContent, notificationTitle, notificationStatus, notificationCreatedAt)
            VALUES (?, ?, ?, 'unread', CURRENT_TIMESTAMP)
        `;
        const createNotificationResult = await executeQuery(createNotificationQuery, [receiverID, 'New message received', 'New Message']);

        if (createNotificationResult.affectedRows === 0) {
            // Erreur 400 si la création de la notification échoue
            const error = new Error('Failed to create notification');
            error.status = 400;
            throw error;
        }

        // Compter le nombre de messages non lus pour l'utilisateur dans cette conversation
        const unreadCountQuery = `
            SELECT COUNT(*) AS unreadCount
            FROM messages
            WHERE convID = ? AND messageStatus = 'unread' AND messageSenderID != ?
        `;
        const unreadCountResult = await executeQuery(unreadCountQuery, [convID, receiverID]);
        const unreadCount = unreadCountResult[0].unreadCount;

        return {
            convID: convID,
            lastMessage: {
                messageSenderID: senderID,
                messageTextContent: messageTextContent,
                messageCreatedAt: new Date().toISOString()
            },
            unreadCount: unreadCount
        };
    } catch (error) {
        console.error('Error sending message:', error);
        throw error.status ? error : new Error('Internal Server Error');
    }
};

module.exports = {
    sendMessage,
};
```

Nous avons utilisé le même procédé pour les notifications dans le fichier `notificationHandler.js` :

```js
const { executeQuery } = require('./database.js');
const socketManager = require('../utils/socketManager.js');

const handleNewNotification = async (io, notificationData) => {
    const { userID, notificationContent } = notificationData;

    // On émet la notification à l'utilisateur concerné via Socket.io
    io.to(userID).emit('newNotification', { notificationContent });

    // Mettre à jour le statut de la notification dans la base de données
    const updateNotificationQuery = `UPDATE notifications SET notificationStatus = 'send' WHERE userID = ? AND notificationContent = ? ;`;
    await executeQuery(updateNotificationQuery, [userID, notificationContent]);
};

module.exports = {
    handleNewNotification,
    // watchNotifications
};
```

#### Pourquoi avoir utiliser ce procédé ?

Nous avons utilisé ce procédé afin de pouvoir avoir des interactions en temps réel sans avoir besoin de recharger la page web. Le principe d'un chat en quelque sorte. C'est important pour nous que les utilisateurs puissent communiqués entre eux de manière fiable et rapide.

## Documentation de l'API

Pour plus d'informations, voir le fichier `GestionAPI.drawio`

### Gestion des activités

-- Utilisation de la route /activity --

* GET :  Donne les informations d'une activité
* POST : Creer une activité dans la table activité
* PUT : Met à jour une activité
* DELETE : Supprime une activité

-- Utilisation de la route /activity/favorite --

* POST : Met en favori une activité
* DELETE : Enlève une activité des favoris

-- Utilisation de la route /activities --

* GET : Donne les 20 activités d'un utilisateur à partir d'un index

-- Utilisation de la route /activities/favorite --

* GET : Donne les 20 activités favorite d'un utilisateur à partir d'un index

### Gestion de l'utilisateur

-- Utilisation de la route /user --

* GET : Donne toutes les infos de l'utilisateur
* POST : Création de l'utilisateur
* PUT : Met à jour les infos de l'utilisateur
* DELETE : Supprime l'utilisateur et tout ce qu'il lui est associé

-- Utilisation de la route /user/activities --

* GET : Donne toutes les activités et leurs infos d'un utilisateur à partir d'une date + donne la phrase récapitulative

-- Utilisation de la route /user/notifications --

* GET : Donne le contenu des 10 dernières notifications émises

### Gestion du leaderboard

-- Utilisation de la route /leaderboard/friends --

* GET : Donne le classement des amis avec soit compris au niveau du score

-- Utilisation de la route /leaderboard/world --

* GET : Donne le classement des utilisateurs avec soit compris au niveau du score

### Gestion du réseau social principal

-- Utilisation de la route /social/feed --

* GET : Donne les différents posts liés au compte de l'utilisateur donc aussi ces amis

-- Utilisation de la route /social/like --

* POST : permet d'ajouter un like au post

-- Utilisation de la route /social/comments --

* GET : Charger les commentaires d'un post
* POST : ajouter un commentaire à un post

### Gestion de l'amitié

-- Utilisation de la route /friends --

* GET : Donne les différents amis, personnes en attente et bloqués dans un dictionnaire JSON
* POST : actionType :
  - add : pour envoyer une demande d'ami
  - block : pour bloquer
  - accept : pour accepter la demande d'ami si il y en a une
  - refuse
  - deblock

-- Utilisation de la route /friends/search --

* GET : rechercher un utilisateur qui commence par idSearch

### Affichage du rapport

-- Utilisation de la route /rapport --

* GET : Charge le rapport en envoyant les acitivtés trioés par types et par dates sous forme de dictionnaire JSON

### Gestion du système de messagerie

-- Utilisation de la route /conversations --

* GET : Charger les conversations de l'utilisateur

-- Utilisation de la route /messages --

* GET : Charger les 40 derniers messages partir d'un index 

## Test avec postman

Pour tester notre **API**, j'ai opté pour le logiciel Postman qui permet de faire des requêtes directement au serveur avec les différentes clés en paramètres : HEADERS, BODY, PARAMS, QUERY ...

J'ai donc pu tester toutes les routes en : GET, POST, DELETE & PUT pour voir si tout fonctionnait.

Postman est une excellente alternative au test serveur via le web qui est beaucoup plus long. De plus celui-ci affiche bien la réponse donnée par le serveur soit la plupart du temps le JSON.

## Ressources supplémentaires

Dans le dossier `schemaAPI` se trouve une schematisation de notre API. La schematisation à jour est celle qui se nomme : `GestionAPI.drawio`. Celle qui se nomme `API.drawio` est le brouillon de notre API. Le fichier doit être ouvert avec le site ou logiciel drawio.