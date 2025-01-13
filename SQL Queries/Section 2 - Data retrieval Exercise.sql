SELECT * FROM MOVIES;

-- 1. Print all movie titles and release year for all Marvel Studios movies.
SELECT title, release_year FROM movies where studio="Marvel Studios";

-- 2. Print the year when the movie "The Godfather" was released.
select release_year from movies where title="The Godfather";

-- 3. Print all movies that have Avenger in their name.
select * from movies where title like "%Avenger%";

-- 4. Print all distinct movie studios in the Bollywood industry.
select distinct studio from movies where industry = "Bollywood";

-- 5. Print all movies in the order of their release year (latest first)
select * from movies order by release_year Desc;

-- 6. All movies released in the year 2022
select * from movies where release_year=2022;

-- 7. Now all the movies released after 2020
select * from movies where release_year>2020;

-- 8. All movies after the year 2020 that have more than 8 rating
select * from movies where release_year>2020 and imdb_rating>8.0;

-- 9. Select all movies that are by Marvel studios and Hombale Films
select * from movies where studio="Marvel studios" or studio="Hombale Films";

-- 10. Select all THOR movies by their release year
select * from movies where title like "%THOR%" order by release_year;

-- 11. Select all movies that are not from Marvel Studios
select * from movies where studio != "Marvel studios";

-- 12. How many movies were released between 2015 and 2022
select count(*) from movies where release_year between 2015 and 2022;

-- 13. Print the max and min movie release year
select min(release_year) as MinYear, max(release_year) as MaxYear
	   from movies;

-- 14. Print a year and how many movies were released in that year starting with the latest year
select release_year, count(title) as TotalMovies
	   from movies group by release_year order by TotalMovies Desc;
       
-- 15.  Print profit % for all the movies