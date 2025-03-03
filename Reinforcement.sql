 use imdb;
-- 1. Count the total number of records in each table of the database.
select 
(select count(*) from director_mapping) as director_mapping,
(select count(*) from genre) as genre,
(select count(*) from movie) as movie,
(select count(*) from names) as names,
(select count(*) from ratings) as ratings,
(select count(*) from role_mapping) as role_mapping;


-- 2. Identify which columns in the movie table contain null values.
Delimiter //
SELECT GROUP_CONCAT(
    'SELECT "', COLUMN_NAME, '" AS column_name FROM movie WHERE ', COLUMN_NAME, ' IS NULL HAVING COUNT(*) > 0'
    SEPARATOR ' UNION '
) INTO @sql
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA ='imdb'  
AND TABLE_NAME = 'movie';
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt//
delimiter ;

-- 3. Determine the total number of movies released each year, and analyze how the trend changes month-wise. 
select 
    year as release_year,
    sum(case when month(date_published) = 1 then 1 else 0 end) as jan,
    sum(case when month(date_published) = 2 then 1 else 0 end) as feb,
    sum(case when month(date_published) = 3 then 1 else 0 end) as mar,
    sum(case when month(date_published) = 4 then 1 else 0 end) as apr,
    sum(case when month(date_published) = 5 then 1 else 0 end) as may,
    sum(case when month(date_published) = 6 then 1 else 0 end) as jun,
    sum(case when month(date_published) = 7 then 1 else 0 end) as jul,
    sum(case when month(date_published) = 8 then 1 else 0 end) as aug,
    sum(case when month(date_published) = 9 then 1 else 0 end) as sep,
    sum(case when month(date_published) = 10 then 1 else 0 end) as oct,
    sum(case when month(date_published) = 11 then 1 else 0 end) as nov,
    sum(case when month(date_published) = 12 then 1 else 0 end) as dece,
    count(id) as total_movies
from movie
group by release_year
order by release_year;


-- 4. How many movies were produced in either the USA or India in the year 2019?
select year,count(id) as Total_movie
from movie
where country in ('usa','india') AND year=2019;

-- 5. List the unique genres in the dataset, and count how many movies belong exclusively to one genre. 
select distinct genre from  genre;
select genre, count(movie_id) as total_movies
from (
    select genre, movie_id, 
    count(*) over (partition by movie_id) as genre_count
    from genre
) as sub_table
where genre_count = 1
group by genre;


-- 6.Which genre has the highest total number of movies produced? 
select genre,count(movie_id) as Total_movies
from genre
group by genre
order by Total_movies desc
limit 1;

-- 7.Calculate the average movie duration for each genre.
select g.genre,
round(avg(m.duration),2) as Average_duartion
from genre g
inner join movie m
on g.movie_id = m.id
group by g.genre;

-- 8.Identify actors or actresses who have appeared in more than three movies with an average rating below 5.
select n.name, rm.category, 
count(rm.movie_id) as total_movies, 
round(avg(r.avg_rating),2) as avg_rating
from role_mapping rm
inner join ratings r on rm.movie_id = r.movie_id
inner join names n on rm.name_id = n.id
where r.avg_rating < 5
group by n.name, rm.category
having count(rm.movie_id) > 3
order by avg_rating;



-- 9. Find the minimum and maximum values for each column in the ratings table, excluding the movie_id column.
select min(avg_rating) as min_avg_rating,
max(avg_rating) as max_avg_rating,
min(total_votes) as min_total_values,
max(total_votes) as max_total_values,
min(median_rating) as min_median_rating,
max(median_rating) as max_median_rating
from ratings;

-- 10.Which are the top 10 movies based on their average rating? 
select m.title,r.avg_rating
from movie m
inner join ratings r
on m.id = r.movie_id
order by avg_rating desc
limit 10;

-- 11. Summarize the ratings table by grouping movies based on their median ratings. 
select * from ratings;
select median_rating ,
count(movie_id) as Total_movies,
sum(total_votes) as Total_votes,
round(avg(avg_rating),2) as average_rating
from ratings
group by median_rating
order by median_rating;

-- 12.How many movies, released in March 2017 in the USA within a specific genre, had more than 1,000 votes?    
select g.genre,count(m.id) as Total_movies from movie m
inner join genre g on m.id = g.movie_id
inner join ratings r on m.id = r.movie_id
where m.year = 2017 and 
month(m.date_published)= 3 and 
m.country = 'usa' And
r.total_votes > 1000
group by g.genre
order by Total_movies desc;

