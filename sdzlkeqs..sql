-- 0.1 Create database (run once)
CREATE DATABASE recommendation_system;
GO
USE recommendation_system;
GO

-- 0.2 Create schemas
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'staging') EXEC('CREATE SCHEMA staging');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'core')    EXEC('CREATE SCHEMA core');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'mart')    EXEC('CREATE SCHEMA mart');
GO

--  --Patients
--IF OBJECT_ID('staging.patients') IS NOT NULL DROP TABLE staging.patients;
--CREATE TABLE staging.patients (
--  Id NVARCHAR(100), BIRTHDATE NVARCHAR(50),
--  SSN NVARCHAR(50), DRIVERS NVARCHAR(50), PASSPORT NVARCHAR(50), PREFIX NVARCHAR(50),
--  FIRST NVARCHAR(100), LAST NVARCHAR(100), SUFFIX NVARCHAR(50),
--  MAIDEN NVARCHAR(100), MARITAL NVARCHAR(50), RACE NVARCHAR(100), ETHNICITY NVARCHAR(100),
--  GENDER NVARCHAR(20), BIRTHPLACE NVARCHAR(200), ADDRESS NVARCHAR(200), CITY NVARCHAR(100),
--  STATE NVARCHAR(100), COUNTY NVARCHAR(100), ZIP NVARCHAR(50),
--  LAT NVARCHAR(50), LON NVARCHAR(50), HEALTHCARE_EXPENSES NVARCHAR(50),
--  HEALTHCARE_COVERAGE NVARCHAR(50)
--);



IF OBJECT_ID('staging.patients') IS NOT NULL DROP TABLE staging.patients;
CREATE TABLE staging.patients (
  Id              NVARCHAR(100), BIRTHDATE NVARCHAR(50), DEATHDATE NVARCHAR(50),
  SSN NVARCHAR(50), DRIVERS NVARCHAR(50), PASSPORT NVARCHAR(50), PREFIX NVARCHAR(50),
  FIRST NVARCHAR(100), MIDDLE NVARCHAR(100), LAST NVARCHAR(100), SUFFIX NVARCHAR(50),
  MAIDEN NVARCHAR(100), MARITAL NVARCHAR(50), RACE NVARCHAR(100), ETHNICITY NVARCHAR(100),
  GENDER NVARCHAR(20), BIRTHPLACE NVARCHAR(200), ADDRESS NVARCHAR(200), CITY NVARCHAR(100),
  STATE NVARCHAR(100), COUNTY NVARCHAR(100), FIPS NVARCHAR(50), ZIP NVARCHAR(50),
  LAT NVARCHAR(50), LON NVARCHAR(50), HEALTHCARE_EXPENSES NVARCHAR(50),
  HEALTHCARE_COVERAGE NVARCHAR(50), INCOME NVARCHAR(50)
);


-- Encounters (your sample header says "ecounters"; we’ll allow both)
IF OBJECT_ID('staging.encounters') IS NOT NULL DROP TABLE staging.encounters;
CREATE TABLE staging.encounters (
  Id NVARCHAR(100), START NVARCHAR(50), STOP NVARCHAR(50), PATIENT NVARCHAR(100),
  ORGANIZATION NVARCHAR(100), PROVIDER NVARCHAR(100), PAYER NVARCHAR(100),
  ENCOUNTERCLASS NVARCHAR(50), CODE NVARCHAR(50), DESCRIPTION NVARCHAR(200),
  BASE_ENCOUNTER_COST NVARCHAR(50), TOTAL_CLAIM_COST NVARCHAR(50),
  PAYER_COVERAGE NVARCHAR(50), REASONCODE NVARCHAR(50), REASONDESCRIPTION NVARCHAR(200)
);

-- Observations
IF OBJECT_ID('staging.observations') IS NOT NULL DROP TABLE staging.observations;
CREATE TABLE staging.observations (
  DATE NVARCHAR(50), PATIENT NVARCHAR(100), ENCOUNTER NVARCHAR(100),
  CATEGORY NVARCHAR(50), CODE NVARCHAR(50), OBS_DESCRIPTION NVARCHAR(200),
  OBS_VALUE NVARCHAR(255), UNITS NVARCHAR(50), OBS_TYPE NVARCHAR(50)
);

-- Medications
IF OBJECT_ID('staging.medications') IS NOT NULL DROP TABLE staging.medications;
CREATE TABLE staging.medications (
  START NVARCHAR(50), STOP NVARCHAR(50), PATIENT NVARCHAR(100), PAYER NVARCHAR(100),
  ENCOUNTER NVARCHAR(100), CODE NVARCHAR(50), DESCRIPTION NVARCHAR(200),
  BASE_COST NVARCHAR(50), PAYER_COVERAGE NVARCHAR(50), DISPENSES NVARCHAR(50),
  TOTALCOST NVARCHAR(50), REASONCODE NVARCHAR(50), REASONDESCRIPTION NVARCHAR(200)
);

-- Procedures
IF OBJECT_ID('staging.p_procedures') IS NOT NULL DROP TABLE staging.p_procedures;
CREATE TABLE staging.p_procedures (
  START NVARCHAR(50), STOP NVARCHAR(50), PATIENT NVARCHAR(100), ENCOUNTER NVARCHAR(100),
  SYSTEM NVARCHAR(200), CODE NVARCHAR(50), DESCRIPTION NVARCHAR(200),
  BASE_COST NVARCHAR(50), REASONCODE NVARCHAR(50), REASONDESCRIPTION NVARCHAR(200)
);

-- Immunizations
IF OBJECT_ID('staging.immunizations') IS NOT NULL DROP TABLE staging.immunizations;
CREATE TABLE staging.immunizations (
  DATE NVARCHAR(50), PATIENT NVARCHAR(100), ENCOUNTER NVARCHAR(100),
  CODE NVARCHAR(50), DESCRIPTION NVARCHAR(200), BASE_COST NVARCHAR(50)
);

-- Conditions
IF OBJECT_ID('staging.conditions') IS NOT NULL DROP TABLE staging.conditions;
CREATE TABLE staging.conditions (
  START NVARCHAR(50), STOP NVARCHAR(50), PATIENT NVARCHAR(100), ENCOUNTER NVARCHAR(100),
  SYSTEM NVARCHAR(200), CODE NVARCHAR(50), DESCRIPTION NVARCHAR(200)
);

-- Allergies
IF OBJECT_ID('staging.allergies') IS NOT NULL DROP TABLE staging.allergies;
CREATE TABLE staging.allergies (
  START NVARCHAR(50), STOP NVARCHAR(50), PATIENT NVARCHAR(100), ENCOUNTER NVARCHAR(100),
  CODE NVARCHAR(50), SYSTEM NVARCHAR(100), DESCRIPTION NVARCHAR(200),
  TYPE NVARCHAR(50), CATEGORY NVARCHAR(50),
  REACTION1 NVARCHAR(50), DESCRIPTION1 NVARCHAR(200), SEVERITY1 NVARCHAR(50),
  REACTION2 NVARCHAR(50), DESCRIPTION2 NVARCHAR(200), SEVERITY2 NVARCHAR(50)
);

-- Careplans (your sample had "carplans")
IF OBJECT_ID('staging.careplans') IS NOT NULL DROP TABLE staging.careplans;
CREATE TABLE staging.careplans (
  Id NVARCHAR(100), START NVARCHAR(50), STOP NVARCHAR(50), PATIENT NVARCHAR(100),
  ENCOUNTER NVARCHAR(100), CODE NVARCHAR(50), DESCRIPTION NVARCHAR(200),
  REASONCODE NVARCHAR(50), REASONDESCRIPTION NVARCHAR(200)
);

-- Devices
IF OBJECT_ID('staging.devices') IS NOT NULL DROP TABLE staging.devices;
CREATE TABLE staging.devices (
  START NVARCHAR(50), STOP NVARCHAR(50), PATIENT NVARCHAR(100), ENCOUNTER NVARCHAR(100),
  CODE NVARCHAR(50), DESCRIPTION NVARCHAR(200), UDI NVARCHAR(200)
);

-- Imaging Studies
IF OBJECT_ID('staging.imaging_studies') IS NOT NULL DROP TABLE staging.imaging_studies;
CREATE TABLE staging.imaging_studies (
  Id NVARCHAR(100), DATE NVARCHAR(50), PATIENT NVARCHAR(100), ENCOUNTER NVARCHAR(100),
  SERIES_UID NVARCHAR(100), BODYSITE_CODE NVARCHAR(50), BODYSITE_DESCRIPTION NVARCHAR(200),
  MODALITY_CODE NVARCHAR(50), MODALITY_DESCRIPTION NVARCHAR(200),
  INSTANCE_UID NVARCHAR(100), SOP_CODE NVARCHAR(50), SOP_DESCRIPTION NVARCHAR(200),
  PROCEDURE_CODE NVARCHAR(50)
);

-- Organizations
IF OBJECT_ID('staging.organizations') IS NOT NULL DROP TABLE staging.organizations;
CREATE TABLE staging.organizations (
  Id NVARCHAR(100), NAME NVARCHAR(200), ADDRESS NVARCHAR(200), CITY NVARCHAR(100),
  STATE NVARCHAR(50), ZIP NVARCHAR(50), LAT NVARCHAR(50), LON NVARCHAR(50),
  PHONE NVARCHAR(100), REVENUE NVARCHAR(50), UTILIZATION NVARCHAR(50)
);

