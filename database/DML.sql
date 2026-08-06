-- CS340 Project Group 42 
-- Project Step 4 Draft: SELECTs + DML SQL
-- Team Members: Brian Keck and Jackson Happel-Walvatne

-- These are the Data Manipulation Queries for our Project website

-- The @ symbol is used to denote values supplied by the backend 
-- from user input or selections


-- Get all patients for the Patients page and put DOB in correct format
SELECT patientID, firstName, lastName, 
DATE_FORMAT(dateOfBirth, '%m-%d-%Y') AS dateOfBirth FROM Patients;

-- Get all doctors for the Doctors page
SELECT doctorID, firstName, lastName, specialty FROM Doctors;

-- Get all laboratory tests for the LaboratoryTests page
SELECT laboratoryTestID, testName, department FROM LaboratoryTests;

-- Get all specimens and associated patient names for the Specimens page
SELECT Specimens.specimenID, CONCAT(Patients.firstName, ' ', Patients.lastName) AS patient,
Specimens.specimenType, Specimens.status FROM Specimens
INNER JOIN Patients ON Specimens.patientID = Patients.patientID;

-- Get all specimen tests with associated laboratory test and doctor information
-- for the SpecimenTests page
SELECT SpecimenTests.specimenTestID, SpecimenTests.specimenID, CONCAT(Patients.firstName, ' ', Patients.lastName) AS patient,
Specimens.specimenType, LaboratoryTests.testName AS test,
CONCAT(Doctors.firstName, ' ', Doctors.lastName) AS doctor, SpecimenTests.testStatus AS status 
FROM SpecimenTests
INNER JOIN Specimens ON SpecimenTests.specimenID = Specimens.specimenID
INNER JOIN Patients ON Specimens.patientID = Patients.patientID
INNER JOIN LaboratoryTests ON SpecimenTests.laboratoryTestID = LaboratoryTests.laboratoryTestID
INNER JOIN Doctors ON SpecimenTests.doctorID = Doctors.doctorID;

-- Get all specimens to populate the specimen dropdown
SELECT Specimens.specimenID, CONCAT(Patients.firstName, ' ', Patients.lastName) AS patient, 
Specimens.specimenType FROM Specimens
INNER JOIN Patients ON Specimens.patientID = Patients.patientID;

-- Get all laboratory tests to populate the laboratory test dropdown
SELECT laboratoryTestID, testName FROM LaboratoryTests;

-- Get all doctors to populate the doctor dropdown
SELECT doctorID, CONCAT(firstName, ' ', lastName) AS doctorName FROM Doctors;

-- Add a new SpecimenTest
INSERT INTO SpecimenTests (specimenID, laboratoryTestID, doctorID, testStatus)
VALUES (@specimenIDInput, @laboratoryTestIDInput, @doctorIDInput, @testStatusInput);

-- Update an existing SpecimenTest
UPDATE SpecimenTests
SET specimenID = @specimenIDInput, laboratoryTestID = @laboratoryTestIDInput, doctorID = @doctorIDInput,
testStatus = @testStatusInput
WHERE specimenTestID = @specimenTestIDInput;

-- Delete a SpecimenTest
-- This query is implemented by sp_delete_specimen_test in PL.sql for the
-- Step 4 DELETE/RESET demonstration.
DELETE FROM SpecimenTests
WHERE specimenTestID = @specimenTestIDInput;

-- Add a new Patient
INSERT INTO Patients (firstName, lastName, dateOfBirth)
VALUES (@patientFirstNameInput, @patientLastNameInput, @patientDateOfBirthInput);

-- Update an existing Patient
UPDATE Patients
SET firstName = @patientFirstNameInput,
lastName = @patientLastNameInput,
dateOfBirth = @patientDateOfBirthInput
WHERE patientID = @patientIDInput;

-- Delete a Patient
DELETE FROM Patients
WHERE patientID = @patientIDInput;


-- Add a new Doctor
INSERT INTO Doctors (firstName, lastName, specialty)
VALUES (@doctorFirstNameInput, @doctorLastNameInput, @doctorSpecialtyInput);

-- Update an existing Doctor
UPDATE Doctors
SET firstName = @doctorFirstNameInput,
lastName = @doctorLastNameInput,
specialty = @doctorSpecialtyInput
WHERE doctorID = @doctorIDInput;

-- Delete a Doctor
DELETE FROM Doctors
WHERE doctorID = @doctorIDInput;


-- Add a new Laboratory Test
INSERT INTO LaboratoryTests (testName, department)
VALUES (@testNameInput, @departmentInput);

-- Update an existing Laboratory Test
UPDATE LaboratoryTests
SET testName = @testNameInput,
department = @departmentInput
WHERE laboratoryTestID = @laboratoryTestIDInput;

-- Delete a Laboratory Test
DELETE FROM LaboratoryTests
WHERE laboratoryTestID = @laboratoryTestIDInput;


-- Get all patients to populate the patient dropdown
SELECT patientID, firstName, lastName
FROM Patients;

-- Add a new Specimen
INSERT INTO Specimens (patientID, specimenType, status)
VALUES (@patientIDInput, @specimenTypeInput, @specimenStatusInput);

-- Update an existing Specimen
UPDATE Specimens
SET patientID = @patientIDInput,
specimenType = @specimenTypeInput,
status = @specimenStatusInput
WHERE specimenID = @specimenIDInput;

-- Delete a Specimen
DELETE FROM Specimens
WHERE specimenID = @specimenIDInput;