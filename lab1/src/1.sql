CREATE TABLE `book` (
  `ID` char(8) NOT NULL,
  `name` varchar(10) NOT NULL,
  `author` varchar(10) DEFAULT NULL,
  `price` float DEFAULT NULL,
  `status` int DEFAULT '0',
  PRIMARY KEY (`ID`)
);

CREATE TABLE `reader` (
  `ID` char(8) NOT NULL,
  `name` varchar(10) DEFAULT NULL,
  `age` int DEFAULT NULL,
  `address` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ID`)
);

CREATE TABLE `borrow` (
  `book_ID` char(8) NOT NULL,
  `Reader_ID` char(8) NOT NULL,
  `Borrow_Date` date DEFAULT NULL,
  `Return_Date` date DEFAULT NULL,
  PRIMARY KEY (`book_ID`,`Reader_ID`),
  KEY `Reader_ID_idx` (`Reader_ID`),
  CONSTRAINT `book_ID` FOREIGN KEY (`book_ID`) REFERENCES `book` (`ID`),
  CONSTRAINT `Reader_ID` FOREIGN KEY (`Reader_ID`) REFERENCES `reader` (`ID`)
);