-- Providers
IF OBJECT_ID('staging.providers') IS NOT NULL DROP TABLE staging.providers;
CREATE TABLE staging.providers (
  Id NVARCHAR(100), ORGANIZATION NVARCHAR(100), NAME NVARCHAR(200), GENDER NVARCHAR(20),
  SPECIALITY NVARCHAR(100), ADDRESS NVARCHAR(200), CITY NVARCHAR(100), STATE NVARCHAR(50),
  ZIP NVARCHAR(50), LAT NVARCHAR(50), LON NVARCHAR(50), ENCOUNTERS NVARCHAR(50),
  P_PROCEDURES NVARCHAR(50)
);

-- Supplies
IF OBJECT_ID('staging.supplies') IS NOT NULL DROP TABLE staging.supplies;
CREATE TABLE staging.supplies (
  DATE NVARCHAR(50), PATIENT NVARCHAR(100), ENCOUNTER NVARCHAR(100),
  CODE NVARCHAR(50), DESCRIPTION NVARCHAR(200), QUANTITY NVARCHAR(50)
);

 --Example loads (repeat for all files you have)
BULK INSERT staging.patients
FROM 'C:\Users\user\Desktop\Work\project\conditions\patients.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE='65001');

BULK INSERT staging.medications
FROM 'C:\Users\user\Desktop\Work\project\conditions\medications.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE='65001');

BULK INSERT staging.p_procedures
FROM 'C:\Users\user\Desktop\Work\project\conditions\procedures.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE='65001');

BULK INSERT staging.immunizations
FROM 'C:\Users\user\Desktop\Work\project\conditions\immunizations.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE='65001');

BULK INSERT staging.conditions
FROM 'C:\Users\user\Desktop\Work\project\conditions\conditions.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE='65001');

BULK INSERT staging.allergies
FROM 'C:\Users\user\Desktop\Work\project\conditions\allergies.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE='65001');

BULK INSERT staging.careplans
FROM 'C:\Users\user\Desktop\Work\project\conditions\careplans.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE='65001');

BULK INSERT staging.devices
FROM 'C:\Users\user\Desktop\Work\project\conditions\devices.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE='65001');

BULK INSERT staging.imaging_studies
FROM 'C:\Users\user\Desktop\Work\project\conditions\imaging_studies.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE='65001');

BULK INSERT staging.organizations
FROM 'C:\Users\user\Desktop\Work\project\conditions\organizations.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE='65001');

BULK INSERT staging.providers
FROM 'C:\Users\user\Desktop\Work\project\conditions\providers.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE='65001');

BULK INSERT staging.supplies
FROM 'C:\Users\user\Desktop\Work\project\conditions\supplies.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE='65001');

BULK INSERT staging.encounters
FROM 'C:\Users\user\Desktop\Work\project\conditions\encounters.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE='65001');

BULK INSERT staging.observations
FROM 'C:\Users\user\Desktop\Work\project\conditions\observations.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE='65001');


-- Patients
IF OBJECT_ID('core.patients') IS NOT NULL DROP TABLE core.patients;
CREATE TABLE core.patients (
  Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
  Birthdate DATE NULL,
  Deathdate DATE NULL,
  Gender NVARCHAR(20) NULL,
  Race NVARCHAR(100) NULL,
  Ethnicity NVARCHAR(100) NULL,
  Marital NVARCHAR(20) NULL,
  Income DECIMAL(18,2) NULL,
  Healthcare_Expenses DECIMAL(18,2) NULL,
  Healthcare_Coverage DECIMAL(18,2) NULL,
  City NVARCHAR(100) NULL, State NVARCHAR(50) NULL, Zip NVARCHAR(20) NULL
);

-- Encounters
IF OBJECT_ID('core.encounters') IS NOT NULL DROP TABLE core.encounters;
CREATE TABLE core.encounters (
  Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
  StartDT DATETIME2(0) NOT NULL,
  StopDT DATETIME2(0) NULL,
  Patient UNIQUEIDENTIFIER NOT NULL,
  EncounterClass NVARCHAR(50) NULL,
  Code NVARCHAR(50) NULL,
  Description NVARCHAR(200) NULL,
  Base_Encounter_Cost DECIMAL(18,2) NULL,
  Total_Claim_Cost DECIMAL(18,2) NULL,
  Payer_Coverage DECIMAL(18,2) NULL,
  ReasonCode NVARCHAR(50) NULL,
  ReasonDescription NVARCHAR(200) NULL,
  CONSTRAINT FK_encounters_patients FOREIGN KEY (Patient) REFERENCES core.patients(Id)
);

-- Observations
IF OBJECT_ID('core.observations') IS NOT NULL DROP TABLE core.observations;
CREATE TABLE core.observations (
  ObsDT DATETIME2(0) NOT NULL,
  Patient UNIQUEIDENTIFIER NOT NULL,
  Encounter UNIQUEIDENTIFIER NULL,
  Category NVARCHAR(50) NULL,
  Code NVARCHAR(50) NULL,
  OBS_DESCRIPTION NVARCHAR(200) NULL,
  ValueNum DECIMAL(18,4) NULL,
  ValueTxt NVARCHAR(255) NULL,
  Units NVARCHAR(30) NULL,
  OBS_TYPE NVARCHAR(50) NULL
);

-- Medications
IF OBJECT_ID('core.medications') IS NOT NULL DROP TABLE core.medications;
CREATE TABLE core.medications (
  StartDT DATETIME2(0) NULL,
  StopDT DATETIME2(0) NULL,
  Patient UNIQUEIDENTIFIER NOT NULL,
  Payer UNIQUEIDENTIFIER NULL,
  Encounter UNIQUEIDENTIFIER NULL,
  Code NVARCHAR(50) NULL,
  Description NVARCHAR(200) NULL,
  Base_Cost DECIMAL(18,2) NULL,
  Payer_Coverage DECIMAL(18,2) NULL,
  Dispenses INT NULL,
  TotalCost DECIMAL(18,2) NULL,
  ReasonCode NVARCHAR(50) NULL,
  ReasonDescription NVARCHAR(200) NULL
);

-- Procedures
IF OBJECT_ID('core.p_procedures') IS NOT NULL DROP TABLE core.p_procedures;
CREATE TABLE core.p_procedures (
  StartDT DATETIME2(0) NULL,
  StopDT DATETIME2(0) NULL,
  Patient UNIQUEIDENTIFIER NOT NULL,
  Encounter UNIQUEIDENTIFIER NULL,
  System NVARCHAR(200) NULL,
  Code NVARCHAR(50) NULL,
  Description NVARCHAR(200) NULL,
  Base_Cost DECIMAL(18,2) NULL,
  ReasonCode NVARCHAR(50) NULL,
  ReasonDescription NVARCHAR(200) NULL
);

-- Immunizations
IF OBJECT_ID('core.immunizations') IS NOT NULL DROP TABLE core.immunizations;
CREATE TABLE core.immunizations (
  ImmunDT DATETIME2(0) NOT NULL,
  Patient UNIQUEIDENTIFIER NOT NULL,
  Encounter UNIQUEIDENTIFIER NULL,
  Code NVARCHAR(50) NULL,
  Description NVARCHAR(200) NULL,
  Base_Cost DECIMAL(18,2) NULL
);

-- Conditions
IF OBJECT_ID('core.conditions') IS NOT NULL DROP TABLE core.conditions;
CREATE TABLE core.conditions (
  StartDT DATETIME2(0) NULL,
  StopDT DATETIME2(0) NULL,
  Patient UNIQUEIDENTIFIER NOT NULL,
  Encounter UNIQUEIDENTIFIER NULL,
  System NVARCHAR(200) NULL,
  Code NVARCHAR(50) NULL,
  Description NVARCHAR(200) NULL
);

-- Allergies
IF OBJECT_ID('core.allergies') IS NOT NULL DROP TABLE core.allergies;
CREATE TABLE core.allergies (
  StartDT DATETIME2(0) NULL,
  StopDT DATETIME2(0) NULL,
  Patient UNIQUEIDENTIFIER NOT NULL,
  Encounter UNIQUEIDENTIFIER NULL,
  Code NVARCHAR(50) NULL,
  System NVARCHAR(100) NULL,
  Description NVARCHAR(200) NULL,
  Type NVARCHAR(50) NULL,
  Category NVARCHAR(50) NULL,
  Reaction1 NVARCHAR(50) NULL, Description1 NVARCHAR(200) NULL, Severity1 NVARCHAR(50) NULL,
  Reaction2 NVARCHAR(50) NULL, Description2 NVARCHAR(200) NULL, Severity2 NVARCHAR(50) NULL
);

-- Organizations
IF OBJECT_ID('core.organizations') IS NOT NULL DROP TABLE core.organizations;
CREATE TABLE core.organizations (
  Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
  Name NVARCHAR(200) NULL, City NVARCHAR(100) NULL, State NVARCHAR(50) NULL, Zip NVARCHAR(20) NULL,
  Lat DECIMAL(9,6) NULL, Lon DECIMAL(9,6) NULL, Revenue DECIMAL(18,2) NULL, Utilization INT NULL
);

-- Providers
IF OBJECT_ID('core.providers') IS NOT NULL DROP TABLE core.providers;
CREATE TABLE core.providers (
  Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
  Organization UNIQUEIDENTIFIER NULL,
  Name NVARCHAR(200) NULL,
  Gender NVARCHAR(20) NULL,
  Speciality NVARCHAR(100) NULL,
  City NVARCHAR(100) NULL, State NVARCHAR(50) NULL, Zip NVARCHAR(20) NULL,
  Lat DECIMAL(9,6) NULL, Lon DECIMAL(9,6) NULL,
  Encounters INT NULL, Procedures INT NULL
);

