-- LAB 3 – TRIGGERS IN POSTGRESQL

-- EXERCISE 1

-- Drop tables if they already exist to ensure a clean slate
DROP TABLE IF EXISTS logTeam, euroLeague, matches, teams;

-- Create the teams table
CREATE TABLE teams (
    TeamName VARCHAR(50) PRIMARY KEY,
    TeamCountry VARCHAR(50) CHECK (TeamCountry IN ('England', 'Spain'))
);

-- Create the matches table
CREATE TABLE matches (
    MatchID SERIAL PRIMARY KEY,
    TeamA_Name VARCHAR(50) REFERENCES teams(TeamName),
    TeamB_Name VARCHAR(50) REFERENCES teams(TeamName),
    CONSTRAINT diff_team_check CHECK (TeamA_Name <> TeamB_Name),
    Goal_A INT CHECK (Goal_A >= 0),
    Goal_B INT CHECK (Goal_B >= 0),
    Competition VARCHAR(50) CHECK (Competition IN ('Champions League', 'Europa League', 'Premier League', 'La Liga'))
);

-- Create the euroLeague table
CREATE TABLE euroLeague (
    TeamName VARCHAR(50) PRIMARY KEY,
    Points INT DEFAULT 0,
    Goals_scored INT DEFAULT 0,
    Goals_conceded INT DEFAULT 0,
    Difference INT DEFAULT 0,
    FOREIGN KEY (TeamName) REFERENCES teams (TeamName)
);

-- Create the logTeam table
CREATE TABLE logTeam (
    TeamName VARCHAR(50),
    InsertionTime TIMESTAMP DEFAULT current_timestamp
);

-- Create or replace function to log team insertion and add them to euroLeague
CREATE OR REPLACE FUNCTION log_team_insertion() RETURNS TRIGGER AS $$
BEGIN
    -- Log the insertion with timestamp
    INSERT INTO logTeam (TeamName, InsertionTime)
    VALUES (NEW.TeamName, CURRENT_TIMESTAMP);

    -- Insert the team into euroLeague if it doesn't exist
    INSERT INTO euroLeague (TeamName) 
    VALUES (NEW.TeamName) 
    ON CONFLICT (TeamName) DO NOTHING;  -- Do nothing if already exists

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to execute log_team_insertion after inserting into teams
CREATE TRIGGER after_team_insertion
AFTER INSERT ON teams
FOR EACH ROW
EXECUTE FUNCTION log_team_insertion();

-- Create or replace function to check team country for specific competitions
CREATE OR REPLACE FUNCTION check_team_country() RETURNS TRIGGER AS $$
DECLARE
    teamA_country VARCHAR(50);
    teamB_country VARCHAR(50);
BEGIN
    SELECT TeamCountry INTO teamA_country FROM teams WHERE TeamName = NEW.TeamA_Name;
    SELECT TeamCountry INTO teamB_country FROM teams WHERE TeamName = NEW.TeamB_Name;
    
    IF NEW.Competition = 'Premier League' AND (teamA_country <> 'England' OR teamB_country <> 'England') THEN
        RAISE EXCEPTION 'Both teams must be from England for Premier League matches.';
    ELSIF NEW.Competition = 'La Liga' AND (teamA_country <> 'Spain' OR teamB_country <> 'Spain') THEN
        RAISE EXCEPTION 'Both teams must be from Spain for La Liga matches.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to enforce country rules before inserting a match
CREATE TRIGGER before_match_insertion
BEFORE INSERT ON matches
FOR EACH ROW
EXECUTE FUNCTION check_team_country();

-- Create or replace function to limit matches and calculate points, goals, and difference
CREATE OR REPLACE FUNCTION check_match_limit() RETURNS TRIGGER AS $$
DECLARE
    matches_count INT;
BEGIN
    -- Check that a team does not exceed 4 matches
    SELECT COUNT(*) INTO matches_count 
    FROM matches 
    WHERE TeamA_Name = NEW.TeamA_Name OR TeamB_Name = NEW.TeamA_Name;

    IF matches_count >= 4 THEN
        RAISE EXCEPTION 'A team cannot play more than 4 matches';
    END IF;

    RETURN NEW;  -- Continue with the insertion
