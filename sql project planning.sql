select y, max(end_date)
from (select end_date, last_value(x ignore nulls) over (order by end_date) y
      from (select task_id,
                   start_date,
                   end_date,
                   case
                       when lag(end_date) over (order by end_date) - end_date != -1 or
                            lag(end_date) over (order by end_date) - end_date is null then start_date end as x
            from projects))
group by y
order by max(end_date) - y, y
;