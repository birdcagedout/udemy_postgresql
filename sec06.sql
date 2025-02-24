-- Section6. Filtering Data

-- operators
-- 1) 같지 않다: <>
-- 2) AND OR LIKE IN BETWEEN
-- 3) / : 정수들간 나누기 결과는 정수(몫)만 나온다. (실수가 있으면 나누기 결과도 실수)
--    % : modulo(나머지)

select 10 / 3;
select 10 % 3;



-- text가 where절에 사용되면 반드시 ''으로 묶어준다 (주의: ""는 안 된다)
select * from movies where movie_lang = 'English';
select * from movies where movie_lang = "English";


-- DATE
select * from movies where release_date < '2000-01-01';
select * from movies where release_date < DATE '2000/01/01';
select * from movies where release_date BETWEEN '2000/01/01' AND '2010-01-01';


select * from movies;
select * from directors;


-- JOIN 연습
select m.movie_name, m.release_date, (d.first_name || ' ' || d.last_name) as director
from movies as m
join directors as d
on m.director_id = d.director_id
order by m.release_date;


select distinct age_certificate from movies;

