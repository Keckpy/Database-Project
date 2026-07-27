const fs = require('fs');
const db = require('./db-connector');

const ddl = fs.readFileSync(__dirname + '/DDL.sql', 'utf8');

async function resetDatabase() {
    try {
        await db.query(ddl);
        console.log('---Database reset---');
    } catch (error) {
        console.error('Database reset failed: ', error);
    } finally {
        await db.end();
    }
}

resetDatabase();