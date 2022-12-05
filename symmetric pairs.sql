with pair as (select x, y
              from (select x, y, count(*) z
                    from Functions
                    group by x, y)
              where x != y
                 or z > 1)
select p1.x, p1.y
from pair p1,
     pair p2
where p1.x = p2.y
  and p1.y = p2.x
  and p1.x <= p1.y
order by p1.x
;