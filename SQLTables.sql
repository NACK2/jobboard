DROP TABLE ApplyTo;
DROP TABLE Interviews;
DROP TABLE Interviewer;
DROP TABLE JobPostingOfferedPosted;
DROP TABLE EmployeeWorksAt;
DROP TABLE SubmitsApplication;
DROP TABLE AdvisedStudentAccesses;
DROP TABLE EmployedCoopAdvisor;
DROP TABLE CoopProgram;
DROP TABLE University;
DROP TABLE JobBoard;
DROP TABLE Location;
DROP TABLE Company;

CREATE TABLE Location(
                         PostalCode CHAR(6) PRIMARY KEY,
                         City VARCHAR(50)
);

CREATE TABLE University(
                           UniversityName VARCHAR(50) UNIQUE,
                           PostalCode CHAR(6),
                           PRIMARY KEY (UniversityName, PostalCode),
                           FOREIGN KEY (PostalCode) REFERENCES Location(PostalCode)
);

CREATE TABLE CoopProgram(
                            DeptName CHAR(20),
                            nStudents INTEGER,
                            UniversityName VARCHAR(50),
                            PostalCode CHAR(6),
                            PRIMARY KEY (DeptName, UniversityName, PostalCode),
                            FOREIGN KEY (UniversityName, PostalCode) REFERENCES University(UniversityName, PostalCode)
);

CREATE TABLE JobBoard(
    BoardTitle VARCHAR(50) PRIMARY KEY
);

CREATE TABLE EmployedCoopAdvisor(
                                    AdvisorID INTEGER PRIMARY KEY,
                                    AdvisorName CHAR(20),
                                    AdvisorEmail CHAR(20) UNIQUE,
                                    DeptName CHAR(20) NOT NULL,
                                    UniversityName VARCHAR(50),
                                    PostalCode CHAR(6),
                                    FOREIGN KEY (DeptName, UniversityName, PostalCode) REFERENCES CoopProgram(DeptName, UniversityName, PostalCode),
                                    FOREIGN KEY (UniversityName, PostalCode) REFERENCES University(UniversityName, PostalCode)
);

CREATE TABLE AdvisedStudentAccesses(
                                       StudentID INTEGER PRIMARY KEY,
                                       Name CHAR(20),
                                       Email CHAR(20) UNIQUE,
                                       Year INTEGER,
                                       nApplications INTEGER,
                                       BoardTitle VARCHAR(50) NOT NULL,
                                       AdvisorID INTEGER NOT NULL,
                                       FOREIGN KEY (BoardTitle) REFERENCES JobBoard(BoardTitle),
                                       FOREIGN KEY (AdvisorID) REFERENCES EmployedCoopAdvisor(AdvisorID)
);

CREATE TABLE SubmitsApplication(
                                   StudentID INTEGER NOT NULL,
                                   ApplicationID INTEGER PRIMARY KEY,
                                   TimeSubmitted TIMESTAMP,
                                   FOREIGN KEY (StudentID) REFERENCES AdvisedStudentAccesses(StudentID)
);

CREATE TABLE Company(
                        CompanyName VARCHAR(50) PRIMARY KEY,
                        Address VARCHAR(50),
                        Website VARCHAR(50)
);

CREATE TABLE EmployeeWorksAt(
                                CompanyName VARCHAR(50),
                                EmployeeID INTEGER,
                                EmployeeName VARCHAR(50),
                                PRIMARY KEY (CompanyName, EmployeeID),
                                FOREIGN KEY (CompanyName) REFERENCES Company(CompanyName)
);

CREATE TABLE JobPostingOfferedPosted(
                                        PostingID INTEGER PRIMARY KEY,
                                        TimePosted TIMESTAMP,
                                        Deadline TIMESTAMP,
                                        Duration INTEGER,
                                        Position VARCHAR(50),
                                        CompanyName VARCHAR(50) NOT NULL,
                                        BoardTitle VARCHAR(50),
                                        FOREIGN KEY (CompanyName) REFERENCES Company(CompanyName),
                                        FOREIGN KEY (BoardTitle) REFERENCES JobBoard(BoardTitle)
);

