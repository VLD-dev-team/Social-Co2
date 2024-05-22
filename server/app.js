// importation des modules

// Le module express
const express = require('express');

// Le module bodyParser
const bodyParser = require('body-parser');

const { executeQuery } = require('./utils/database.js');

const websocketRouter = require('./apiroutes/websocket.js'); // Importer le routeur WebSocket

const path = require('path'); // Le module path pour react

// Le module CORS
const cors = require('cors');

// initialisation de la variable environnement
require('dotenv').config()

// initialisation d'express
const app = express();

// initialisation de firebase admin
const firebaseAdmin = require("firebase-admin");
const serviceAccount = require("./credentials/firebaseAdminCredentials.json");
firebaseAdmin.initializeApp({
  credential: firebaseAdmin.credential.cert(serviceAccount)
});

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// Paramétrage du CORS
app.use((req, res, next) => {
  res.header('Content-Type', "application/json")
  res.header('Access-Control-Allow-Origin', 'https://app.social-co2.vld-group.com');
  console.log(req.headers.origin);
  res.header('Access-Control-Allow-Credentials', true)
  next();
});

const apiroutes = require('./apiroutes/index.js');
app.use('/', apiroutes);

// Utiliser un port différent que socket.io -> port 3006
// lancement du serveur
const server = app.listen(process.env.ServerPort || 3000, () => {
  console.log(`Server listening on port ${process.env.ServerPort || 3000}`);
});

// Utilisation du routeur WebSocket sur /api/websocket
app.use('/api/websocket', websocketRouter);
