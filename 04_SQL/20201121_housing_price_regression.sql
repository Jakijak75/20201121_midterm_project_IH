# 4.Select all the data from table house_price_data to check if the data was imported correctly
SELECT * FROM house_pricing_data; #looks good

# 5. Use the alter table command to drop the column date from the database, as we would not use it in the analysis with SQL. Select all the data from the table to verify if the command worked. Limit your returned results to 10.
ALTER TABLE house_pricing_data DROP COLUMN date;
SELECT * FROM house_pricing_data
LIMIT 10; #works

# 6.Use sql query to find how many rows of data you have .
SELECT COUNT(*)
FROM house_pricing_data; #table has 21597 rows

# 7.Now we will try to find the unique values in some of the categorical columns:

	#What are the unique values in the column bedrooms?
	SELECT DISTINCT(bedrooms)
	FROM house_pricing_data;
	#What are the unique values in the column bathrooms?
	SELECT DISTINCT(bathrooms)
	FROM house_pricing_data;
	#What are the unique values in the column floors?
	SELECT DISTINCT(floors)
	FROM house_pricing_data;
	#What are the unique values in the column condition?
	SELECT DISTINCT(`condition`)
	FROM house_pricing_data; #had to use back quotes `` here because I was getting an error, the column name being also an SQL keyword
	#What are the unique values in the column grade?
	SELECT DISTINCT(grade)
	FROM house_pricing_data;
	
# 8.Arrange the data in a decreasing order by the price of the house. Return only the IDs of the top 10 most expensive houses in your data.
SELECT id FROM house_pricing_data
ORDER BY price DESC
LIMIT 10; 

# 9.What is the average price of all the properties in your data?
SELECT AVG(price) as avg_price
FROM house_pricing_data; #average price is 540296.5735

# 10.In this exercise we will use simple group by to check the properties of some of the categorical variables in our data

	#What is the average price of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the prices. Use an alias to change the name of the second 	column.
	SELECT bedrooms, AVG(price) as avg_price
	FROM house_pricing_data
	GROUP BY bedrooms
	ORDER BY avg_price DESC; #fun fact: we have just demonstrated that the record with 33 bedrooms (and possibly the one with 11 bedrooms) are outliers. We should probably remove them in our model.
	
	#What is the average sqft_living of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the sqft_living. Use an alias to change the name of 	the second column.
	SELECT bedrooms, AVG(sqft_living) as avg_living
	FROM house_pricing_data
	GROUP BY bedrooms
	ORDER BY avg_living DESC;
	
	#What is the average price of the houses with a waterfront and without a waterfront? The returned result should have only two columns, waterfront and Average of the prices. Use an alias to 		change the name of the second column.
	SELECT waterfront, AVG(price) as avg_price
	FROM house_pricing_data
	GROUP BY waterfront
	ORDER BY avg_price DESC;
	
	#Is there any correlation between the columns condition and grade? You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. 			Visually check if there is a positive correlation or negative correlation or no correlation between the variables.
	SELECT grade, AVG(`condition`) as avg_condition
	FROM house_pricing_data
	GROUP BY grade
	ORDER BY grade; #there is no correlation at all: looks like the grading system does not take the condition into account
	
# 11. One of the customers is only interested in the following houses:

	#Number of bedrooms either 3 or 4, Bathrooms more than 3, One Floor, No waterfront, Condition should be 3 at least, Grade should be 5 at least, Price less than 300000, For the rest of the 		things, they are not too concerned. Write a simple query to find what are the options available for them?
	
	SELECT * FROM house_pricing_data
	WHERE 
		bedrooms IN (3,4) AND 
		bathrooms >= 3 AND
		floors = 1 AND
		waterfront = 0 AND
		`condition` >= 3 AND
		grade >= 5 AND
		price < 300000
	ORDER BY price DESC; #ok
	
# 12. Your manager wants to find out the list of properties whose prices are twice more than the average of all the properties in the database. Write a query to show them the list of such properties. You might need to use a sub query for this problem.

SELECT * FROM house_pricing_data 	
WHERE price > 2*( 
	SELECT AVG(price) as avg_price
	FROM house_pricing_data); #1246 properties correspond to this criterion
	
# 13. Since this is something that the senior management is regularly interested in, create a view of the same query.

CREATE VIEW double_avg_price AS
SELECT * FROM house_pricing_data 	
WHERE price > 2*( 
	SELECT AVG(price) as avg_price
	FROM house_pricing_data);

# 14. Most customers are interested in properties with three or four bedrooms. What is the difference in average prices of the properties with three and four bedrooms?

SELECT bedrooms, AVG(price) as avg_price 
FROM house_pricing_data
WHERE bedrooms IN (3,4)
GROUP BY bedrooms
ORDER BY avg_price DESC;

# 15. What are the different locations where properties are available in your database? (distinct zip codes)
SELECT DISTINCT zipcode
FROM house_pricing_data; #70 different zicodes

# 16. Show the list of all the properties that were renovated.

	#a. by comparing the sqft_living and sqft_lot new data to the old data  
	SELECT * FROM house_pricing_data
	WHERE sqft_living <> sqft_living15 OR sqft_lot <> sqft_lot15;
	#b. by just looking at the column yr_renovated
	SELECT * FROM house_pricing_data
	WHERE yr_renovated <> 0;

# 17. Provide the details of the property that is the 11th most expensive property in your database.

WITH cte_price_rankings as
	(
	SELECT *, RANK() OVER (ORDER BY price DESC) AS rank_price
	FROM house_pricing_data 
	)	
SELECT * FROM cte_price_rankings
WHERE rank_price = 11; #Note: couldn't use "HAVING" with RANK() for some reason



