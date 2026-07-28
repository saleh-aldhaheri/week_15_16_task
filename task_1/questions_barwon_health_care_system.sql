USE barwon_health_care_system;

-- 1  -  SELECT: Retrieve all columns from the Doctor table.
SELECT * FROM doctors;

-- 2  -  ORDER BY: List patients in the Patient table in ascending order of their ages.
SELECT * FROM patients 
ORDER BY age;

-- 3  -  OFFSET FETCH: Retrieve the first 10 patients from the Patient table, starting from the 5th record.
SELECT * FROM patients
ORDER BY ur_number
OFFSET 4 ROWS 
FETCH NEXT 10 ROWS ONLY; 

-- 4  -  SELECT TOP: Retrieve the top 5 doctors from the Doctor table.
SELECT TOP 5 * FROM doctors 
-- OR 
SELECT * FROM doctors
ORDER BY id
OFFSET 0 ROWS 
FETCH NEXT 5 ROWS ONLY; 

-- 5  -  SELECT DISTINCT: Get a list of unique address from the Patient table.
SELECT DISTINCT city, country , street FROM patients;

-- 6  -  WHERE: Retrieve patients from the Patient table who are aged 25.
SELECT * FROM patients WHERE age = 25; 

-- 7  -  NULL: Retrieve patients from the Patient table whose email is not provided.
SELECT * FROM patients WHERE email is Null;

-- 8  -  AND: Retrieve doctors from the Doctor table who have experience greater than 5 years and specialize in 'Cardiology'.
SELECT * FROM doctors WHERE year_of_experience > 5 AND specialty = 'Cardiology';

-- 9  -  IN: Retrieve doctors from the Doctor table whose speciality is either 'Dermatology' or 'Oncology'.
SELECT * FROM doctors WHERE specialty = 'Dermatology' or specialty = 'Oncology';

-- 10 -  BETWEEN: Retrieve patients from the Patient table whose ages are between 18 and 30.
SELECT * FROM patients WHERE age BETWEEN 18 AND 30;

-- 11 -  LIKE: Retrieve doctors from the Doctor table whose names start with 'Dr.'.
SELECT * FROM doctors WHERE name LIKE 'Dr.%';

-- 12 -  Column & Table Aliases: Select the name and email of doctors, aliasing them as 'DoctorName' and 'DoctorEmail'.
SELECT name AS DoctorName , email AS DoctorEmail FROM doctors;

-- 13 -  Joins: Retrieve all prescriptions with corresponding patient names.
SELECT 
pa.name AS 'patient name',
p.date,
p.quantity,
p.doctor_id,
p.drug_id, 
p.ur_number FROM prescriptions p 
LEFT JOIN patients pa
ON p.ur_number = pa.ur_number;

-- 14 -  GROUP BY: Retrieve the count of patients grouped by their cities.
SELECT COUNT(*) AS 'patients count in each city' FROM patients
GROUP BY city

-- 15 -  HAVING: Retrieve cities with more than 3 patients.
SELECT city FROM patients
GROUP BY city
HAVING COUNT(city) > 3

-- 16 -  GROUPING SETS: Retrieve counts of patients grouped by cities and ages.
SELECT city , age , COUNT(*) AS 'number of patients'  FROM patients
GROUP BY GROUPING SETS((city) , (age));

-- 17 -  CUBE: Retrieve counts of patients considering all possible combinations of city and age.
SELECT city , age , COUNT(*) AS 'number of patients'  FROM patients
GROUP BY CUBE (city, age);

-- 18 -  ROLLUP: Retrieve counts of patients rolled up by city.
SELECT city, age, COUNT(*) AS 'number of patients' FROM patients
GROUP BY ROLLUP (city, age);

-- 19 -  EXISTS: Retrieve patients who have at least one prescription.
SELECT * FROM patients p
WHERE EXISTS (SELECT 1 FROM prescriptions pr
WHERE pr.ur_number = p.ur_number);

-- 20 -  UNION: Retrieve a combined list of doctors and patients.
SELECT name, phone, email FROM doctors
UNION
SELECT name, phone, email FROM patients