-- 13.Find movies from each genre that begin with the word “The” and have an average rating greater than 8.
select m.title,g.genre,r.avg_rating
from movie m
inner join genre g on m.id=g.movie_id
inner join ratings r on m.id = r.movie_id
where m.title like 'The%' and r.avg_rating > 8
order by genre;

-- 14. Of the movies released between April 1, 2018, and April 1, 2019, how many received a median rating of 8?
select count(m.id) as Total_movie
from movie m
inner join ratings r on m.id = r.movie_id
where m.date_published between '2018-04-01' AND '2019-04-01'
And r.median_rating = 8;

-- 15. Do German movies receive more votes on average than Italian movies? 
with language_votes as (
   select 
        case 
            when languages like '%german%' then 'german'
            when languages like '%italian%' then 'italian'
            else languages 
        end as search_language,
        avg(r.total_votes) as avg_votes
    from movie m
    join ratings r on m.id = r.movie_id
    where languages like '%german%' or languages like '%italian%'
    group by search_language
)
select 
    case 
        when (select avg_votes from language_votes where search_language = 'german') >
             (select avg_votes from language_votes where search_language = 'italian') 
        then 'german movies receive more votes on average'
        when (select avg_votes from language_votes where search_language = 'german') <
             (select avg_votes from language_votes where search_language = 'italian') 
        then 'italian movies receive more votes on average'
        else 'both languages have the same average votes'
    end as comparison_result;

-- 16. Identify the columns in the names table that contain null values.
Delimiter //
SELECT GROUP_CONCAT(
    'SELECT "', COLUMN_NAME, '" AS column_name FROM names WHERE ', COLUMN_NAME, 
    ' IS NULL HAVING COUNT(*) > 0'
    SEPARATOR ' UNION '
) INTO @sql
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA ='imdb'  
AND TABLE_NAME = 'names';
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt//
Delimiter ;

-- 17. Who are the top two actors whose movies have a median rating of 8 or higher?
select n.name,rm.category,
count(r.movie_id) as count_of_movies
from names n
inner join role_mapping rm on n.id = rm.name_id
inner join ratings r on rm.movie_id = r.movie_id
where rm.category='actor' AND r.median_rating >= 8
group by rm.category,n.name
order by count_of_movies desc
limit 2;

-- 18. Which are the top three production companies based on the total number of votes their movies received?
select m.production_company,sum(r.total_votes) as Total_votes
from  movie m
inner join ratings r on m.id = r.movie_id
group by m.production_Company
order by Total_votes desc
limit 3;

-- 19. How many directors have worked on more than three movies? 
select count(*) as director_count
from (select n.name
from names n
inner join director_mapping dm on n.id = dm.name_id
group by n.name
having count(dm.movie_id) > 3) as subquery;

-- 20. Calculate the average height of actors and actresses separately. 
select rm.category,avg(n.height) as Avg_height
from names n
inner join role_mapping rm on n.id = rm.name_id
group by category;

-- 21. List the 10 oldest movies in the dataset along with their title, country, and director. 
select m.title,m.date_published,m.country,n.name as director
from movie m
inner join director_mapping dm on m.id = dm.movie_id
inner join names n on dm.name_id = n.id
order by m.date_published
limit 10;

-- 22. List the top 5 movies with the highest total votes, along with their genres. 
select m.title,group_concat(g.genre separator ',') as genres,
r.total_votes
from movie m
inner join genre g on m.id = g.movie_id
inner join ratings r on m.id = r.movie_id
group by m.title, r.total_votes
order by r.total_votes desc
limit 5;

-- 23. Identify the movie with the longest duration, along with its genre and production company. 
select m.title, m.duration, 
group_concat(g.genre separator ', ') as genres, 
m.production_company
from movie m
inner join genre g on m.id = g.movie_id
where m.duration = (select max(duration) from movie)
group by m.title, m.duration, m.production_company;

-- 24. Determine the total number of votes for each movie released in 2018. 
select m.title, sum(r.total_votes) as total_votes
from movie m
inner join ratings r on m.id = r.movie_id
where m.year = 2018
group by m.title
order by total_votes desc;

-- 25. What is the most common language in which movies were produced? 
select languages, count(id) as total_movies
from movie
group by languages
order by total_movies desc
limit 1;