-- Devices
IF OBJECT_ID('core.devices') IS NOT NULL DROP TABLE core.devices;
CREATE TABLE core.devices (
  StartDT DATETIME2(0) NULL, StopDT DATETIME2(0) NULL,
  Patient UNIQUEIDENTIFIER NOT NULL, Encounter UNIQUEIDENTIFIER NULL,
  Code NVARCHAR(50) NULL, Description NVARCHAR(200) NULL, UDI NVARCHAR(200) NULL
);

-- Imaging studies
IF OBJECT_ID('core.imaging_studies') IS NOT NULL DROP TABLE core.imaging_studies;
CREATE TABLE core.imaging_studies (
  Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
  ImgDT DATETIME2(0) NOT NULL, Patient UNIQUEIDENTIFIER NOT NULL, Encounter UNIQUEIDENTIFIER NULL,
  Series_UID NVARCHAR(100) NULL, Bodysite_Code NVARCHAR(50) NULL, Bodysite_Description NVARCHAR(200) NULL,
  Modality_Code NVARCHAR(50) NULL, Modality_Description NVARCHAR(200) NULL,
  Instance_UID NVARCHAR(100) NULL, SOP_Code NVARCHAR(50) NULL, SOP_Description NVARCHAR(200) NULL,
  Procedure_Code NVARCHAR(50) NULL
);

-- Supplies
IF OBJECT_ID('core.supplies') IS NOT NULL DROP TABLE core.supplies;
CREATE TABLE core.supplies (
  SupplyDT DATETIME2(0) NOT NULL, Patient UNIQUEIDENTIFIER NOT NULL, Encounter UNIQUEIDENTIFIER NULL,
  Code NVARCHAR(50) NULL, Description NVARCHAR(200) NULL, Quantity INT NULL
);



DELETE FROM core.patients;

INSERT INTO core.patients (Id, Birthdate, Gender, Race, Ethnicity, Marital,
                           Healthcare_Expenses, Healthcare_Coverage, City, State, Zip)
SELECT
  TRY_CONVERT(UNIQUEIDENTIFIER, Id),
  COALESCE(TRY_CONVERT(date, BIRTHDATE, 127), TRY_CONVERT(date, BIRTHDATE, 101)),
  NULLIF(GENDER,''),
  NULLIF(RACE,''),
  NULLIF(ETHNICITY,''),
  NULLIF(MARITAL,''),
  TRY_CONVERT(decimal(18,2), HEALTHCARE_EXPENSES),
  TRY_CONVERT(decimal(18,2), HEALTHCARE_COVERAGE),
  NULLIF(CITY,''),
  NULLIF(STATE,''),
  NULLIF(ZIP,'')
FROM staging.patients;



SELECT
    fk.name AS FK_Name,
    OBJECT_SCHEMA_NAME(fk.parent_object_id) AS ReferencingSchema,
    OBJECT_NAME(fk.parent_object_id) AS ReferencingTable,
    cpa.name AS ReferencingColumn,
    OBJECT_SCHEMA_NAME(fk.referenced_object_id) AS ReferencedSchema,
    OBJECT_NAME(fk.referenced_object_id) AS ReferencedTable,
    cre.name AS ReferencedColumn
FROM sys.foreign_keys fk
INNER JOIN sys.foreign_key_columns fkc
    ON fk.object_id = fkc.constraint_object_id
INNER JOIN sys.columns cpa
    ON fkc.parent_object_id = cpa.object_id
   AND fkc.parent_column_id = cpa.column_id
INNER JOIN sys.columns cre
    ON fkc.referenced_object_id = cre.object_id
   AND fkc.referenced_column_id = cre.column_id
WHERE fk.referenced_object_id = OBJECT_ID('core.patients');


ALTER TABLE core.encounters
DROP CONSTRAINT FK_encounters_patients;


IF OBJECT_ID('core.patients') IS NOT NULL 
    DROP TABLE core.patients;

CREATE TABLE core.patients (
  Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
  Birthdate DATE NULL,
  Deathdate DATE NULL,
  Gender NVARCHAR(20) NULL,
  Race NVARCHAR(100) NULL,
  Ethnicity NVARCHAR(100) NULL,
  Marital NVARCHAR(20) NULL,
  Income DECIMAL(18,2) NULL,
  Healthcare_Expenses DECIMAL(18,2) NULL,
  Healthcare_Coverage DECIMAL(18,2) NULL,
  City NVARCHAR(100) NULL,
  State NVARCHAR(50) NULL,
  Zip NVARCHAR(20) NULL
);

INSERT INTO core.patients (Id, Birthdate, Gender, Race, Ethnicity, Marital,
                           Healthcare_Expenses, Healthcare_Coverage, City, State, Zip)
SELECT
  TRY_CONVERT(UNIQUEIDENTIFIER, Id),
  COALESCE(TRY_CONVERT(date, BIRTHDATE, 127), TRY_CONVERT(date, BIRTHDATE, 101)),
  NULLIF(GENDER,''),
  NULLIF(RACE,''),
  NULLIF(ETHNICITY,''),
  NULLIF(MARITAL,''),
  TRY_CONVERT(decimal(18,2), HEALTHCARE_EXPENSES),
  TRY_CONVERT(decimal(18,2), HEALTHCARE_COVERAGE),
  NULLIF(CITY,''),
  NULLIF(STATE,''),
  NULLIF(ZIP,'')
FROM staging.patients;





-- 4.2 Encounters
INSERT INTO core.encounters (Id, StartDT, StopDT, Patient, EncounterClass, Code, Description,
                             Base_Encounter_Cost, Total_Claim_Cost, Payer_Coverage, ReasonCode, ReasonDescription)
SELECT
  TRY_CONVERT(UNIQUEIDENTIFIER, Id),
  COALESCE(TRY_CONVERT(datetime2, START, 127), TRY_CONVERT(datetime2, START, 120), TRY_CONVERT(datetime2, START, 101)),
  COALESCE(TRY_CONVERT(datetime2, STOP, 127),  TRY_CONVERT(datetime2, STOP, 120),  TRY_CONVERT(datetime2, STOP, 101)),
  TRY_CONVERT(UNIQUEIDENTIFIER, PATIENT),
  NULLIF(ENCOUNTERCLASS,''),
  NULLIF(CODE,''),
  NULLIF(DESCRIPTION,''),
  TRY_CONVERT(decimal(18,2), BASE_ENCOUNTER_COST),
  TRY_CONVERT(decimal(18,2), TOTAL_CLAIM_COST),
  TRY_CONVERT(decimal(18,2), PAYER_COVERAGE),
  NULLIF(REASONCODE,''),
  NULLIF(REASONDESCRIPTION,'')
FROM staging.encounters e
WHERE TRY_CONVERT(UNIQUEIDENTIFIER, e.PATIENT) IN (SELECT Id FROM core.patients);


ALTER TABLE core.observations
ALTER COLUMN ValueTxt NVARCHAR(500);


EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;

EXEC sp_configure 'remote query timeout', 0;   -- 0 = unlimited
RECONFIGURE;



SELECT COUNT(*) 
FROM staging.observations;


SET NOCOUNT ON;

WHILE 1 = 1
BEGIN
    INSERT INTO core.observations (ObsDT, Patient, Encounter, Category, Code, OBS_DESCRIPTION,
                                   ValueNum, ValueTxt, Units, OBS_TYPE)
    SELECT TOP (50000)
      COALESCE(TRY_CONVERT(datetime2, DATE, 127), TRY_CONVERT(datetime2, DATE, 120), TRY_CONVERT(datetime2, DATE, 101)),
      TRY_CONVERT(UNIQUEIDENTIFIER, PATIENT),
      TRY_CONVERT(UNIQUEIDENTIFIER, ENCOUNTER),
      NULLIF(CATEGORY,''),
      NULLIF(CODE,''),
      NULLIF(OBS_DESCRIPTION,''),
      TRY_CONVERT(decimal(18,4), OBS_VALUE),
      CASE WHEN TRY_CONVERT(decimal(18,4), OBS_VALUE) IS NULL THEN NULLIF(OBS_VALUE,'') END,
      NULLIF(UNITS,''),
      NULLIF(OBS_TYPE,'')
    FROM staging.observations
    WHERE NOT EXISTS (
         SELECT 1
         FROM core.observations c
         WHERE c.Patient = TRY_CONVERT(UNIQUEIDENTIFIER, PATIENT)
         AND c.ObsDT = COALESCE(TRY_CONVERT(datetime2, DATE, 127), TRY_CONVERT(datetime2, DATE, 120), TRY_CONVERT(datetime2, DATE, 101))
    );

    IF @@ROWCOUNT = 0 BREAK;
END


-- 4.4 Medications
INSERT INTO core.medications (StartDT, StopDT, Patient, Payer, Encounter, Code, Description,
                              Base_Cost, Payer_Coverage, Dispenses, TotalCost, ReasonCode, ReasonDescription)
SELECT
  COALESCE(TRY_CONVERT(datetime2, START, 127), TRY_CONVERT(datetime2, START, 120), TRY_CONVERT(datetime2, START, 101)),
  COALESCE(TRY_CONVERT(datetime2, STOP, 127),  TRY_CONVERT(datetime2, STOP, 120),  TRY_CONVERT(datetime2, STOP, 101)),
  TRY_CONVERT(UNIQUEIDENTIFIER, PATIENT),
  TRY_CONVERT(UNIQUEIDENTIFIER, PAYER),
  TRY_CONVERT(UNIQUEIDENTIFIER, ENCOUNTER),
  NULLIF(CODE,''),
  NULLIF(DESCRIPTION,''),
  TRY_CONVERT(decimal(18,2), BASE_COST),
  TRY_CONVERT(decimal(18,2), PAYER_COVERAGE),
  TRY_CONVERT(int, DISPENSES),
  TRY_CONVERT(decimal(18,2), TOTALCOST),
  NULLIF(REASONCODE,''),
  NULLIF(REASONDESCRIPTION,'')
