CREATE DATABASE barwon_health_care_system
GO	

USE barwon_health_care_system
GO 

-- No Schema Need As All Entities Follow The Same Domain

-- Doctors
CREATE TABLE doctors ( 
	id                 INT IDENTITY PRIMARY KEY, 
	name               VARCHAR(50) NOT NULL,  
	phone              VARCHAR(20) NOT NULL, 
	email              VARCHAR(100) NOT NULL,
	year_of_experience INT NOT NULL, 
	specialty          VARCHAR(50) NOT NULL 
);

-- Patients
CREATE TABLE patients (
	ur_number            INT PRIMARY KEY, 
	name                 VARCHAR(50) NOT NULL,  
	city                 VARCHAR(50) NOT NULL,
	country              VARCHAR(50) NOT NULL,
	street               VARCHAR(50) NOT NULL,
	age                  INT NOT NULL, 
	email                VARCHAR(100) NOT NULL, 
	phone                VARCHAR(20) NOT NULL, 
	medicare_card_number VARCHAR(20),
	doctor_id            INT REFERENCES doctors(id) NOT NULL
); 

-- Pharmaceutica Companies
CREATE TABLE pharmaceutica_companies ( 
	id           INT IDENTITY PRIMARY KEY,
	name         VARCHAR(100) UNIQUE NOT NULL,
	city         VARCHAR(50) NOT NULL,
	country      VARCHAR(50) NOT NULL,
	street       VARCHAR(50) NOT NULL,
	phone_number VARCHAR(20) NOT NULL
); 

-- Drug
CREATE TABLE drugs (
	id         INT IDENTITY PRIMARY KEY, 
	name       VARCHAR(255) NOT NULL, 
	strength   VARCHAR(20) NOT NULL, 
	company_id INT REFERENCES pharmaceutica_companies(id) ON DELETE CASCADE NOT NULL,
	UNIQUE (name, company_id)
);

-- Prescriptions
CREATE TABLE prescriptions (
	id        INT IDENTITY PRIMARY KEY, 
	date      DATE NOT NULL,
	quantity  INT NOT NULL, 
	doctor_id INT REFERENCES doctors(id) NOT NULL, 
	ur_number INT REFERENCES patients(ur_number) NOT NULL,
	drug_id   INT REFERENCES drugs(id) NOT NULL
)
GO

-- INDEXING ADDITIONAL
CREATE NONCLUSTERED INDEX idx_patient_medicare_card_number
ON patients(medicare_card_number)

CREATE NONCLUSTERED INDEX idx_patient_docter_id 
ON patients(doctor_id)  

CREATE NONCLUSTERED INDEX idx_durgs_name
ON drugs(name)  

CREATE NONCLUSTERED INDEX idx_prescriptions_ur_number
ON prescriptions(ur_number) 

CREATE NONCLUSTERED INDEX idx_prescriptions_doctor_id
ON prescriptions(doctor_id) 

CREATE NONCLUSTERED INDEX idx_prescriptions_drug_id
ON prescriptions(drug_id)