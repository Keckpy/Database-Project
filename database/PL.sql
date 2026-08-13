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

DROP PROCEDURE IF EXISTS sp_delete_specimen_test;
DROP PROCEDURE IF EXISTS sp_update_specimen_test;
DROP PROCEDURE IF EXISTS sp_add_specimen;
DROP PROCEDURE IF EXISTS sp_add_specimen_test;

DROP PROCEDURE IF EXISTS sp_add_laboratory_test;

DROP PROCEDURE IF EXISTS sp_add_doctor;
DROP PROCEDURE IF EXISTS sp_add_patient;

DELIMITER //

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
