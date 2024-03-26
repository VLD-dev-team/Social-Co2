const mysql = require('mysql2');

const pool = mysql.createPool({
    host: process.env.BDDhost,
    user: process.env.BDDuser,
    database: process.env.BDDdatabase,
    password: process.env.BDDpsw,
    port: process.env.BDDport,
    connectionLimit: 1000
});

executeQuery = function (query, userQuery) {
    pool.query(query, userQuery, function (error, results, fields) {
        if (error) {
            console.error(error);
            return [];
        }
    
        return results;
    });
};

module.exports = { executeQuery };
