const express = require('express')
const router = express.Router()
const { executeQuery } = require('../utils/database.js');
const requireAuthentication = require('../utils/requireAuth.js')


router.route('/*')
    .all((req, res, next) => requireAuthentication(req, res, next))

router.route('/')
    .get((req,res)=>{
        
    })