create database restaurant_project;

USE restaurant_project;
-- Objective: 
-- =============================================================================
-- Using the WHERE clause to filter data based on specific criteria.
-- ==============================================================================

alter table consumers
change column `ï»¿Consumer_ID` Consumer_ID varchar(10);
alter table consumer_preferences
change column `ï»¿Consumer_ID` Consumer_ID varchar(10);

-- 1.List all details of consumers who live in the city of 'Cuernavaca'.
SELECT * FROM consumers
WHERE City = 'Cuernavaca';

-- 2.Find the Consumer_ID, Age, and Occupation of all consumers who are 'Students' AND are 'Smokers'.



SELECT Consumer_ID, Age, Occupation
FROM consumers
WHERE Occupation = 'Student'
AND Smoker = 'Yes';

SELECT DISTINCT Smoker FROM consumers;

-- 3.List the Name, City, Alcohol_Service, and Price of all restaurants that serve 'Wine & Beer' and have a 'Medium' price level.
SELECT Name, City, Alcohol_Service, Price
FROM restaurants
WHERE Alcohol_Service = 'Wine & Beer'
AND Price = 'Medium';

-- 4.Find the names and cities of all restaurants that are part of a 'Franchise'.
SELECT Name, City
FROM restaurants
WHERE Franchise = 'Yes';

/* 5.Show the Consumer_ID, Restaurant_ID, and Overall_Rating for 
all ratings where the Overall_Rating was 'Highly Satisfactory' 
(which corresponds to a value of 2, according to the data dictionary).*/
alter table ratings
change column `ï»¿Consumer_ID` Consumer_ID varchar(10);

SELECT Consumer_ID, Restaurant_ID, Overall_Rating
FROM ratings
WHERE Overall_Rating = 2;

-- =============================================================================
-- Questions JOINs with Subqueries
-- =============================================================================
-- 1.List the names and cities of all restaurants that have an Overall_Rating of 2 (Highly Satisfactory) from at least one consumer.

alter table restaurants
change column `ï»¿Restaurant_ID` Restaurant_ID int;
alter table restaurant_cuisines
change column `ï»¿Restaurant_ID` Restaurant_ID int;

SELECT DISTINCT r.Name, r.City
FROM restaurants r
JOIN ratings rt 
    ON r.Restaurant_ID = rt.Restaurant_ID
WHERE rt.Overall_Rating = 2;

-- 2.Find the Consumer_ID and Age of consumers who have rated restaurants located in 'San Luis Potosi'.

SELECT DISTINCT c.Consumer_ID, c.Age
FROM consumers c
JOIN ratings r 
    ON c.Consumer_ID = r.Consumer_ID
JOIN restaurants res 
    ON r.Restaurant_ID = res.Restaurant_ID
WHERE res.City = 'San Luis Potosi';

-- 3.List the names of restaurants that serve 'Mexican' cuisine and have been rated by consumer 'U1001'.
SELECT DISTINCT r.Name
FROM restaurants r
JOIN restaurant_cuisines rc 
    ON r.Restaurant_ID = rc.Restaurant_ID
JOIN ratings rt 
    ON r.Restaurant_ID = rt.Restaurant_ID
WHERE rc.Cuisine = 'Mexican'
AND rt.Consumer_ID = 'U1001';

-- 4.Find all details of consumers who prefer 'American' cuisine AND have a 'Medium' budget.
SELECT c.*
FROM consumers c
JOIN consumer_preferences cp 
    ON c.Consumer_ID = cp.Consumer_ID
WHERE cp.Preferred_Cuisine = 'American'
AND c.Budget = 'Medium';

/* 5.List restaurants (Name, City) that have received a Food_Rating 
lower than the average Food_Rating across all rated restaurants.*/
SELECT DISTINCT r.Name, r.City
FROM restaurants r
JOIN ratings rt 
    ON r.Restaurant_ID = rt.Restaurant_ID
WHERE rt.Food_Rating < (
    SELECT AVG(Food_Rating) FROM ratings
);

