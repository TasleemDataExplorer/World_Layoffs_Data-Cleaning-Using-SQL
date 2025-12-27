											
                                            #Removing Duplicates#
select *
from layoffs;

CREATE TABLE layoffs_staging
like layoffs;

Insert into layoffs_staging
Select *
FROM layoffs;

Select *
FROM layoffs_staging;

select * ,
Row_number () over( partition by company,location, industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
from layoffs_staging;

with cte_duplicate as
(
select * ,
Row_number () over( partition by company,location, industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
from layoffs_staging
)
select *
from cte_duplicate
where row_num >1;

CREATE TABLE `layoffs_staging_remodup`
 (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from layoffs_staging_remodup;

insert into layoffs_staging_remodup
select * ,
Row_number () over( partition by company,location, industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
from layoffs_staging;

select *
from layoffs_staging_remodup
where row_num> 1;

DELETE
from layoffs_staging_remodup
where row_num> 1;

												#Standardizing the Data
#TRIM METHOD
select *
from layoffs_staging_remodup;

select distinct company
from layoffs_staging_remodup
order by 1;

select distinct company, trim(company)
from layoffs_staging_remodup
order by 1;

update layoffs_staging_remodup
set company= trim(company)
;

SELECT DISTINCT location
FROM layoffs_staging_remodup
ORDER BY 1;

select distinct industry
from layoffs_staging_remodup
order by 1;

select *
from layoffs_staging_remodup
where industry like 'crypto%'
;

update layoffs_staging_remodup
set industry = 'Crypto'
where industry like 'crypto%'
;

select distinct country
from layoffs_staging_remodup
order by 1;

select distinct country, trim(trailing '.' from country)
from layoffs_staging_remodup
order by 1;

update layoffs_staging_remodup
set country = 'United States'
where country like 'United States%'
;

#To Convert DATE from TEXT to TIME SERIES#

select *
from layoffs_staging_remodup;

select `date`,
str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_staging_remodup;

update layoffs_staging_remodup
set `date`= str_to_date(`date`, '%m/%d/%Y')
;

alter table layoffs_staging_remodup
modify column `date` DATE;


# TO REMOVE NULL AND BLANKS OR POPULATE THE NULLS

select total_laid_off
from layoffs_staging_remodup
where total_laid_off = ' ' 
or total_laid_off is null;

select *
from layoffs_staging_remodup
where total_laid_off is null
and percentage_laid_off is null
;

update layoffs_staging_remodup
set `industry` = 'Null'
where industry like ' '
;

select *
from layoffs_staging_remodup
Where industry is null
OR industry =''
;

select *
from layoffs_staging_remodup
Where company = 'Airbnb';

select *
from layoffs_staging_remodup
Where company = 'Carvana'
;

select * 
from layoffs_staging_remodup as t1
join layoffs_staging_remodup as t2
	on t1.company= t2.company
    and t1.location = t2.location
where (t1.industry is null or t1.industry='')
and t2.industry is not null
;

update layoffs_staging_remodup
set industry= null
where industry = '';

update layoffs_staging_remodup as t1
join layoffs_staging_remodup as t2
	on t1.company= t2.company
    and t1.location = t2.location
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;

#Delete Unwanted Rows

select *
from layoffs_staging_remodup;

select *
from layoffs_staging_remodup
where total_laid_off is null
and percentage_laid_off is null;

delete
from layoffs_staging_remodup
where total_laid_off is null
and percentage_laid_off is null;

#To Remove Unwanted Rows

alter table layoffs_staging_remodup
drop column row_num;