END;
$$ LANGUAGE plpgsql;

-- Trigger to check match limits before inserting a match
CREATE TRIGGER before_match_limit
BEFORE INSERT ON matches
FOR EACH ROW
EXECUTE FUNCTION check_match_limit();

-- Create or replace function to update euroLeague based on match result
CREATE OR REPLACE FUNCTION update_euroLeague() RETURNS TRIGGER AS $$
BEGIN
    -- Determine the result and update points, goals, and difference
    IF NEW.Goal_A > NEW.Goal_B THEN
        UPDATE euroLeague
        SET Points = Points + 3, 
            Goals_scored = Goals_scored + NEW.Goal_A, 
            Goals_conceded = Goals_conceded + NEW.Goal_B,
            Difference = (Goals_scored + NEW.Goal_A) - (Goals_conceded + NEW.Goal_B)
        WHERE TeamName = NEW.TeamA_Name;

        UPDATE euroLeague
        SET Goals_scored = Goals_scored + NEW.Goal_B, 
            Goals_conceded = Goals_conceded + NEW.Goal_A,
            Difference = (Goals_scored + NEW.Goal_B) - (Goals_conceded + NEW.Goal_A)
        WHERE TeamName = NEW.TeamB_Name;

    ELSIF NEW.Goal_A < NEW.Goal_B THEN
        UPDATE euroLeague
        SET Points = Points + 3, 
            Goals_scored = Goals_scored + NEW.Goal_B, 
            Goals_conceded = Goals_conceded + NEW.Goal_A,
            Difference = (Goals_scored + NEW.Goal_B) - (Goals_conceded + NEW.Goal_A)
        WHERE TeamName = NEW.TeamB_Name;

        UPDATE euroLeague
        SET Goals_scored = Goals_scored + NEW.Goal_A, 
            Goals_conceded = Goals_conceded + NEW.Goal_B,
            Difference = (Goals_scored + NEW.Goal_A) - (Goals_conceded + NEW.Goal_B)
        WHERE TeamName = NEW.TeamA_Name;

    ELSE  -- It's a draw
        UPDATE euroLeague
        SET Points = Points + 1, 
            Goals_scored = Goals_scored + NEW.Goal_A, 
            Goals_conceded = Goals_conceded + NEW.Goal_B,
            Difference = (Goals_scored + NEW.Goal_A) - (Goals_conceded + NEW.Goal_B)
        WHERE TeamName = NEW.TeamA_Name;

        UPDATE euroLeague
        SET Points = Points + 1, 
            Goals_scored = Goals_scored + NEW.Goal_B, 
            Goals_conceded = Goals_conceded + NEW.Goal_A,
            Difference = (Goals_scored + NEW.Goal_B) - (Goals_conceded + NEW.Goal_A)
        WHERE TeamName = NEW.TeamB_Name;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update euroLeague after a match is inserted
CREATE TRIGGER after_match_insert
AFTER INSERT ON matches
FOR EACH ROW
EXECUTE FUNCTION update_euroLeague();

-- Test data
INSERT INTO teams (TeamName, TeamCountry) VALUES 
('Arsenal', 'England'), 
('Manchester City', 'England'), 
('Manchester United', 'England'), 
('Chelsea', 'England'), 
('Real Madrid', 'Spain'), 
('Barcelona', 'Spain'), 
('Atletico Madrid', 'Spain'), 
('Sevilla', 'Spain');

-- Sample match insertion
INSERT INTO matches (TeamA_Name, TeamB_Name, Goal_A, Goal_B, Competition) VALUES 
('Arsenal', 'Manchester United', 1, 1, 'Premier League');

-- Queries to verify the results
SELECT * FROM teams;
SELECT * FROM logTeam;
SELECT * FROM euroLeague;
SELECT * FROM matches;