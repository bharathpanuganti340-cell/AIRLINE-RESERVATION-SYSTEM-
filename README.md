AIRLINE RESERVATION SYSTEM
A full featured Airline Reservation System that allow users to search book, manage, cancel flight tickets. Designed for both customers and admins the system
provides a stermlined interface for booking and managing flights using the sql database

ER DIAGRAM;
Customers --< Bookings >-- Flights
                    |
                  Seats
                  
THE DATABASE SETUP
EXAMPLE:-CREATE TABLE Flights (
    FlightID INT PRIMARY KEY IDENTITY(1,1),
    FlightNumber VARCHAR(10) NOT NULL UNIQUE,
    Origin VARCHAR(50) NOT NULL,
    Destination VARCHAR(50) NOT NULL,
    DepartureTime DATETIME NOT NULL,
    ArrivalTime DATETIME NOT NULL,
    TotalSeats INT NOT NULL
);

FEATURES:-
*View the available flights
*Booking the seats
*Cancelling the tickets
*View available seats
*Flight timings
*search flights by destination
*Date and time of each flight

PROJECT STRUCTURE:-
AirlineReservationSystem/
├── airline_schema.sql
├── sample_data.sql
├── triggers.sql
├── views.sql
├── queries.sql
