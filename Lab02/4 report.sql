DROP TABLE fact_ratings;
DROP TABLE dim_time;

DROP SEQUENCE seq_fact_ratings;
DROP SEQUENCE seq_dim_time;


-- Creating dim_time TABLE
CREATE TABLE dim_time (
    time_id NUMBER PRIMARY KEY,
    date_value DATE NOT NULL,
    day NUMBER,
    month NUMBER,
    quarter NUMBER,
    year NUMBER,
    weekday VARCHAR2(10)
);

-- Creating a sequence for time_id
CREATE SEQUENCE seq_dim_time START WITH 1 INCREMENT BY 1;

-- Trigger to auto-increment time_id for dim_time
CREATE OR REPLACE TRIGGER trg_dim_time_id
BEFORE INSERT ON dim_time
FOR EACH ROW
WHEN (NEW.time_id IS NULL)
BEGIN
    :NEW.time_id := seq_dim_time.NEXTVAL;
END;
/

-- Creating fact_ratings TABLE

CREATE TABLE fact_ratings (
    rating_id NUMBER PRIMARY KEY,
    player_id NUMBER,
    car_id NUMBER,
    race_id NUMBER,
    city VARCHAR2(100),
    rating NUMBER,
    reward_points NUMBER,
    duration_minutes NUMBER,
    time_id NUMBER,
    CONSTRAINT fk_fact_time FOREIGN KEY (time_id) REFERENCES dim_time(time_id)
);

-- Creating a sequence for rating_id
CREATE SEQUENCE seq_fact_ratings START WITH 1 INCREMENT BY 1;
-- Trigger to auto-increment rating_id for fact_ratings
CREATE OR REPLACE TRIGGER trg_fact_ratings_id
BEFORE INSERT ON fact_ratings
FOR EACH ROW
WHEN (NEW.rating_id IS NULL)
BEGIN
    :NEW.rating_id := seq_fact_ratings.NEXTVAL;
END;
/


-- Inserting Data to dim_time
INSERT INTO dim_time (date_value, day, month, quarter, year, weekday)
VALUES (TO_DATE('2024-06-01', 'YYYY-MM-DD'), 1, 6, 2, 2024, 'Saturday');

INSERT INTO dim_time (date_value, day, month, quarter, year, weekday)
VALUES (TO_DATE('2024-06-02', 'YYYY-MM-DD'), 2, 6, 2, 2024, 'Sunday');

INSERT INTO dim_time (date_value, day, month, quarter, year, weekday)
VALUES (TO_DATE('2024-06-03', 'YYYY-MM-DD'), 3, 6, 2, 2024, 'Monday');

INSERT INTO dim_time (date_value, day, month, quarter, year, weekday)
VALUES (TO_DATE('2024-06-04', 'YYYY-MM-DD'), 4, 6, 2, 2024, 'Tuesday');

INSERT INTO dim_time (date_value, day, month, quarter, year, weekday)
VALUES (TO_DATE('2024-06-05', 'YYYY-MM-DD'), 5, 6, 2, 2024, 'Wednesday');


-- Inserting Data to fact_ratings
-- Step 1: Insert missing dates into dim_time
BEGIN
    FOR rec IN (
        SELECT DISTINCT TRUNC(rating_timestamp) AS rating_date
        FROM race_participation
        WHERE TRUNC(rating_timestamp) IS NOT NULL
          AND TRUNC(rating_timestamp) NOT IN (
              SELECT date_value FROM dim_time
          )
    ) LOOP
        INSERT INTO dim_time (
            date_value, day, month, quarter, year, weekday
        )
        VALUES (
            rec.rating_date,
            TO_NUMBER(TO_CHAR(rec.rating_date, 'DD')),
            TO_NUMBER(TO_CHAR(rec.rating_date, 'MM')),
            TO_NUMBER(TO_CHAR(rec.rating_date, 'Q')),
            TO_NUMBER(TO_CHAR(rec.rating_date, 'YYYY')),
            TO_CHAR(rec.rating_date, 'Day')
        );
    END LOOP;
END;
/

-- Step 2: Insert into fact_ratings from operational tables
INSERT INTO fact_ratings (
    player_id, car_id, race_id, city,
    rating, reward_points, duration_minutes, time_id
)
SELECT
    p.player_id,
    c.car_id,
    r.race_id,
    r.city,
    rp.rating,
    r.reward_points,
    r.duration_minutes,
    dt.time_id
FROM
    race_participation rp
JOIN car c ON rp.car_id = c.car_id
JOIN player p ON c.player_id = p.player_id
JOIN race r ON rp.race_id = r.race_id
JOIN dim_time dt ON TRUNC(rp.rating_timestamp) = dt.date_value
WHERE
    rp.rating IS NOT NULL;



