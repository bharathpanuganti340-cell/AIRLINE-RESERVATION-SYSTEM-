---PROJECT AIRLINES RESERVATION SYSTEM

-----CREATING A DATABASE 
CREATE DATABASE Airlines

USE Airlines

----CREATING FLIGHTS TABLE
CREATE TABLE Flights
(
   FlightID INT PRIMARY KEY IDENTITY(1,1),
   FlightNumber VARCHAR(10) NOT NULL UNIQUE,
   Origin VARCHAR(50) NOT NULL,
   Destination VARCHAR(50) NOT NULL,
   DepatureTime DATETIME NOT NULL,
   ArrivalTime DATETIME NOT NULL,
   TotalSeats INT NOT NULL
)

-----CREATING CUSTOMERS TABLE
CREATE TABLE Customers
(
   CustomerID INT PRIMARY KEY IDENTITY(1,1),
   FullName VARCHAR(100) NOT NULL,
   Email VARCHAR(100) UNIQUE,
   MobileNumber VARCHAR(15),
)

----CREATING BOOKINGS TABLE
CREATE TABLE Bookings
(
   BookingID INT PRIMARY KEY IDENTITY(1,1),
   CustomerID INT,
   FlightID INT,
   BookingDate DATETIME DEFAULT GETDATE(),
   BookingStatus VARCHAR(20) CHECK (BookingStatus IN ('BOOKED','CANCELLED')) DEFAULT 'BOOKED'
   FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
   FOREIGN KEY (FlightID) REFERENCES Flights(FlightID)
)

-----CREATING SEATS TABLE
CREATE TABLE Seats
(
    SeatID INT PRIMARY KEY IDENTITY(1,1),
	FlightID INT FOREIGN KEY REFERENCES Flights(FlightID),
	SeatNumber VARCHAR(5) NOT NULL,
	ISBooked BIT DEFAULT 0,
	BookingID INT NULL FOREIGN KEY REFERENCES Bookings(BookingID)
)
-----TO VIEW THE TABLES WE CREATED
SELECT*FROM Flights
SELECT*FROM Customers
SELECT*FROM Seats
SELECT*FROM Bookings

-----INSERTING THE DATA INTO TABLES-----

----INSERT DATA INTO FLIGHTS TABLE
INSERT INTO Flights
	(FlightNumber,Origin,Destination,DepatureTime,ArrivalTime,TotalSeats)
VALUES
	('A1O1','Delhi','Mumbai','2025-08-22 10:00','2025-08-22 12:05',5),
	('A102','Banglore','Hyderabad','2025-08-21 7:10','2025-08-21 10:30',4),
	('B1O1','Vizag','Chennai','2025-08-18 9:00','2025-08-18 12:05',3),
	('B102','Banglore','Hyderabad','2025-08-25 7:30','2025-08-27 11:30',2)

-----INSERT DATA INTO CUSTOMERS TABLE
INSERT INTO Customers
	(FullName,Email,MobileNumber)
VALUES
	('Joe Root','joeroot@example.com','5272517'),
	('Jane Smith','janesmith@example.com','7637622'),
	('David Warner','davidwarnar@example.com','4246272'),
	('jofra Arcer','jofraarcher@example.com','5364711')

-----INSERT DATA INTO SEATS TABLE
INSERT INTO Seats
	(FlightID,SeatNumber)
VALUES
	(1,'1A'),(1,'1B'),(1,'1C'),(1,'1D'),(1,'1E'),
	(2,'2A'),(2,'2B'),(2,'2C'),(2,'2D'),
	(3,'3A'),(3,'3B'),(3,'3C'),
	(4,'4A'),(4,'4B')

----BOOKED SEATS WITH FLIGHTNUMBERS
	SELECT s.SeatNumber,
	f.Flightnumber
FROM Seats s Join flights f ON s.FlightID=f.FlightID
WHERE  IsBooked = 0;

----TRIGGER:- After Insert Booking --Mark seat as booked
CREATE TRIGGER trg_Bookset
ON Bookings
AFTER Insert
AS 
BEGIN
     UPDATE Seats
	 SET IsBooked =1,
	 BookingID=i.BookingID
	 FROM Inserted i
WHERE Seats.FlightID=i.FlightID AND Seats.IsBooked=0
AND Seats.BookingID is NULL
AND SeatID=(
         SELECT MIN(SeatID)
		 FROM	Seats
		WHERE FlightID=i.FlightID AND IsBooked=0
)
END

----TRIGGER ON BOOKING CANCEL --UNBOOK THE SEAT
CREATE TRIGGER trg_CancelBooking
ON Bookings
AFTER UPDATE
AS 
BEGIN
     UPDATE Seats
	 SET IsBooked =0,
	 BookingID = NULL
	 FROM Seats S
INNER JOIN inserted i ON S.BookingID=i.BookingID
WHERE i.BookingStatus ='Cancelled'
END

----SELECTING THE SEATS WHICH ARE AVAILABLE 
SELECT SeatNumber
FROM Seats
WHERE FlightID = 3 AND IsBooked = 0;

----BOOKING SUMMARY REPORT
SELECT
	  b.BookingID,
	  c.FullName,
	  f.FlightNumber,
	  f.origin,
	  f.Destination,
	  f.DepatureTime,
	  s.SeatNumber,
	  b.BookingStatus,
	  B.BookingDate
FROM Bookings b
JOIN Customers c ON b.CustomerID=c.CustomerID
JOIN Flights f ON b.FlightID = f.FlightID
LEFT JOIN Seats s ON s.BookingID=b.BookingID

-----CUSTOMER SUMMARY
SELECT
	  c.FullName,
	  b.BookingID,
	  s.SeatNumber
	  FROM Customers c
JOIN bookings b ON  c.CustomerID =b.CustomerID
LEFT JOIN Seats s ON b.BookingID=s.BookingID

-----CREATE A VIEW FOR AVAILABLE FLIGHTS
CREATE VIEW AvailableSeatsView AS
SELECT 
    f.FlightID,
    f.FlightNumber,
    f.Origin,
    f.Destination,
    COUNT(s.SeatID) AS AvailableSeats
FROM Flights f
JOIN Seats s ON f.FlightID = s.FlightID
WHERE s.IsBooked = 0
GROUP BY f.FlightID, f.FlightNumber, f.Origin, f.Destination

SELECT*FROM  AvailableSeatsView 






