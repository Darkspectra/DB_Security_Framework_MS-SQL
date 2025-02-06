


--===============Column Level Encryption===================




--========AES-256 cryptography configuration=============


USE Take1;
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'StrongPassword123!';


CREATE CERTIFICATE TransformersCertificate
WITH SUBJECT = 'Certificate for Encrypting Transformers Data';

USE Take1;
-- USE master;
CREATE SYMMETRIC KEY TransformersSymmetricKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE TransformersCertificate;




--========Table Creation=============



DROP TABLE Transformers;

CREATE TABLE Transformers
(
	Rank int,
	Name varchar(30),
	Initial char(2),
	Type varchar(30),
	Power int,
	Weapon VARBINARY(MAX),
	Department varchar(15),
	Date date
);



OPEN SYMMETRIC KEY TransformersSymmetricKey
DECRYPTION BY CERTIFICATE TransformersCertificate;

INSERT INTO Transformers
VALUES
(1, 'Optimus Prime', 'OP', 'Truck', 99225, 
    ENCRYPTBYKEY(KEY_GUID('TransformersSymmetricKey'), CONVERT(VARBINARY(MAX), 'Sword of Judgement')), 
    'Artillery', '2016-01-18'),
(2, 'Bumblebee', 'OG', 'Mini-vehicle', 14808, 
    ENCRYPTBYKEY(KEY_GUID('TransformersSymmetricKey'), CONVERT(VARBINARY(MAX), 'Cosmic Rust Gun')), 
    'Artillery', '2017-05-19'),
(2, 'Ratchet', 'NF', 'Car', 10644, 
    ENCRYPTBYKEY(KEY_GUID('TransformersSymmetricKey'), CONVERT(VARBINARY(MAX), 'Shield Cannon')), 
    'Artillery', '2018-01-09'),
(5, 'Outback', 'UW', 'Mini-vehicle', 1390, 
    ENCRYPTBYKEY(KEY_GUID('TransformersSymmetricKey'), CONVERT(VARBINARY(MAX), 'Primax Blade')), 
    'Engineering', '2015-06-04'),
(5, 'Huffer', 'CX', 'Mini-vehicle', 4865, 
    ENCRYPTBYKEY(KEY_GUID('TransformersSymmetricKey'), CONVERT(VARBINARY(MAX), 'Machine Gun')), 
    'Medical', '2014-02-05'),
(4, 'Bluestreak', 'AB', 'Car', 12438, 
    ENCRYPTBYKEY(KEY_GUID('TransformersSymmetricKey'), CONVERT(VARBINARY(MAX), 'Chainsaw')), 
    'Artillery', '2015-08-16'),
(6, 'Grimlock', 'FF', 'Dinobot', 25634, 
    ENCRYPTBYKEY(KEY_GUID('TransformersSymmetricKey'), CONVERT(VARBINARY(MAX), 'Padding Missiles')), 
    'Intelligence', '2012-08-11'),
(2, 'Brawn', 'HI', 'Mini-vehicle', 9339, 
    ENCRYPTBYKEY(KEY_GUID('TransformersSymmetricKey'), CONVERT(VARBINARY(MAX), 'Shield Cannon')), 
    'Infantry', '2017-05-22'),
(1, 'Sentinel Prime', 'KY', 'Truck', 65214, 
    ENCRYPTBYKEY(KEY_GUID('TransformersSymmetricKey'), CONVERT(VARBINARY(MAX), 'Cybertronian Sword')), 
    'Engineering', '2016-01-19'),
(3, 'Slag', 'GU', 'Dinobot', 9213, 
    ENCRYPTBYKEY(KEY_GUID('TransformersSymmetricKey'), CONVERT(VARBINARY(MAX), 'Shield Cannon')), 
    'Engineering', '2017-05-19'),
(4, 'Prowl', 'OE', 'Car', 7433, 
    ENCRYPTBYKEY(KEY_GUID('TransformersSymmetricKey'), CONVERT(VARBINARY(MAX), 'Cosmic Rust Gun')), 
    'Engineering', '2014-02-05'),
(5, 'Chromia', 'IG', 'Van', 19375, 
    ENCRYPTBYKEY(KEY_GUID('TransformersSymmetricKey'), CONVERT(VARBINARY(MAX), 'Primax Blade')), 
    'Infantry', '2012-03-08'),
(6, 'Cosmos', 'HR', 'Mini-vehicle', 15925, 
    ENCRYPTBYKEY(KEY_GUID('TransformersSymmetricKey'), CONVERT(VARBINARY(MAX), 'Cybertronian Sword')), 
    'Medical', '2016-10-29'),
(2, 'Eject', 'KN', 'Mini-cassette', 12536, 
    ENCRYPTBYKEY(KEY_GUID('TransformersSymmetricKey'), CONVERT(VARBINARY(MAX), 'Chainsaw')), 
    'Medical', '2017-08-14'),
