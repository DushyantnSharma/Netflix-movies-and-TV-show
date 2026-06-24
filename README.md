# Netflix SQL Database Analysis

This repository contains a self-contained SQL script (NETFLIX_SQL.sql) to create a simple MySQL-compatible database and run a set of analysis queries against a Netflix movies & TV shows dataset. It's intended as an educational template for exploring and analyzing streaming catalog metadata.

## Contents
- NETFLIX_SQL.sql  — DDL to create the `netflix` database and the `netflix_db` table plus a set of analysis queries and examples.
- README.md        — This file (how to use the SQL script and what each query does).

## What this is for
Use this project to:
- Create a small MySQL schema for Netflix-style metadata.
- Run example analytic queries (counts, top countries, rating analysis, genre analysis, etc.).
- Learn SQL techniques for parsing string columns (comma-separated fields, durations, and date strings).

## Prerequisites
- MySQL Server (5.7+) or compatible database that supports the used functions (STR_TO_DATE, SUBSTRING_INDEX, ROW_NUMBER/OVER if using MySQL 8+).
- Basic SQL knowledge and permissions to create databases/tables and to load data.

## Quick start
1. Clone the repository:

   git clone https://github.com/DushyantnSharma/Netflix-movies-and-TV-show.git
   cd Netflix-movies-and-TV-show

2. Open the SQL script to inspect the schema and queries:

   - NETFLIX_SQL.sql

3. Load the schema into your MySQL server and import data (if you have a CSV/TSV dataset):

   # Run the schema and example queries
   mysql -u <username> -p < NETFLIX_SQL.sql

   # Or create the database manually and load your CSV
   mysql -u <username> -p
   > SOURCE NETFLIX_SQL.sql;

4. If you have a CSV file (example: netflix_titles.csv) you can load it using LOAD DATA INFILE or a client tool (be careful with column order and data types):

   LOAD DATA INFILE '/path/to/netflix_titles.csv'
   INTO TABLE netflix_db
   FIELDS TERMINATED BY ','
   OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 LINES
   (show_id, type, title, director, cast, country, date_added, release_year, rating, duration, listed_in, description);

   Note: adjust path, separators and escaping for your environment.

## Schema (netflix_db)
- show_id VARCHAR(6)
- type VARCHAR(10)          -- 'Movie' or 'TV Show'
- title VARCHAR(150)
- director VARCHAR(209)    -- possibly comma-separated
- cast VARCHAR(1000)       -- comma-separated
- country VARCHAR(150)     -- comma-separated
- date_added VARCHAR(50)   -- original dataset uses a string like 'September 9, 2019'
- release_year INT
- rating VARCHAR(10)
- duration VARCHAR(15)     -- e.g. '90 min' or '2 Seasons'
- listed_in VARCHAR(100)   -- genres (comma-separated)
- description VARCHAR(250)

## Included example queries (what they do)
The SQL file contains ready-to-run queries for common analyses. A short summary:

1. Dataset overview
   - SELECT COUNT(*) FROM netflix_db;
   - SELECT DISTINCT type FROM netflix_db;

2. Content distribution (Movies vs TV Shows)
   - COUNT grouped by `type`.

3. Rating analysis
   - Most common rating per content type using ROW_NUMBER() OVER(...) (MySQL 8+).

4. Movies by year
   - Filter `type = 'Movie'` and `release_year = <year>`.

5. Top countries
   - Uses SUBSTRING_INDEX to parse comma-separated `country` values and returns top 5 countries by content count.

6. Longest movie
   - Orders movies by the numeric part of `duration` (CAST + SUBSTRING_INDEX).

7. Recent content
   - Parses `date_added` with STR_TO_DATE and returns rows added within the last 5 years.

8. Director search
   - Filter `director LIKE '%<name>%'`.

9. TV shows with many seasons
   - Identify TV shows by `type = 'TV Show'` and a duration filter for seasons (string comparison—see notes below).

10. Genre analysis
   - Counts items per genre (basic parsing via SUBSTRING_INDEX / grouped by the listed_in value).

11. India content analysis
   - Counts and computes release proportions for entries where country = 'India'.

12. Documentary filter
   - WHERE listed_in LIKE '%documentaries%'.

13. Missing data check
   - Identify rows where `director` is NULL.

## Notes & recommendations
- Date parsing: the script assumes `date_added` values use the format '%M %e, %Y' (e.g., 'September 9, 2019'). If your data uses a different format, update STR_TO_DATE calls.
- Multi-valued columns: `country`, `cast`, `director`, and `listed_in` are stored as comma-separated strings in this schema. For robust analysis consider normalizing these into separate relationship tables.
- Duration parsing: the script extracts the leading numeric token from `duration` (SUBSTRING_INDEX) and casts it to an integer for sorting. Duration strings must be consistent (e.g., '90 min' or '2 Seasons').
- MySQL version: ROW_NUMBER() and window functions require MySQL 8+. If using older MySQL, rework those queries using GROUP BY + aggregate logic.

## Suggested indexes (add after loading data for better performance)
ALTER TABLE netflix_db
  ADD INDEX idx_type (type),
  ADD INDEX idx_release_year (release_year),
  ADD INDEX idx_country (country(50)),
  ADD INDEX idx_director (director(100)),
  ADD INDEX idx_rating (rating);

Index prefix lengths may be necessary for long text columns (MySQL index length limits).

## Common modifications
- Filter by year: change the WHERE clause on `release_year`.
- Filter by country: `WHERE country LIKE '%India%'` or normalize countries first.
- Multiple directors: use `director LIKE '%Name1%' OR director LIKE '%Name2%'` or normalize directors into a join table.

## Troubleshooting
- Queries return no results: ensure data has been imported and table/column names match.
- Date errors: verify the `date_added` format and STR_TO_DATE format string.
- Wrong LIMIT results: check data type and consistency of `release_year` and `duration`.

## Future enhancements
- Normalize multi-valued fields into join tables (countries, genres, cast, directors).
- Add views for frequently used analytics.
- Create stored procedures to encapsulate complex parsing logic.
- Add unit tests / CI that validate the SQL on a small sample dataset.

## License
This project is provided for educational purposes. No warranty is provided. You may reuse and adapt the SQL code in your own projects.

---

If you'd like, I can:
- Normalize the schema into a 3NF design and update the SQL file.
- Add example CSV import commands specific to a sample dataset.
- Create a small sample dataset and a SQL-based test suite.