FROM staging.medications;




-- 4.5 Procedures
INSERT INTO core.p_procedures (StartDT, StopDT, Patient, Encounter, System, Code, Description,
                             Base_Cost, ReasonCode, ReasonDescription)
SELECT
  COALESCE(TRY_CONVERT(datetime2, START, 127), TRY_CONVERT(datetime2, START, 120), TRY_CONVERT(datetime2, START, 101)),
  COALESCE(TRY_CONVERT(datetime2, STOP, 127),  TRY_CONVERT(datetime2, STOP, 120),  TRY_CONVERT(datetime2, STOP, 101)),
  TRY_CONVERT(UNIQUEIDENTIFIER, PATIENT),
  TRY_CONVERT(UNIQUEIDENTIFIER, ENCOUNTER),
  NULLIF(SYSTEM,''),
  NULLIF(CODE,''),
  NULLIF(DESCRIPTION,''),
  TRY_CONVERT(decimal(18,2), BASE_COST),
  NULLIF(REASONCODE,''),
  NULLIF(REASONDESCRIPTION,'')
FROM staging.p_procedures;


-- 4.6 Immunizations
INSERT INTO core.immunizations (ImmunDT, Patient, Encounter, Code, Description, Base_Cost)
SELECT
  COALESCE(TRY_CONVERT(datetime2, DATE, 127), TRY_CONVERT(datetime2, DATE, 120), TRY_CONVERT(datetime2, DATE, 101)),
  TRY_CONVERT(UNIQUEIDENTIFIER, PATIENT),
  TRY_CONVERT(UNIQUEIDENTIFIER, ENCOUNTER),
  NULLIF(CODE,''),
  NULLIF(DESCRIPTION,''),
  TRY_CONVERT(decimal(18,2), BASE_COST)
FROM staging.immunizations;


-- 4.7 Conditions
INSERT INTO core.conditions (StartDT, StopDT, Patient, Encounter, System, Code, Description)
SELECT
  COALESCE(TRY_CONVERT(datetime2, START, 127), TRY_CONVERT(datetime2, START, 120), TRY_CONVERT(datetime2, START, 101)),
  COALESCE(TRY_CONVERT(datetime2, STOP, 127),  TRY_CONVERT(datetime2, STOP, 120),  TRY_CONVERT(datetime2, STOP, 101)),
  TRY_CONVERT(UNIQUEIDENTIFIER, PATIENT),
  TRY_CONVERT(UNIQUEIDENTIFIER, ENCOUNTER),
  NULLIF(SYSTEM,''),
  NULLIF(CODE,''),
  NULLIF(DESCRIPTION,'')
FROM staging.conditions;



INSERT INTO core.allergies (StartDT, StopDT, Patient, Encounter, Code, System, Description,
                            Type, Category, Reaction1, Description1, Severity1, Reaction2, Description2, Severity2)
SELECT
  COALESCE(TRY_CONVERT(datetime2, START, 127), TRY_CONVERT(datetime2, START, 120), TRY_CONVERT(datetime2, START, 101)),
  COALESCE(TRY_CONVERT(datetime2, STOP, 127),  TRY_CONVERT(datetime2, STOP, 120),  TRY_CONVERT(datetime2, STOP, 101)),
  TRY_CONVERT(UNIQUEIDENTIFIER, PATIENT),
  TRY_CONVERT(UNIQUEIDENTIFIER, ENCOUNTER),
  NULLIF(CODE,''),
  NULLIF(SYSTEM,''),
  NULLIF(DESCRIPTION,''),
  NULLIF(TYPE,''),
  NULLIF(CATEGORY,''),
  NULLIF(REACTION1,''),
  NULLIF(DESCRIPTION1,''),
  NULLIF(SEVERITY1,''),
  NULLIF(REACTION2,''),
  NULLIF(DESCRIPTION2,''),
  NULLIF(SEVERITY2,'')
FROM staging.allergies;


-- 4.9 Organizations
INSERT INTO core.organizations (Id, Name, City, State, Zip, Lat, Lon, Revenue, Utilization)
SELECT
  TRY_CONVERT(UNIQUEIDENTIFIER, Id),
  NULLIF(NAME,''),
  NULLIF(CITY,''),
  NULLIF(STATE,''),
  NULLIF(ZIP,''),
  TRY_CONVERT(decimal(9,6), LAT),
  TRY_CONVERT(decimal(9,6), LON),
  TRY_CONVERT(decimal(18,2), REVENUE),
  TRY_CONVERT(int, UTILIZATION)
FROM staging.organizations;

-- 4.10 Providers
INSERT INTO core.providers (Id, Organization, Name, Gender, Speciality, City, State, Zip, Lat, Lon, Encounters)
SELECT
  TRY_CONVERT(UNIQUEIDENTIFIER, Id),
  TRY_CONVERT(UNIQUEIDENTIFIER, ORGANIZATION),
  NULLIF(NAME,''),
  NULLIF(GENDER,''),
  NULLIF(SPECIALITY,''),
  NULLIF(CITY,''),
  NULLIF(STATE,''),
  NULLIF(ZIP,''),
  TRY_CONVERT(decimal(9,6), LAT),
  TRY_CONVERT(decimal(9,6), LON),
  TRY_CONVERT(int, ENCOUNTERS)
FROM staging.providers;

-- 4.11 Devices
INSERT INTO core.devices (StartDT, StopDT, Patient, Encounter, Code, Description, UDI)
SELECT
  COALESCE(TRY_CONVERT(datetime2, START, 127), TRY_CONVERT(datetime2, START, 120), TRY_CONVERT(datetime2, START, 101)),
  COALESCE(TRY_CONVERT(datetime2, STOP, 127),  TRY_CONVERT(datetime2, STOP, 120),  TRY_CONVERT(datetime2, STOP, 101)),
  TRY_CONVERT(UNIQUEIDENTIFIER, PATIENT),
  TRY_CONVERT(UNIQUEIDENTIFIER, ENCOUNTER),
  NULLIF(CODE,''),
  NULLIF(DESCRIPTION,''),
  NULLIF(UDI,'')
FROM staging.devices;

-- 4.12 Imaging
INSERT INTO core.imaging_studies (
  Id, ImgDT, Patient, Encounter, Series_UID, Bodysite_Code, Bodysite_Description,
  Modality_Code, Modality_Description, Instance_UID, SOP_Code, SOP_Description, Procedure_Code
)
SELECT
    Id,
    MAX(ImgDT) AS ImgDT,
    MAX(Patient),
    MAX(Encounter),
    MAX(Series_UID),
    MAX(Bodysite_Code),
    MAX(Bodysite_Description),
    MAX(Modality_Code),
    MAX(Modality_Description),
    MAX(Instance_UID),
    MAX(SOP_Code),
    MAX(SOP_Description),
    MAX(Procedure_Code)
FROM (
    SELECT
      TRY_CONVERT(UNIQUEIDENTIFIER, Id) AS Id,
      COALESCE(TRY_CONVERT(datetime2, DATE, 127), TRY_CONVERT(datetime2, DATE, 120), TRY_CONVERT(datetime2, DATE, 101)) AS ImgDT,
      TRY_CONVERT(UNIQUEIDENTIFIER, PATIENT) AS Patient,
      TRY_CONVERT(UNIQUEIDENTIFIER, ENCOUNTER) AS Encounter,
      NULLIF(SERIES_UID,'') AS Series_UID,
      NULLIF(BODYSITE_CODE,'') AS Bodysite_Code,
      NULLIF(BODYSITE_DESCRIPTION,'') AS Bodysite_Description,
      NULLIF(MODALITY_CODE,'') AS Modality_Code,
      NULLIF(MODALITY_DESCRIPTION,'') AS Modality_Description,
      NULLIF(INSTANCE_UID,'') AS Instance_UID,
      NULLIF(SOP_CODE,'') AS SOP_Code,
      NULLIF(SOP_DESCRIPTION,'') AS SOP_Description,
      NULLIF(PROCEDURE_CODE,'') AS Procedure_Code
    FROM staging.imaging_studies
) AS Cleaned
GROUP BY Id;




-- 4.13 Supplies
INSERT INTO core.supplies (SupplyDT, Patient, Encounter, Code, Description, Quantity)
SELECT
  COALESCE(TRY_CONVERT(datetime2, DATE, 127), TRY_CONVERT(datetime2, DATE, 120), TRY_CONVERT(datetime2, DATE, 101)),
  TRY_CONVERT(UNIQUEIDENTIFIER, PATIENT),
  TRY_CONVERT(UNIQUEIDENTIFIER, ENCOUNTER),
  NULLIF(CODE,''),
  NULLIF(DESCRIPTION,''),
  TRY_CONVERT(int, QUANTITY)
FROM staging.supplies






-- patients
CREATE UNIQUE INDEX IX_patients_Id ON core.patients(Id);

-- encounters
CREATE INDEX IX_encounters_patient_start ON core.encounters(Patient, StartDT);
CREATE INDEX IX_encounters_patient_stop  ON core.encounters(Patient, StopDT);

