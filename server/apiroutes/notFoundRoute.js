const express = require('express');
const router = express.Router();

// Page 404
router.route('/*')
    .all((req, res) => {
        const response = {
                error : true,
                error_message : 'Page not found',
                error_code : 4
        }
        return res.status(404).json(response);
    });

module.exports = router;
