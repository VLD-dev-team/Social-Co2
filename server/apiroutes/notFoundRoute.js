const express = require('express');
const router = express.Router();

// Page 404
router.route('/*')
    .all((req, res) => {
        res.status(404).send('Page not found');
    });

module.exports = router;