-- observations
CREATE INDEX IX_observations_patient_date ON core.observations(Patient, ObsDT);
CREATE INDEX IX_observations_code        ON core.observations(Code);

-- medications / procedures
CREATE INDEX IX_medications_patient_start ON core.medications(Patient, StartDT);
CREATE INDEX IX_procedures_patient_start  ON core.p_procedures(Patient, StartDT);

-- conditions
CREATE INDEX IX_conditions_patient_start ON core.conditions(Patient, StartDT);

-- allergies
CREATE INDEX IX_allergies_patient_start ON core.allergies(Patient, StartDT);














USE recommendation_system;
GO
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'dwh')
    EXEC('CREATE SCHEMA dwh');
GO


SELECT name FROM sys.schemas WHERE name = 'dwh';





-- 2.1 DimDate
IF OBJECT_ID('dwh.DimDate') IS NOT NULL DROP TABLE dwh.DimDate;
CREATE TABLE dwh.DimDate (
    DateKey INT PRIMARY KEY,
    FullDate DATE,
    Year INT,
    Quarter INT,
    Month INT,
    MonthName NVARCHAR(20),
    Day INT,
    Week INT
);

-- Populate DimDate (20 years span)
DECLARE @start DATE = '2010-01-01', @end DATE = '2030-12-31';
WHILE @start <= @end
BEGIN
    INSERT INTO dwh.DimDate
    SELECT 
        CONVERT(INT, FORMAT(@start, 'yyyyMMdd')),
        @start,
        YEAR(@start),
        DATEPART(QUARTER, @start),
        MONTH(@start),
        DATENAME(MONTH, @start),
        DAY(@start),
        DATEPART(WEEK, @start);
    SET @start = DATEADD(DAY, 1, @start);
END;


-- 2.2 DimPatient
IF OBJECT_ID('dwh.DimPatient') IS NOT NULL DROP TABLE dwh.DimPatient;
CREATE TABLE dwh.DimPatient (
    PatientKey INT IDENTITY PRIMARY KEY,
    PatientId UNIQUEIDENTIFIER,
    Gender NVARCHAR(20),
    Race NVARCHAR(100),
    Ethnicity NVARCHAR(100),
    Marital NVARCHAR(20),
    City NVARCHAR(100),
    State NVARCHAR(50),
    Zip NVARCHAR(20),
    BirthYear INT,
    Income DECIMAL(18,2),
    Healthcare_Expenses DECIMAL(18,2),
    Healthcare_Coverage DECIMAL(18,2)
);

INSERT INTO dwh.DimPatient (PatientId, Gender, Race, Ethnicity, Marital, City, State, Zip,
                            BirthYear, Income, Healthcare_Expenses, Healthcare_Coverage)
SELECT 
    Id,
    Gender, Race, Ethnicity, Marital, City, State, Zip,
    YEAR(Birthdate),
    Income, Healthcare_Expenses, Healthcare_Coverage
FROM core.patients;


-- 2.3 DimEncounterType
IF OBJECT_ID('dwh.DimEncounterType') IS NOT NULL DROP TABLE dwh.DimEncounterType;
CREATE TABLE dwh.DimEncounterType (
    EncounterTypeKey INT IDENTITY PRIMARY KEY,
    EncounterClass NVARCHAR(50)
);

INSERT INTO dwh.DimEncounterType (EncounterClass)
SELECT DISTINCT EncounterClass FROM core.encounters WHERE EncounterClass IS NOT NULL;


-- 2.4 DimCondition
IF OBJECT_ID('dwh.DimCondition') IS NOT NULL DROP TABLE dwh.DimCondition;
CREATE TABLE dwh.DimCondition (
    ConditionKey INT IDENTITY PRIMARY KEY,
    Code NVARCHAR(50),
    Description NVARCHAR(200)
);

INSERT INTO dwh.DimCondition (Code, Description)
SELECT DISTINCT Code, Description FROM core.conditions WHERE Code IS NOT NULL;


-- 2.5 DimMedication
IF OBJECT_ID('dwh.DimMedication') IS NOT NULL DROP TABLE dwh.DimMedication;
CREATE TABLE dwh.DimMedication (
    MedicationKey INT IDENTITY PRIMARY KEY,
    Code NVARCHAR(50),
    Description NVARCHAR(200)
);

INSERT INTO dwh.DimMedication (Code, Description)
SELECT DISTINCT Code, Description FROM core.medications WHERE Code IS NOT NULL;


-- 2.6 DimProcedure
IF OBJECT_ID('dwh.DimProcedure') IS NOT NULL DROP TABLE dwh.DimProcedure;
CREATE TABLE dwh.DimProcedure (
    ProcedureKey INT IDENTITY PRIMARY KEY,
    Code NVARCHAR(50),
    Description NVARCHAR(200)
);

INSERT INTO dwh.DimProcedure (Code, Description)
SELECT DISTINCT Code, Description FROM core.p_procedures WHERE Code IS NOT NULL;


-- 2.7 DimAllergy
IF OBJECT_ID('dwh.DimAllergy') IS NOT NULL DROP TABLE dwh.DimAllergy;
CREATE TABLE dwh.DimAllergy (
    AllergyKey INT IDENTITY PRIMARY KEY,
    Code NVARCHAR(50),
    Description NVARCHAR(200),
    Category NVARCHAR(50)
);

INSERT INTO dwh.DimAllergy (Code, Description, Category)
SELECT DISTINCT Code, Description, Category FROM core.allergies WHERE Code IS NOT NULL;


-- 2.8 DimDevice
IF OBJECT_ID('dwh.DimDevice') IS NOT NULL DROP TABLE dwh.DimDevice;
CREATE TABLE dwh.DimDevice (
    DeviceKey INT IDENTITY PRIMARY KEY,
    Code NVARCHAR(50),
    Description NVARCHAR(200)
);

INSERT INTO dwh.DimDevice (Code, Description)
SELECT DISTINCT Code, Description FROM core.devices WHERE Code IS NOT NULL;


-- 2.9 DimImmunization
IF OBJECT_ID('dwh.DimImmunization') IS NOT NULL DROP TABLE dwh.DimImmunization;
CREATE TABLE dwh.DimImmunization (
    ImmunizationKey INT IDENTITY PRIMARY KEY,
    Code NVARCHAR(50),
    Description NVARCHAR(200)
);

INSERT INTO dwh.DimImmunization (Code, Description)
SELECT DISTINCT Code, Description FROM core.immunizations WHERE Code IS NOT NULL;


-- 2.10 DimObservation
IF OBJECT_ID('dwh.DimObservation') IS NOT NULL DROP TABLE dwh.DimObservation;
CREATE TABLE dwh.DimObservation (
    ObservationKey INT IDENTITY PRIMARY KEY,
    Code NVARCHAR(50),
    Description NVARCHAR(200),
    Units NVARCHAR(30)
);

INSERT INTO dwh.DimObservation (Code, Description, Units)
SELECT DISTINCT Code, OBS_DESCRIPTION, Units FROM core.observations WHERE Code IS NOT NULL;


-- 2.11 DimProvider
IF OBJECT_ID('dwh.DimProvider') IS NOT NULL DROP TABLE dwh.DimProvider;
CREATE TABLE dwh.DimProvider (
    ProviderKey INT IDENTITY PRIMARY KEY,
    ProviderId UNIQUEIDENTIFIER,
    Name NVARCHAR(200),
    Gender NVARCHAR(20),
    Speciality NVARCHAR(100),
    City NVARCHAR(100),
    State NVARCHAR(50),
    Zip NVARCHAR(20)
);

INSERT INTO dwh.DimProvider (ProviderId, Name, Gender, Speciality, City, State, Zip)
SELECT Id, Name, Gender, Speciality, City, State, Zip FROM core.providers;


-- 2.12 DimOrganization
IF OBJECT_ID('dwh.DimOrganization') IS NOT NULL DROP TABLE dwh.DimOrganization;
CREATE TABLE dwh.DimOrganization (
    OrganizationKey INT IDENTITY PRIMARY KEY,
    OrganizationId UNIQUEIDENTIFIER,
    Name NVARCHAR(200),
    City NVARCHAR(100),
    State NVARCHAR(50),
    Zip NVARCHAR(20)
);

INSERT INTO dwh.DimOrganization (OrganizationId, Name, City, State, Zip)
SELECT Id, Name, City, State, Zip FROM core.organizations;

















-- 3.1 FactEncounters
IF OBJECT_ID('dwh.FactEncounters') IS NOT NULL DROP TABLE dwh.FactEncounters;
CREATE TABLE dwh.FactEncounters (
    EncounterKey INT IDENTITY PRIMARY KEY,
    PatientKey INT,
    EncounterTypeKey INT,
    DateKey INT,
    TotalClaimCost DECIMAL(18,2),
    BaseEncounterCost DECIMAL(18,2),
    PayerCoverage DECIMAL(18,2),
    FOREIGN KEY (PatientKey) REFERENCES dwh.DimPatient(PatientKey),
    FOREIGN KEY (EncounterTypeKey) REFERENCES dwh.DimEncounterType(EncounterTypeKey)
);

INSERT INTO dwh.FactEncounters (PatientKey, EncounterTypeKey, DateKey, TotalClaimCost, BaseEncounterCost, PayerCoverage)
SELECT 
    p.PatientKey,
    eType.EncounterTypeKey,
    CONVERT(INT, FORMAT(c.StartDT, 'yyyyMMdd')),
    c.Total_Claim_Cost,
    c.Base_Encounter_Cost,
    c.Payer_Coverage
