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

DELIMITER //

CREATE PROCEDURE sp_delete_specimen_test(
    IN p_specimenTestID INT
)
BEGIN
    DELETE FROM SpecimenTests
    WHERE specimenTestID = p_specimenTestID;
END //

DELIMITER ;
