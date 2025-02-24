-- Section5. Querying Data
-- 35. Select all data from a table


-- 주의1) "SELECT ~ FROM ~" 구문애서 FROM절을 SELECT절보다 먼저 처리한다.
-- 주의2) 필요한 열만 선택하여 SELECT할 것.
-- 주의3) 열이름에 AS로 별명을 붙일 때는 큰따옴표만 사용 가능

-- 주의4) "SELECT ~ FROM ~ ORDER BY ~" 구문에서 FROM절 -> SELECT절 -> ORDER BY절 순서로 처리된다. 
SELECT *
FROM movies
ORDER BY 
	release_date ASC,
	movie_name DESC;

select * from actors;



-- SELECT절에서 Alias를 사용한 경우, WHERE절에서 Alias를 사용할 수 있을까? ==> 없다(ERROR:  column "surname" does not exist)
SELECT 
	first_name,
	last_name AS surname
FROM actors
WHERE surname = 'Allen';



-- SELECT절에서 Alias를 사용한 경우, ORDER BY절에서 Alias를 사용할 수 있을까? ==> 있다.
SELECT 
	first_name,
	last_name AS surname
FROM actors
ORDER BY surname;




-- LENGTH() : 공백도 1개 문자로 친다
select first_name, length(' ')
from actors;


select first_name, length(first_name) as len
from actors
order by len DESC;



-- 열번호 사용하기
select 
	first_name,
	last_name,
	date_of_birth
from actors
order by 
	first_name asc,
	date_of_birth desc;


-- 열번호 사용하기: 위와 똑같은 기능을 한다
select 
	first_name,
	last_name,
	date_of_birth
from actors
order by 
	1 asc,
	3 desc;



-- NULL : missing or unknown
--        ORDER BY절에서 2가지로 표현가능 ==> NULLS FIRST / NULLS LAST
--        하지만 앞에 다른 기준이 와야 하고, 단독으로 사용할 수는 없다

CREATE TABLE null_t (
	num INT
);


INSERT INTO null_t(num)
VALUES
	(1),
	(2),
	(3),
	(NULL);


-- NULL 처리의 기본값 : 오름차순에서는 NULLS LAST
--                   내림차순에서는 NULLS FIRST
select * from null_t;


-- 이렇게 단독으로 사용할 수는 없다
select * from null_t
order by nulls first;


-- 반드시 다른 order by 기준열이 있어야 한다.
select * from null_t
order by num NULLS FIRST;


-- 내림차순에서는 NULLS FIRST가 기본값
select * from null_t
order by num DESC;


-- 하지만 내림차순에서 NULL을 마지막으로 보낼 수 있다
select * from null_t
order by num DESC NULLS LAST;


drop table null_t;



-- DISTINCT
select * from movies;

select movie_lang from movies;

select DISTINCT movie_lang from movies;


-- 이렇게 쓰면 안 된다
select movie_name, DISTINCT movie_lang from movies;

-- 이렇게 쓰면 된다 ==> DISTINCT가 2개 열에 모두 작용하기 때문
select DISTINCT movie_lang, movie_name from movies;

-- 이렇게 쓰면 될까? ==> 안된다
-- 이유: SQL에서 DISTINCT는 SELECT 절 전체에 적용되어 중복된 행 전체를 제거하는 역할을 합니다.
--      아래와 같이 특정 컬럼에만 DISTINCT를 적용하려는 시도는 올바른 문법이 아닙니다. 
--      괄호로 묶어 DISTINCT를 특정 컬럼에만 적용할 수 없으며, DISTINCT는 SELECT 키워드 바로 뒤에 위치해야 합니다.
select (DISTINCT movie_lang), movie_name from movies;



-- 참고: 어떤 언어로 제작된 영화가 많을까
select movie_lang, count(*) as movie_count
from movies
group by movie_lang
order by movie_count desc;


