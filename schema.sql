-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it

CREATE TABLE "players" (
    "id" INTEGER NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT,
    "age" INTEGER NOT NULL,
    "position" TEXT NOT NULL CHECK("position" IN ('forward', 'defender', 'midfielder', 'goalkeeper')),
    "shirt_number" INTEGER NOT NULL CHECK("shirt_number" >= 0 AND "shirt_number" <= 99),
    "nacionality" TEXT NOT NULL,
    "contract_expiration" NUMERIC NOT NULL,
    "market_value" REAL CHECK("market_value" >= 0),
    PRIMARY KEY("id")
);

CREATE TABLE "matches" (
    "id" INTEGER NOT NULL,
    "opponent" TEXT NOT NULL,
    "match_date" NUMERIC NOT NULL,
    "result" CHAR NOT NULL CHECK("result" IN ('W', 'D', 'L')),
    "site" TEXT NOT NULL CHECK("site" IN ('home', 'away')),
    "stadium" TEXT NOT NULL,
    "competition" TEXT NOT NULL CHECK("competition" IN
    ('UEFA Champions League', 'La Liga', 'Copa del Rey', 'Spanish Super Cup', 'UEFA Super cup', 'FIFA Club World Cup')),
    "attendance" INTEGER NOT NULL,
    PRIMARY KEY("id")
);

CREATE TABLE "performances" (
    "id" INTEGER NOT NULL,
    "player_id" INTEGER NOT NULL,
    "match_id" INTEGER NOT NULL,
    "rating" REAL CHECK("rating" >= 0.0),
    "min_played" INTEGER DEFAULT 0 CHECK("min_played" >= 0),
    "goals" INTEGER DEFAULT 0 CHECK("goals" >= 0),
    "assists" INTEGER DEFAULT 0 CHECK("assists" >= 0),
    "yellow_card" INTEGER DEFAULT 0 CHECK("yellow_card" = 0 OR "yellow_card" = 1 OR "yellow_card" = 2),
    "red_card" INTEGER DEFAULT 0 CHECK("red_card" = 0 OR "red_card" = 1),
    PRIMARY KEY("id"),
    FOREIGN KEY("player_id") REFERENCES "players"("id"),
    FOREIGN KEY("match_id") REFERENCES "matches"("id")
);

CREATE TABLE "referees" (
    "id" INTEGER NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    PRIMARY KEY("id")
);

CREATE TABLE "referees_in_matches" (
    "match_id" INTEGER NOT NULL,
    "referee_id" INTEGER NOT NULL,
    PRIMARY KEY("match_id", "referee_id"),
    FOREIGN KEY("match_id") REFERENCES "matches"("id"),
    FOREIGN KEY("referee_id") REFERENCES "referees"("id")
);

CREATE VIEW "la_liga_performance" AS
SELECT "opponent", "match_date", "result", "site", "stadium", "competition", "attendance" FROM "matches"
WHERE "competition" = 'La Liga';

CREATE VIEW "champions_league_performance" AS
SELECT "opponent", "match_date", "result", "site", "stadium", "competition", "attendance" FROM "matches"
WHERE "competition" = 'UEFA Champions League';

CREATE VIEW "players_by_avg_rating" AS
SELECT "players"."id", "first_name", "last_name", ROUND(AVG("rating"), 2) AS "avg_rating" FROM "players"
JOIN "performances" ON "performances"."player_id" = "players"."id"
GROUP BY "players"."id"
ORDER BY "avg_rating" DESC;

CREATE VIEW "contracts_about_to_expire" AS
SELECT "first_name", "last_name", "age", "contract_expiration" FROM "players"
ORDER BY "contract_expiration";

CREATE VIEW "minutes_by_player" AS
SELECT "players"."id", "first_name", "last_name", SUM("min_played") AS "min_played" FROM "players"
JOIN "performances" ON "performances"."player_id" = "players"."id"
GROUP BY "players"."id"
ORDER BY "min_played" DESC;

CREATE INDEX "idx_performances_player_id"
ON "performances" ("player_id");