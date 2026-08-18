create database job_market ;
use job_market;

select * from salaries;

select count(*) from salaries;

-- ** 10 Buisness Questions JOb Markect Project ** --

-- Q1) What is the average salary for each experience level, from highest to lowest? --

select experience_level, 
round(avg(salary_in_usd),0) as avg_salary,
count(*) job_count
from salaries
group by experience_level
order by avg_salary desc;


-- Q2) Which are the top 5 highest paying job titles? --

select job_title , salary_in_usd as highest_salary
from  salaries
order by highest_salary desc
limit 5;


-- Q3) 	Which countries have the most job postings? --

select company_location,
count(*) job_posting_count
from salaries
group by company_location
order by job_posting_count desc;


-- Q4) What are the top 3 highest paying job titles within each experience level? --

select experience_level, job_title, salary_in_usd 
rnk from (
select experience_level ,
 job_title,salary_in_usd,
rank() over(partition by experience_level order by salary_in_usd desc) as rnk
from salaries
) as ranked_data 
where  rnk <= 3
order by  experience_level, rnk;



-- Q5) How did average salary change year by year (2020→2022)? --

-- Step 1: Har saal ka average salary nikalo
-- Step 2: Us result pe LAG lagao taaki previous year se compare kar sakein
select work_year,
       avg_salary,                                                -- current year ki salary dikhao
       avg_salary - lag(avg_salary) over (order by work_year) as yoy_change   -- current minus previous year = kitna change hua
from (
    select work_year, round(avg(salary_in_usd),0) as avg_salary   -- yahan andar average nikal rahe hain
    from salaries
    group by work_year                                             -- har saal ka apna group
) as yearly_avg;

-- Q6)  Which company size — Small, Medium, or Large — pays the highest average salary?" --

select company_size,
       round(avg(salary_in_usd),0) as avg_salary,
       count(*) as job_count
from salaries
group by company_size
order by avg_salary desc;


-- Q7) Which countries have the most entry-level (fresher) jobs? --

-- Sirf EN (entry-level) wali jobs filter karo
-- Fir har country mein kitni entry-level jobs hain, count karo

select company_location,
       count(*) as entry_jobs
from salaries
where experience_level = 'EN'      -- pehle sirf entry-level rows chuno
group by company_location           -- fir country ke hisaab se group karo
order by entry_jobs desc;


-- Q8) What is the highest paying job in each country --

select company_location, job_title, salary_in_usd
from (
    select company_location,
           job_title,
           salary_in_usd,
           row_number() over (partition by company_location order by salary_in_usd desc) as rn
    from salaries
) as ranked_jobs
where rn = 1;    -- sirf har country ka number 1 (highest) lo

-- RANK() = if two values are equal, gives them the same rank (like 1, 1, 3 — skips a number) 
-- ROW_NUMBER() = always gives unique numbers, even if values are equal (like 1, 2, 3 — no repeats)
-- rank = same value same number 
-- row_number = same value but unique number



-- Q9) Which pays more — remote jobs, hybrid jobs, or office jobs

-- Har remote type (0=office, 50=hybrid, 100=fully remote) ka average salary nikalo
select remote_ratio,
       round(avg(salary_in_usd),0) as avg_salary,
       count(*) as job_count
from salaries
group by remote_ratio
order by remote_ratio;


-- Q10) What is the most common employment type — Full-time, Part-time, Contract, or Freelance?"

-- Har employment type ki kitni jobs hain, count karo
select employment_type,
       count(*) as job_count
from salaries
group by employment_type
order by job_count desc;



