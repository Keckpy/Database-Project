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
DROP PROCEDURE IF EXISTS sp_add_specimen;

DELIMITER //

CREATE PROCEDURE sp_delete_specimen_test(
    IN p_specimenTestID INT
)
BEGIN
    DELETE FROM SpecimenTests
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

DELIMITER ;
