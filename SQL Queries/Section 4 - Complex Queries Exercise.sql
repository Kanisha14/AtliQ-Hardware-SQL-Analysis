-- 1.Select all the movies with minimum and maximum release_year.Note that 
-- there can be more than one movie in min and a max year hence output rows 
-- can be more than 2
with 
	my as (select min(release_year) as min_year, 
				  max(release_year) as max_year
					 from movies)
select movie_id,title,release_year from movies, my 
where release_year in (my.min_year,my.max_year);

-- subquery answer
select * from movies where release_year in (
        (select min(release_year) from movies),
		(select max(release_year) from movies));
    
-- 2. Select all the rows from the movies table whose imdb_rating is higher 
-- than the average rating
select * from movies where imdb_rating > (select avg(imdb_rating) from movies);

-- 3. Select all Hollywood movies released after the year 2000 that made more 
-- than 500 million $ profit. Note that all Hollywood movies have 
-- millions as a unit hence you don't need to do the unit conversion. Also, you 
-- can write this query without CTE as well but you should try to write this 
-- using CTE only

with 
   profit as (select movie_id, (revenue - budget) as profit_mln from financials)
select * 
from movies m
join profit p using(movie_id)
where industry="Hollywood" and release_year>2000 and p.profit_mln>500
order by p.profit_mln;