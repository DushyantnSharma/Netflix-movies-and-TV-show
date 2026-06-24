CREATE DATABASE netflix;
USE netflix;


CREATE TABLE netflix_db(
show_id VARCHAR(6),
type VARCHAR(10),	
title VARCHAR(150),	
director VARCHAR(209),	
cast VARCHAR(1000),
country VARCHAR(150),	
date_added VARCHAR(50),	
release_year INT,	
rating VARCHAR(10),	
duration VARCHAR(15),	
listed_in VARCHAR(100),	
description VARCHAR(250)
);

SELECT * FROM netflix_db;

## How many ROWS are avaliable in this dataset 
SELECT COUNT(*) FROM netflix_db;

## How many differenat type of contant be have
SELECT DISTINCT type FROM netflix_db;


## 1. Count the number of Movies vs TV Shows
 
SELECT DISTINCT type, 
COUNT(type) AS Total_number
FROM netflix_db
GROUP BY type;

## 2. Find the most common rating for movies and TV shows
SELECT type, rating, total_count
FROM (SELECT type, rating, COUNT(*) AS total_count,
ROW_NUMBER() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
FROM netflix_db
WHERE rating IS NOT NULL AND rating != ''
GROUP BY type, rating ) AS rank_rating
WHERE ranking = 1;


## 3. List all movies released in a specific year (e.g., 2020)
 SELECT show_id, type , title, release_year
 FROM netflix_db
 WHERE type = 'Movie' AND release_year = 2020;

# 4. Find the top 5 countries with the most content on Netflix

SELECT TRIM(SUBSTRING_INDEX(country, ',', 1)) AS country_name, COUNT(*) AS total_content
FROM netflix_db
WHERE country IS NOT NULL AND country != ''
GROUP BY country_name
ORDER BY total_content DESC
LIMIT 5;


## 5. Identify the longest movie

SELECT * FROM netflix_db
WHERE type = 'Movie' 
ORDER BY CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED ) DESC; 

# 6. Find content added in the last 5 years

SELECT * FROM netflix_db
WHERE STR_TO_DATE(date_added, '%M %e, %Y') >= CURRENT_DATE() - INTERVAL 5 YEAR;

## 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT * FROM netflix_db
WHERE director LIKE '%Rajiv Chilaka%'; 

# 8. List all TV shows with more than 5 seasons

SELECT * FROM netflix_db
WHERE type = 'TV Show' AND duration > '5 Season'; 

# 9. Count the number of content items in each genre

SELECT SUBSTRING_INDEX(listed_in, ' ', 1) AS Genre , COUNT(*) AS Total_content 
FROM netflix_db
Group by listed_in
ORDER BY Total_content DESC;

#10.Find each year and the average numbers of content release in India on netflix. return top 5 year with highest avg content release

 SELECT country, release_year, COUNT(show_id) AS total_content, 
 ROUND(COUNT(show_id) / (SELECT COUNT(show_id) FROM netflix_db WHERE country = 'India')* 100, 2) AS avg_release
 FROM netflix_db
 WHERE country = 'India'
 GROUP BY country, release_year 
 ORDER BY total_content DESC
 LIMIT 5;

##11. List all movies that are documentaries

SELECT * FROM netflix_db
WHERE listed_in LIKE '%documentaries%';

##12. Find all content without a director

SELECT * FROM netflix_DB
WHERE director IS NULL;

