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

const executeQuery = function (query, parameters) {
    return new Promise((resolve, reject) => {
        pool.query(query, parameters, (error, results, fields) => {
            if (error) {
                reject(error);
            } else {
                resolve(results);
            }
        });
    });
};

module.exports = { executeQuery };
