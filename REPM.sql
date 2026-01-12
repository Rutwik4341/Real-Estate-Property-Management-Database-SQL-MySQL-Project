-- Create the database for Berealty
CREATE DATABASE Berealty_RealEstate;
USE Berealty_RealEstate;
CREATE TABLE Property (
    Property_ID INT PRIMARY KEY AUTO_INCREMENT,
    Address VARCHAR(255),
    Type ENUM('Residential', 'Commercial'),
    Size INT,
    Status ENUM('Available', 'Sold', 'Rented'),
    Price DECIMAL(10, 2),
    Agent_ID INT,
    FOREIGN KEY (Agent_ID) REFERENCES Agent(Agent_ID)
);
CREATE TABLE Client (
    Client_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255),
    Email VARCHAR(255) UNIQUE,
    Phone VARCHAR(20),
    Address VARCHAR(255)
);
CREATE TABLE Agent (
    Agent_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255),
    Email VARCHAR(255) UNIQUE,
    Phone VARCHAR(20),
    Experience INT,
    Department ENUM('Sales', 'Rentals')
);
CREATE TABLE Transaction (
    Transaction_ID INT PRIMARY KEY AUTO_INCREMENT,
    Property_ID INT,
    Client_ID INT,
    Agent_ID INT,
    Date DATE,
    Amount DECIMAL(10, 2),
    Type ENUM('Sale', 'Rent'),
    Status ENUM('Completed', 'Pending'),
    FOREIGN KEY (Property_ID) REFERENCES Property(Property_ID),
    FOREIGN KEY (Client_ID) REFERENCES Client(Client_ID),
    FOREIGN KEY (Agent_ID) REFERENCES Agent(Agent_ID)
);
INSERT INTO Property (Address, Type, Size, Status, Price, Agent_ID)
VALUES 
('123 Main St', 'Residential', 1200, 'Available', 300000, 1),
('456 Market St', 'Commercial', 5000, 'Available', 1000000, 2),
('789 River Rd', 'Residential', 1500, 'Sold', 450000, 1);
INSERT INTO Client (Name, Email, Phone, Address)
VALUES 
('John Doe', 'john@example.com', '555-1234', '789 Park Ave'),
('Jane Smith', 'jane@example.com', '555-5678', '101 Maple St');
INSERT INTO Agent (Name, Email, Phone, Experience, Department)
VALUES 
('Alice Johnson', 'alice@example.com', '555-9876', 5, 'Sales'),
('Bob Lee', 'bob@example.com', '555-5432', 8, 'Rentals');
INSERT INTO Transaction (Property_ID, Client_ID, Agent_ID, Date, Amount, Type, Status)
VALUES 
(1, 1, 1, '2023-09-01', 300000, 'Sale', 'Completed'),
(2, 2, 2, '2023-09-15', 500000, 'Rent', 'Pending');
SELECT * FROM Property;
SELECT Transaction_ID, Property_ID, Client_ID, Amount, Date
FROM Transaction
WHERE Agent_ID = 1;
SELECT * FROM Property
WHERE Status = 'Available';
SELECT t.Transaction_ID, p.Address, c.Name AS Client, a.Name AS Agent, t.Amount, t.Date
FROM Transaction t
JOIN Property p ON t.Property_ID = p.Property_ID
JOIN Client c ON t.Client_ID = c.Client_ID
JOIN Agent a ON t.Agent_ID = a.Agent_ID;
SELECT MONTH(t.Date) AS Month, COUNT(t.Transaction_ID) AS Transactions, SUM(t.Amount) AS Total_Sales
FROM Transaction t
WHERE t.Status = 'Completed'
GROUP BY MONTH(t.Date);
SELECT Agent_ID, SUM(Amount) AS Total_Sales
FROM Transaction
WHERE Status = 'Completed' AND MONTH(Date) = 9
GROUP BY Agent_ID
ORDER BY Total_Sales DESC
LIMIT 1;
CREATE TRIGGER UpdatePropertyStatus
AFTER UPDATE ON Transaction
FOR EACH ROW
BEGIN
    IF NEW.Status = 'Completed' THEN
        UPDATE Property
        SET Status = 'Sold'
        WHERE Property_ID = NEW.Property_ID
    END IF;
END

