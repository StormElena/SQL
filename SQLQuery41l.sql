SELECT  Contracts.Id AS Contract_Id, Contracts.DateFrom, Contracts.DateTo, 
Accounts.Id AS Account_Id,Accounts.Contract_Id, Accounts.DateTimeFrom, Accounts.DateTimeTo 
FROM Contracts JOIN Accounts ON Contracts.Id = Accounts.Contract_Id 
WHERE Contracts.DateTo < CONVERT(date, Accounts.DateTimeTo) 
OR (Contracts.DateTo IS NOT NULL AND Accounts.DateTimeTo IS NULL) 
OR Contracts.DateFrom > CONVERT(date, Accounts.DateTimeFrom)


