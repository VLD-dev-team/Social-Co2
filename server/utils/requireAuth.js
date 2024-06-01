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

const verifyAuthTokenOnSocket = (token, userID) => {
  // On vérifie le token avec firebase-admin
  admin.auth().verifyIdToken(token)
    .then(decodedToken => {
      const userIDFromToken = decodedToken.uid;

      // Comparer les userID
      if (userIDFromToken !== userID) {
          const response = {
            error: true,
            error_message: 'Invalid Token',
            error_code: 30
          }
        return response;
      }

      // Si les userID correspondent, ajoutez l'utilisateur à la demande
      return {
        error: false,
        succeed: true,
      }
    })
    .catch(error => {
      console.error('Erreur de vérification du token Firebase:', error);
      const response = {
        error: true,
        error_message: 'Invalid Token',
        error_code: 30
      }
      return response;
    });
}

// On exporte le middleware pour l'utiliser
module.exports = { verifyAuthToken, verifyAuthTokenOnSocket };
