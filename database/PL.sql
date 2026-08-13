-- CS340 Project Group 42 - Beta Data
-- Project Step 4 Draft: Procedure Language SQL
-- Team Members: Brian Keck and Jackson Happel-Walvatne
--
-- AI Use Citation
-- Date: 08/05/2026
-- Scope: ChatGPT helped draft the DELETE stored procedure used to demonstrate
-- that the RESET procedure restores removed sample data.
-- Prompt synopsis: Create a parameterized stored procedure that deletes one
-- SpecimenTests row for the Step 4 RESET demonstration.
-- Originality: The procedure was reviewed and edited for the group's schema.
-- Source: https://chatgpt.com/

DROP PROCEDURE IF EXISTS sp_reset_database;
DROP PROCEDURE IF EXISTS sp_delete_specimen_test;
DROP PROCEDURE IF EXISTS sp_update_specimen_test;
DROP PROCEDURE IF EXISTS sp_add_specimen;
DROP PROCEDURE IF EXISTS sp_add_specimen_test;

DROP PROCEDURE IF EXISTS sp_add_laboratory_test;

DROP PROCEDURE IF EXISTS sp_add_doctor;
DROP PROCEDURE IF EXISTS sp_add_patient;

DELIMITER //

CREATE PROCEDURE sp_reset_database()
BEGIN
    -- Re-enable foreign-key checks if any statement in the reset fails.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET FOREIGN_KEY_CHECKS = 1;
        RESIGNAL;
    END;

    SET FOREIGN_KEY_CHECKS = 0;

    DROP TABLE IF EXISTS SpecimenTests;
    DROP TABLE IF EXISTS Specimens;
    DROP TABLE IF EXISTS LaboratoryTests;
    DROP TABLE IF EXISTS Doctors;
    DROP TABLE IF EXISTS Patients;

    CREATE TABLE Patients (
        patientID INT NOT NULL AUTO_INCREMENT,
        firstName VARCHAR(50) NOT NULL,
        lastName VARCHAR(50) NOT NULL,
        dateOfBirth DATE NOT NULL,
        PRIMARY KEY (patientID)
    );

    CREATE TABLE Doctors (
        doctorID INT NOT NULL AUTO_INCREMENT,
        firstName VARCHAR(50) NOT NULL,
        lastName VARCHAR(50) NOT NULL,
        specialty VARCHAR(75) NOT NULL,
        PRIMARY KEY (doctorID)
    );

    CREATE TABLE LaboratoryTests (
        laboratoryTestID INT NOT NULL AUTO_INCREMENT,
        testName VARCHAR(100) NOT NULL,
        department VARCHAR(75) NOT NULL,
        PRIMARY KEY (laboratoryTestID)
    );

    CREATE TABLE Specimens (
        specimenID INT NOT NULL AUTO_INCREMENT,
        patientID INT NOT NULL,
        specimenType VARCHAR(50) NOT NULL,
        status VARCHAR(25) NOT NULL,
        PRIMARY KEY (specimenID),
        FOREIGN KEY (patientID)
            REFERENCES Patients(patientID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT
    );

    CREATE TABLE SpecimenTests (
        specimenTestID INT NOT NULL AUTO_INCREMENT,
        specimenID INT NOT NULL,
        laboratoryTestID INT NOT NULL,
        doctorID INT NOT NULL,
        testStatus VARCHAR(25) NOT NULL,
        PRIMARY KEY (specimenTestID),
        UNIQUE (specimenID, laboratoryTestID),
        FOREIGN KEY (specimenID)
            REFERENCES Specimens(specimenID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,
        FOREIGN KEY (laboratoryTestID)
            REFERENCES LaboratoryTests(laboratoryTestID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,
        FOREIGN KEY (doctorID)
            REFERENCES Doctors(doctorID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT
    );

    INSERT INTO Patients (firstName, lastName, dateOfBirth) VALUES
        ('Malcolm', 'Whitaker', '1985-04-12'),
        ('Luciana', 'Navarro', '1972-09-23'),
        ('Darius', 'Holloway', '1990-01-15'),
        ('Celeste', 'Collatz', '1965-07-30'),
        ('Nikolai', 'Petrov', '2001-11-08');

    INSERT INTO Doctors (firstName, lastName, specialty) VALUES
        ('Priya', 'Ramanathan', 'Internal Medicine'),
        ('Elias', 'Bennett', 'Cardiology'),
        ('Marisol', 'Vega', 'Emergency Medicine'),
        ('Theodore', 'Langford', 'Oncology'),
        ('Anika', 'Deshmukh', 'Pediatrics');

    INSERT INTO LaboratoryTests (testName, department) VALUES
        ('Comprehensive Metabolic Panel', 'Chemistry'),
        ('Basic Metabolic Panel', 'Chemistry'),
        ('Complete Blood Count', 'Hematology'),
        ('Prothrombin Time', 'Hematology'),
        ('Troponin', 'Chemistry'),
        ('Magnesium', 'Chemistry');

    INSERT INTO Specimens (patientID, specimenType, status) VALUES
        (
            (SELECT patientID FROM Patients
            WHERE firstName = 'Malcolm' AND lastName = 'Whitaker'
            AND dateOfBirth = '1985-04-12'),
            'SST',
            'Received'
        ),
        (
            (SELECT patientID FROM Patients
            WHERE firstName = 'Luciana' AND lastName = 'Navarro'
            AND dateOfBirth = '1972-09-23'),
            'SST',
            'Processing'
        ),
        (
            (SELECT patientID FROM Patients
            WHERE firstName = 'Darius' AND lastName = 'Holloway'
            AND dateOfBirth = '1990-01-15'),
            'EDTA',
            'Completed'
        ),
        (
            (SELECT patientID FROM Patients
            WHERE firstName = 'Celeste' AND lastName = 'Collatz'
            AND dateOfBirth = '1965-07-30'),
            'Sodium Citrate',
            'Collected'
        ),
        (
            (SELECT patientID FROM Patients
            WHERE firstName = 'Nikolai' AND lastName = 'Petrov'
            AND dateOfBirth = '2001-11-08'),
            'Lithium Heparin',
            'Collected'
        );

    INSERT INTO SpecimenTests
        (specimenID, laboratoryTestID, doctorID, testStatus)
    VALUES
        (
            (SELECT s.specimenID FROM Specimens s
            JOIN Patients p ON s.patientID = p.patientID
            WHERE p.firstName = 'Malcolm' AND p.lastName = 'Whitaker'
            AND s.specimenType = 'SST'),
            (SELECT laboratoryTestID FROM LaboratoryTests
            WHERE testName = 'Comprehensive Metabolic Panel'),
            (SELECT doctorID FROM Doctors
            WHERE firstName = 'Marisol' AND lastName = 'Vega'),
            'In-Lab'
        ),
        (
            (SELECT s.specimenID FROM Specimens s
            JOIN Patients p ON s.patientID = p.patientID
            WHERE p.firstName = 'Malcolm' AND p.lastName = 'Whitaker'
            AND s.specimenType = 'SST'),
            (SELECT laboratoryTestID FROM LaboratoryTests
            WHERE testName = 'Magnesium'),
            (SELECT doctorID FROM Doctors
            WHERE firstName = 'Marisol' AND lastName = 'Vega'),
            'In-Lab'
        ),
        (
            (SELECT s.specimenID FROM Specimens s
            JOIN Patients p ON s.patientID = p.patientID
            WHERE p.firstName = 'Luciana' AND p.lastName = 'Navarro'
            AND s.specimenType = 'SST'),
            (SELECT laboratoryTestID FROM LaboratoryTests
            WHERE testName = 'Basic Metabolic Panel'),
            (SELECT doctorID FROM Doctors
            WHERE firstName = 'Anika' AND lastName = 'Deshmukh'),
            'In-Lab'
        ),
        (
            (SELECT s.specimenID FROM Specimens s
            JOIN Patients p ON s.patientID = p.patientID
            WHERE p.firstName = 'Darius' AND p.lastName = 'Holloway'
            AND s.specimenType = 'EDTA'),
            (SELECT laboratoryTestID FROM LaboratoryTests
            WHERE testName = 'Complete Blood Count'),
            (SELECT doctorID FROM Doctors
            WHERE firstName = 'Theodore' AND lastName = 'Langford'),
            'Completed'
        ),
        (
            (SELECT s.specimenID FROM Specimens s
            JOIN Patients p ON s.patientID = p.patientID
            WHERE p.firstName = 'Celeste' AND p.lastName = 'Collatz'
            AND s.specimenType = 'Sodium Citrate'),
            (SELECT laboratoryTestID FROM LaboratoryTests
            WHERE testName = 'Prothrombin Time'),
            (SELECT doctorID FROM Doctors
            WHERE firstName = 'Priya' AND lastName = 'Ramanathan'),
            'Ordered'
        );

    SET FOREIGN_KEY_CHECKS = 1;
END //


CREATE PROCEDURE sp_delete_specimen_test(
    IN p_specimenTestID INT
)
BEGIN
    DELETE FROM SpecimenTests
    WHERE specimenTestID = p_specimenTestID;
END //

-- AI Use Citation
-- Date: 08/12/2026
-- Scope: ChatGPT helped draft this UPDATE stored procedure for SpecimenTests.
-- Prompt synopsis: Add a stored procedure that updates the LaboratoryTests FK,
-- Doctor FK, and status for a selected SpecimenTests record so the UI can
-- demonstrate an UPDATE of the M:N relationship.
-- Originality: The procedure was reviewed and adapted to the group's schema.
-- Source: https://chatgpt.com/
CREATE PROCEDURE sp_update_specimen_test(
    IN p_specimenTestID INT,
    IN p_laboratoryTestID INT,
    IN p_doctorID INT,
    IN p_status VARCHAR(25)
)
BEGIN
    UPDATE SpecimenTests
    SET laboratoryTestID = p_laboratoryTestID,
        doctorID = p_doctorID,
        testStatus = p_status
    WHERE specimenTestID = p_specimenTestID;
END //

CREATE PROCEDURE sp_add_specimen(
    IN p_patientID INT,
    IN p_specimenType VARCHAR(50),
    IN p_status VARCHAR(50),
    OUT p_id INT
)
BEGIN
    INSERT INTO Specimens (patientID, specimenType, status)
    VALUES (p_patientID, p_specimenType, p_status);

    SELECT LAST_INSERT_ID() INTO p_id;
    SELECT p_id AS new_id;
END //

CREATE PROCEDURE sp_add_specimen_test(
    IN p_specimenID INT,
    IN p_laboratoryTestID INT,
    IN p_doctorID INT,
    IN p_status VARCHAR(25),
    OUT p_id INT
)
BEGIN
    INSERT INTO SpecimenTests (specimenID, laboratoryTestID, doctorID, testStatus)
    VALUES (p_specimenID, p_laboratoryTestID, p_doctorID, p_status);

    SELECT LAST_INSERT_ID() INTO p_id;
    SELECT p_id AS new_id;
END //

CREATE PROCEDURE sp_add_laboratory_test(
    IN p_testName VARCHAR(100),
    IN p_department VARCHAR(75),
    OUT p_id INT
)
BEGIN
    INSERT INTO LaboratoryTests (testName, department)
    VALUES (p_testName, p_department);

    SELECT LAST_INSERT_ID() INTO p_id;
    SELECT p_id AS new_id;
END //

CREATE PROCEDURE sp_add_doctor(
    IN p_firstName VARCHAR(50),
    IN p_lastName VARCHAR(50),
    IN p_specialty VARCHAR(75),
    OUT p_id INT
)
BEGIN
    INSERT INTO Doctors (firstName, lastName, specialty)
    VALUES (p_firstName, p_lastName, p_specialty);

    SELECT LAST_INSERT_ID() INTO p_id;
    SELECT p_id AS new_id;
END //

CREATE PROCEDURE sp_add_patient(
    IN p_firstName VARCHAR(50),
    IN p_lastName VARCHAR(50),
    IN p_dateOfBirth DATE,
    OUT p_id INT
)
BEGIN
    INSERT INTO Patients (firstName, lastName, dateOfBirth)
    VALUES (p_firstName, p_lastName, p_dateOfBirth);

    SELECT LAST_INSERT_ID() INTO p_id;
    SELECT p_id AS new_id;
END //
DELIMITER ;