-- 21 -  Common Table Expression (CTE): Retrieve patients along with their doctors using a CTE.
WITH patinent_doctors AS ( 
 SELECT 
   p.*, 
   d.name AS 'doctor name',
   d.phone AS 'docter phone', 
   d.email AS 'docter email', 
   d.year_of_experience, 
   d.specialty
 FROM patients p
 LEFT JOIN doctors d
 ON p.doctor_id = d.id
)

SELECT * FROM patinent_doctors

-- 22 -  INSERT: Insert a new doctor into the Doctor table.
INSERT INTO doctors
(name, phone, email, year_of_experience, specialty)
VALUES
('saleh', '737801951', 'saleh@gmail.com', 7, 'Dermatology')


-- 23 -  INSERT Multiple Rows: Insert multiple patients into the Patient table.
INSERT INTO patients
(ur_number, name, phone, email, country, city, street, age, medicare_card_number, doctor_id)
VALUES
(1001, 'Ahmed Al-Farsi', '0501234567', 'ahmed.farsi@mail.com', 'Saudi Arabia', 'Riyadh', 'King Fahd Rd', 34, 'MC1023456', 12),
(1002, 'Layla Haddad', '0791234567', 'layla.haddad@mail.com', 'Jordan', 'Amman', 'Al-Rainbow St', 29, NULL, 47),
(1003, 'Youssef El-Sayed', '01012345678', 'youssef.elsayed@mail.com', 'Egypt', 'Cairo', 'Tahrir St', 41, 'MC7789012', 5),
(1004, 'Fatima Al-Zahrani', '0561234567', 'fatima.zahrani@mail.com', 'United Arab Emirates', 'Dubai', 'Sheikh Zayed Rd', 52, 'MC4456781', 88),
(1005, 'Karim Bensaid', '0612345678', 'karim.bensaid@mail.com', 'Morocco', 'Casablanca', 'Boulevard Zerktouni', 23, NULL, 100);

-- 24 -  UPDATE: Update the phone number of a doctor.
UPDATE doctors SET phone = '715555171'
WHERE id = 101; 


-- 25 -  UPDATE JOIN: Update the city of patients who have a prescription from a specific doctor.
UPDATE p
SET city = 'Cairo'
FROM patients p 
INNER JOIN prescriptions pr 
ON p.ur_number = pr.ur_number
WHERE pr.doctor_id = 1

-- 26 -  DELETE: Delete a patient from the Patient table.
DELETE FROM patients WHERE ur_number = 1005;  

-- 27 -  Transaction: Insert a new doctor and a patient, ensuring both operations succeed or fail together.
BEGIN TRANSACTION 
	INSERT INTO doctors
	(name, phone, email, year_of_experience, specialty)
	VALUES
	('saleh', '737801951', 'saleh@gmail.com', 7, 'Dermatology')

	INSERT INTO patients
	(ur_number, name, phone, email, country, city, street, age, medicare_card_number, doctor_id)
	VALUES
	(1001, 'Ahmed Al-Farsi', '0501234567', 'ahmed.farsi@mail.com', 'Saudi Arabia', 'Riyadh', 'King Fahd Rd', 34, 'MC1023456', 12)
COMMIT 
ROLLBACK;

-- 28 -  View: Create a view that combines patient and doctor information for easy access.
CREATE VIEW patients_doctors AS 
SELECT 
	p.*,
	d.name AS 'doctor name',
	d.phone AS 'docter phone', 
	d.email AS 'docter email', 
	d.year_of_experience, 
	d.specialty
FROM patients  p 
FULL JOIN doctors d 
ON p.doctor_id = d.id;

-- 29 -  Index: Create an index on the 'phone' column of the Patient table to improve search performance.
CREATE NONCLUSTERED INDEX idx_patinets_phone 
ON patients(phone);

-- 30 -  Backup: Perform a backup of the entire database to ensure data safety.
BACKUP DATABASE barwon_health_care_system  
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\barwon_health_care_system.bak'
WITH INIT,  
NAME = 'barwon_health_care_system_backup';

-- additional Restore: database from the backup *_*
DROP DATABASE barwon_health_care_system;  

RESTORE DATABASE barwon_health_care_system
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\barwon_health_care_system.bak'
