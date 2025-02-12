-- Drop the existing database if it exists
DROP DATABASE IF EXISTS storeDB;

-- Create the database
CREATE DATABASE IF NOT EXISTS storeDB;
USE storeDB;

-- Drop tables if they exist
DROP TABLE IF EXISTS `api_keys`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `calendars`;
DROP TABLE IF EXISTS `events`;

CREATE TABLE IF NOT EXISTS `storeDB`.`api_keys` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `api_key` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
);

CREATE TABLE IF NOT EXISTS `storeDB`.`users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `google_id` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `google_id` (`google_id`),
  UNIQUE KEY `email` (`email`)
);

INSERT INTO `storeDB`.`users` (`google_id`, `email`, `name`) VALUES ('superuser_id', 'superuser@example.com', 'Super User');

CREATE TABLE IF NOT EXISTS `storeDB`.`calendars` (
  `id` int NOT NULL AUTO_INCREMENT,
  `userId` int NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `userId` (`userId`),
  CONSTRAINT `calendars_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `storeDB`.`users` (`id`)
);

INSERT INTO `storeDB`.`calendars` (`userId`, `name`) VALUES (1, 'Super User Calendar');
INSERT INTO `storeDB`.`api_keys` (`username`, `password`, `api_key`) VALUES ('luis', 'luis', '7d4d3351-64b9-4d0a-918c-419828a941d3');

CREATE TABLE IF NOT EXISTS `storeDB`.`events` (
  `id` CHAR(36) NOT NULL,
  `calendarId` int DEFAULT NULL,
  `summary` varchar(255) NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `description` text,
  `startDateTime` datetime NOT NULL,
  `endDateTime` datetime NOT NULL,
  `timeZone` varchar(50) DEFAULT NULL,
  `obs` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `calendarId` (`calendarId`),
  CONSTRAINT `events_ibfk_1` FOREIGN KEY (`calendarId`) REFERENCES `storeDB`.`calendars` (`id`)
);

-- Remover a primary key da tabela events
ALTER TABLE `storeDB`.`events`
DROP PRIMARY KEY;

-- INSERT INTO `storeDB`.`events` (`id`, `calendarId`, `summary`, `location`, `description`, `startDateTime`, `endDateTime`) VALUES ('cac80a76-72a5-4845-a630-10fabe049caa', 1, 'Sporting vs Porto', 'Rua Professor Fernando da Fonseca, 1501-806 Lisboa, Portugal', 'The game that will decide the league.', '2024-05-11 19:45:00', '2024-05-11 21:45:00');
-- INSERT INTO `storeDB`.`events` (`id`, `calendarId`, `summary`, `location`, `description`, `startDateTime`, `endDateTime`) VALUES ('5034bfc8-e761-4426-9fa4-c1a276bf163f', 1, 'Sporting vs Real Madrid', 'Rua Professor Fernando da Fonseca, 1501-806 Lisboa, Portugal', 'The portuguese champions and the spanish champions. Who will win and be crowned european champions?', '2024-06-01 20:00:00', '2024-06-01 22:00:00');
-- INSERT INTO `storeDB`.`events` (`id`, `calendarId`, `summary`, `location`, `description`, `startDateTime`, `endDateTime`) VALUES ('4c6ce530-c1f2-424f-a261-2fabaf533679', 1, 'Benfica vs Rio Ave', 'Avenida Eusebio da Silva Ferreira, 1500-313 Lisboa, Portugal', 'The final game of the season. Can Benfica get the 3 points?', '2024-05-17 18:00:00', '2024-05-17 20:00:00');
-- INSERT INTO `storeDB`.`events` (`id`, `calendarId`, `summary`, `location`, `description`, `startDateTime`, `endDateTime`) VALUES ('41378065-359b-42f3-84e5-8b29dc20c532', 1, 'World Animal Day', 'Praça Marechal Humberto Delgado, 1549-004 Lisboa, Portugal', 'Discover the girafes and elephants from Africa savannah and enjoy the majestic flights of the colorful birds of South America.', '2024-05-17 10:00:00', '2024-05-17 18:00:00');
-- INSERT INTO `storeDB`.`events` (`id`, `calendarId`, `summary`, `location`, `description`, `startDateTime`, `endDateTime`) VALUES ('21cd4b9a-8ef0-4824-9038-88eb038ae16d', 1, 'Portrait of Philip IV by Diego Velazquez', 'Avenida de Berna 45A, 1067-001 Lisboa, Portugal', 'Learn about the history of this painting, and discover the unexpected dialogues it developed with the other great masters of its time.', '2024-05-22 09:00:00', '2024-05-22 19:00:00');
-- INSERT INTO `storeDB`.`events` (`id`, `calendarId`, `summary`, `location`, `description`, `startDateTime`, `endDateTime`) VALUES ('8a53079e-8093-4022-8e76-10543e42c03e', 1, 'Cirque Du Soleil Corteo', 'Rossio dos Olivais, 1990-231 Lisboa, Portugal', 'This show brings together the passion of the actor with the grace and power of the acrobat to immerse the audience in a theatrical world of fun, comedy and spontaneity set in a mysterious space between heaven and earth.', '2024-06-05 14:30:00', '2024-06-05 17:30:00');
-- INSERT INTO `events` (`id`, `calendarId`, `summary`, `location`, `description`, `startDateTime`, `endDateTime`) VALUES 
-- ('cac80a76-72a5-4845-a630-10fabe049caa', 1, 'Sporting vs Porto', 'Rua Professor Fernando da Fonseca, 1501-806 Lisboa, Portugal', 'The game that will decide the league.', '2024-05-11 19:45:00', '2024-05-11 21:45:00'),
-- ('5034bfc8-e761-4426-9fa4-c1a276bf163f', 1, 'Sporting vs Real Madrid', 'Rua Professor Fernando da Fonseca, 1501-806 Lisboa, Portugal', 'The portuguese champions and the spanish champions. Who will win and be crowned european champions?', '2024-06-01 20:00:00', '2024-06-01 22:00:00'),
-- ('4c6ce530-c1f2-424f-a261-2fabaf533679', 1, 'Benfica vs Rio Ave', 'Avenida Eusebio da Silva Ferreira, 1500-313 Lisboa, Portugal', 'The final game of the season. Can Benfica get the 3 points?', '2024-05-17 18:00:00', '2024-05-17 20:00:00'),
-- ('41378065-359b-42f3-84e5-8b29dc20c532', 1, 'World Animal Day', 'Praça Marechal Humberto Delgado, 1549-004 Lisboa, Portugal', 'Discover the girafes and elephants from Africa savannah and enjoy the majestic flights of the colorful birds of South America.', '2024-05-17 10:00:00', '2024-05-17 18:00:00'),
-- ('21cd4b9a-8ef0-4824-9038-88eb038ae16d', 1, 'Portrait of Philip IV by Diego Velazquez', 'Avenida de Berna 45A, 1067-001 Lisboa, Portugal', 'Learn about the history of this painting, and discover the unexpected dialogues it developed with the other great masters of its time.', '2024-05-22 09:00:00', '2024-05-22 19:00:00'),
-- ('8a53079e-8093-4022-8e76-10543e42c03e', 1, 'Cirque Du Soleil Corteo', 'Rossio dos Olivais, 1990-231 Lisboa, Portugal', 'This show brings together the passion of the actor with the grace and power of the acrobat to immerse the audience in a theatrical world of fun, comedy and spontaneity set in a mysterious space between heaven and earth.', '2024-06-05 14:30:00', '2024-06-05 17:30:00');