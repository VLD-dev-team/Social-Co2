const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const verifyAuthToken = require('../utils/requireAuth.js');
const admin = require('firebase-admin');

router.route('/*')
    .all((req, res, next) => verifyAuthToken(req, res, next));

router.route('/activity')
    .get((req,res, next)=> {
        const userID = req.headers.id;
        const activityId = req.body.activityId;
        
    })