# 🍽️ Restaurant & Consumer Data Analysis

### SQL Analysis & Business Insights using MySQL

A SQL-based data analytics project focused on analyzing restaurant performance, consumer behavior, cuisine preferences, customer ratings, and spending patterns using MySQL.

---

## 📌 Project Overview

This project transforms raw restaurant and consumer datasets into a structured relational database and uses SQL to answer real-world business questions.

The analysis covers:

- Consumer demographics and behavior
- Restaurant performance
- Cuisine preferences
- Customer ratings
- Budget-based consumer segmentation
- Restaurant rankings
- Cuisine analysis
- Customer engagement
- Advanced SQL analytics

The project contains **5 relational tables** and uses **MySQL** as the database engine.

---

## 🎯 Project Objectives

- Design a structured relational database
- Clean and prepare raw CSV data
- Establish relationships between multiple tables
- Analyze consumer behavior and preferences
- Evaluate restaurant performance
- Analyze ratings across restaurants and cuisines
- Solve real-world business questions using SQL
- Implement advanced SQL techniques
- Generate actionable business insights

---

## 🗂️ Database Schema

<img width="990" height="511" alt="image" src="https://github.com/user-attachments/assets/83828b34-7f57-4a8c-9c45-e8eb4b4838fc" />


The project consists of the following tables:

| Table | Description |
|---|---|
| `consumers` | Consumer demographic, lifestyle, occupation and budget information |
| `consumer_preferences` | Consumer preferred cuisine information |
| `restaurants` | Restaurant details including city, price, franchise, parking and alcohol service |
| `restaurant_cuisines` | Cuisine types served by each restaurant |
| `ratings` | Consumer ratings for restaurants including overall, food and service ratings |

## Database


- Database Name: restaurant_project
- Database Engine: MySQL
- Number of Tables: 5


## 🧠 SQL Concepts Used

- **DDL:** `CREATE DATABASE`, `CREATE TABLE`, `ALTER TABLE`
- **DML:** `SELECT`, `INSERT`
- **Filtering:** `WHERE`, `DISTINCT`
- **Sorting & Grouping:** `ORDER BY`, `GROUP BY`, `HAVING`
- **Aggregate Functions:** `AVG()`, `COUNT()`, `SUM()`, `MAX()`, `MIN()`
- **Joins:** `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`
- **Subqueries:** Nested queries and `IN` subqueries
- **Derived Tables:** Subqueries used as temporary tables
- **CTEs:** `WITH` Common Table Expressions
- **Window Functions:** `RANK()`, `DENSE_RANK()`, `ROW_NUMBER()`, `LEAD()`
- **Views:** Reusable analytical views
- **Stored Procedures:** Parameterized procedures for reusable analysis
- **Conditional Logic:** `CASE`
- **Data Transformation:** Integer division using `DIV`
- **Database Relationships:** Primary Keys and Foreign Keys
- **Relational Database Design:** Multi-table analysis and normalization

---

## 📊 Top 10 Business Questions Solved

1. Which restaurants have received highly satisfactory ratings from consumers?

2. Which restaurants have a Food Rating below the overall average Food Rating?

3. Which consumers have rated restaurants but have never rated an Italian restaurant?

4. Which restaurants serving Pizzeria cuisine are located in cities where students live?

5. What is the average age of consumers by occupation among consumers who have rated restaurants?

6. How are restaurant ratings ranked within each restaurant using window functions?

7. What are the top 3 preferred cuisines of low-budget students?

8. Which are the top 2 highest-rated restaurants for each cuisine?

9. Who are the top 5 consumers based on their average overall rating, and how many Mexican restaurants have they rated?

10. How does an individual consumer's rating compare with the overall average rating of each restaurant they rated?


