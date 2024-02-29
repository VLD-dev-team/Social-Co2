const express = require('express');
const router = express.Router();

// Page 404
router.route('/*')
    .all((req, res) => {
        const error = {
            error : true,
            error_message : 'Page not found',
            error_code : 404
        }
        return res.status(404).json(error);
    });

module.exports = router;
