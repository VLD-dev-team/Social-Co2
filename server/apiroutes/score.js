const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const verifyAuthToken = require('../utils/requireAuth.js');


router.route('/*')
    .all((req, res, next) => verifyAuthToken(req, res, next));
    // Vérification de la connexion

router.route('/')
    .get(async (req, res) => {

    })