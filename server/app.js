// importation des modules

// Le module express
const express = require('express');

// Le module bodyParser
const bodyParser = require('body-parser');

// Le module path
const path = require('path');

// initialisation de la variable environnement
require('dotenv').config()

// initialisation d'express
const app = express();

const admin = require('firebase-admin');

const serviceAccount = require('./utils/google-services.json');

// Initialisation de la configuration dans firebase
const firebaseConfig = {
  apiKey: process.env.FIREBASE_API_KEY,
  authDomain: process.env.FIREBASE_AUTH_DOMAIN,
  projectId: process.env.FIREBASE_PROJECT_ID,
  storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.FIREBASE_APP_ID,
};

// Création ud crédential firebase
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

const apiroutes = require('./routes/index.js');
app.use('/api', apiroutes)

// lancement du serveur
app.listen(3000, () => {
  console.log('Server listening on port 3000');
});

// Exemple de post

// app.post('/activity', (req, res) => {
//   const authToken = req.headers.authToken
//   // Validation token

//   actitity = Actitity.getActivity(req.body.actitityID);

//   res.status('200').send(activity);
// })