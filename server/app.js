// importation des modules

// Le module express
const express = require('express');
const { createServer } = require('node:http');

// Le module bodyParser
const bodyParser = require('body-parser');

const { executeQuery } = require('./utils/database.js');

const path = require('path'); // Le module path pour react

// Le module CORS
const cors = require('cors');

// initialisation de la variable environnement
require('dotenv').config()

// initialisation d'express et socket.io
const app = express();
const server = createServer(app);

// initialisation de firebase admin
const firebaseAdmin = require("firebase-admin");
const serviceAccount = require("./credentials/firebaseAdminCredentials.json");
firebaseAdmin.initializeApp({
  credential: firebaseAdmin.credential.cert(serviceAccount)
});

// configuration de cors
const allowedOrigins = ['https://app.social-co2.vld-group.com'];
app.options('*', cors())
app.use(cors({
  origin: function(origin, callback){
    return callback(null, true); // TODO: à enlever à la fin des test en prod
    if (!origin) {
      return callback(null, true);
    }
    if (!allowedOrigins.includes(origin)) {
      const msg = 'The CORS policy for this site does not allow access from the specified Origin.';
      return callback(new Error(msg), false);
    }
    return callback(null, true);
  },
}));

// Paramètrage de l'encodage des corps des requetes
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// Définition du router 
const apiroutes = require('./apiroutes/index.js');
const WebsocketService = require('./websocket/websocketService.js');
app.use('/', apiroutes);

// démarrage du socket et handle des routes socket
const socketService = require('./websocket/websocketService.js');
socketService.initialize(server, allowedOrigins);

// Utiliser un port différent que socket.io -> port 3006
// lancement du serveur
server.listen(process.env.ServerPort || 3000, () => {
  console.log(`Server listening on port ${process.env.ServerPort || 3000}`);
});

