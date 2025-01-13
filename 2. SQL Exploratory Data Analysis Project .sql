
-- EXPLORATORY DATA ANALYSIS --

SELECT *
FROM layoffs_staging;

 SELECT max(total_laid_off), max(percentage_laid_off)
 from layoffs_staging;
 
 SELECT company, country, total_laid_off
 FROM layoffs_staging
 WHERE total_laid_off > 1000
 ORDER BY 3 DESC;
 
 SELECT company, country, total_laid_off, percentage_laid_off
 FROM layoffs_staging
 WHERE percentage_laid_off = 1 AND country = 'Indonesia'
 ORDER BY total_laid_off DESC;
 
 SELECT company, SUM(total_laid_off)
 FROM layoffs_staging
 Group by company
 order by 2 desc;
 
 SELECT substring(`date`,1,7) AS `Time`, SUM(total_laid_off)
 FROM layoffs_staging
 WHERE substring(`date`,1,7) IS NOT NULL
 GROUP BY `Time` 
 ORDER BY 1 ASC;
 
 WITH Rolling_Total AS
 (SELECT substring(`date`,1,7) AS `Time`, SUM(total_laid_off) AS total_off
 FROM layoffs_staging
 WHERE substring(`date`,1,7) IS NOT NULL
 GROUP BY `Time` 
 ORDER BY 1 ASC)
 
 select `date`, total_off, SUM(total_off) OVER (ORDER BY `date`) AS Rolling_Total
 from Rolling_Total;