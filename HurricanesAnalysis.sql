-- Convert longitude to negative
update Observations
set longitude = longitude * -1


-- Find all hurricanes that reached 130MPH wind speed (CAT 4)
with cte as (
	select
	ID,
	storm_name,
	year,
	month,
	max_wind,
	row_number() over (partition by ID order by max_wind desc) as rn
from
	Observations
where
	max_wind >= 130
)
select
	*
from
	cte
where
	rn = 1
order by
	year, month


-- Find all hurricanes but only max wind speed recorded
with cte as (
	select
	ID,
	storm_name,
	year,
	month,
	max(max_wind) over (partition by ID) as max_wind,
	row_number() over (partition by ID order by max_wind desc) as rn
from
	Observations
)
select
	*
from
	cte
where
	rn = 1
order by
	year, month

select
	ID,
	storm_name,
	year,
	month,
	latitude,
	longitude,
	max_wind
from
	Observations
where
	event = 'L'
order by
	year,
	month

-- Find number of storms and max wind speed for each year
with cte as (
	select
	ID,
	year,
	max_wind,
	row_number() over (partition by ID order by max_wind desc) as rn
from
	Observations
)
select
	year,
	count(*) as num_storms,
	max(max_wind) as max_wind
from
	cte
where
	rn = 1
group by
	year
order by
	year