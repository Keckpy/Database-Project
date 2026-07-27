-- CS340 Project Group 42 - Beta Data
-- Project Step 2 Draft: Normalized Schema + DDL with Sample Data
-- Team Members: Brian Keck and Jackson Happel-Walvatne

SET FOREIGN_KEY_CHECKS = 0;
SET AUTOCOMMIT = 0;
START TRANSACTION;

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
        ON DELETE CASCADE
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
        ON DELETE CASCADE,
    FOREIGN KEY (laboratoryTestID)
        REFERENCES LaboratoryTests(laboratoryTestID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (doctorID)
        REFERENCES Doctors(doctorID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

INSERT INTO Patients (patientID, firstName, lastName, dateOfBirth) VALUES
    (1, 'Malcolm', 'Whitaker', '1985-04-12'),
    (2, 'Luciana', 'Navarro', '1972-09-23'),
    (3, 'Darius', 'Holloway', '1990-01-15'),
    (4, 'Celeste', 'Collatz', '1965-07-30'),
    (5, 'Nikolai', 'Petrov', '2001-11-08');

INSERT INTO Doctors (doctorID, firstName, lastName, specialty) VALUES
    (1, 'Priya', 'Ramanathan', 'Internal Medicine'),
    (2, 'Elias', 'Bennett', 'Cardiology'),
    (3, 'Marisol', 'Vega', 'Emergency Medicine'),
    (4, 'Theodore', 'Langford', 'Oncology'),
    (5, 'Anika', 'Deshmukh', 'Pediatrics');

INSERT INTO LaboratoryTests (laboratoryTestID, testName, department) VALUES
    (1, 'Comprehensive Metabolic Panel', 'Chemistry'),
    (2, 'Basic Metabolic Panel', 'Chemistry'),
    (3, 'Complete Blood Count', 'Hematology'),
    (4, 'Prothrombin Time', 'Hematology'),
    (5, 'Troponin', 'Chemistry');

INSERT INTO Specimens (specimenID, patientID, specimenType, status) VALUES
    (1, 1, 'SST', 'Received'),
    (2, 2, 'SST', 'Processing'),
    (3, 3, 'EDTA', 'Processing'),
    (4, 4, 'Sodium Citrate', 'Received'),
    (5, 5, 'Lithium Heparin', 'Completed');

INSERT INTO SpecimenTests
    (specimenTestID, specimenID, laboratoryTestID, doctorID, testStatus)
VALUES
    (1, 1, 1, 3, 'In-Lab'),
    (2, 1, 3, 3, 'In-Lab'),
    (3, 2, 1, 5, 'In-Lab'),
    (4, 3, 3, 4, 'Completed'),
    (5, 4, 4, 1, 'Collected');

COMMIT;
SET FOREIGN_KEY_CHECKS = 1;
