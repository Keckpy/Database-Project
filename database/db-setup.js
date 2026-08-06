// Citation for use of AI Tools:
// Date: 08/06/2026
// Summary of prompts used:
// Create a simple db-setup.js that runs DDL.sql and PL.sql.
// Remove MySQL DELIMITER syntax so the files work through mysql2.
// Use the existing db-connector.js connection pool.
// AI Source URL: https://chatgpt.com/

const fs = require('fs');
const db = require('./db-connector');

function readSql(fileName) {
    return fs.readFileSync(`${__dirname}/${fileName}`, 'utf8')
        .replace(/^DELIMITER .*$/gmi, '')
        .replace(/\/\/\s*$/gm, ';');
}

async function setupDatabase() {
    try {
        await db.query(readSql('DDL.sql'));
        await db.query(readSql('PL.sql'));

        console.log('---Database setup complete---');
    } catch (error) {
        console.error('Database setup failed:', error);
        process.exitCode = 1;
    } finally {
        await db.end();
    }
}

setupDatabase();