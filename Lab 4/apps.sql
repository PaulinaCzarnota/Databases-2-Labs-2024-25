-- LAB 4 – NORMALIZATION

-- EXERCISE 2: DESIGN AND IMPLEMENTATION

-- Drop the existing non-normalized table if it exists
DROP TABLE IF EXISTS Apps_NOT_Normalized;

-- Create non-normalized table
CREATE TABLE Apps_NOT_Normalized (
  App_No INTEGER,
  StudentID INTEGER,
  StudentName VARCHAR(50),
  Street VARCHAR(100),
  State VARCHAR(30),
  ZipCode VARCHAR(7),
  App_Year INTEGER,
  ReferenceName VARCHAR(100),
  RefInstitution VARCHAR(100),
  ReferenceStatement VARCHAR(500),
  PriorSchoolId INTEGER,
  PriorSchoolAddr VARCHAR(100),
  GPA NUMERIC(4, 2) 
);

INSERT INTO Apps_NOT_Normalized VALUES(1,1,'Mark','Grafton Street','New York','NY234',2003,'Dr. Jones','Trinity College','Good guy',1,'Castleknock',65);
INSERT INTO Apps_NOT_Normalized VALUES(1,1,'Mark','Grafton Street','New York','NY234',2004,'Dr. Jones','Trinity College','Good guy',1,'Castleknock',65);
INSERT INTO Apps_NOT_Normalized VALUES(2,1,'Mark','White Street','Florida','Flo435',2007,'Dr. Jones','Trinity College','Good guy',1,'Castleknock',65);
INSERT INTO Apps_NOT_Normalized VALUES(2,1,'Mark','White Street','Florida','Flo435',2007,'Dr. Jones','Trinity College','Good guy',2,'Loreto College',87);
INSERT INTO Apps_NOT_Normalized VALUES(3,1,'Mark','White Street','Florida','Flo435',2012,'Dr. Jones','U Limerick','Very Good guy',1,'Castleknock',65);
INSERT INTO Apps_NOT_Normalized VALUES(3,1,'Mark','White Street','Florida','Flo435',2012,'Dr. Jones','U Limerick','Very Good guy',2,'Loreto College',87);
INSERT INTO Apps_NOT_Normalized VALUES(2,2,'Sarah','Green Road','California','Cal123',2010,'Dr. Byrne','DIT','Perfect',1,'Castleknock',90);
INSERT INTO Apps_NOT_Normalized VALUES(2,2,'Sarah','Green Road','California','Cal123',2010,'Dr. Byrne','DIT','Perfect',3,'St. Patrick',76);
INSERT INTO Apps_NOT_Normalized VALUES(2,2,'Sarah','Green Road','California','Cal123',2011,'Dr. Byrne','DIT','Perfect',1,'Castleknock',90);
INSERT INTO Apps_NOT_Normalized VALUES(2,2,'Sarah','Green Road','California','Cal123',2011,'Dr. Byrne','DIT','Perfect',3,'St. Patrick',76);
INSERT INTO Apps_NOT_Normalized VALUES(2,2,'Sarah','Green Road','California','Cal123',2012,'Dr. Byrne','UCD','Average',1,'Castleknock',90);
INSERT INTO Apps_NOT_Normalized VALUES(2,2,'Sarah','Green Road','California','Cal123',2012,'Dr. Byrne','UCD','Average',3,'St. Patrick',76);
INSERT INTO Apps_NOT_Normalized VALUES(2,2,'Sarah','Green Road','California','Cal123',2012,'Dr. Byrne','UCD','Average',4,'DBS',66);
INSERT INTO Apps_NOT_Normalized VALUES(2,2,'Sarah','Green Road','California','Cal123',2012,'Dr. Byrne','UCD','Average',5,'Harvard',45);
INSERT INTO Apps_NOT_Normalized VALUES(1,3,'Paul','Red Crescent','Carolina','Ca455',2012,'Dr. Jones','Trinity College','Poor',1,'Castleknock',45);
INSERT INTO Apps_NOT_Normalized VALUES(1,3,'Paul','Red Crescent','Carolina','Ca455',2012,'Dr. Jones','Trinity College','Poor',3,'St. Patrick',67);
INSERT INTO Apps_NOT_Normalized VALUES(1,3,'Paul','Red Crescent','Carolina','Ca455',2012,'Dr. Jones','Trinity College','Poor',4,'DBS',23);
INSERT INTO Apps_NOT_Normalized VALUES(1,3,'Paul','Red Crescent','Carolina','Ca455',2012,'Dr. Jones','Trinity College','Poor',5,'Harvard',67);
INSERT INTO Apps_NOT_Normalized VALUES(3,3,'Paul','Yellow Park','Mexico','Mex1',2008,'Prof. Cahill','UCC','Excellent',1,'Castleknock',45);
INSERT INTO Apps_NOT_Normalized VALUES(3,3,'Paul','Yellow Park','Mexico','Mex1',2008,'Prof. Cahill','UCC','Excellent',3,'St. Patrick',67);
INSERT INTO Apps_NOT_Normalized VALUES(3,3,'Paul','Yellow Park','Mexico','Mex1',2008,'Prof. Cahill','UCC','Excellent',4,'DBS',23);
INSERT INTO Apps_NOT_Normalized VALUES(3,3,'Paul','Yellow Park','Mexico','Mex1',2008,'Prof. Cahill','UCC','Excellent',5,'Harvard',67);
INSERT INTO Apps_NOT_Normalized VALUES(1,4,'Jack','Dartry Road','Ohio','Oh34',2009,'Prof. Lillis','DIT','Fair',3,'St. Patrick',29);
INSERT INTO Apps_NOT_Normalized VALUES(1,4,'Jack','Dartry Road','Ohio','Oh34',2009,'Prof. Lillis','DIT','Fair',4,'DBS',88);
INSERT INTO Apps_NOT_Normalized VALUES(1,4,'Jack','Dartry Road','Ohio','Oh34',2009,'Prof. Lillis','DIT','Fair',5,'Harvard',66);
INSERT INTO Apps_NOT_Normalized VALUES(2,5,'Mary','Malahide Road','Ireland','IRE',2009,'Prof. Lillis','DIT','Good girl',3,'St. Patrick',44);
INSERT INTO Apps_NOT_Normalized VALUES(2,5,'Mary','Malahide Road','Ireland','IRE',2009,'Prof. Lillis','DIT','Good girl',4,'DBS',55);
INSERT INTO Apps_NOT_Normalized VALUES(2,5,'Mary','Malahide Road','Ireland','IRE',2009,'Prof. Lillis','DIT','Good girl',5,'Harvard',66);
INSERT INTO Apps_NOT_Normalized VALUES(2,5,'Mary','Malahide Road','Ireland','IRE',2009,'Prof. Lillis','DIT','Good girl',1,'Castleknock',74);
INSERT INTO Apps_NOT_Normalized VALUES(1,5,'Mary','Black Bay','Kansas','Kan45',2005,'Dr. Byrne','DIT','Perfect',3,'St. Patrick',44);
INSERT INTO Apps_NOT_Normalized VALUES(1,5,'Mary','Black Bay','Kansas','Kan45',2005,'Dr. Byrne','DIT','Perfect',4,'DBS',55);
INSERT INTO Apps_NOT_Normalized VALUES(1,5,'Mary','Black Bay','Kansas','Kan45',2005,'Dr. Byrne','DIT','Perfect',5,'Harvard',66);
INSERT INTO Apps_NOT_Normalized VALUES(3,6,'Susan','River Road','Kansas','Kan45',2011,'Prof. Cahill','UCC','Messy',1,'Castleknock',88);
INSERT INTO Apps_NOT_Normalized VALUES(3,6,'Susan','River Road','Kansas','Kan45',2011,'Prof. Cahill','UCC','Messy',3,'St. Patrick',77);
INSERT INTO Apps_NOT_Normalized VALUES(3,6,'Susan','River Road','Kansas','Kan45',2011,'Prof. Cahill','UCC','Messy',4,'DBS',56);
INSERT INTO Apps_NOT_Normalized VALUES(3,6,'Susan','River Road','Kansas','Kan45',2011,'Prof. Cahill','UCC','Messy',2,'Loreto College',45);

-- Verify table contents
SELECT * FROM Apps_NOT_Normalized;