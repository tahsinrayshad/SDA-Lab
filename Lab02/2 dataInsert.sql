-- Inserting Data to change_log
INSERT INTO change_log (created_by, script_name, script_details)
VALUES ('admin', '000_init_schema.sql', 'Created initial schema and tables');

INSERT INTO change_log (created_by, script_name, script_details)
VALUES ('admin', '001_seed_data.sql', 'Inserted seed data into all tables');


-- Inserting Data to player
INSERT INTO player (username, email) VALUES ('SpeedKing', 'king@example.com');
INSERT INTO player (username, email) VALUES ('TurboQueen', 'queen@example.com');
INSERT INTO player (username, email) VALUES ('MechaMaster', 'mecha@example.com');
INSERT INTO player (username, email) VALUES ('ShadowDrift', 'shadow@example.com');
INSERT INTO player (username, email) VALUES ('NeoBlazer', 'neo@example.com');

-- Inserting Data to car
INSERT INTO car (player_id, car_model, car_name) VALUES (1, 'RX-7', 'Ghost Flame');
INSERT INTO car (player_id, car_model, car_name) VALUES (2, 'Supra', 'Sky Beast');
INSERT INTO car (player_id, car_model, car_name) VALUES (3, 'GTR-35', 'Neo Pulse');
INSERT INTO car (player_id, car_model, car_name) VALUES (4, 'Camaro', 'Midnight Howl');
INSERT INTO car (player_id, car_model, car_name) VALUES (5, 'Mustang', 'Solar Sonic');

-- Inserting Data to part
INSERT INTO part (part_name, part_type) VALUES ('Turbo X100', 'Turbo');
INSERT INTO part (part_name, part_type) VALUES ('GripMaster T5', 'Tire');
INSERT INTO part (part_name, part_type) VALUES ('EcoBoost V2', 'Engine');
INSERT INTO part (part_name, part_type) VALUES ('SkyTrack Pro', 'Suspension');
INSERT INTO part (part_name, part_type) VALUES ('NitroFlash Z', 'Nitro');

-- Inserting Data to race
INSERT INTO race (race_name, city, duration_minutes, reward_points)
VALUES ('Turbo Rally', 'NeoTokyo', 40, 120);

INSERT INTO race (race_name, city, duration_minutes, reward_points)
VALUES ('Skyline Showdown', 'Skyline Bay', 35, 150);

INSERT INTO race (race_name, city, duration_minutes, reward_points)
VALUES ('Mecha Sprint', 'Mecha Hills', 25, 90);

INSERT INTO race (race_name, city, duration_minutes, reward_points)
VALUES ('Solar Drift', 'Solar Drift', 50, 180);

INSERT INTO race (race_name, city, duration_minutes, reward_points)
VALUES ('Velocity Clash', 'NeoTokyo', 30, 100);

-- Inserting Data to car_part
INSERT INTO car_part (car_id, part_id) VALUES (1, 1);
INSERT INTO car_part (car_id, part_id) VALUES (1, 2);
INSERT INTO car_part (car_id, part_id) VALUES (2, 3);
INSERT INTO car_part (car_id, part_id) VALUES (3, 4);
INSERT INTO car_part (car_id, part_id) VALUES (4, 5);

-- Inserting Data to race_part_reward
INSERT INTO race_part_reward (race_id, part_id) VALUES (1, 1);
INSERT INTO race_part_reward (race_id, part_id) VALUES (2, 2);
INSERT INTO race_part_reward (race_id, part_id) VALUES (3, 3);
INSERT INTO race_part_reward (race_id, part_id) VALUES (4, 4);
INSERT INTO race_part_reward (race_id, part_id) VALUES (5, 5);

-- Inserting Data to race_participation
INSERT INTO race_participation (car_id, race_id, completed_at, rating, rating_timestamp)
VALUES (1, 1, SYSDATE - 10, 5, SYSDATE - 9);

INSERT INTO race_participation (car_id, race_id, completed_at, rating, rating_timestamp)
VALUES (2, 1, SYSDATE - 8, 4, SYSDATE - 7);

INSERT INTO race_participation (car_id, race_id, completed_at, rating, rating_timestamp)
VALUES (3, 2, SYSDATE - 6, 3, SYSDATE - 5);

INSERT INTO race_participation (car_id, race_id, completed_at, rating, rating_timestamp)
VALUES (4, 3, SYSDATE - 4, 5, SYSDATE - 3);

INSERT INTO race_participation (car_id, race_id, completed_at, rating, rating_timestamp)
VALUES (5, 4, SYSDATE - 2, 4, SYSDATE - 1);
