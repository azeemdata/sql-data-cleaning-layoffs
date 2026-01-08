/* =========================================================
   SQL DATA CLEANING – GLOBAL LAYOFFS DATASET
   Author: Azeem
   Table: layoffs (raw)
   Output: layoffs_staging2 (clean)
   ========================================================= */

-- Quick view of raw data
SELECT *
FROM layoffs;


/* =========================================================
   0) CREATE STAGING TABLE (KEEP RAW TABLE UNTOUCHED)
   ========================================================= */

DROP TABLE IF EXISTS layoffs_staging;

CREATE TABLE layoffs_staging LIKE layoffs;

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;


/* =========================================================
   1) REMOVE DUPLICATES
   - Create a new staging table with a row number
   - Delete rows where row_num > 1
   ========================================================= */

DROP TABLE IF EXISTS layoffs_staging2;

CREATE TABLE layoffs_staging2 (
  company TEXT,
  location TEXT,
  industry TEXT,
  total_laid_off INT DEFAULT NULL,
  percentage_laid_off TEXT,
  `date` TEXT,
  stage TEXT,
  country TEXT,
  funds_raised_millions INT DEFAULT NULL,
  row_num INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging2
SELECT
  company,
  location,
  industry,
  total_laid_off,
  percentage_laid_off,
  `date`,
  stage,
  country,
  funds_raised_millions,
  ROW_NUMBER() OVER(
    PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
    ORDER BY company
  ) AS row_num
FROM layoffs_staging;

-- Check duplicates (should show rows before deletion)
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- Delete duplicates
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

-- Re-check duplicates (should return 0 rows)
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;


/* =========================================================
   2) STANDARDISE DATA
   - Trim whitespace
   - Normalise industry values
   - Fix country formatting
   - Convert date from text to DATE
   ========================================================= */

-- Remove leading/trailing spaces in company names
UPDATE layoffs_staging2
SET company = TRIM(company);

-- Standardise industry: CryptoCurrency / Crypto Currency / Crypto -> Crypto
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Fix country formatting: remove trailing '.' from United States.
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Convert date text to DATE format
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


/* =========================================================
   3) HANDLE NULL / BLANK VALUES
   - Convert blanks to NULL
   - Fill missing industry using self-join
   - Remove rows missing both layoff metrics
   ========================================================= */

-- Convert blank industry values to NULL
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Fill missing industry values using other rows from same company + location
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
  ON t1.company = t2.company
 AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;

-- Delete rows where both layoff metrics are NULL
DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;


/* =========================================================
   4) REMOVE UNNECESSARY COLUMNS
   - row_num is only needed for duplicate removal
   ========================================================= */

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;


-- Final cleaned table preview
SELECT *
FROM layoffs_staging2;