/* 6.Find consumers (Consumer_ID, Age, Occupation) who have rated at least one restaurant 
but have NOT rated any restaurant that serves 'Italian' cuisine.*/
SELECT DISTINCT c.Consumer_ID, c.Age, c.Occupation
FROM consumers c
JOIN ratings r 
    ON c.Consumer_ID = r.Consumer_ID
WHERE c.Consumer_ID NOT IN (
    SELECT r2.Consumer_ID
    FROM ratings r2
    JOIN restaurant_cuisines rc 
        ON r2.Restaurant_ID = rc.Restaurant_ID
    WHERE rc.Cuisine = 'Italian'
);

-- 7.List restaurants (Name) that have received ratings from consumers older than 30.
SELECT DISTINCT res.Name
FROM restaurants res
JOIN ratings r 
    ON res.Restaurant_ID = r.Restaurant_ID
JOIN consumers c 
    ON r.Consumer_ID = c.Consumer_ID
WHERE c.Age > 30;

/* 8.Find the Consumer_ID and Occupation of consumers whose preferred cuisine is 'Mexican' 
and who have given an Overall_Rating of 0 to at least one restaurant (any restaurant).*/
SELECT DISTINCT c.Consumer_ID, c.Occupation
FROM consumers c
JOIN consumer_preferences cp 
    ON c.Consumer_ID = cp.Consumer_ID
JOIN ratings r 
    ON c.Consumer_ID = r.Consumer_ID
WHERE cp.Preferred_Cuisine = 'Mexican'
AND r.Overall_Rating = 0;

/* 9.List the names and cities of restaurants that serve 'Pizzeria' cuisine 
and are located in a city where at least one 'Student' consumer lives.*/

SELECT DISTINCT r.Name, r.City
FROM restaurants r
JOIN restaurant_cuisines rc 
    ON r.Restaurant_ID = rc.Restaurant_ID
WHERE rc.Cuisine = 'Pizzeria'
AND r.City IN (
    SELECT DISTINCT City
    FROM consumers
    WHERE Occupation = 'Student'
);

/* 10.Find consumers (Consumer_ID, Age) who are 'Social Drinkers' 
and have rated a restaurant that has 'No' parking.*/
SELECT DISTINCT c.Consumer_ID, c.Age
FROM consumers c
JOIN ratings r 
    ON c.Consumer_ID = r.Consumer_ID
JOIN restaurants res 
    ON r.Restaurant_ID = res.Restaurant_ID
WHERE c.Drink_Level = 'Social Drinker'
AND res.Parking = 'No';

-- ============================================================================
-- Questions Emphasizing WHERE Clause and Order of Execution
-- ===========================================================================
/* 1.List Consumer_IDs and the count of restaurants they've rated, but only for consumers who are 'Students'. 
Show only students who have rated more than 2 restaurants.*/
SELECT c.Consumer_ID, COUNT(r.Restaurant_ID) AS total_rated
FROM consumers c
JOIN ratings r 
    ON c.Consumer_ID = r.Consumer_ID
WHERE c.Occupation = 'Student'
GROUP BY c.Consumer_ID
HAVING COUNT(r.Restaurant_ID) > 2;

/* 2.We want to categorize consumers by an 'Engagement_Score' which is their Age divided by 10 (integer division). 
List the Consumer_ID, Age, and this calculated Engagement_Score, 
but only for consumers whose Engagement_Score would be exactly 2 and who use 'Public' transportation.*/
SELECT Consumer_ID, Age, (Age DIV 10) AS Engagement_Score
FROM consumers
WHERE (Age DIV 10) = 2
AND Transportation_Method = 'Public';

/* 3.For each restaurant, calculate its average Overall_Rating. 
Then, list the restaurant Name, City, and its calculated average Overall_Rating, 
but only for restaurants located in 'Cuernavaca' AND whose calculated average Overall_Rating is greater than 1.0.*/
SELECT r.Name, r.City, AVG(rt.Overall_Rating) AS avg_rating
FROM restaurants r
JOIN ratings rt 
    ON r.Restaurant_ID = rt.Restaurant_ID
WHERE r.City = 'Cuernavaca'
GROUP BY r.Restaurant_ID, r.Name, r.City
HAVING AVG(rt.Overall_Rating) > 1.0;

