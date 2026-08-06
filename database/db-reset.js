const db = require('./db-connector');

async function resetDatabase() {
    try {
        await db.query('CALL sp_reset_database()');
        console.log('---Database reset---');
    } catch (error) {
        console.error(
            'Database reset failed. Import database/DDL.sql first so ' +
            'sp_reset_database exists:',
            error
        );
        process.exitCode = 1;
    } finally {
        await db.end();
    }
}

resetDatabase();
