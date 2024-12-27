-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

-- IMPORT DATA
.import --csv --skip 1 players.csv players
.import --csv --skip 1 matches.csv matches
.import --csv --skip 1 referees.csv referees
.import --csv --skip 1 referees_in_matches.csv referees_in_matches
.import --csv performances.csv temp

-- INSERT DATA
INSERT INTO "performances" ("player_id", "match_id", "rating", "min_played", "goals", "assists", "yellow_card", "red_card")
SELECT "player_id", "match_id", "rating", "min_played", "goals", "assists", "yellow_card", "red_card" FROM "temp";

INSERT INTO "players" ("first_name", "last_name", "age", "position", "shirt_number", "nacionality",
"contract_expiration", "market_value")
VALUES ('Jules', 'Koundé', 26, 'defender', 23, 'France', '30-06-2027', 55.00);

INSERT INTO "matches" ("opponent", "match_date", "result", "site", "stadium", "competition", "attendance")
VALUES ('Bayern Múnich', '23-10-2024', 'W', 'home', 'Olimpic Lluís Companys', 'UEFA Champions League', 50312)

INSERT INTO "performances" ("player_id", "match_id", "rating", "min_played", "goals", "assists", "yellow_card", "red_card")
VALUES (11, 4, 9.5, 90, 3, 1, 0, 0)

INSERT INTO "referees" ("first_name", "last_name")
VALUES ('Slavko', 'Vincic')

-- FRECUENT QUERIES
-- players with the highest market value
SELECT "first_name", "last_name", "age", "contract_expiration", "market_value" FROM "players"
ORDER BY "market_value" DESC;

-- players with contracts about to expire
SELECT "first_name", "last_name", "age", "contract_expiration" FROM "players"
ORDER BY "contract_expiration";

-- players with the most goals and assists
SELECT "players"."id", "first_name", "last_name", SUM("goals") AS "goals", SUM("assists") AS "assists" FROM "players"
JOIN "performances" ON "performances"."player_id" = "players"."id"
GROUP BY "players"."id"
ORDER BY "goals" DESC, "assists" DESC;

-- players with the most goals and assists by competition
SELECT "players"."id", "first_name", "last_name", SUM("goals") AS "goals", SUM("assists") AS "assists" FROM "players"
JOIN "performances" ON "performances"."player_id" = "players"."id"
JOIN "matches" ON "matches"."id" = "performances"."match_id"
WHERE "competition" = 'UEFA Champions League'
GROUP BY "players"."id"
ORDER BY "goals" DESC, "assists" DESC;

-- players by position
SELECT "first_name", "last_name", "age", "contract_expiration", "market_value" FROM "players"
WHERE "position" = 'defender';

-- players with the best average rating
SELECT "players"."id", "first_name", "last_name", ROUND(AVG("rating"), 2) AS "avg_rating" FROM "players"
JOIN "performances" ON "performances"."player_id" = "players"."id"
GROUP BY "players"."id"
ORDER BY "avg_rating" DESC;

-- players with most minutes played
SELECT "players"."id", "first_name", "last_name", SUM("min_played") AS "min_played" FROM "players"
JOIN "performances" ON "performances"."player_id" = "players"."id"
GROUP BY "players"."id"
ORDER BY "min_played" DESC;

-- players sub 21
SELECT "id", "first_name", "last_name", "age", "contract_expiration", "market_value" FROM "players"
WHERE "age" <= 21;

-- home games
SELECT "opponent", "result", "site", "competition" FROM "matches"
WHERE "site" = 'home';

-- away games
SELECT "opponent", "result", "site", "competition" FROM "matches"
WHERE "site" = 'away';

-- matches with the highest attendance
SELECT "opponent", "match_date", "site", "stadium", "competition", "attendance" FROM "matches"
ORDER BY "attendance" DESC;

-- matches by competition
SELECT "opponent", "match_date", "result", "site", "stadium", "competition", "attendance" FROM "matches"
WHERE "competition" = 'La Liga';

SELECT "opponent", "match_date", "result", "site", "stadium", "competition", "attendance" FROM "matches"
WHERE "competition" = 'UEFA Champions League';

-- matches per referee
SELECT "first_name", "last_name", COUNT("referee_id") AS "matches" FROM "referees"
JOIN "referees_in_matches" ON "referees"."id" = "referees_in_matches"."referee_id"
GROUP BY "referees"."id";

-- find matches by referee
SELECT "opponent", "result", "site", "stadium", "first_name", "last_name" FROM "matches"
JOIN "referees_in_matches" ON "referees_in_matches"."match_id" = "matches"."id"
JOIN "referees" ON "referees"."id" = "referees_in_matches"."referee_id"
WHERE "referees"."id" = (
    SELECT "id" FROM "referees"
    WHERE "first_name" = 'Adrián' AND "last_name" = 'Cordero'
);