FROM core.encounters c
JOIN dwh.DimPatient p ON p.PatientId = c.Patient
LEFT JOIN dwh.DimEncounterType eType ON eType.EncounterClass = c.EncounterClass;


-- 3.2 FactConditions
IF OBJECT_ID('dwh.FactConditions') IS NOT NULL DROP TABLE dwh.FactConditions;
CREATE TABLE dwh.FactConditions (
    ConditionFactKey INT IDENTITY PRIMARY KEY,
    PatientKey INT,
    ConditionKey INT,
    StartDateKey INT,
    StopDateKey INT,
    IsChronic BIT,
    FOREIGN KEY (PatientKey) REFERENCES dwh.DimPatient(PatientKey),
    FOREIGN KEY (ConditionKey) REFERENCES dwh.DimCondition(ConditionKey)
);

INSERT INTO dwh.FactConditions (PatientKey, ConditionKey, StartDateKey, StopDateKey, IsChronic)
SELECT 
    p.PatientKey,
    cDim.ConditionKey,
    CONVERT(INT, FORMAT(c.StartDT, 'yyyyMMdd')),
    CONVERT(INT, FORMAT(c.StopDT, 'yyyyMMdd')),
    CASE WHEN c.Description LIKE '%chronic%' THEN 1 ELSE 0 END
FROM core.conditions c
JOIN dwh.DimPatient p ON p.PatientId = c.Patient
JOIN dwh.DimCondition cDim ON cDim.Code = c.Code;


-- 3.3 FactMedications
IF OBJECT_ID('dwh.FactMedications') IS NOT NULL DROP TABLE dwh.FactMedications;
CREATE TABLE dwh.FactMedications (
    MedicationFactKey INT IDENTITY PRIMARY KEY,
    PatientKey INT,
    MedicationKey INT,
    StartDateKey INT,
    TotalCost DECIMAL(18,2),
    PayerCoverage DECIMAL(18,2),
    Dispenses INT,
    FOREIGN KEY (PatientKey) REFERENCES dwh.DimPatient(PatientKey),
    FOREIGN KEY (MedicationKey) REFERENCES dwh.DimMedication(MedicationKey)
);

INSERT INTO dwh.FactMedications (PatientKey, MedicationKey, StartDateKey, TotalCost, PayerCoverage, Dispenses)
SELECT 
    p.PatientKey,
    mDim.MedicationKey,
    CONVERT(INT, FORMAT(m.StartDT, 'yyyyMMdd')),
    m.TotalCost,
    m.Payer_Coverage,
    m.Dispenses
FROM core.medications m
JOIN dwh.DimPatient p ON p.PatientId = m.Patient
JOIN dwh.DimMedication mDim ON mDim.Code = m.Code;


-- 3.4 FactProcedures
IF OBJECT_ID('dwh.FactProcedures') IS NOT NULL DROP TABLE dwh.FactProcedures;
CREATE TABLE dwh.FactProcedures (
    ProcedureFactKey INT IDENTITY PRIMARY KEY,
    PatientKey INT,
    ProcedureKey INT,
    DateKey INT,
    BaseCost DECIMAL(18,2),
    FOREIGN KEY (PatientKey) REFERENCES dwh.DimPatient(PatientKey),
    FOREIGN KEY (ProcedureKey) REFERENCES dwh.DimProcedure(ProcedureKey)
);

INSERT INTO dwh.FactProcedures (PatientKey, ProcedureKey, DateKey, BaseCost)
SELECT 
    p.PatientKey,
    prDim.ProcedureKey,
    CONVERT(INT, FORMAT(pr.StartDT, 'yyyyMMdd')),
    pr.Base_Cost
FROM core.p_procedures pr
JOIN dwh.DimPatient p ON p.PatientId = pr.Patient
JOIN dwh.DimProcedure prDim ON prDim.Code = pr.Code;












-- Step 0: Cleanup
IF OBJECT_ID('tempdb..#EncAgg') IS NOT NULL DROP TABLE #EncAgg;
IF OBJECT_ID('tempdb..#MedAgg') IS NOT NULL DROP TABLE #MedAgg;
IF OBJECT_ID('tempdb..#ProcAgg') IS NOT NULL DROP TABLE #ProcAgg;
IF OBJECT_ID('tempdb..#ChronicPatients') IS NOT NULL DROP TABLE #ChronicPatients;

-----------------------------------------
-- Step 1: Identify chronic patients (5 years)
-----------------------------------------
SELECT DISTINCT TRY_CONVERT(UNIQUEIDENTIFIER, c.Patient) AS PatientId
INTO #ChronicPatients
FROM core.conditions c
WHERE c.Description LIKE '%chronic%'
  AND c.StartDT >= DATEADD(YEAR, -5, GETDATE());

-----------------------------------------
-- Step 2: Aggregate encounters
-----------------------------------------
SELECT 
    p.PatientKey,
    YEAR(e.StartDT) AS [Year],
    MONTH(e.StartDT) AS [Month],
    COUNT(DISTINCT e.Id) AS TotalEncounters,
    AVG(e.Base_Encounter_Cost) AS AvgEncounterCost,
    SUM(e.Total_Claim_Cost) AS TotalClaimCost,
    SUM(e.Payer_Coverage) AS TotalPayerCoverage
INTO #EncAgg
FROM core.encounters e
JOIN dwh.DimPatient p ON p.PatientId = e.Patient
GROUP BY p.PatientKey, YEAR(e.StartDT), MONTH(e.StartDT);

-----------------------------------------
-- Step 3: Aggregate medications
-----------------------------------------
SELECT 
    p.PatientKey,
    YEAR(m.StartDT) AS [Year],
    MONTH(m.StartDT) AS [Month],
    COUNT(DISTINCT m.Code) AS TotalMedications
INTO #MedAgg
FROM core.medications m
JOIN dwh.DimPatient p ON p.PatientId = m.Patient
GROUP BY p.PatientKey, YEAR(m.StartDT), MONTH(m.StartDT);

-----------------------------------------
-- Step 4: Aggregate procedures
-----------------------------------------
SELECT 
    p.PatientKey,
    YEAR(pr.StartDT) AS [Year],
    MONTH(pr.StartDT) AS [Month],
    COUNT(DISTINCT pr.Code) AS TotalProcedures
INTO #ProcAgg
FROM core.p_procedures pr
JOIN dwh.DimPatient p ON p.PatientId = pr.Patient
GROUP BY p.PatientKey, YEAR(pr.StartDT), MONTH(pr.StartDT);

-----------------------------------------
-- Step 5: Merge everything into final fact table
-----------------------------------------
IF OBJECT_ID('dwh.FactPatientMonthly') IS NOT NULL DROP TABLE dwh.FactPatientMonthly;

CREATE TABLE dwh.FactPatientMonthly (
    PatientKey INT,
    Year INT,
    Month INT,
    TotalEncounters INT,
    TotalMedications INT,
    TotalProcedures INT,
    AvgEncounterCost DECIMAL(18,2),
    TotalClaimCost DECIMAL(18,2),
    TotalPayerCoverage DECIMAL(18,2),
    ChronicConditionFlag BIT,
    PRIMARY KEY (PatientKey, Year, Month),
    FOREIGN KEY (PatientKey) REFERENCES dwh.DimPatient(PatientKey)
);

INSERT INTO dwh.FactPatientMonthly
SELECT 
    e.PatientKey,
    e.[Year],
    e.[Month],
    e.TotalEncounters,
    ISNULL(m.TotalMedications, 0) AS TotalMedications,
    ISNULL(pr.TotalProcedures, 0) AS TotalProcedures,
    e.AvgEncounterCost,
    e.TotalClaimCost,
    e.TotalPayerCoverage,
    CASE WHEN cp.PatientId IS NOT NULL THEN 1 ELSE 0 END AS ChronicConditionFlag
FROM #EncAgg e
LEFT JOIN #MedAgg m 
    ON e.PatientKey = m.PatientKey AND e.[Year] = m.[Year] AND e.[Month] = m.[Month]
LEFT JOIN #ProcAgg pr 
    ON e.PatientKey = pr.PatientKey AND e.[Year] = pr.[Year] AND e.[Month] = pr.[Month]
LEFT JOIN dwh.DimPatient dp 
    ON dp.PatientKey = e.PatientKey
LEFT JOIN #ChronicPatients cp 
    ON cp.PatientId = dp.PatientId;














--IF OBJECT_ID('dwh.DimPatient') IS NOT NULL DROP TABLE dwh.DimPatient;
--CREATE TABLE dwh.DimPatient (
--    PatientKey INT IDENTITY(1,1) PRIMARY KEY,
--    PatientId UNIQUEIDENTIFIER NOT NULL,
--    Gender NVARCHAR(20),
--    Race NVARCHAR(100),
--    Ethnicity NVARCHAR(100),
--    Marital NVARCHAR(20),
--    City NVARCHAR(100),
--    State NVARCHAR(50),
--    Zip NVARCHAR(20),
--    Birthdate DATE,
--    Age INT,
--    Income DECIMAL(18,2),
--    Healthcare_Expenses DECIMAL(18,2),
--    Healthcare_Coverage DECIMAL(18,2)
--);


--IF OBJECT_ID('dwh.DimPatient') IS NOT NULL DROP TABLE dwh.DimPatient;
--CREATE TABLE dwh.DimPatient (
--    PatientKey INT IDENTITY(1,1) PRIMARY KEY,
--    PatientId UNIQUEIDENTIFIER NOT NULL,
--    Gender NVARCHAR(20),
--    Race NVARCHAR(100),
--    Ethnicity NVARCHAR(100),
--    Marital NVARCHAR(20),
--    City NVARCHAR(100),
--    State NVARCHAR(50),
--    Zip NVARCHAR(20),
--    Birthdate DATE,
--    Age INT,
--    Income DECIMAL(18,2),
--    Healthcare_Expenses DECIMAL(18,2),
--    Healthcare_Coverage DECIMAL(18,2)
--);

