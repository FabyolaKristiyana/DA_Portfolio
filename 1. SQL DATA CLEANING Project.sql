
-- REMOVING DUPLICATES --

SELECT *
FROM layoffs;

-- RIGHT CLICK ON layoffs COPY TO CLIPBOARD then CREATE NEW STATEMENT--
CREATE TABLE `layoffs_staging` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging;

INSERT INTO layoffs_staging
SELECT *,
ROW_NUMBER () OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs;

SELECT *
FROM layoffs_staging
WHERE row_num > 1;

SELECT *
FROM layoffs_staging
WHERE company = 'Hibob';

DELETE
FROM layoffs_staging
WHERE row_num > 1;

SELECT *
FROM layoffs_staging
WHERE row_num > 1;


-- STANDARDIZING DATA --

SELECT *
FROM layoffs_staging;

SELECT DISTINCT (company)
FROM layoffs_staging;

SELECT company, trim(company)
FROM layoffs_staging;
UPDATE layoffs_staging
SET company= trim(company);

SELECT DISTINCT (industry)
FROM layoffs_staging
ORDER BY 1;
SELECT *
FROM layoffs_staging
WHERE industry LIKE 'Crypto%';
UPDATE layoffs_staging
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT *
FROM layoffs_staging
ORDER BY country;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging
ORDER BY 1;
UPDATE layoffs_staging
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT `date`, str_to_date(`date`,'%m/%d/%Y')
FROM layoffs_staging;
UPDATE layoffs_staging
SET `date`= str_to_date(`date`,'%m/%d/%Y');

ALTER TABLE layoffs_staging
MODIFY COLUMN `date` date;

-- REMOVING NULLS--

SELECT *
FROM layoffs_staging
WHERE industry IS NULL
	OR industry= '';

UPDATE layoffs_staging
SET industry = null 
WHERE industry = ''; 
    
SELECT *
FROM layoffs_staging
WHERE company = 'Airbnb';

SELECT *
FROM layoffs_staging t1
JOIN layoffs_staging t2
	ON t1.company=t2.company
    WHERE (t1.industry IS NULL OR t1.industry = '')
    AND t2.industry IS NOT NULL;
UPDATE layoffs_staging t1
JOIN layoffs_staging t2
	ON t1.company=t2.company
SET t1.industry=t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- REMOVING UNNECESARRY ROWS AND COLLUMN --
SELECT *
FROM layoffs_staging;

SELECT *
FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging
DROP COLUMN row_num;