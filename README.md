# SQL Project: BikeStores Database

Welcome to my SQL project repository! This project focuses on working with the **BikeStores** database, a sample database designed to simulate the operations of a bicycle store chain. The primary goal of this project is to demonstrate various SQL skills and techniques, including database design, data querying, and data manipulation.

## Project Overview

The BikeStores database encompasses various aspects of a typical retail environment, such as:

- **Customers**: Information about customers, including their contact details and purchase history.
- **Products**: Details about the bicycles and accessories available for sale.
- **Stores**: Information about the physical store locations.
- **Sales**: Transaction data capturing customer purchases.
- **Staff**: Information about the employees working in the stores.

## Database Structure

The database consists of the following tables:

### Production Schema

- **categories**
  - `category_id`: INT, Primary Key
  - `category_name`: VARCHAR(255), NOT NULL

- **brands**
  - `brand_id`: INT, Primary Key
  - `brand_name`: VARCHAR(255), NOT NULL

- **products**
  - `product_id`: INT, Primary Key
  - `product_name`: VARCHAR(255), NOT NULL
  - `brand_id`: INT, NOT NULL, Foreign Key
  - `category_id`: INT, NOT NULL, Foreign Key
  - `model_year`: SMALLINT, NOT NULL
  - `list_price`: DECIMAL(10, 2), NOT NULL

- **stocks**
  - `store_id`: INT, Primary Key, Foreign Key
  - `product_id`: INT, Primary Key, Foreign Key
  - `quantity`: INT

### Sales Schema

- **customers**
  - `customer_id`: INT, Primary Key
  - `first_name`: VARCHAR(255), NOT NULL
  - `last_name`: VARCHAR(255), NOT NULL
  - `phone`: VARCHAR(25)
  - `email`: VARCHAR(255), NOT NULL
  - `street`: VARCHAR(255)
  - `city`: VARCHAR(50)
  - `state`: VARCHAR(25)
  - `zip_code`: VARCHAR(5)

- **stores**
  - `store_id`: INT, Primary Key
  - `store_name`: VARCHAR(255), NOT NULL
  - `phone`: VARCHAR(25)
  - `email`: VARCHAR(255)
  - `street`: VARCHAR(255)
  - `city`: VARCHAR(255)
  - `state`: VARCHAR(10)
  - `zip_code`: VARCHAR(5)

- **staffs**
  - `staff_id`: INT, Primary Key
  - `first_name`: VARCHAR(50), NOT NULL
  - `last_name`: VARCHAR(50), NOT NULL
  - `email`: VARCHAR(255), NOT NULL, UNIQUE
  - `phone`: VARCHAR(25)
  - `active`: TINYINT, NOT NULL
  - `store_id`: INT, NOT NULL, Foreign Key
  - `manager_id`: INT, Foreign Key

- **orders**
  - `order_id`: INT, Primary Key
  - `customer_id`: INT, Foreign Key
  - `order_status`: TINYINT, NOT NULL
  - `order_date`: DATE, NOT NULL
  - `required_date`: DATE, NOT NULL
  - `shipped_date`: DATE
  - `store_id`: INT, NOT NULL, Foreign Key
  - `staff_id`: INT, NOT NULL, Foreign Key

- **order_items**
  - `order_id`: INT, Primary Key, Foreign Key
  - `item_id`: INT, Primary Key
  - `product_id`: INT, NOT NULL, Foreign Key
  - `quantity`: INT, NOT NULL
  - `list_price`: DECIMAL(10, 2), NOT NULL
  - `discount`: DECIMAL(4, 2), NOT NULL, DEFAULT 0

## Key Features

- **Database Schema Design**: Understanding and analyzing the schema of the BikeStores database.
- **Data Import and Export**: Techniques for importing and exporting data to and from the database.
- **Complex Queries**: Writing complex SQL queries to extract meaningful insights from the data.
- **Data Manipulation**: Performing various data manipulation operations like INSERT, UPDATE, DELETE, and more.
- **Joins and Subqueries**: Utilizing joins and subqueries to combine and filter data from multiple tables.
- **Aggregation and Grouping**: Using aggregate functions and GROUP BY clauses to summarize data.
- **Views and Indexes**: Creating views and indexes to optimize query performance and simplify data access.
- **Stored Procedures and Functions**: Implementing stored procedures and functions for reusable and modular SQL code.
- **Data Analysis**: Performing data analysis to uncover trends and patterns in the sales data.

## Conclusion

This project showcases my proficiency in SQL and database management. By working with the BikeStores database, I have honed my skills in data querying, data manipulation, and data analysis. I hope this project serves as a valuable resource for anyone looking to learn more about SQL and database management.

Feel free to explore the repository and reach out if you have any questions or feedback!

## Contact

-- Fares Ashraf
-- 01281931001
-- fares.social41@gmail.com
-- github.com/Fares403
--linkedin.com/in/Fares403/
---

