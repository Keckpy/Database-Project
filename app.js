// Citation for starter code:
// Date: 07/25/2026
// Copied from:
// Source URL: https://canvas.oregonstate.edu/courses/2051721/pages/exploration-web-application-technology-2?module_item_id=26923351

// ########################################
// ########## SETUP

// Express
const express = require('express');
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

const PORT = 57355;

// Database
const db = require('./database/db-connector');

// Handlebars
const { engine } = require('express-handlebars'); // Import express-handlebars engine
app.engine('.hbs', engine({ extname: '.hbs' })); // Create instance of handlebars
app.set('view engine', '.hbs'); // Use handlebars engine for *.hbs files.

// ########################################
// ########## ROUTE HANDLERS

// READ ROUTES
app.get('/', async function (req, res) {
    try {
        res.render('home', {
            resetSuccess: req.query.reset === 'success'
        }); // Render the home.hbs file
    } catch (error) {
        console.error('Error rendering page:', error);
        // Send a generic error message to the browser
        res.status(500).send('An error occurred while rendering the page.');
    }
});

app.get('/patients', async function (req, res) {
    try {
        const query1 = `SELECT patientID, firstName, lastName, 
        DATE_FORMAT(dateOfBirth, '%m-%d-%Y') as dateOfBirth FROM Patients`;

        const [patients] = await db.query(query1);

        res.render('patients', { patients: patients, pageTitle: 'Patients', showNav: true });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/doctors', async function (req, res) {
    try {
        const query1 = `SELECT * FROM Doctors`;

        const [doctors] = await db.query(query1);

        res.render('doctors', { doctors: doctors, pageTitle: 'Doctors', showNav: true });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/specimens', async function (req, res) {
    try {
        const query1 = `SELECT Specimens.specimenID, CONCAT(Patients.firstName, ' ', Patients.lastName) AS patient,
        Specimens.specimenType, Specimens.status FROM Specimens
        INNER JOIN Patients ON Specimens.patientID = Patients.patientID`;
        const query2 = `SELECT patientID, firstName, lastName FROM Patients`;

        const [specimens] = await db.query(query1);
        const [patients] = await db.query(query2);

        res.render('specimens', { specimens: specimens, patients: patients, pageTitle: 'Specimens', showNav: true });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/laboratoryTests', async function (req, res) {
    try {
        const query1 = `SELECT * FROM LaboratoryTests`;

        const [laboratoryTests] = await db.query(query1);

        res.render('laboratoryTests', { laboratoryTests: laboratoryTests, pageTitle: 'LaboratoryTests', showNav: true });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/specimenTests', async function (req, res) {
    try {
        const query1 = `SELECT SpecimenTests.specimenTestID, SpecimenTests.specimenID, 
        CONCAT(Patients.firstName, ' ', Patients.lastName) AS patient,
        Specimens.specimenType, LaboratoryTests.testName AS test,
        CONCAT(Doctors.firstName, ' ', Doctors.lastName) AS doctor, 
        SpecimenTests.testStatus AS status FROM SpecimenTests
        INNER JOIN Specimens ON SpecimenTests.specimenID = Specimens.specimenID
        INNER JOIN Patients ON Specimens.patientID = Patients.patientID
        INNER JOIN LaboratoryTests ON SpecimenTests.laboratoryTestID = LaboratoryTests.laboratoryTestID
        INNER JOIN Doctors ON SpecimenTests.doctorID = Doctors.doctorID
        ORDER BY SpecimenTests.specimenTestID`;
        const query2 = `SELECT Specimens.specimenID, CONCAT(Patients.firstName, ' ', Patients.lastName) AS patient, 
                        Specimens.specimenType FROM Specimens
                        INNER JOIN Patients ON Specimens.patientID = Patients.patientID`;
        const query3 = `SELECT * FROM LaboratoryTests`;
        const query4 = `SELECT doctorID, CONCAT(firstName, ' ', lastName) AS doctorName FROM Doctors`;
        const [specimenTests] = await db.query(query1);
        const [specimens] = await db.query(query2);
        const [laboratoryTests] = await db.query(query3);
        const [doctors] = await db.query(query4);

        res.render('specimenTests', { 
            specimenTests: specimenTests,
            deleteSuccess: req.query.deleted === 'success',
            specimens: specimens,
            laboratoryTests: laboratoryTests,
            doctors: doctors,
            pageTitle: 'SpecimenTests', 
            showNav: true 
        });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// CUD ROUTES FOR THE STEP 4 RESET DEMONSTRATION
// AI Use Citation
// Date: 08/05/2026
// Scope: ChatGPT helped connect the group's RESET and DELETE stored procedures
// to Express POST routes. The code was reviewed and edited for this project.
// Source: https://chatgpt.com/

app.post('/reset-database', async function (req, res) {
    try {
        await db.query('CALL sp_reset_database()');
        res.redirect('/?reset=success');
    } catch (error) {
        console.error('Error resetting database:', error);
        res.status(500).send(
            'The database could not be reset. Make sure database/DDL.sql has been imported.'
        );
    }
});

app.post('/specimenTests/delete/:specimenTestID', async function (req, res) {
    const specimenTestID = Number.parseInt(req.params.specimenTestID, 10);

    if (!Number.isInteger(specimenTestID) || specimenTestID <= 0) {
        return res.status(400).send('Invalid SpecimenTest ID.');
    }

    try {
        await db.query('CALL sp_delete_specimen_test(?)', [specimenTestID]);
        res.redirect('/specimenTests?deleted=success');
    } catch (error) {
        console.error('Error deleting SpecimenTest:', error);
        res.status(500).send(
            'The SpecimenTest could not be deleted. Make sure database/PL.sql has been imported.'
        );
    }
});


// --- CREATE ROUTES ---

// Citation for starter code:
// Date: 08/09/2026
// Copied from:
// Source URL: https://canvas.oregonstate.edu/courses/2051721/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=26923368

app.post('/specimens/add', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        // Use parameterized queries to prevent SQL injection attacks
        const query1 = `CALL sp_add_specimen(?, ?, ?, @new_id);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.patientID,
            data.specimenType,
            data.status
        ]);

        console.log(`CREATE Specimens. ID: ${rows.new_id} ` +
            `Patient ID: ${data.patientID}` + `Specimen Type: ${data.specimenType}` +
            `Status: ${data.status}`
        );

        // Redirect the user to the updated webpage
        res.redirect('/specimens');
    } catch (error) {
        console.error('Error executing queries', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.post('/specimenTests/add', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        // Use parameterized queries to prevent SQL injection attacks
        const query1 = `CALL sp_add_specimen_test(?, ?, ?, ?, @new_id);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.specimenID,
            data.laboratoryTestID,
            data.doctorID,
            data.status
        ]);

        console.log(`CREATE SpecimenTests. ID: ${rows.new_id} ` +
            `Specimen ID: ${data.specimenID}` + `LaboratoryTests ID: ${data.laboratoryTestID}` +
            `Doctor ID: ${data.doctorID}` + `Status: ${data.status}`
        );

        // Redirect the user to the updated webpage
        res.redirect('/specimenTests');
    } catch (error) {
        console.error('Error executing queries', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// ########################################
// ########## LISTENER

app.listen(PORT, function () {
    console.log(
        'Express started on http://localhost:' +
            PORT +
            '; press Ctrl-C to terminate.'
    );
});