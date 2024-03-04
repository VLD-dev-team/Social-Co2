const express = require('express');
const router = express.Router();

// Page 404
router.route('/*')
    .all((req, res) => {
        const response = {
            errorJSON : {
                error : true,
                error_message : 'Page not found',
                error_code : 404
            },
            status : 404,
            type : 'error'
        }
        return res.status(404).json(response);
    });

module.exports = router;