(4, 'Firestar', 'FA', 'Van', 3255, 
    ENCRYPTBYKEY(KEY_GUID('TransformersSymmetricKey'), CONVERT(VARBINARY(MAX), 'Shield Cannon')), 
    'Infantry', '2018-01-23'),
(5, 'Hound', 'WR', 'Car', 14867, 
    ENCRYPTBYKEY(KEY_GUID('TransformersSymmetricKey'), CONVERT(VARBINARY(MAX), 'Shield Cannon')), 
    'Intelligence', '2016-11-11'),
(5, 'Raindance', 'NE', 'Mini-cassette', 26283, 
    ENCRYPTBYKEY(KEY_GUID('TransformersSymmetricKey'), CONVERT(VARBINARY(MAX), 'Shield Cannon')), 
    'Medical', '2017-04-23'),
(4, 'Ramhorn', 'EL', 'Mini-cassette', 19302, 
    ENCRYPTBYKEY(KEY_GUID('TransformersSymmetricKey'), CONVERT(VARBINARY(MAX), 'Shield Cannon')), 
    'Artillery', '2016-03-03'),
(3, 'Skyfire', 'TM', 'Jet', 9698, 
    ENCRYPTBYKEY(KEY_GUID('TransformersSymmetricKey'), CONVERT(VARBINARY(MAX), 'Naginata Staff')), 
    'Engineering', '2017-05-19');

CLOSE SYMMETRIC KEY TransformersSymmetricKey;




OPEN SYMMETRIC KEY TransformersSymmetricKey
DECRYPTION BY CERTIFICATE TransformersCertificate;

SELECT 
    Rank,
    Name,
    Initial,
    Type,
    Power,
    CAST(DECRYPTBYKEY(Weapon) AS VARCHAR(MAX)) AS Weapon,
    Department,
    Date
FROM Transformers;

CLOSE SYMMETRIC KEY TransformersSymmetricKey;




USE Take1;
SELECT * FROM Transformers;




--===================================
--===================================



--==========Backup DB=============

BACKUP DATABASE Take1
TO DISK = 'C:\SQLBackup\Take1.bak'
WITH INIT, NAME = 'Full Backup';

-- for testing
DELETE FROM Transformers WHERE Name = 'Outback';


-- Restore the database
revert;
USE master;
GO


RESTORE DATABASE Take1
FROM DISK = 'C:\SQLBackup\Take1.bak'
WITH REPLACE;


USE Take1;
SELECT * FROM Transformers;

--=============Monitor active session on Take1=============

SELECT 
    session_id, 
    login_name, 
    status, 
    database_id, 
    program_name 
FROM sys.dm_exec_sessions
WHERE database_id = DB_ID('Take1');








--=================Audit Log System==============

USE master;
GO

-- Create an audit specification

CREATE SERVER AUDIT MyServerAudit
TO FILE (FILEPATH = 'C:\SQLAudit\AuditLogs\')
WITH (ON_FAILURE = CONTINUE);


-- Enable the audit
ALTER SERVER AUDIT MyServerAudit WITH (STATE = ON);


-- Create a database audit specification
USE Take1;
CREATE DATABASE AUDIT SPECIFICATION MyDatabaseAudit
FOR SERVER AUDIT MyServerAudit
ADD (SELECT ON SCHEMA::dbo BY PUBLIC)
WITH (STATE = ON);


SELECT * FROM sys.fn_get_audit_file('C:\SQLAudit\AuditLogs\*.sqlaudit', DEFAULT, DEFAULT);






--==========Role Based Access Control============


-- Create roles
CREATE ROLE DataReaderRole;
CREATE ROLE DataWriterRole;


--======================

USE Take1;
GO

CREATE LOGIN Login1 WITH PASSWORD = 'StrongPassword1';
CREATE LOGIN Login2 WITH PASSWORD = 'StrongPassword2';


CREATE USER Optimus FOR LOGIN Login1;
CREATE USER Megatron FOR LOGIN Login2;


GRANT SELECT ON Transformers TO DataReaderRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Transformers TO DataWriterRole;


EXEC sp_addrolemember 'DataReaderRole', 'Megatron';
EXEC sp_addrolemember 'DataWriterRole', 'Optimus';

GRANT CONTROL ON CERTIFICATE::TransformersCertificate TO Optimus;
GRANT CONTROL ON SYMMETRIC KEY::TransformersSymmetricKey TO Optimus;








SELECT 
    spid AS SessionID, 
    db_name(dbid) AS DatabaseName, 
    loginame AS LoginName, 
    status, 
    hostname AS HostName, 
    program_name AS ProgramName
FROM sys.sysprocesses
WHERE dbid = DB_ID('Take1');

KILL 58;