/*4.Find consumers (Consumer_ID, Age) who are 'Married' and whose Food_Rating for any restaurant is equal 
to their Service_Rating for that same restaurant, but only consider ratings where the Overall_Rating was 2.*/
SELECT DISTINCT c.Consumer_ID, c.Age
FROM consumers c
JOIN ratings r 
    ON c.Consumer_ID = r.Consumer_ID
WHERE c.Marital_Status = 'Married'
AND r.Overall_Rating = 2
AND r.Food_Rating = r.Service_Rating;

/* 5.List Consumer_ID, Age, and the Name of any restaurant they rated, 
but only for consumers who are 'Employed' and have given a Food_Rating of 0 
to at least one restaurant located in 'Ciudad Victoria'.*/
SELECT DISTINCT c.Consumer_ID, c.Age, res.Name
FROM consumers c
JOIN ratings r 
    ON c.Consumer_ID = r.Consumer_ID
JOIN restaurants res 
    ON r.Restaurant_ID = res.Restaurant_ID
WHERE c.Occupation = 'Employed'
AND r.Food_Rating = 0
AND res.City = 'Ciudad Victoria';

-- ===========================================================================================
-- Advanced SQL Concepts: Derived Tables, CTEs, Window Functions, Views, Stored Procedures
-- ===========================================================================================
/* 1.Using a CTE, find all consumers who live in 'San Luis Potosi'. 
Then, list their Consumer_ID, Age, and the Name of any Mexican restaurant they have rated with an Overall_Rating of 2.*/
WITH slp_consumers AS (
    SELECT Consumer_ID, Age
    FROM consumers
    WHERE City = 'San Luis Potosi'
)
SELECT DISTINCT c.Consumer_ID, c.Age, r.Name
FROM slp_consumers c
JOIN ratings rt 
    ON c.Consumer_ID = rt.Consumer_ID
JOIN restaurants r 
    ON rt.Restaurant_ID = r.Restaurant_ID
JOIN restaurant_cuisines rc 
    ON r.Restaurant_ID = rc.Restaurant_ID
WHERE rc.Cuisine = 'Mexican'
AND rt.Overall_Rating = 2;

/* 2.For each Occupation, find the average age of consumers. 
Only consider consumers who have made at least one rating. 
(Use a derived table to get consumers who have rated).*/
SELECT Occupation, AVG(Age) AS avg_age
FROM (
    SELECT DISTINCT c.Consumer_ID, c.Age, c.Occupation
    FROM consumers c
    JOIN ratings r 
        ON c.Consumer_ID = r.Consumer_ID
) AS rated_consumers
GROUP BY Occupation;

/* 3.Using a CTE to get all ratings for restaurants in 'Cuernavaca', 
rank these ratings within each restaurant based on Overall_Rating (highest first).
 Display Restaurant_ID, Consumer_ID, Overall_Rating, and the RatingRank.*/
 WITH cuernavaca_ratings AS (
    SELECT r.Restaurant_ID, rt.Consumer_ID, rt.Overall_Rating
    FROM restaurants r
    JOIN ratings rt 
        ON r.Restaurant_ID = rt.Restaurant_ID
    WHERE r.City = 'Cuernavaca'
)
SELECT Restaurant_ID, Consumer_ID, Overall_Rating,
       RANK() OVER (PARTITION BY Restaurant_ID ORDER BY Overall_Rating DESC) AS RatingRank
FROM cuernavaca_ratings;

/* 4.For each rating, show the Consumer_ID, Restaurant_ID, Overall_Rating, 
and also display the average Overall_Rating given by that specific consumer across all their ratings.*/
SELECT Consumer_ID, Restaurant_ID, Overall_Rating,
       AVG(Overall_Rating) OVER (PARTITION BY Consumer_ID) AS avg_consumer_rating
FROM ratings;