--IF OBJECT_ID('dwh.DimDate') IS NOT NULL DROP TABLE dwh.DimDate;
--CREATE TABLE dwh.DimDate (
--    DateKey INT IDENTITY(1,1) PRIMARY KEY,
--    FullDate DATE,
--    Year INT,
--    Month INT,
--    MonthName NVARCHAR(20),
--    Quarter INT
--);

--IF OBJECT_ID('dwh.DimEncounterType') IS NOT NULL DROP TABLE dwh.DimEncounterType;
--CREATE TABLE dwh.DimEncounterType (
--    EncounterTypeKey INT IDENTITY(1,1) PRIMARY KEY,
--    EncounterClass NVARCHAR(50)
--);


--IF OBJECT_ID('dwh.DimCondition') IS NOT NULL DROP TABLE dwh.DimCondition;
--CREATE TABLE dwh.DimCondition (
--    ConditionKey INT IDENTITY(1,1) PRIMARY KEY,
--    Code NVARCHAR(50),
--    Description NVARCHAR(200),
--    IsChronic BIT
--);


--IF OBJECT_ID('dwh.DimMedication') IS NOT NULL DROP TABLE dwh.DimMedication;
--CREATE TABLE dwh.DimMedication (
--    MedicationKey INT IDENTITY(1,1) PRIMARY KEY,
--    Code NVARCHAR(50),
--    Description NVARCHAR(200)
--);



--IF OBJECT_ID('dwh.FactEncounters') IS NOT NULL DROP TABLE dwh.FactEncounters;
--CREATE TABLE dwh.FactEncounters (
--    EncounterKey INT IDENTITY(1,1) PRIMARY KEY,
--    PatientKey INT NOT NULL,
--    EncounterTypeKey INT NULL,
--    StartDateKey INT NULL,
--    TotalClaimCost DECIMAL(18,2),
--    PayerCoverage DECIMAL(18,2),
--    BaseEncounterCost DECIMAL(18,2),
--    LengthOfStay INT NULL,
--    FOREIGN KEY (PatientKey) REFERENCES dwh.DimPatient(PatientKey),
--    FOREIGN KEY (EncounterTypeKey) REFERENCES dwh.DimEncounterType(EncounterTypeKey),
--    FOREIGN KEY (StartDateKey) REFERENCES dwh.DimDate(DateKey)
--);


--IF OBJECT_ID('dwh.FactMedications') IS NOT NULL DROP TABLE dwh.FactMedications;
--CREATE TABLE dwh.FactMedications (
--    MedicationFactKey INT IDENTITY(1,1) PRIMARY KEY,
--    PatientKey INT NOT NULL,
--    MedicationKey INT NOT NULL,
--    StartDateKey INT NULL,
--    TotalCost DECIMAL(18,2),
--    PayerCoverage DECIMAL(18,2),
--    Dispenses INT,
--    FOREIGN KEY (PatientKey) REFERENCES dwh.DimPatient(PatientKey),
--    FOREIGN KEY (MedicationKey) REFERENCES dwh.DimMedication(MedicationKey),
--    FOREIGN KEY (StartDateKey) REFERENCES dwh.DimDate(DateKey)
--);


--IF OBJECT_ID('dwh.FactConditions') IS NOT NULL DROP TABLE dwh.FactConditions;
--CREATE TABLE dwh.FactConditions (
--    ConditionFactKey INT IDENTITY(1,1) PRIMARY KEY,
--    PatientKey INT NOT NULL,
--    ConditionKey INT NOT NULL,
--    StartDateKey INT NULL,
--    FOREIGN KEY (PatientKey) REFERENCES dwh.DimPatient(PatientKey),
--    FOREIGN KEY (ConditionKey) REFERENCES dwh.DimCondition(ConditionKey),
--    FOREIGN KEY (StartDateKey) REFERENCES dwh.DimDate(DateKey)
--);




--IF OBJECT_ID('dwh.FactPatientMonthly') IS NOT NULL DROP TABLE dwh.FactPatientMonthly;
--CREATE TABLE dwh.FactPatientMonthly (
--    PatientMonthlyKey INT IDENTITY(1,1) PRIMARY KEY,
--    PatientKey INT NOT NULL,
--    Year INT,
--    Month INT,
--    TotalEncounters INT,
--    TotalMedications INT,
--    TotalConditions INT,
--    Total_Claim_Cost DECIMAL(18,2),
--    Avg_Observation_Value DECIMAL(18,4),
--    Chronic_Flag BIT,
--    FOREIGN KEY (PatientKey) REFERENCES dwh.DimPatient(PatientKey)
--);



--DECLARE @StartDate DATE = '2015-01-01', @EndDate DATE = '2030-12-31';
--WHILE @StartDate <= @EndDate
--BEGIN
--    INSERT INTO dwh.DimDate (FullDate, Year, Month, MonthName, Quarter)
--    VALUES (
--        @StartDate,
--        YEAR(@StartDate),
--        MONTH(@StartDate),
--        DATENAME(MONTH, @StartDate),
--        DATEPART(QUARTER, @StartDate)
--    );
--    SET @StartDate = DATEADD(DAY, 1, @StartDate);
--END;


--INSERT INTO dwh.DimPatient (PatientId, Gender, Race, Ethnicity, Marital, City, State, Zip,
--                            Birthdate, Age, Income, Healthcare_Expenses, Healthcare_Coverage)
--SELECT
--    p.Id,
--    p.Gender,
--    p.Race,
--    p.Ethnicity,
--    p.Marital,
--    p.City,
--    p.State,
--    p.Zip,
--    p.Birthdate,
--    DATEDIFF(YEAR, p.Birthdate, GETDATE()) AS Age,
--    p.Income,
--    p.Healthcare_Expenses,
--    p.Healthcare_Coverage
--FROM core.patients p;


--INSERT INTO dwh.DimEncounterType (EncounterClass)
--SELECT DISTINCT EncounterClass
--FROM core.encounters
--WHERE EncounterClass IS NOT NULL;


--INSERT INTO dwh.DimCondition (Code, Description, IsChronic)
--SELECT DISTINCT
--    Code,
--    Description,
--    CASE WHEN LOWER(Description) LIKE '%chronic%' THEN 1 ELSE 0 END AS IsChronic
--FROM core.conditions
--WHERE Code IS NOT NULL;


--INSERT INTO dwh.DimMedication (Code, Description)
--SELECT DISTINCT Code, Description
--FROM core.medications
--WHERE Code IS NOT NULL;



--INSERT INTO dwh.FactEncounters (PatientKey, EncounterTypeKey, StartDateKey, TotalClaimCost, PayerCoverage, BaseEncounterCost)
--SELECT
--    dp.PatientKey,
--    det.EncounterTypeKey,
--    dd.DateKey,
--    e.Total_Claim_Cost,
--    e.Payer_Coverage,
--    e.Base_Encounter_Cost
--FROM core.encounters e
--JOIN dwh.DimPatient dp ON dp.PatientId = e.Patient
--LEFT JOIN dwh.DimEncounterType det ON det.EncounterClass = e.EncounterClass
--LEFT JOIN dwh.DimDate dd ON dd.FullDate = CAST(e.StartDT AS DATE);


--INSERT INTO dwh.FactMedications (PatientKey, MedicationKey, StartDateKey, TotalCost, PayerCoverage, Dispenses)
--SELECT
--    dp.PatientKey,
--    dm.MedicationKey,
--    dd.DateKey,
--    m.TotalCost,
--    m.Payer_Coverage,
--    m.Dispenses
--FROM core.medications m
--JOIN dwh.DimPatient dp ON dp.PatientId = m.Patient
--LEFT JOIN dwh.DimMedication dm ON dm.Code = m.Code
--LEFT JOIN dwh.DimDate dd ON dd.FullDate = CAST(m.StartDT AS DATE);


--INSERT INTO dwh.FactConditions (PatientKey, ConditionKey, StartDateKey)
--SELECT
--    dp.PatientKey,
--    dc.ConditionKey,
--    dd.DateKey
--FROM core.conditions c
--JOIN dwh.DimPatient dp ON dp.PatientId = c.Patient
--LEFT JOIN dwh.DimCondition dc ON dc.Code = c.Code
--LEFT JOIN dwh.DimDate dd ON dd.FullDate = CAST(c.StartDT AS DATE);


---- 6? Aggregated Monthly Fact (Patient-Level)
--INSERT INTO dwh.FactPatientMonthly (
--    PatientKey, Year, Month,
--    TotalEncounters, TotalMedications, TotalConditions,
--    Total_Claim_Cost, Avg_Observation_Value, Chronic_Flag
--)
--SELECT
--    dp.PatientKey,
--    YEAR(e.StartDT) AS Year,
--    MONTH(e.StartDT) AS Month,
--    COUNT(DISTINCT e.Id) AS TotalEncounters,
--    COUNT(DISTINCT m.Code) AS TotalMedications,
--    COUNT(DISTINCT c.Code) AS TotalConditions,
--    SUM(e.Total_Claim_Cost) AS Total_Claim_Cost,
--    AVG(o.ValueNum) AS Avg_Observation_Value,
--    CASE WHEN EXISTS (
--        SELECT 1
--        FROM core.conditions cc
--        WHERE cc.Patient = dp.PatientId
--          AND LOWER(cc.Description) LIKE '%chronic%'
--          AND cc.StartDT >= DATEADD(YEAR, -5, GETDATE())
--    ) THEN 1 ELSE 0 END AS Chronic_Flag
--FROM core.encounters e
--JOIN dwh.DimPatient dp ON dp.PatientId = e.Patient
--LEFT JOIN core.medications m ON m.Patient = e.Patient
--LEFT JOIN core.conditions c ON c.Patient = e.Patient
--LEFT JOIN core.observations o ON o.Patient = e.Patient
--GROUP BY dp.PatientKey, YEAR(e.StartDT), MONTH(e.StartDT);




