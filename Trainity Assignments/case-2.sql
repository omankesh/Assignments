use project3;

select distinct event_type from events;

# A) Measure the activeness of users on a weekly basis
select extract(week from occurred_at) as weeks,
count(distinct user_id) as no_of_users
from events
where event_type ="engagement"
group by weeks
order by weeks;

#2. calculate the user growth for the product.
SELECT week_num, year_num,
sum(active_users) OVER (order by week_num, year_num 
rows between unbounded preceding AND current row) as cumulative_sum
from (
SELECT extract(week from activated_at) AS week_num,
extract(year from activated_at) AS year_num,
count(distinct user_id) AS active_users FROM users
where state= "active"
group by year_num, week_num
order by year_num, week_num) as alias;

#3. calc the weekly retention of users-signup cohort
select extract(week from occurred_at) as weeks, 
count(distinct user_id) as no_of_users from events
where event_type="signup_flow" and event_name="complete_signup" 
group by weeks order by weeks;

#4. calculate the weekly user engagement per device
select device, extract(week from occurred_at) as weeks, 
count(distinct user_id) as no_of_users from events 
where event_type="engagement"
group by device, weeks order by weeks;

#5. calculate the email engagement metrics.
select 
(sum(case when 
email_category="email_opened" then 1 else 0 end)/sum(case when email_category="email_sent" then 1 else 0 end))*100 as open_rate,
(sum(case when 
email_category="email_clickthrough" then 1 else 0 end)/sum(case when email_category="email_sent" then 1 else 0 end))*100 as click_rate
from (
	select *, 
	case 
		when action in ("sent_weekly_digest", "sent_reengagement_email") then ("email_sent")
		when action in ("email_open") then ("email_opened")
		when action in ("email_clickthrough") then ("email_clickthrough")
	end as email_category
	from email_events) as alias;