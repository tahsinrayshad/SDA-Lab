-- 1. City-Wise Most Popular Races Based on Ratings
CREATE OR REPLACE PROCEDURE city_wise_top_races AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('City | Race | Avg Rating');
    FOR rec IN (
        SELECT
            city,
            race_id,
            ROUND(AVG(rating), 2) AS avg_rating
        FROM fact_ratings
        GROUP BY city, race_id
        ORDER BY city, avg_rating DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.city || ' | Race ID: ' || rec.race_id || ' | Rating: ' || rec.avg_rating);
    END LOOP;
END;
/

SET SERVEROUTPUT ON;
EXEC city_wise_top_races;


-- 2. Top 5 Most Rewarded Players by City
CREATE OR REPLACE PROCEDURE top_5_rewarded_players_by_city AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('City | Player ID | Total Rewards');

    FOR rec IN (
        SELECT city, player_id, total_reward
        FROM (
            SELECT
                city,
                player_id,
                SUM(reward_points) AS total_reward,
                ROW_NUMBER() OVER (
                    PARTITION BY city
                    ORDER BY SUM(reward_points) DESC
                ) AS rn
            FROM fact_ratings
            GROUP BY city, player_id
        )
        WHERE rn <= 5
        ORDER BY city, total_reward DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            rec.city || ' | Player: ' || rec.player_id || ' | Rewards: ' || rec.total_reward
        );
    END LOOP;
END;
/



SET SERVEROUTPUT ON;
EXEC top_5_rewarded_players_by_city;


-- 3. Race Ratings and Rewards Across Months
CREATE OR REPLACE PROCEDURE monthly_race_summary AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Month | Race | Avg Rating | Avg Reward');
    FOR rec IN (
        SELECT
            dt.month,
            race_id,
            ROUND(AVG(rating), 2) AS avg_rating,
            ROUND(AVG(reward_points), 2) AS avg_reward
        FROM fact_ratings fr
        JOIN dim_time dt ON fr.time_id = dt.time_id
        GROUP BY dt.month, race_id
        ORDER BY dt.month, race_id
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Month ' || rec.month || ' | Race ID: ' || rec.race_id || ' | Rating: ' || rec.avg_rating || ' | Reward: ' || rec.avg_reward);
    END LOOP;
END;
/

SET SERVEROUTPUT ON;
EXEC monthly_race_summary;


-- 4. Player Activity Summary
CREATE OR REPLACE PROCEDURE player_activity_summary AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Player | Races Completed | Total Duration | Total Reward');

    FOR rec IN (
        SELECT
            player_id,
            COUNT(*) AS races_completed,
            SUM(duration_minutes) AS total_duration,
            SUM(reward_points) AS total_reward
        FROM fact_ratings
        GROUP BY player_id
        ORDER BY player_id
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Player ' || rec.player_id || ' | ' || rec.races_completed || 
            ' races | ' || rec.total_duration || ' mins | ' || rec.total_reward || ' points'
        );
    END LOOP;
END;
/

SET SERVEROUTPUT ON;

EXEC player_activity_summary;


-- 5. Monthly City-Based Number of Player Engagements
CREATE OR REPLACE PROCEDURE monthly_city_engagement AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Month | City | Player Count');

    FOR rec IN (
        SELECT
            dt.month,
            fr.city,
            COUNT(DISTINCT fr.player_id) AS engaged_players
        FROM fact_ratings fr
        JOIN dim_time dt ON fr.time_id = dt.time_id
        GROUP BY dt.month, fr.city
        ORDER BY dt.month, fr.city
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Month ' || rec.month || ' | ' || rec.city || 
            ' | Players: ' || rec.engaged_players
        );
    END LOOP;
END;
/

SET SERVEROUTPUT ON;
EXEC monthly_city_engagement;


-- 6. Most Frequently Played Races with Avg Reward > 100 & Avg Duration > 30 mins

CREATE OR REPLACE PROCEDURE popular_high_value_races AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Race ID | Avg Reward | Avg Duration | Times Played');

    FOR rec IN (
        SELECT
            race_id,
            ROUND(AVG(reward_points), 2) AS avg_reward,
            ROUND(AVG(duration_minutes), 2) AS avg_duration,
            COUNT(*) AS times_played
        FROM fact_ratings
        GROUP BY race_id
        HAVING
            AVG(reward_points) > 100 AND
            AVG(duration_minutes) > 30
        ORDER BY times_played DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Race ' || rec.race_id || ' | Reward: ' || rec.avg_reward || 
            ' | Duration: ' || rec.avg_duration || 
            ' mins | Played: ' || rec.times_played
        );
    END LOOP;
END;
/
-- Execute 
SET SERVEROUTPUT ON;
EXEC popular_high_value_races;