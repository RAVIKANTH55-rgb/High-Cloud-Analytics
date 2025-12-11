
create view master_data as
select *,
 MONTHNAME(STR_TO_DATE(`Month (#)`, '%m')) as Month_FullName,
concat('Q',"",quarter(STR_TO_DATE(`Month (#)`, '%m'))) as Quarter,
weekofyear(Properdate) as week_no, 
dayofweek(Properdate) as day_no ,
dayname(Properdate) as day_name,
  CASE 
        WHEN `Month (#)` >= 4 THEN `Month (#)` - 3
        ELSE `Month (#)` + 9
    END AS FinancialMonth,

    CASE 
        WHEN `Month (#)` BETWEEN 4 AND 6 THEN 'Q1'
        WHEN `Month (#)` BETWEEN 7 AND 9 THEN 'Q2'
        WHEN `Month (#)` BETWEEN 10 AND 12 THEN 'Q3'
        ELSE 'Q4'
    END AS FinancialQuarter 
    from master_d;
    select * from master_data;
    drop view master_data;
    
------#Yearly Load factor%

    select year,concat(round(sum(`# Transported Passengers`)/sum(`# Available Seats`)*100,2),'%') as Load_factor from master_data
    group by year;
    
------#Quartely Load factor%

    select quarter,concat(round(sum(`# Transported Passengers`)/sum(`# Available Seats`)*100,2),'%') as Load_factor from master_data
    group by quarter;
    
------#Monthly Load factor%

    select month_fullname,concat(round(sum(`# Transported Passengers`)/sum(`# Available Seats`)*100,2),'%') as Load_factor from master_data
    group by month_fullname;
    
------#Carrier name wise Load factor%

    select `Carrier Name`,concat(round(sum(`# Transported Passengers`)/sum(`# Available Seats`)*100,2),'%') as Load_factor from master_data
    group by `Carrier Name`
    order by load_factor desc;
  
------#Top 10 Carriers

    select `Carrier Name`,sum(`# Transported Passengers`)as Passengers_travelled from master_data
    group by `Carrier Name`
    order by Passengers_travelled desc
    limit 10;
    
------#Top 10 Routes

    select `From - To City`,count(*) as Number_of_flights from master_data
    group by `From - To City`
    order by Number_of_flights desc
    limit 10;
    
------#Weekend VS Weekday Load factor%

select case 
               when dayname(Properdate) in ('Saturday','Sunday') then 'Weekend' else 'Weekday'
		  end as Week_type
    ,concat( round(avg(`# Transported Passengers`)/avg(`# Available Seats`)*100,2),'%') as `Load_factor%` from master_data
    group by Week_type;
    
------#Distance Group wise Load factor%

select d.`Distance Interval`,
count(m.`%Distance Group ID`) as No_of_Flights
 from `distance groups` as d join master_data as m
 on d.`%Distance Group ID`= m.`%Distance Group ID`
group by `Distance Interval` ;