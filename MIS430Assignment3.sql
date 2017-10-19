exec WipeDatabase

-- Part 1, step 1
create table Woods
(
Wood varchar(50) not null,
WoodType varchar(50)
)

create table Dates
(
ActualDate Date not null,
Season varchar(50)
)

create table Spells
(
SpellName varchar(50) not null,
Category varchar(50),
Description varchar(200)
)

create table Locations
(
LocationName varchar(50) not null,
Section varchar(50),
Floor int
)

create table Wizards
(
FirstName varchar(50) not null,
LastName varchar(50) not null,
WizardBorn bit,
Age int,
FatherFirstName varchar(50),
FatherLastName varchar(50),
MotherFirstName varchar(50),
MotherLastName varchar(50),
House varchar(50),
HouseWizardId int
)

create table Sales
(
FirstName varchar(50) not null,
LastName varchar(50) not null,
Core varchar(50) not null,
Length float not null,
OrderDate date not null,
Wood varchar(50) not null,
DeliveryDate date,
Quantity int,
Price float,
PaymentType varchar(50)
)

create table Wands
(
Wood varchar(50) not null,
Length float not null,
Core varchar(50) not null
)

create table SpellCasts
(
CastDate date not null,
Wood varchar(50) not null,
Length float not null,
Core varchar(50) not null,
LocationName varchar(50) not null,
SpellName varchar(50) not null,
Frequency Int not null
)

-- Part 1, step 2

alter table Woods
add constraint PK_Woods
primary key(Wood)

alter table Dates
add constraint PK_Dates
primary key(ActualDate)

alter table Wands
add constraint PK_Wands
primary key(Wood, Length, Core)

alter table Wizards
add constraint PK_Wizards
primary key(FirstName, LastName)

alter table Sales
add constraint PK_Sales
primary key(FirstName, LastName, Core, Length, OrderDate, Wood)

alter table Spells
add constraint PK_Spells
primary key(SpellName)

alter table SpellCasts
add constraint PK_SpellCasts
primary key(CastDate, Wood, Length, Core, LocationName, SpellName)

alter table Locations
add constraint PK_Locations
primary key(LocationName)


-- Part 1, step 3

alter table Wizards
add constraint FK_Wizards_Wizards_1
foreign key (FatherFirstName, FatherLastName)
references Wizards(FirstName, LastName)

alter table Wizards
add constraint FK_Wizards_Wizards_2
foreign key(MotherFirstName, MotherLastName)
references Wizards(FirstName, LastName)

alter table Sales
add constraint FK_Sales_Wizards_1
foreign key(FirstName, LastName)
references Wizards(FirstName, LastName)

alter table Wands
add constraint FK_Wands_Woods_1
foreign key(Wood)
references Woods(Wood)

alter table Sales
add constraint FK_Sales_Wands_1
foreign key(Wood, Length, Core)
references Wands(Wood, Length, Core)

alter table Sales
add constraint FK_Sales_Dates_1
foreign key(OrderDate)
references Dates(ActualDate)

alter table Sales
add constraint FK_Sales_Dates_2
foreign key(DeliveryDate)
references Dates(ActualDate)

alter table SpellCasts
add constraint FK_SpellCasts_Spells_1
foreign key(SpellName)
references Spells(SpellName)

alter table SpellCasts
add constraint FK_SpellCasts_Wands_1
foreign key(Wood, Length, Core)
references Wands(Wood, Length, Core)

alter table SpellCasts
add constraint FK_SpellCasts_Dates_1
foreign key(CastDate)
references Dates(ActualDate)

alter table SpellCasts
add constraint FK_SpellCasts_Locations_1
foreign key(LocationName)
references Locations(LocationName)

exec RunSQLTests1

-- Part 2

create index IDX_Wands_Wood_1
ON Wands(Wood)

create index IDX_Wizards_House_1
ON Wizards(House)

create index IDX_Wizards_FatherLastName_1
ON Wizards(FatherLastName, MotherLastName)

