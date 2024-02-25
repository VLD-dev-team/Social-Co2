// importation des modules

// Le module express
const express = require('express');

// Le module bodyParser
const bodyParser = require('body-parser');

const { executeQuery } = require('./utils/database.js');

// initialisation de la variable environnement
require('dotenv').config()

// initialisation d'express
const app = express();

// initialisation de firebase admin
var firebaseAdmin = require("firebase-admin");
var serviceAccount = require("./credentials/firebaseAdminCredentials.json");
firebaseAdmin.initializeApp({
  credential: firebaseAdmin.credential.cert(serviceAccount)
});

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

const apiroutes = require('./apiroutes/index.js');
app.use('/api', apiroutes);

// Utiliser un port différent que socket.io -> port 3006
// lancement du serveur
app.listen(process.env.BDDport || 3006, () => {
  console.log(`Server listening on port ${process.env.BDDport || 3000}`);
});
