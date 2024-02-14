USE ReservaVoos;

CREATE TABLE Airport(
	Airport_name VARCHAR(20)	not null,
	Airport_city VARCHAR(20)	not null,
	Airport_state VARCHAR(30)	not null,
	Airport_code CHAR(3)	not null,

	PRIMARY KEY(Airport_Code)
);

CREATE TABLE Airplane_Type(
	Type__name VARCHAR(30)	not null,
	Company VARCHAR(15)		not null,
	Max_seats INT			not null,

	PRIMARY KEY(Type__name)
);

CREATE TABLE Can_Land(
	FK_Airport_code CHAR(3)		not null,
	FK_Type__name VARCHAR(30)	not null,

	PRIMARY KEY(FK_Airport_code, FK_Type__name),
	FOREIGN KEY(FK_Airport_code) REFERENCES Airport(Airport_code),
	FOREIGN KEY(FK_Type__name) REFERENCES Airplane_type(Type__name)
);

CREATE TABLE Airplane(
	FK_Type_name VARCHAR(30)	not null,
	Total_no_of_seats INT		not null,
	Airplane_id INT				not null,

	FOREIGN KEY(FK_Type_name) REFERENCES Airplane_Type(Type__name),
	PRIMARY KEY(Airplane_id)
);

CREATE TABLE Flight(
	Flight_number INT			not null,
	Flight_airline VARCHAR(15)	not null,
	Weekdays VARCHAR(9)			not null,

	PRIMARY KEY(Flight_number)
);

CREATE TABLE Flight_Leg(
	Leg_no INT	not null,
	FK_Flight_number INT not null,
	FK_airport_code_departure CHAR(3) not null,
	FK_airport_code_arrival CHAR(3) not null,
	Scheduled_departure_time TIME not null,		
	Scheduled_arrival_time TIME not null,

	PRIMARY KEY(Leg_no, FK_Flight_number),
	FOREIGN KEY(FK_airport_code_departure) REFERENCES Airport(Airport_code),
	FOREIGN KEY(FK_airport_code_arrival) REFERENCES Airport(Airport_code),
	FOREIGN KEY(FK_Flight_number) REFERENCES Flight(Flight_number)
);

CREATE TABLE Fare(
	Fare_code VARCHAR(10)	not null,
	FK_Flight_number INT	not null,
	Restrictions VARCHAR(40)	not null,
	Amount INT	DEFAULT 0	not null,

	PRIMARY KEY(Fare_code, FK_Flight_number),
	FOREIGN KEY(FK_Flight_number) REFERENCES Flight(Flight_number)
);

CREATE TABLE Leg_Instance(
	Leg_date DATE	not null,
	FK_Leg_no INT	not null,
	FK_Flight_number INT	not null,
	No_available_seats	INT	not null,
	FK_airport_code_departure CHAR(3) not null,
	FK_airport_code_arrival CHAR(3) not null,
	Departure_time TIME	not null,
	Arrival_time TIME not null,
	FK_airplane INT not null,

	PRIMARY KEY(Leg_date, FK_Leg_no, FK_Flight_number),
	FOREIGN KEY(FK_Leg_no,FK_Flight_number) REFERENCES Flight_Leg(Leg_no,FK_Flight_number),
	FOREIGN KEY(FK_airport_code_departure) REFERENCES Airport(Airport_code),
	FOREIGN KEY(FK_airport_code_arrival) REFERENCES Airport(Airport_code),
	FOREIGN KEY(FK_airplane) REFERENCES Airplane(Airplane_id)
);

CREATE TABLE Seat(
	Seat_no	INT not null,
	FK_Leg_date	DATE not null,
	FK_Leg_no INT	not null,
	FK_Flight_number INT	not null,
	Customer_name VARCHAR(30)	not null,
	Cphone INT,

	PRIMARY KEY(Seat_no, FK_Leg_date, FK_Leg_no, FK_Flight_number),
	FOREIGN KEY(FK_Leg_date, FK_Leg_no, FK_Flight_number) REFERENCES Leg_instance(Leg_date, FK_Leg_no, FK_Flight_number)
);
























