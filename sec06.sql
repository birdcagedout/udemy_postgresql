-- Section6. Filtering Data

-- operators
-- 1) 같지 않다: <>
-- 2) AND OR LIKE IN BETWEEN
-- 3) / : 정수들간 나누기 결과는 정수(몫)만 나온다. (실수가 있으면 나누기 결과도 실수)
--    % : modulo(나머지)

select 10 / 3;		-- 3
select 10 % 3;		-- 1



-- text가 where절에 사용되면 반드시 ''으로 묶어준다 (주의: ""는 안 된다)
select * from movies where movie_lang = 'English';
select * from movies where movie_lang = "English";		-- ERROR


-- OR과 |는 다르다
-- | : bit OR
-- ||: concatenation
select * from movies where movie_lang = 'English' OR movie_lang = 'Chinese';
select * from movies where movie_lang = 'English' || movie_lang = 'Chinese';		-- ERROR

select 5 | 2;				-- 7
select 'Engl' || 'ish';		-- 'English'



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



-- SELECT ~ FROM ~ WHERE ~
-- WHERE는 FROM 뒤에만 올 수 있다
-- WHERE를 ORDER BY 뒤에 쓸 수 없다




-- AND, OR 연산: AND가 먼저 실행되고, OR가 나중에 실행된다 (마치 곱셈이 먼저 실행되고, 덧셈이 실행되는 것처럼)

-- 영어 또는 중국어 영화만을 찾는데, 12세 관람가만 찾고 싶다고 하자. ==> 아래와 같이 하면 12세 관람가가 아닌 영화도 나온다
-- 그 이유는 AND가 먼저 처리되기 때문임. 즉, 영어 영화 또는 12세관람가인 중국어 영화로 처리되기 때문
select * 
from movies
where movie_lang = 'English' OR movie_lang = 'Chinese' AND age_certificate = '12';

-- 제대로 하려면 다음과 같이 괄호를 사용한다
select * 
from movies
where (movie_lang = 'English' OR movie_lang = 'Chinese') AND age_certificate = '12';



-- column 별명을 WHERE에서 사용 가능?
-- SELECT절에서 정의한 column 별명은 WHERE절에서 사용 불가
-----------------------------------------------------------------------
-- SQL쿼리 실행순서: FROM - WHERE - GROUP BY - HAVING - SELECT - ORDER BY
-----------------------------------------------------------------------
select * from actors;

select first_name, last_name as surname 
from actors 
where surname = 'Choi';


-- 따라서 FROM절 안에서 서브쿼리를 사용하여 alias를 정의하면 WHERE절에서 사용할 수 있다.
select *
from (
	select first_name first, last_name surname
	from actors
) sub
where surname = 'Choi';



-- 같지 않다: <> 또는 !=
select * from movies where movie_lang != 'English';




-- LIMIT: 출력개수를 처음부터 몇개로 제한 (마지막 몇개로 제한하는 기능은 없다. 정렬 역순으로 처리해야 됨)
select *
from directors
order by date_of_birth;



-- 가장 나이가 많은 미국 영화감독 top5를 골라라
select *
from directors
where nationality = 'American'
order by date_of_birth asc
limit 5;


-- 가장 국내에서 돈 많이 번 영화 top10개 골라라
select * 
from movies_revenues
where revenues_domestic is not null
order by revenues_domestic desc
limit 10;


select * 
from movies_revenues
order by revenues_domestic desc nulls last		-- nulls last로 null을 마지막에 몰아넣을 수도 있다
limit 10;



-- fetch first X row(s) only <-- 맨끝에
select *
from movies
fetch first 2 rows only;




-- IN / NOT IN (~, ~, ~,...)
select *
from movies
where movie_lang not in ('English', 'Chinese', 'Japanese');



-- BETWEEN A AND B : A, B를 포함한다
select *
from actors
where date_of_birth between '1991-1-1' and '1995-12-31';		-- 80ms


select *
from actors
where date_of_birth >= '1991-1-1' and date_of_birth <= '1995-12-31';		-- 95ms




-- LIKE / ILIKE : pattern matching (returns true / false)
-- LIKE는 대소문자를 구별한다. ILIKE는 구별하지 않는다(insensitive).
-- % : zero or more characters
-- _ : any single character

select 'hello' like 'he%';
select 'hello' like '%e%';
select 'hello' like '__ll_';
select 'HELLO' like '__ll_';	-- false
select 'HELLO' ilike '__ll_';	-- true




-- IS NULL / IS NOT NULL
-- date_of_birth가 없는 actors 찾기
select * from actors;

select * from actors
where date_of_birth is null;



-- CONCAT
select concat('A', 'B', 'C');

-- CONCAT_WS
select concat_ws('-', '1995', '2', '3');


-- CONCAT with NULL
select 'ABC' || null;			-- null
select 'ABC' || null || 'DE';	-- null
select 'ABC' || '' || 'DE';		-- ABCDE