CREATE TABLE ApplyTo(
                        StudentID INTEGER,
                        PostingID INTEGER,
                        PRIMARY KEY (StudentID, PostingID),
                        FOREIGN KEY (StudentID) REFERENCES AdvisedStudentAccesses(StudentID),
                        FOREIGN KEY (PostingID) REFERENCES JobPostingOfferedPosted(PostingID)
);

CREATE TABLE Interviewer(
                            CompanyName VARCHAR(50),
                            EmployeeID INTEGER,
                            Status VARCHAR(50),
                            PRIMARY KEY (CompanyName, EmployeeID),
                            FOREIGN KEY (CompanyName) REFERENCES Company(CompanyName),
                            FOREIGN KEY (CompanyName, EmployeeID) REFERENCES EmployeeWorksAt(CompanyName, EmployeeID)
);

CREATE TABLE Interviews(
                           CompanyName VARCHAR(50),
                           EmployeeID INTEGER,
                           StudentID INTEGER,
                           InterviewDate DATE,
                           PRIMARY KEY (CompanyName, EmployeeID, StudentID),
                           FOREIGN KEY (CompanyName) REFERENCES  Company(CompanyName),
                           FOREIGN KEY (CompanyName, EmployeeID) REFERENCES EmployeeWorksAt(CompanyName, EmployeeID),
                           FOREIGN KEY (StudentID) REFERENCES AdvisedStudentAccesses(StudentID)
);

INSERT INTO Location(PostalCode, City) VALUES ('123456', 'Vancouver');
INSERT INTO Location(PostalCode, City) VALUES ('654321', 'Waterloo');
INSERT INTO Location(PostalCode, City) VALUES ('987654', 'Burnaby');
INSERT INTO Location(PostalCode, City) VALUES ('abcdef', 'London');
INSERT INTO Location(PostalCode, City) VALUES ('uvwxyz', 'Toronto');

INSERT INTO University(UniversityName, PostalCode) VALUES ('UBC', '123456');
INSERT INTO University(UniversityName, PostalCode) VALUES ('Waterloo', '654321');
INSERT INTO University(UniversityName, PostalCode) VALUES ('SFU', '987654');
INSERT INTO University(UniversityName, PostalCode) VALUES ('Western', 'abcdef');
INSERT INTO University(UniversityName, PostalCode) VALUES ('UofT', 'uvwxyz');

INSERT INTO CoopProgram(DeptName, nStudents, UniversityName, PostalCode) VALUES ('Dept 1', 700, 'UBC', '123456');
INSERT INTO CoopProgram(DeptName, nStudents, UniversityName, PostalCode) VALUES ('Dept 2', 500, 'Waterloo', '654321');
INSERT INTO CoopProgram(DeptName, nStudents, UniversityName, PostalCode) VALUES ('Dept 3', 550, 'SFU', '987654');
INSERT INTO CoopProgram(DeptName, nStudents, UniversityName, PostalCode) VALUES ('Dept 4', 200, 'Western', 'abcdef');
INSERT INTO CoopProgram(DeptName, nStudents, UniversityName, PostalCode) VALUES ('Dept 5', 300, 'UofT', 'uvwxyz');

INSERT INTO JobBoard(BoardTitle) VALUES ('Board 1');
INSERT INTO JobBoard(BoardTitle) VALUES ('Board 2');
INSERT INTO JobBoard(BoardTitle) VALUES ('Board 3');
INSERT INTO JobBoard(BoardTitle) VALUES ('Board 4');
INSERT INTO JobBoard(BoardTitle) VALUES ('Board 5');

