This repository contains a collection of labs from the Databases 2 module in my third year of Computer Science at TU Dublin. 

Each lab focuses on essential topics in database design, advanced SQL techniques, query optimization, and data structuring using PostgreSQL. 

# Lab Summaries 

### Lab 1: Relational Database Design
Explored core concepts in database modeling, including entity-relationship (ER) diagrams, relational modeling, and the physical implementation of these models in PostgreSQL.

1. **Database Modeling for Toys**: Developed a storage model for various toy types (e.g., toy cars vs. toy teddies), balancing ease of use, performance, and storage efficiency. Implemented and tested the model in PostgreSQL.
2. **Entity Relationship Modeling**: Examined different relationship types between two entities and implemented tables with varying constraints and keys.
3. **Cinema Booking System Database Design**: Designed a relational database model for a cinema booking system, covering entities like cinemas, movies, screens, customers, and bookings. The solution was implemented in PostgreSQL with the necessary tables and relationships.

### Lab 2: Advanced SQL Queries and Data Analysis
Practiced data import and performed advanced SQL queries using window functions to analyze datasets for athletics and stock market data.

1. **Paris 2024 Athletics Results**: Imported athletics event data from CSV, generated rankings, analyzed Irish athlete performance, and developed a medal table comparing the EU and USA.
2. **Stock Market Data Analysis**: Loaded stock data, calculated 5-day moving averages, identified minimum/maximum prices per stock, and tracked the top-performing stock by percentage in 2019. Also, computed monthly gains and daily stock changes.

### Lab 3: Triggers in PostgreSQL
Implemented database triggers for data validation and automation, applying them in soccer match and medical records databases to ensure data integrity and automation.

1. **Soccer League Database**: Built tables for teams, matches, and league standings, adding triggers for logging team entries, validating team country, limiting match entries per team, and auto-updating the league table after each match.
2. **Medical Records Database**: Developed triggers to auto-calculate BMI on record creation/update and set up a versioning trigger to archive patient details for historical records after each update.

### Lab 4: Database Normalization
Focused on transforming data structures to meet the principles of normalization (1NF, 2NF, 3NF) for more efficient storage and enhanced data consistency.

1. **Art Gallery Data Normalization**: Transformed an art gallery database for storing customer transactions into a normalized structure, reducing redundancy while maintaining data integrity.
2. **Student Applications Database**: Normalized a denormalized student applications table, implementing a structure in 3NF, and compared storage efficiency improvements post-normalization in PostgreSQL.

### Lab 5: Indexes and Tree Structures
Examined B-tree indexing and data structures, focusing on the role of balanced trees in efficient data retrieval.

1. **B-tree Insertion**: Simulated B-tree insertions to maintain a balanced structure, observing the implications for query performance.
2. **Ordered Tree Insertion**: Compared simple ordered tree insertions (without balancing) to B-trees, examining how balanced versus unbalanced structures impact efficiency.
3. **B-tree Analysis**: Analyzed storage and retrieval differences between balanced B-trees and simple ordered trees, highlighting the advantages of indexing for large datasets.