ALTER TABLE Woods
ADD CONSTRAINT CK_Woods_Woodtype
CHECK (WoodType='Softwood' OR WoodType='Hardwood')

ALTER TABLE Wands
ADD CONSTRAINT CK_Wands_Length
CHECK (Length >= 8 and Length < 13)

ALTER TABLE Wizards
ADD CONSTRAINT U_Wizards_HouseWizardId
UNIQUE (HouseWizardId, House)

ALTER TABLE Wizards
ADD CONSTRAINT DF_Wizards_WizardBorn
DEFAULT 1 
FOR WizardBorn

ALTER TABLE Sales
ADD CONSTRAINT DF_Sales_DeliveryDate
DEFAULT getDate() 
FOR DeliveryDate

exec RunSQLTests2

-- Part 3

exec PopulateData

GO
CREATE VIEW VIEW1 AS
SELECT * FROM Sales

GO
CREATE VIEW VIEW2 AS
SELECT FirstName, LastName FROM Wizards

GO
CREATE VIEW VIEW3 AS
SELECT DISTINCT LastName FROM Wizards

GO
CREATE VIEW VIEW4 AS
SELECT FirstName, LastName FROM Wizards
WHERE LastName = 'Voigt'

GO
CREATE VIEW VIEW5 AS
SELECT FirstName, LastName FROM Wizards
WHERE firstName LIKE 'H%' AND LastName LIKE 'S%%D'

GO 
CREATE VIEW VIEW6 AS
SELECT FirstName, LastName FROM Wizards
WHERE Age IS NULL

GO
CREATE VIEW VIEW7 AS
SELECT DISTINCT FirstName, LastName FROM Sales
WHERE Core IN ('Dragon heartstring', 'Phoenix Feather')

GO
CREATE VIEW VIEW8 AS
SELECT FirstName, LastName, Length FROM Sales
WHERE YEAR(OrderDate) = 2013

GO
CREATE VIEW VIEW9 AS
SELECT Wi.FirstName as FirstName, Wi.LastName as LastName, Wi.House as House, Sa.Length as Length, Sa.OrderDate as OrderDate
FROM Wizards as Wi
JOIN Sales as Sa
ON (Sa.FirstName = Wi.FirstName AND Sa.LastName = Wi.LastName)

GO
CREATE VIEW VIEW10 AS
SELECT Wi.FirstName as FirstName, Wi.LastName as LastName, Sa.Core as Core
FROM Wizards as Wi
LEFT JOIN Sales as Sa
ON (Wi.FirstName = Sa.FirstName AND Wi.LastName = Sa.LastName)

GO
CREATE VIEW VIEW11 AS
SELECT Wi.FirstName, Wi.LastName, Wi.House, Sa.Core, Sa.Length, Sa.Wood
FROM Wizards as Wi
FULL OUTER JOIN Sales as Sa
ON (Wi.FirstName = Sa.FirstName and Wi.LastName = Sa.LastName)

GO
CREATE VIEW VIEW12 AS
SELECT Core, Length, Wood FROM Sales
WHERE Length BETWEEN 10 AND 11

GO
CREATE VIEW VIEW13 AS
SELECT Wi.FirstName, Wi.LastName, Wi.House, Sa.Core, Sa.Length, Sa.Wood, Sa.OrderDate, D.Season, Wo.WoodType
FROM Sales as Sa
JOIN Wizards as Wi
ON (Sa.FirstName = Wi.FirstName)
AND Sa.LastName = Wi.LastName
JOIN Dates as D
ON ( Sa.OrderDate = D.ActualDate)
JOIN Woods as Wo
ON (Sa.Wood = Wo.Wood)

GO
CREATE VIEW VIEW14 AS
SELECT COUNT( Distinct Length) as LengthCount FROM Sales

GO
CREATE VIEW VIEW15 AS
SELECT House FROM Wizards
GROUP BY House
HAVING COUNT(FirstName) >= 30
GO

exec RunSQLTests3

exec RunSQLTests
