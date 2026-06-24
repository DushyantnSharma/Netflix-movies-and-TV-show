# Netflix Movies and TV Shows — SQL

This repository contains a SQL script (NETFLIX_SQL.sql) that creates a sample `netflix` database and a single table `netflix_db`, and includes a set of example queries to analyze a Netflix titles dataset.

## Files

- `NETFLIX_SQL.sql` — SQL script that creates the `netflix` database, the `netflix_db` table, and contains example SELECT queries and analysis examples. You can view the script here: https://github.com/DushyantnSharma/Netflix-movies-and-TV-show/blob/main/NETFLIX_SQL.sql

## Purpose

The SQL file demonstrates:
- Creating a database and table for storing Netflix titles
- Counting rows and grouping by type (Movie vs TV Show)
- Finding top ratings per type
- Filtering by release year, director, country, etc.
- Basic date and string operations (parsing `date_added`, extracting duration)

## Prerequisites

- MySQL or MariaDB server
- A SQL client (mysql CLI, MySQL Workbench, or any DB GUI)

## How to run

1. Clone the repository or download `NETFLIX_SQL.sql`.
2. Run the script against a MySQL server. Example using the mysql CLI:

```bash
mysql -u <username> -p < NETFLIX_SQL.sql
```

This will create a database named `netflix` and a table named `netflix_db`. The script only defines the table and example queries; it does not insert dataset rows. To actually run the example SELECT queries, you must first load data into the `netflix_db` table (for example, from a CSV import).

## About the table schema

The script creates the table with all columns as text (VARCHAR) except `release_year` which is an INT:

- `show_id VARCHAR(6)`
- `type VARCHAR(10)`
- `title VARCHAR(150)`
- `director VARCHAR(209)`
- `cast VARCHAR(1000)`
- `country VARCHAR(150)`
- `date_added VARCHAR(50)`
- `release_year INT`
- `rating VARCHAR(10)`
- `duration VARCHAR(15)`
- `listed_in VARCHAR(100)`
- `description VARCHAR(250)`

Notes:
- `date_added` is stored as a VARCHAR and parsed in queries with `STR_TO_DATE()`; consider storing it as DATE.
- `duration` stores values like `90 min` or `3 Seasons`; parsing numeric duration requires string operations.

## Example queries (what they do)

- Count rows: `SELECT COUNT(*) FROM netflix_db;`
- Distinct content types: `SELECT DISTINCT type FROM netflix_db;`
- Count Movies vs TV Shows:
  ```sql
  SELECT type, COUNT(*) AS Total_number
  FROM netflix_db
  GROUP BY type;
  ```
- Most common rating per type (uses window function):
  ```sql
  SELECT type, rating, total_count
  FROM (
    SELECT type, rating, COUNT(*) AS total_count,
      ROW_NUMBER() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
    FROM netflix_db
    WHERE rating IS NOT NULL AND rating != ''
    GROUP BY type, rating
  ) AS rank_rating
  WHERE ranking = 1;
  ```
- Movies released in a specific year (example 2020):
  ```sql
  SELECT show_id, type, title, release_year
  FROM netflix_db
  WHERE type = 'Movie' AND release_year = 2020;
  ```
- Top 5 countries with most content (extracts first country listed):
  ```sql
  SELECT TRIM(SUBSTRING_INDEX(country, ',', 1)) AS country_name, COUNT(*) AS total_content
  FROM netflix_db
  WHERE country IS NOT NULL AND country != ''
  GROUP BY country_name
  ORDER BY total_content DESC
  LIMIT 5;
  ```
- Longest movie by numeric value in `duration` (expects `duration` like `120 min`):
  ```sql
  SELECT * FROM netflix_db
  WHERE type = 'Movie'
  ORDER BY CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC
  LIMIT 1;
  ```
- Find content added in last 5 years (parses `date_added` using format like `September 9, 2020`):
  ```sql
  SELECT * FROM netflix_db
  WHERE STR_TO_DATE(date_added, '%M %e, %Y') >= CURRENT_DATE() - INTERVAL 5 YEAR;
  ```
- Search by director name:
  ```sql
  SELECT * FROM netflix_db
  WHERE director LIKE '%Rajiv Chilaka%';
  ```
- TV shows with more than 5 seasons (string comparison in provided script is not robust):
  ```sql
  SELECT * FROM netflix_db
  WHERE type = 'TV Show' AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;
  ```
- Count content items per genre (script groups by `listed_in` — consider splitting multiple genres first):
  ```sql
  SELECT listed_in AS genre, COUNT(*) AS total_content
  FROM netflix_db
  GROUP BY listed_in
  ORDER BY total_content DESC;
  ```
- Movies that are documentaries:
  ```sql
  SELECT * FROM netflix_db
  WHERE listed_in LIKE '%Documentaries%';
  ```
- Content without a director:
  ```sql
  SELECT * FROM netflix_db
  WHERE director IS NULL OR director = '';
  ```

## Suggested improvements

- Normalize the schema: separate tables for directors, cast, countries, and genres to avoid string parsing and improve joins/performance.
- Use appropriate column types: DATE for `date_added`, INT for season counts/durations (or separate columns for `runtime_minutes` and `seasons`).
- Load real dataset and provide sample import instructions (CSV or bulk load).
- Add constraints (primary key on `show_id`) and indexes (on `release_year`, `type`, `country`) for better query performance.

## Contributing

Contributions are welcome. If you'd like help loading a CSV file into the table, normalizing the schema, or adding more queries and visualizations, open an issue or submit a pull request.

## License

Specify a license for the repository (for example, MIT) if you want others to reuse the scripts.
