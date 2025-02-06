

use Take1;
EXECUTE AS USER = 'Optimus';
GO


SELECT * FROM Transformers;

--===================================================

OPEN SYMMETRIC KEY TransformersSymmetricKey
DECRYPTION BY CERTIFICATE TransformersCertificate;

INSERT INTO Transformers
VALUES
(43, 'Mez P56', 'OP', 'Jettt', 192253, 
    ENCRYPTBYKEY(KEY_GUID('TransformersSymmetricKey'), CONVERT(VARBINARY(MAX), 'laser beammmm')), 
    'Artillery', '2019-01-18');

SELECT * FROM Transformers;

CLOSE SYMMETRIC KEY TransformersSymmetricKey;



--===============See the updated decrypted data===============

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



revert;
--==================================================

EXECUTE AS USER = 'Megatron';
GO

SELECT * FROM Transformers;

DELETE FROM Transformers WHERE Name = 'Mez P5';


revert;
--===================================================


EXECUTE AS USER = 'Optimus';
GO

SELECT * FROM Transformers;

DELETE FROM Transformers WHERE Name = 'Eject';



revert;