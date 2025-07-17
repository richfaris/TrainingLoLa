/* v_dates [dates] */
create or replace algorithm = merge view v_dates as
select
  dt `date`,
  wk `week`,
  mo `month`,
  qtr `quarter`,
  yr `year`,
  yrmo `year_month`,
  dow day_of_week,
  dom day_of_month,
  doy day_of_year,
  monthStart is_month_start,
  monthEnd is_month_end,
  quarterStart is_quarter_start,
  quarterEnd is_quarter_end,
  yearStart is_year_start,
  yearEnd is_year_end
from dates
;
