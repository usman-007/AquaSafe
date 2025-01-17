DROP schema if exists AquaSafe;
CREATE schema AquaSafe;
USE AquaSafe;

CREATE TABLE `WaterParameters` (
  `Name` VARCHAR (50) not null,
  `Description` VARCHAR (1500),
  PRIMARY KEY (`Name`)
);

CREATE TABLE `ParameterUnits` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ParameterName` varchar(50) NOT NULL,
  `Unit` varchar(20) NOT NULL,
  `Min` float DEFAULT NULL,
  `Max` float DEFAULT NULL,
  PRIMARY KEY (`Id`),
  FOREIGN KEY (`ParameterName`) REFERENCES `WaterParameters` (`Name`)
);

CREATE TABLE `Users` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR (20) NOT NULL, 
  `LastName` VARCHAR (20) NOT NULL,
  `Email` VARCHAR (50) NOT NULL,
  `Password` VARCHAR(100) NOT NULL,
   PRIMARY KEY (`Id`)
);

CREATE TABLE `Projects` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR (20),
  `Location` VARCHAR (50),
  `Country` VARCHAR (20),
  `Longitude` Float,
  `Latitude` Float,
  `Description` VARCHAR (500),
  PRIMARY KEY (`Id`)
);

CREATE TABLE `WorksOn` (
  `user` INT NOT NULL,
  `project` INT NOT NULL,  
  `Designation` Enum ('IoT Engineer', 'Local Admin', 'Government Admin') NOT NULL,
  PRIMARY KEY (`user`,`project`),
  FOREIGN KEY (`user`) REFERENCES `Users`(`Id`),
  FOREIGN KEY (`project`) REFERENCES `Projects`(`Id`)
);

CREATE TABLE `Communication` (
  `Id` INT NOT NULL,
  `Type` Enum ('LORAWAN', 'GSM'),
  `Channel/Frequency` Float,
  `Model` VARCHAR (20),
  `Transmitter/recieverID` VARCHAR (20),
  PRIMARY KEY (`Id`)
);

CREATE TABLE `DeployedDevices` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR (20),
  `Longitude` Float,
  `Latitude` Float,
  `Frequency` VARCHAR (20),
  `Project` INT NOT NULL,
  `Locality` VARCHAR (50),
  `CommTech` Enum ('LORAWAN', 'GSM'),
  `StatusCode` Int,
  `Sensors` JSON,
  PRIMARY KEY (`Id`),
  FOREIGN KEY (`Project`) REFERENCES `Projects`(`Id`)
);

CREATE TABLE `Readings` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Time` Date,
  `Reading` VARCHAR (20),
  `Device` INT NOT NULL,
  `Parameter` VARCHAR (50) NOT NULL,
  `UnitId` int NOT NULL,
  PRIMARY KEY (`Id`),
  FOREIGN KEY (`Device`) REFERENCES `DeployedDevices`(`Id`),
  FOREIGN KEY (`Parameter`) REFERENCES `WaterParameters`(`Name`),
  FOREIGN KEY (`UnitId`) REFERENCES `ParameterUnits` (`Id`)
);

CREATE TABLE `Notifications` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Priority` Enum ('high', 'low', 'normal'),
  `Location` VARCHAR (100),
  `Description` VARCHAR (500),
  `Device` INT NOT NULL,
  `Reading` INT NOT NULL,
  `Time` Date,
  `User` INT NOT NULL,
  `IsViewed` BOOLEAN DEFAULT FALSE,
  PRIMARY KEY (`Id`),
  FOREIGN KEY (`Reading`) REFERENCES `Readings`(`Id`),
  FOREIGN KEY (`Device`) REFERENCES `DeployedDevices`(`Id`),
  FOREIGN KEY (`User`) REFERENCES `Users`(`Id`)
);

CREATE TABLE `Action` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Type` Enum ('TBD'),  -- This has to be changed, once actions are finalized
  `Description` VARCHAR (20),
  `Notification` INT NOT NULL,
  `User` INT NOT NULL,
  `Time` Date,
  PRIMARY KEY (`Id`),
  FOREIGN KEY (`Notification`) REFERENCES `Notifications`(`User`)
);

CREATE TABLE `Predictions` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Time` Date,
  `Reading` VARCHAR (20),
  `Parameter` VARCHAR (20) not null,
  PRIMARY KEY (`Id`),
  FOREIGN KEY (`Parameter`) REFERENCES `WaterParameters`(`Name`)
);

CREATE TABLE `Reports` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Device` INT NOT NULL,
  `Description` VARCHAR (20),
  `Time` Date,
  PRIMARY KEY (`Id`),
  FOREIGN KEY (`Device`) REFERENCES `DeployedDevices`(`Id`)
);

CREATE TABLE Subscriptions (
    Id INT AUTO_INCREMENT,
    UserId INT NOT NULL,
    Subscription TEXT NOT NULL,
    FOREIGN KEY (UserId) REFERENCES Users(Id),
    PRIMARY KEY (Id)
);

-- ----------------------------------------------