-- recalculate_race_ratings PROCEDURE

CREATE OR REPLACE PROCEDURE recalculate_race_ratings AS
BEGIN
    UPDATE race r
    SET average_rating = (
        SELECT ROUND(AVG(rp.rating), 2)
        FROM race_participation rp
        WHERE rp.race_id = r.race_id AND rp.rating IS NOT NULL
    );
END;
/

-- add_race_rating PROCEDURE

CREATE OR REPLACE PROCEDURE add_race_rating (
    p_car_id IN NUMBER,
    p_race_id IN NUMBER,
    p_rating_value IN NUMBER
) AS
BEGIN
    UPDATE race_participation
    SET rating = p_rating_value,
        rating_timestamp = CURRENT_TIMESTAMP
    WHERE car_id = p_car_id AND race_id = p_race_id;

    recalculate_race_ratings;
END;
/


-- get_race_average_rating(race_id) FUNCTION

CREATE OR REPLACE FUNCTION get_race_average_rating (
    p_race_id IN NUMBER
) RETURN NUMBER IS
    avg_rating NUMBER(3,2);
BEGIN
    SELECT average_rating INTO avg_rating
    FROM race
    WHERE race_id = p_race_id;

    RETURN avg_rating;
END;
/


EXEC add_race_rating(1, 1, 4);
EXEC recalculate_race_ratings;
SELECT get_race_average_rating(1) AS avg_rating FROM dual;










