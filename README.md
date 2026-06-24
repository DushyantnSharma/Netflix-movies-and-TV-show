 Netflix SQL Database Analysis

Overview

This SQL file provides a complete database setup and analysis queries for Netflix content. It creates a netflix database with a table containing information about movies and TV shows available on Netflix, along with 12 pre-built analytical queries to extract insights from the data.

Prerequisites


MySQL Server (or compatible SQL database)
Basic SQL knowledge
Access to execute DDL (Data Definition Language) statements


Database Setup

Database Creation

sqlCREATE DATABASE netflix;
USE netflix;

Table Schema

The netflix_db table contains the following columns:

ColumnData TypeDescriptionshow_idVARCHAR(6)Unique identifier for each showtypeVARCHAR(10)Content type: 'Movie' or 'TV Show'titleVARCHAR(150)Title of the contentdirectorVARCHAR(209)Director(s) of the contentcastVARCHAR(1000)Cast memberscountryVARCHAR(150)Country/countries where content was produceddate_addedVARCHAR(50)Date the content was added to Netflixrelease_yearINTYear the content was releasedratingVARCHAR(10)Content rating (e.g., PG, R, 13+, etc.)durationVARCHAR(15)Duration in minutes (for movies) or seasons (for TV shows)listed_inVARCHAR(100)Genre/category classificationdescriptionVARCHAR(250)Brief description of the content

Included Queries

1. Dataset Overview


Count total rows in dataset
Identify distinct content types


2. Content Distribution (Query #1)


Count Movies vs TV Shows
Groups content by type with totals


3. Rating Analysis (Query #2)


Finds the most common rating for each content type
Uses window functions (ROW_NUMBER) for ranking


4. Movies by Year (Query #3)


Lists all movies released in a specific year (example: 2020)
Easy to modify for different years


5. Top Countries (Query #4)


Identifies top 5 countries with the most Netflix content
Handles comma-separated country values using SUBSTRING_INDEX


6. Longest Movie (Query #5)


Finds the movie with the maximum duration
Extracts numeric duration value for proper sorting


7. Recent Content (Query #6)


Finds all content added in the last 5 years
Uses date calculations and string parsing


8. Director Search (Query #7)


Lists all movies/TV shows by a specific director
Example: Rajiv Chilaka


9. TV Show Seasons (Query #8)


Lists TV shows with more than 5 seasons


10. Genre Analysis (Query #9)


Counts content items in each genre
Orders results by popularity


11. India Content Analysis (Query #10)


Shows content release trends for India
Returns top 5 years by release count
Includes percentage calculations


12. Documentary Filter (Query #11)


Lists all movies that are classified as documentaries


13. Missing Data Check (Query #12)


Identifies content without director information


How to Use


Setup the Database:


sql   -- Run the entire script or just the CREATE statements
   mysql -u username -p < NETFLIX_SQL.sql


Load Your Data:

Insert your Netflix dataset into the netflix_db table using INSERT statements or LOAD DATA INFILE



Run Individual Queries:

Execute any of the pre-built queries to analyze different aspects of the data
Modify query parameters (e.g., year, director name, etc.) as needed



Customize Queries:

Adapt the WHERE clauses to filter for specific countries, years, or ratings
Combine queries to create more complex analyses





Important Notes


Data Format Issues: The date_added column uses string format ('%M %e, %Y'). Ensure your data matches this format
String Parsing: Queries use SUBSTRING_INDEX and TRIM for handling comma-separated values (country, cast, etc.)
Null Handling: Several queries check for NULL and empty string values
Performance: For large datasets, consider adding indexes on frequently queried columns like type, release_year, and country


Recommended Indexes

For better query performance with large datasets:

sqlCREATE INDEX idx_type ON netflix_db(type);
CREATE INDEX idx_release_year ON netflix_db(release_year);
CREATE INDEX idx_country ON netflix_db(country);
CREATE INDEX idx_director ON netflix_db(director);
CREATE INDEX idx_rating ON netflix_db(rating);

Sample Modifications

Find Movies Released in 2022

sqlSELECT show_id, type, title, release_year
FROM netflix_db
WHERE type = 'Movie' AND release_year = 2022;

Find Content by Multiple Directors

sqlSELECT * FROM netflix_db
WHERE director LIKE '%Director_Name1%' OR director LIKE '%Director_Name2%';

Content by Country and Year

sqlSELECT country, release_year, COUNT(*) AS content_count
FROM netflix_db
WHERE country LIKE '%India%'
GROUP BY country, release_year
ORDER BY release_year DESC;

Troubleshooting

IssueSolutionQueries return no resultsCheck that data has been imported into the tableDate-related errorsVerify date_added format matches '%M %e, %Y'Incorrect LIMIT resultsEnsure release_year or duration values are numeric/properly formattedEmpty director resultsCheck for NULL values and proper wildcard usage in LIKE clauses

Future Enhancements


Add more sophisticated genre analysis (handle multiple genres per content)
Implement time-series analysis for content releases
Create views for commonly used queries
Add stored procedures for complex analysis
Implement data validation and cleaning queries


License & Credits

This SQL analysis template is designed for educational and analytical purposes on Netflix content metadata.
