-- 1. Show all the movies with their language names
select title, l.name from movies m
	join languages l
    using (language_id);

-- 2. Show all Telugu movie names (assuming you don't know the language id for Telugu)
select title, l.name from movies m
	join languages l
    using (language_id)
    where l.name = "Telugu";

-- 3. Show the language and number of movies released in that language
select l.name, count(distinct m.title) as movie_count from movies m
	join languages l
    using (language_id)
    group by l.name;

-- 4. Generate a report of all 
	-- Hindi movies 
    -- revenue amount in millions descending. 
    -- Print movie name, revenue, currency, and unit
select m.title, 
	CASE when unit = "Billions" then round((revenue*1000),1)
		 when unit = "Thousands" then round((revenue/1000),1)
         when unit = "Millions" then round(revenue,1)
    END AS revenue_mln ,currency, 'Million' as Unit
from movies m
join financials f
using(movie_id)
order by revenue_mln DESC;