INSERT INTO EmployedCoopAdvisor(AdvisorID, AdvisorName, AdvisorEmail, DeptName, UniversityName, PostalCode)
VALUES (1, 'Advisor 1', 'advisor1@ubc.ca', 'Dept 1', 'UBC', '123456');
INSERT INTO EmployedCoopAdvisor(AdvisorID, AdvisorName, AdvisorEmail, DeptName, UniversityName, PostalCode)
VALUES (2, 'Advisor 2', 'advisor2@waterloo.ca', 'Dept 2', 'Waterloo', '654321');
INSERT INTO EmployedCoopAdvisor(AdvisorID, AdvisorName, AdvisorEmail, DeptName, UniversityName, PostalCode)
VALUES (3, 'Advisor 3', 'advisor3@sfu.ca', 'Dept 3', 'SFU', '987654');
INSERT INTO EmployedCoopAdvisor(AdvisorID, AdvisorName, AdvisorEmail, DeptName, UniversityName, PostalCode)
VALUES (4, 'Advisor 4', 'advisor4@western.ca', 'Dept 4', 'Western', 'abcdef');
INSERT INTO EmployedCoopAdvisor(AdvisorID, AdvisorName, AdvisorEmail, DeptName, UniversityName, PostalCode)
VALUES (5, 'Advisor 5', 'advisor5@uoft.ca', 'Dept 5', 'UofT', 'uvwxyz');

INSERT INTO AdvisedStudentAccesses(StudentID, Name, Email, Year, nApplications, BoardTitle, AdvisorID)
VALUES (1, 'Student 1', 'student1@ubc.ca', 3, 10, 'Board 1', 1);
INSERT INTO AdvisedStudentAccesses(StudentID, Name, Email, Year, nApplications, BoardTitle, AdvisorID)
VALUES (2, 'Student 2', 'student2@waterloo.ca', 2, 15, 'Board 1', 2);
INSERT INTO AdvisedStudentAccesses(StudentID, Name, Email, Year, nApplications, BoardTitle, AdvisorID)
VALUES (3, 'Student 3', 'student3@sfu.ca', 3, 12, 'Board 1', 3);
INSERT INTO AdvisedStudentAccesses(StudentID, Name, Email, Year, nApplications, BoardTitle, AdvisorID)
VALUES (4, 'Student 4', 'student4@western.ca', 4, 20, 'Board 2', 4);
INSERT INTO AdvisedStudentAccesses(StudentID, Name, Email, Year, nApplications, BoardTitle, AdvisorID)
VALUES (5, 'Student 5', 'student5@uoft.ca', 2, 1, 'Board 2', 5);

