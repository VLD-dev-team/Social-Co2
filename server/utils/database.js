require('dotenv').config();
const mysql = require('mysql2');

const pool = mysql.createPool({
    host: process.env.BDDhost,
    user: process.env.BDDuser,
    database: process.env.BDDdatabase,
    password: process.env.BDDpsw,
    port: process.env.BDDport,
    connectionLimit: 1000,
    multipleStatements: false
});

executeQuery = function (userQuery, query, callback) {
    pool.query(query, userQuery, function (error, results, fields) {
        if (error) {
            callback(error, results = null);
            return;
        }
    
        callback(false, results = results, fields = fields);       
        return;
    });
};

module.exports = { executeQuery }