/* 5.Using a CTE, identify students who have a 'Low' budget. 
Then, for each of these students, list their top 3 most preferred cuisines 
based on the order they appear in the Consumer_Preferences table (assuming no explicit preference order, 
use Consumer_ID, Preferred_Cuisine to define order for ROW_NUMBER).*/
WITH low_budget_students AS (
    SELECT Consumer_ID
    FROM consumers
    WHERE Occupation = 'Student'
    AND Budget = 'Low'
),
ranked_cuisines AS (
    SELECT cp.Consumer_ID, cp.Preferred_Cuisine,
           ROW_NUMBER() OVER (
               PARTITION BY cp.Consumer_ID 
               ORDER BY cp.Preferred_Cuisine
           ) AS rn
    FROM consumer_preferences cp
    JOIN low_budget_students s 
        ON cp.Consumer_ID = s.Consumer_ID
)
SELECT Consumer_ID, Preferred_Cuisine
FROM ranked_cuisines
WHERE rn <= 3;

/* 6.Consider all ratings made by 'Consumer_ID' = 'U1008'. For each rating, show the Restaurant_ID, Overall_Rating,
 and the Overall_Rating of the next restaurant they rated (if any), 
 ordered by Restaurant_ID (as a proxy for time if rating time isn't available). 
 Use a derived table to filter for the consumer's ratings first.*/
 SELECT Restaurant_ID, Overall_Rating,
       LEAD(Overall_Rating) OVER (ORDER BY Restaurant_ID) AS next_rating
FROM (
    SELECT Restaurant_ID, Overall_Rating
    FROM ratings
    WHERE Consumer_ID = 'U1008'
) AS user_ratings;

/* 7.Create a VIEW named HighlyRatedMexicanRestaurants that shows the Restaurant_ID, 
Name, and City of all Mexican restaurants that have an average Overall_Rating greater than 1.5.*/
create view highlyratedmexicanrestaurants as
select
    r.restaurant_id,
    r.name,
    r.city
from restaurants r
join ratings rt
    on r.restaurant_id = rt.restaurant_id
join restaurant_cuisines rc
    on r.restaurant_id = rc.restaurant_id
where rc.cuisine = 'Mexican'
group by r.restaurant_id, r.name, r.city
having avg(rt.overall_rating) > 1.5;
select * from highlyratedmexicanrestaurants;

/* 8.First, ensure the HighlyRatedMexicanRestaurants view from Q7 exists. 
Then, using a CTE to find consumers who prefer 'Mexican' cuisine, list those consumers (Consumer_ID) 
who have not rated any restaurant listed in the HighlyRatedMexicanRestaurants view.*/
WITH mexican_pref_consumers AS (
    SELECT DISTINCT Consumer_ID
    FROM consumer_preferences
    WHERE Preferred_Cuisine = 'Mexican'
)
SELECT m.Consumer_ID
FROM mexican_pref_consumers m
WHERE m.Consumer_ID NOT IN (
    SELECT DISTINCT r.Consumer_ID
    FROM ratings r
    JOIN HighlyRatedMexicanRestaurants h 
        ON r.Restaurant_ID = h.Restaurant_ID
);

/* 9.Create a stored procedure GetRestaurantRatingsAboveThreshold that accepts a Restaurant_ID and a minimum Overall_Rating as input. It should return the Consumer_ID, 
Overall_Rating, Food_Rating, and Service_Rating for that restaurant 
where the Overall_Rating meets or exceeds the threshold.*/
delimiter //

create procedure GetRestaurantRatingsAboveThreshold(
    in p_restaurant_id int,
    in p_min_rating int
)
begin
    select
        consumer_id,
        overall_rating,
        food_rating,
        service_rating
    from ratings
    where restaurant_id = p_restaurant_id
      and overall_rating >= p_min_rating;
end //
delimiter ;
CALL GetRestaurantRatingsAboveThreshold(132561, 1);



/* 10.Identify the top 2 highest-rated (by Overall_Rating) restaurants for each cuisine type. 
If there are ties in rating, include all tied restaurants. Display Cuisine, Restaurant_Name, City, and Overall_Rating.*/
SELECT Cuisine, Name AS Restaurant_Name, City, Overall_Rating
FROM (
    SELECT rc.Cuisine, r.Name, r.City, rt.Overall_Rating,
           DENSE_RANK() OVER (
               PARTITION BY rc.Cuisine 
               ORDER BY rt.Overall_Rating DESC
           ) AS rnk
    FROM restaurants r
    JOIN restaurant_cuisines rc 
        ON r.Restaurant_ID = rc.Restaurant_ID
    JOIN ratings rt 
        ON r.Restaurant_ID = rt.Restaurant_ID
) ranked
WHERE rnk <= 2;

