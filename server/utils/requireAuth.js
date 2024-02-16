const admin = require('firebase-admin');
const jwt = require('jsonwebtoken');

// Middleware pour vérifier le token d'authentification
const verifyAuthToken = (req, res, next) => {
  const authToken = req.headers.authorization;

  if (!authToken) {
    return res.status(401).json({ error: 'Token non fourni' });
  }

  // On vérifie le token avec firebase-admin
  admin.auth().verifyIdToken(authToken)
    .then(decodedToken => {
      req.user = decodedToken;
      next();
    })
    .catch(error => {
      console.error('Erreur de vérification du token Firebase:', error);
      return res.status(401).json({ error: 'Token invalide' });
    });
};

// On export le token pour l'utiliser en middleware
module.exports = verifyAuthToken