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

/* const loadFirebaseDatabaseEvents = (client, dir = "./events/firebase") => { // chargement des event firebase depuis ./events/firebase
  const functions = readdirSync(`${dir}`).filter(files => files.endsWith(".js"));
  for (const firebasefonction of functions) {
    console.log(`[Lists Loader] ${firebasefonction} chargé`);
    const { load } = require(`../${dir}/${firebasefonction}`);
    load(client, client.FirebaseDatabaseAdminClient)
  };
  return console.log(`[loader] Event firebase chargés`);
}
*/

// lancement du serveur
app.listen(process.env.BDDport || 3000, () => {
  console.log(`Server listening on port ${process.env.BDDport || 3000}`);
});

// Exemple de post

// app.post('/activity', (req, res) => {
//   const authToken = req.headers.authToken
//   // Validation token

//   actitity = Actitity.getActivity(req.body.actitityID);

//   res.status('200').send(activity);
// })

