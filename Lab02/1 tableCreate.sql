DROP TABLE race_participation CASCADE CONSTRAINTS;
DROP TABLE race_part_reward CASCADE CONSTRAINTS;
DROP TABLE car_part CASCADE CONSTRAINTS;
DROP TABLE part CASCADE CONSTRAINTS;
DROP TABLE car CASCADE CONSTRAINTS;
DROP TABLE player CASCADE CONSTRAINTS;
DROP TABLE change_log CASCADE CONSTRAINTS;

DROP SEQUENCE change_log_seq;
DROP SEQUENCE seq_player;
DROP SEQUENCE seq_car;
DROP SEQUENCE seq_race;
DROP SEQUENCE seq_part;
DROP SEQUENCE seq_race_participation;



-- Creating change_log TABLE
CREATE TABLE change_log (
    id NUMBER PRIMARY KEY,
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR2(100),
    script_name VARCHAR2(100),
    script_details VARCHAR2(500)
);

-- change_log_seq and TRIGGER
CREATE SEQUENCE change_log_seq START WITH 1 INCREMENT BY 1;

-- Trigger to auto-increment id for change_log
CREATE OR REPLACE TRIGGER trg_change_log_id
BEFORE INSERT ON change_log
FOR EACH ROW
BEGIN
    :NEW.id := change_log_seq.NEXTVAL;
END;
/


-- Creating Player TABLE
CREATE TABLE player (
    player_id NUMBER PRIMARY KEY,
    username VARCHAR2(100) UNIQUE NOT NULL,
    email VARCHAR2(100),
    registration_date DATE DEFAULT SYSDATE
);

-- Creating a sequence for player_id
CREATE SEQUENCE seq_player START WITH 1 INCREMENT BY 1;

-- Trigger to auto-increment player_id for player
CREATE OR REPLACE TRIGGER trg_player_id
BEFORE INSERT ON player
FOR EACH ROW
WHEN (NEW.player_id IS NULL)
BEGIN
  :NEW.player_id := seq_player.NEXTVAL;
END;
/

-- Creating car TABLE
CREATE TABLE car (
    car_id NUMBER PRIMARY KEY,
    player_id NUMBER NOT NULL,
    car_model VARCHAR2(100),
    car_name VARCHAR2(100),
    CONSTRAINT fk_car_player FOREIGN KEY (player_id) REFERENCES player(player_id)
);

-- Creating a sequence for car_id
CREATE SEQUENCE seq_car START WITH 1 INCREMENT BY 1;

-- Trigger to auto-increment car_id for car
CREATE OR REPLACE TRIGGER trg_car_id
BEFORE INSERT ON car
FOR EACH ROW
WHEN (NEW.car_id IS NULL)
BEGIN
  :NEW.car_id := seq_car.NEXTVAL;
END;
/

-- Creating race TABLE
CREATE TABLE race (
    race_id NUMBER PRIMARY KEY,
    race_name VARCHAR2(100) NOT NULL,
    city VARCHAR2(100),
    duration_minutes NUMBER,
    reward_points NUMBER,
    average_rating NUMBER(3,2)
);

-- Creating a sequence for race_id
CREATE SEQUENCE seq_race START WITH 1 INCREMENT BY 1;

-- Trigger to auto-increment race_id for race
CREATE OR REPLACE TRIGGER trg_race_id
BEFORE INSERT on race
FOR EACH ROW
WHEN (NEW.race_id IS NULL)
BEGIN
  :NEW.race_id := seq_race.NEXTVAL;
END;
/

-- Creating part TABLE
CREATE TABLE part (
    part_id NUMBER PRIMARY KEY,
    part_name VARCHAR2(100),
    part_type VARCHAR2(50) -- e.g., Turbo, Tire, Suspension
);

-- Creating a sequence for part_id
CREATE SEQUENCE seq_part START WITH 1 INCREMENT BY 1;

-- Trigger to auto-increment part_id for part
CREATE OR REPLACE TRIGGER trg_part_id
BEFORE INSERT ON part
FOR EACH ROW
WHEN (NEW.part_id IS NULL)
BEGIN
  :NEW.part_id := seq_part.NEXTVAL;
END;
/

-- Creating car_part TABLE
CREATE TABLE car_part (
    car_id NUMBER,
    part_id NUMBER,
    equipped_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (car_id, part_id),
    CONSTRAINT fk_cp_car FOREIGN KEY (car_id) REFERENCES car(car_id),
    CONSTRAINT fk_cp_part FOREIGN KEY (part_id) REFERENCES part(part_id)
);

-- Creating race_part_reward TABLE
CREATE TABLE race_part_reward (
    race_id NUMBER,
    part_id NUMBER,
    PRIMARY KEY (race_id, part_id),
    CONSTRAINT fk_rpr_race FOREIGN KEY (race_id) REFERENCES race(race_id),
    CONSTRAINT fk_rpr_part FOREIGN KEY (part_id) REFERENCES part(part_id)
);

-- Creating race_participation TABLE
CREATE TABLE race_participation (
    participation_id NUMBER PRIMARY KEY,
    car_id NUMBER NOT NULL,
    race_id NUMBER NOT NULL,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    rating NUMBER(1, 0) CHECK (rating BETWEEN 1 AND 5),
    rating_timestamp TIMESTAMP,
    CONSTRAINT fk_car FOREIGN KEY (car_id) REFERENCES car(car_id),
    CONSTRAINT fk_race FOREIGN KEY (race_id) REFERENCES race(race_id)
);

-- Creating a sequence for seq_race_participation
CREATE SEQUENCE seq_race_participation START WITH 1 INCREMENT BY 1;

-- Trigger to auto-increment participation
CREATE OR REPLACE TRIGGER trg_race_participation_id
BEFORE INSERT ON race_participation
FOR EACH ROW
WHEN (NEW.participation_id IS NULL)
BEGIN
  :NEW.participation_id := seq_race_participation.NEXTVAL;
END;
/


