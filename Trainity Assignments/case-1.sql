# A) no. of jobs viewed per hour per day for nov 2020
SELECT ds as date, 
round((count(job_id)/sum(time_spent))*3600) as "jobs viewd per hour per day" from job_data 
WHERE ds BETWEEN "2020-11-01" AND "2020-11-30" group by ds;

# B) calculate 7 day rolling avg throughput(no. of events happening pere sec) and calculate daily metric throughput
SELECT ds AS date, 
    ROUND(COUNT(event) / SUM(time_spent), 2) AS daily_throughput,
    ROUND(AVG(COUNT(event) / SUM(time_spent)) over (
ORDER BY ds 
ROWS BETWEEN 6 preceding AND current row), 2) AS rolling_7day_avg 
FROM job_data
GROUP BY ds
ORDER BY ds;

# C) calc percentage share of each language in 30 days
SELECT language, round(((count(language)/8)*100),2) as lang_share 
FROM job_data group by language;

# D) duplicate rows count
SELECT actor_id, count(actor_id) as tot_count from job_data
GROUP BY actor_id HAVING tot_count>1;