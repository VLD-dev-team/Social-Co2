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
const routes = require('./routes/index.js');
app.use('/', routes)

// lancement du serveur
app.listen(3000, () => {
  console.log('Server listening on port 3000');
});