select name
from (select name, f.id, salary as my_salary, friend_id
      from friends f
               left join students s on f.id = s.id
               left join packages p on f.id = p.id) a
         left join packages p on a.friend_id = p.id
where my_salary < p.salary
order by p.salary
;