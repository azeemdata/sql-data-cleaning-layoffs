# SQL Data Cleaning – Global Layoffs Dataset

## 📌 Overview
This project focuses on cleaning and preparing a global layoffs dataset using SQL. The aim was to transform raw, inconsistent data into a clean, analysis-ready table suitable for further exploration and reporting.

## 🛠 Tools Used
- **SQL** (MySQL / SQL Server)

## 📊 Dataset
- ~1,000 rows  
- 9 columns including company, industry, country, funding stage, dates, and layoff metrics  

## 🔧 Key Data Cleaning Steps
- Removed duplicate records using **window functions**
- Standardised inconsistent categorical values (company names, industries, countries)
- Identified and handled **NULL** and blank values
- Imputed missing data using **self-joins**
- Converted text-based date fields into **DATE** format
- Created a clean **staging table** ready for analysis

## ✅ Skills Demonstrated
- SQL data cleaning and validation  
- Window functions  
- Joins and self-joins  
- Date transformations  
- Writing clear, reusable SQL queries

- ## 📂 Project Files
- [Data Cleaning SQL Script](sql/data_cleaning.sql)