IF OBJECT_ID('dwh.FactObservations') IS NOT NULL DROP TABLE dwh.FactObservations;
CREATE TABLE dwh.FactObservations (
    ObservationFactKey INT IDENTITY(1,1) PRIMARY KEY,
    PatientKey INT NOT NULL,
    ObservationKey INT NOT NULL,
    DateKey INT NOT NULL,
    EncounterKey INT NULL,
    ValueNum DECIMAL(18,4) NULL,
    ValueTxt NVARCHAR(255) NULL,
    Units NVARCHAR(50) NULL,

    FOREIGN KEY (PatientKey) REFERENCES dwh.DimPatient(PatientKey),
    FOREIGN KEY (ObservationKey) REFERENCES dwh.DimObservation(ObservationKey),
    FOREIGN KEY (DateKey) REFERENCES dwh.DimDate(DateKey),
    FOREIGN KEY (EncounterKey) REFERENCES dwh.FactEncounters(EncounterKey)
);
GO




IF OBJECT_ID('dwh.FactImmunizations') IS NOT NULL DROP TABLE dwh.FactImmunizations;
CREATE TABLE dwh.FactImmunizations (
    ImmunizationFactKey INT IDENTITY(1,1) PRIMARY KEY,
    PatientKey INT NOT NULL,
    ImmunizationKey INT NOT NULL,
    DateKey INT NOT NULL,
    EncounterKey INT NULL,
    BaseCost DECIMAL(18,2) NULL,

    FOREIGN KEY (PatientKey) REFERENCES dwh.DimPatient(PatientKey),
    FOREIGN KEY (ImmunizationKey) REFERENCES dwh.DimImmunization(ImmunizationKey),
    FOREIGN KEY (DateKey) REFERENCES dwh.DimDate(DateKey),
    FOREIGN KEY (EncounterKey) REFERENCES dwh.FactEncounters(EncounterKey)
);
GO



IF OBJECT_ID('dwh.FactAllergies') IS NOT NULL DROP TABLE dwh.FactAllergies;
CREATE TABLE dwh.FactAllergies (
    AllergyFactKey INT IDENTITY(1,1) PRIMARY KEY,
    PatientKey INT NOT NULL,
    AllergyKey INT NOT NULL,
    DateKey INT NOT NULL,
    EncounterKey INT NULL,
    Severity NVARCHAR(50) NULL,
    Reaction NVARCHAR(200) NULL,
    ActiveFlag BIT NULL,

    FOREIGN KEY (PatientKey) REFERENCES dwh.DimPatient(PatientKey),
    FOREIGN KEY (AllergyKey) REFERENCES dwh.DimAllergy(AllergyKey),
    FOREIGN KEY (DateKey) REFERENCES dwh.DimDate(DateKey),
    FOREIGN KEY (EncounterKey) REFERENCES dwh.FactEncounters(EncounterKey)
);
GO




IF OBJECT_ID('dwh.FactDevices') IS NOT NULL DROP TABLE dwh.FactDevices;
CREATE TABLE dwh.FactDevices (
    DeviceFactKey INT IDENTITY(1,1) PRIMARY KEY,
    PatientKey INT NOT NULL,
    DeviceKey INT NOT NULL,
    DateKey INT NOT NULL,
    EncounterKey INT NULL,
    UDI NVARCHAR(200) NULL,  -- Unique Device Identifier
    BaseCost DECIMAL(18,2) NULL,

    FOREIGN KEY (PatientKey) REFERENCES dwh.DimPatient(PatientKey),
    FOREIGN KEY (DeviceKey) REFERENCES dwh.DimDevice(DeviceKey),
    FOREIGN KEY (DateKey) REFERENCES dwh.DimDate(DateKey),
    FOREIGN KEY (EncounterKey) REFERENCES dwh.FactEncounters(EncounterKey)
);
GO




-- Add foreign key constraints only if they don’t already exist
IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_FactEncounters_Provider'
)
ALTER TABLE dwh.FactEncounters
ADD CONSTRAINT FK_FactEncounters_Provider
FOREIGN KEY (ProviderKey) REFERENCES dwh.DimProvider(ProviderKey);
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_FactEncounters_Organization'
)
ALTER TABLE dwh.FactEncounters
ADD CONSTRAINT FK_FactEncounters_Organization
FOREIGN KEY (OrganizationKey) REFERENCES dwh.DimOrganization(OrganizationKey);
GO





SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dwh' AND TABLE_NAME = 'FactEncounters';





-- Connect FactEncounters → DimProvider
IF NOT EXISTS (
    SELECT 1 
    FROM sys.foreign_keys 
    WHERE name = 'FK_FactEncounters_Provider'
)
ALTER TABLE dwh.FactEncounters
ADD CONSTRAINT FK_FactEncounters_Provider
FOREIGN KEY (ProviderKey) REFERENCES dwh.DimProvider(ProviderKey);
GO

-- Connect FactEncounters → DimOrganization
IF NOT EXISTS (
    SELECT 1 
    FROM sys.foreign_keys 
    WHERE name = 'FK_FactEncounters_Organization'
)
ALTER TABLE dwh.FactEncounters
ADD CONSTRAINT FK_FactEncounters_Organization
FOREIGN KEY (OrganizationKey) REFERENCES dwh.DimOrganization(OrganizationKey);
GO



SELECT 
    fk.name AS FK_Name,
    OBJECT_NAME(fk.parent_object_id) AS FactTable,
    OBJECT_NAME(fk.referenced_object_id) AS DimTable
FROM sys.foreign_keys fk
WHERE OBJECT_NAME(fk.parent_object_id) = 'FactEncounters';



SELECT 
    OBJECT_NAME(fk.parent_object_id) AS FactTable,
    cpa.name AS FactColumn,
    OBJECT_NAME(fk.referenced_object_id) AS DimTable,
    cre.name AS DimColumn
FROM sys.foreign_keys fk
INNER JOIN sys.foreign_key_columns fkc
    ON fk.object_id = fkc.constraint_object_id
INNER JOIN sys.columns cpa
    ON fkc.parent_object_id = cpa.object_id
   AND fkc.parent_column_id = cpa.column_id
INNER JOIN sys.columns cre
    ON fkc.referenced_object_id = cre.object_id
   AND fkc.referenced_column_id = cre.column_id
WHERE OBJECT_SCHEMA_NAME(fk.parent_object_id) = 'dwh'
ORDER BY FactTable;




SELECT 
    fk.name AS FK_Name,
    OBJECT_SCHEMA_NAME(fk.parent_object_id) AS FactSchema,
    OBJECT_NAME(fk.parent_object_id) AS FactTable,
    OBJECT_SCHEMA_NAME(fk.referenced_object_id) AS DimSchema,
    OBJECT_NAME(fk.referenced_object_id) AS DimTable
FROM sys.foreign_keys fk
WHERE OBJECT_NAME(fk.parent_object_id) = 'FactEncounters';



-- Update ProviderKey and OrganizationKey in FactEncounters
UPDATE fe
SET 
    fe.ProviderKey = dpv.ProviderKey,
    fe.OrganizationKey = dor.OrganizationKey
FROM dwh.FactEncounters fe
LEFT JOIN core.encounters e
    ON e.Patient = (
        SELECT PatientId FROM dwh.DimPatient WHERE PatientKey = fe.PatientKey
    )
LEFT JOIN dwh.DimProvider dpv
    ON dpv.ProviderId = e.Provider
LEFT JOIN dwh.DimOrganization dor
    ON dor.OrganizationId = e.Organization;








UPDATE c
SET 
    Provider = TRY_CONVERT(UNIQUEIDENTIFIER, s.PROVIDER),
    Organization = TRY_CONVERT(UNIQUEIDENTIFIER, s.ORGANIZATION)
FROM core.encounters c
JOIN staging.encounters s
    ON TRY_CONVERT(UNIQUEIDENTIFIER, s.Id) = c.Id;





    -- 🔄 Update FactEncounters to fill ProviderKey and OrganizationKey
UPDATE fe
SET 
    fe.ProviderKey = dpv.ProviderKey,
    fe.OrganizationKey = dor.OrganizationKey
FROM dwh.FactEncounters fe
INNER JOIN core.encounters e
    ON e.Patient = (
        SELECT PatientId 
        FROM dwh.DimPatient 
        WHERE PatientKey = fe.PatientKey
    )
LEFT JOIN dwh.DimProvider dpv
    ON TRY_CONVERT(UNIQUEIDENTIFIER, e.Provider) = dpv.ProviderId
LEFT JOIN dwh.DimOrganization dor
    ON TRY_CONVERT(UNIQUEIDENTIFIER, e.Organization) = dor.OrganizationId;




    SELECT 
    COUNT(*) AS TotalRows,
    COUNT(ProviderKey) AS NonNullProviders,
    COUNT(OrganizationKey) AS NonNullOrganizations
FROM dwh.FactEncounters;
