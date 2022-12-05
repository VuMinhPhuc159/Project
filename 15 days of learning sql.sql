drop table consistent_hacker;
commit;
CREATE GLOBAL TEMPORARY TABLE consistent_hacker
(
    submission_date DATE,
    hacker_id       INT
)
    ON COMMIT DELETE ROWS;

INSERT INTO consistent_hacker
SELECT submission_date, hacker_id
FROM submissions
WHERE submission_date = TO_DATE('2016-03-01', 'YYYY-MM-DD')
GROUP BY submission_date, hacker_id;

DECLARE
    date_loop DATE := TO_DATE('2016-03-02', 'YYYY-MM-DD');
BEGIN
    WHILE date_loop <= TO_DATE('2016-03-15', 'YYYY-MM-DD')
        LOOP
            INSERT INTO consistent_hacker
            SELECT submission_date, hacker_id
            FROM submissions
            WHERE submission_date = date_loop
              AND hacker_id IN (SELECT hacker_id FROM consistent_hacker WHERE submission_date = date_loop - 1)
            GROUP BY submission_date, hacker_id;
            date_loop := date_loop + 1;
        END LOOP;
END;

SELECT a.submission_date,
       a.x,
       b.hacker_id,
       b.name
FROM (SELECT submission_date,
             COUNT(hacker_id) x
      FROM consistent_hacker
      GROUP BY submission_date) a
         INNER JOIN
     (SELECT submission_date,
             hacker_id,
             name
      FROM (SELECT submission_date,
                   COUNT(submission_id)                                                      x,
                   s.hacker_id,
                   h.name,
                   ROW_NUMBER() OVER (PARTITION BY submission_date ORDER BY submission_date) y
            FROM submissions s
                     INNER JOIN hackers h ON s.hacker_id = h.hacker_id
            GROUP BY submission_date, s.hacker_id, h.name
            ORDER BY submission_date, x DESC, s.hacker_id)
      WHERE y = 1) b
     ON a.submission_date = b.submission_date;