/* 11.First, create a VIEW named ConsumerAverageRatings that lists Consumer_ID and their average Overall_Rating. 
Then, using this view and a CTE, find the top 5 consumers by their average overall rating. 
For these top 5 consumers, list their Consumer_ID, their average rating, and the number of 'Mexican' restaurants they have rated.*/

CREATE VIEW ConsumerAverageRatings AS
SELECT
    Consumer_ID,
    AVG(Overall_Rating) AS Average_Rating
FROM ratings
GROUP BY Consumer_ID;

WITH TopConsumers AS (
    SELECT
        Consumer_ID,
        Average_Rating
    FROM ConsumerAverageRatings
    ORDER BY Average_Rating DESC
    LIMIT 5
)

SELECT
    tc.Consumer_ID,
    tc.Average_Rating,
    COUNT(*) AS Mexican_Restaurants_Rated
FROM TopConsumers tc
JOIN ratings r
    ON tc.Consumer_ID = r.Consumer_ID
JOIN restaurant_cuisines rc
    ON r.Restaurant_ID = rc.Restaurant_ID
WHERE rc.Cuisine = 'Mexican'
GROUP BY
    tc.Consumer_ID,
    tc.Average_Rating
ORDER BY
    tc.Average_Rating DESC;

/* 12.Create a stored procedure named GetConsumerSegmentAndRestaurantPerformance that accepts a Consumer_ID as input.

The procedure should:
Determine the consumer's "Spending Segment" based on their Budget:
'Low' -> 'Budget Conscious'
'Medium' -> 'Moderate Spender'
'High' -> 'Premium Spender'
NULL or other -> 'Unknown Budget'


For all restaurants rated by this consumer:
List the Restaurant_Name.
The Overall_Rating given by this consumer.
The average Overall_Rating this restaurant has received from all consumers (not just the input consumer).
A "Performance_Flag" indicating if the input consumer's rating for that restaurant is 'Above Average', 'At Average', or 'Below Average' compared to the restaurant's overall average rating.
Rank these restaurants for the input consumer based on the Overall_Rating they gave (highest rating = rank 1).*/

DELIMITER //

CREATE PROCEDURE GetConsumerSegmentAndRestaurantPerformance(
    IN p_Consumer_ID VARCHAR(10)
)
BEGIN

    SELECT
        c.Consumer_ID,

        CASE
            WHEN c.Budget = 'Low' THEN 'Budget Conscious'
            WHEN c.Budget = 'Medium' THEN 'Moderate Spender'
            WHEN c.Budget = 'High' THEN 'Premium Spender'
            ELSE 'Unknown Budget'
        END AS Spending_Segment,

        res.Name AS Restaurant_Name,

        r.Overall_Rating,

        AVG(rt.Overall_Rating) AS Average_Overall_Rating,

        CASE
            WHEN r.Overall_Rating > AVG(rt.Overall_Rating)
                THEN 'Above Average'
            WHEN r.Overall_Rating = AVG(rt.Overall_Rating)
                THEN 'At Average'
            ELSE 'Below Average'
        END AS Performance_Flag,

        RANK() OVER (
            ORDER BY r.Overall_Rating DESC
        ) AS Rating_Rank

    FROM consumers c

    JOIN ratings r
        ON c.Consumer_ID = r.Consumer_ID

    JOIN restaurants res
        ON r.Restaurant_ID = res.Restaurant_ID

    JOIN ratings rt
        ON r.Restaurant_ID = rt.Restaurant_ID

    WHERE c.Consumer_ID = p_Consumer_ID

    GROUP BY
        c.Consumer_ID,
        c.Budget,
        res.Name,
        r.Restaurant_ID,
        r.Overall_Rating

    ORDER BY Rating_Rank;

END //

DELIMITER ;

CALL GetConsumerSegmentAndRestaurantPerformance('U1001');

select * from consumers limit 5;

select * from restaurants limit 5;

select * from ratings limit 5;

select * from consumer_preferences limit 5;

















































