# SQL Data Cleaning – Global Layoffs Dataset
Overview

This project focuses on cleaning and preparing a global layoffs dataset for analysis using SQL. The goal was to transform raw, inconsistent data into a reliable, analysis-ready table that can be reused for further exploration and reporting.

Tools Used

SQL (MySQL / SQL Server)

Dataset

~1,000 rows

9 columns covering company, industry, country, funding stage, dates, and layoff metrics

Key Steps

Removed duplicate records using window functions

Standardised inconsistent categorical values (company names, industries, countries)

Identified and handled NULL and blank values

Imputed missing data using self-joins where appropriate

Converted text-based date fields into DATE format

Created a clean staging table ready for analysis

Skills Demonstrated

Data cleaning and validation

SQL window functions

Joins and self-joins

Date handling and transformations

Writing reusable, readable SQL
