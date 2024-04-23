// importation des modules

// Le module express
const express = require('express');

// Le module bodyParser
const bodyParser = require('body-parser');

const { executeQuery } = require('./utils/database.js');

const websocketRouter = require('./apiroutes/websocket.js'); // Importer le routeur WebSocket

const path = require('path'); // Le module path pour react

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


// On utilise express.static pour servir les fichiers statiques de notre application React
app.use('/', express.static(path.join(__dirname, '../website/sco2-react')));
// Route pour servir le site React
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '../website/sco2-react', 'index.html'));
});

// On utilise express.static pour servir les fichiers statiques de notre application Flutter
app.use('/app', express.static(path.join(__dirname, '../application/social_co2/build/web')));

// Route pour servir l'application Flutter
app.get('/app', (req, res) => {
  res.sendFile(path.join(__dirname, '../application/social_co2/build/web', 'index.html'));
});

const apiroutes = require('./apiroutes/index.js');
app.use('/api', apiroutes);

// Utiliser un port différent que socket.io -> port 3006
// lancement du serveur
const server = app.listen(process.env.ServerPort || 3000, () => {
  console.log(`Server listening on port ${process.env.ServerPort || 3000}`);
});

// Utilisation du routeur WebSocket sur /api/websocket
app.use('/api/websocket', websocketRouter);