INSERT INTO SubmitsApplication(StudentID, ApplicationID, TimeSubmitted) VALUES (1, 101, TO_TIMESTAMP('2023-10-20 09:30:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO SubmitsApplication(StudentID, ApplicationID, TimeSubmitted) VALUES (2, 102, TO_TIMESTAMP('2023-10-20 09:30:01', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO SubmitsApplication(StudentID, ApplicationID, TimeSubmitted) VALUES (3, 103, TO_TIMESTAMP('2023-10-20 09:30:02', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO SubmitsApplication(StudentID, ApplicationID, TimeSubmitted) VALUES (4, 104, TO_TIMESTAMP('2023-10-20 09:30:03', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO SubmitsApplication(StudentID, ApplicationID, TimeSubmitted) VALUES (5, 105, TO_TIMESTAMP('2023-10-20 09:30:04', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Company(CompanyName, Address, Website) VALUES ('Company 1', 'Address 1', 'www.company1.com');
INSERT INTO Company(CompanyName, Address, Website) VALUES ('Company 2', 'Address 2', 'www.company2.com');
INSERT INTO Company(CompanyName, Address, Website) VALUES ('Company 3', 'Address 3', 'www.company3.com');
INSERT INTO Company(CompanyName, Address, Website) VALUES ('Company 4', 'Address 4', 'www.company4.com');
INSERT INTO Company(CompanyName, Address, Website) VALUES ('Company 5', 'Address 5', 'www.company5.com');

INSERT INTO EmployeeWorksAt(CompanyName, EmployeeID, EmployeeName) VALUES ('Company 1', 201, 'Employee 1');
INSERT INTO EmployeeWorksAt(CompanyName, EmployeeID, EmployeeName) VALUES ('Company 2', 202, 'Employee 2');
INSERT INTO EmployeeWorksAt(CompanyName, EmployeeID, EmployeeName) VALUES ('Company 3', 203, 'Employee 3');
INSERT INTO EmployeeWorksAt(CompanyName, EmployeeID, EmployeeName) VALUES ('Company 4', 204, 'Employee 4');
INSERT INTO EmployeeWorksAt(CompanyName, EmployeeID, EmployeeName) VALUES ('Company 5', 205, 'Employee 5');

INSERT INTO JobPostingOfferedPosted(PostingID, TimePosted, Deadline, Duration, Position, CompanyName, BoardTitle)
VALUES (6, TO_TIMESTAMP('2023-10-19 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-10-20 23:59:00', 'YYYY-MM-DD HH24:MI:SS'), 4, 'Researcher', 'Company 1', 'Board 1');
INSERT INTO JobPostingOfferedPosted(PostingID, TimePosted, Deadline, Duration, Position, CompanyName, BoardTitle)
VALUES (7, TO_TIMESTAMP('2023-10-19 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-10-20 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 4, 'QA Tester', 'Company 2', 'Board 2');
INSERT INTO JobPostingOfferedPosted(PostingID, TimePosted, Deadline, Duration, Position, CompanyName, BoardTitle)
VALUES (8, TO_TIMESTAMP('2023-10-19 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-10-20 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 4, 'IT Specialist', 'Company 3', 'Board 3');
INSERT INTO JobPostingOfferedPosted(PostingID, TimePosted, Deadline, Duration, Position, CompanyName, BoardTitle)
VALUES (9, TO_TIMESTAMP('2023-10-19 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-10-20 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 4, 'Data Analyst', 'Company 4', 'Board 4');
INSERT INTO JobPostingOfferedPosted(PostingID, TimePosted, Deadline, Duration, Position, CompanyName, BoardTitle)
VALUES (10, TO_TIMESTAMP('2023-10-19 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-10-20 23:59:00', 'YYYY-MM-DD HH24:MI:SS'), 4, 'Software Engineer', 'Company 5', 'Board 5');

INSERT INTO ApplyTo(StudentID, PostingID) VALUES (1, 6);
INSERT INTO ApplyTo(StudentID, PostingID) VALUES (2, 7);
INSERT INTO ApplyTo(StudentID, PostingID) VALUES (3, 8);
INSERT INTO ApplyTo(StudentID, PostingID) VALUES (4, 9);
INSERT INTO ApplyTo(StudentID, PostingID) VALUES (5, 10);

INSERT INTO Interviewer(CompanyName, EmployeeID, Status) VALUES ('Company 1', 201, 'Interviewing');
INSERT INTO Interviewer(CompanyName, EmployeeID, Status) VALUES ('Company 2', 202, 'Interviewing');
INSERT INTO Interviewer(CompanyName, EmployeeID, Status) VALUES ('Company 3', 203, 'Not Interviewing');
INSERT INTO Interviewer(CompanyName, EmployeeID, Status) VALUES ('Company 4', 204, 'Not Interviewing');
INSERT INTO Interviewer(CompanyName, EmployeeID, Status) VALUES ('Company 5', 205, 'Not Interviewing');

INSERT INTO Interviews(CompanyName, EmployeeID, StudentID, InterviewDate) VALUES ('Company 1', 201, 1, TO_DATE('2023-10-22', 'YYYY-MM-DD'));
INSERT INTO Interviews(CompanyName, EmployeeID, StudentID, InterviewDate) VALUES ('Company 2', 202, 2, TO_DATE('2023-10-22', 'YYYY-MM-DD'));
INSERT INTO Interviews(CompanyName, EmployeeID, StudentID, InterviewDate) VALUES ('Company 3', 203, 3, TO_DATE('2023-10-22', 'YYYY-MM-DD'));
INSERT INTO Interviews(CompanyName, EmployeeID, StudentID, InterviewDate) VALUES ('Company 4', 204, 4, TO_DATE('2023-10-22', 'YYYY-MM-DD'));
INSERT INTO Interviews(CompanyName, EmployeeID, StudentID, InterviewDate) VALUES ('Company 5', 205, 5, TO_DATE('2023-10-22', 'YYYY-MM-DD'));

COMMIT;