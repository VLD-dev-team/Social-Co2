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

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// importer les routes depuis le fichier routes/index.js
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