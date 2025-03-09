-- Section08. 형 변환(type conversion)
-- 1) 암시적(inplicit) : 자동 변환됨
-- 2) 명시적(explicit) : CAST or ::
movie 데이터베이스에 접속

select * from movies;

select * from movies where movie_id = 1;

-- 암시적 형변환
select * from movies where movie_id = '1';

-- 명시적 형변환
select * from movies where movie_id = '1'::integer;	-- 많이 사용

select * from movies where movie_id = integer '1';		-- 많이 사용

select * from movies where movie_id = cast('1' as integer);	-- SQL 표준 함수

ALTER TABLE persons
ALTER COLUMN age TYPE INTEGER USING age::INTEGER;		-- 테이블 스키마 변경시에는 using을 사용한다


-- 명시적 형변환1
-- CAST(표현식 AS 변환할타입)
-- 표현식: 수식, 상수, **열이름**

-- string to int
select CAST('10' AS integer);
select CAST('10n' AS integer);	-- ERROR:  invalid input syntax for type integer: "10n"


-- string to date
select CAST('2020-01-02' AS date);		-- "2020-01-02"

select CAST('01-MAY-2022' AS date);	-- "2022-05-01"
select CAST('MAY-01-2022' AS date);	-- "2022-05-01"

select CAST('01-02-2022' AS date);		-- "2022-01-02" (주의!!)


-- string to Boolean
select CAST('true' as boolean);
select CAST('false' as boolean);

select CAST('t' as boolean);
select CAST('f' as boolean);

select CAST('1' as boolean);		-- true
select CAST('0' as boolean);		-- false

select CAST('2' as boolean);		-- ERROR:  invalid input syntax for type boolean: "2"
select CAST('10' as boolean);		-- ERROR:  invalid input syntax for type boolean: "10"

select CAST('yes' as boolean);		-- true
select CAST('no' as boolean);		-- false

select CAST('y' as boolean);		-- true
select CAST('n' as boolean);		-- false

select CAST(TRUE as boolean);		-- true
select CAST(FALSE as boolean);		-- false


-- string to double
select CAST('14.3444' AS double precision);



-- 명시적 형변환2
-- 표현식::변환할타입

select '10'::int;
select '2020-01-09'::DATE;
select '01-05-2022'::DATE;			-- "2022-01-05" (주의!!)


-- string to timestamp
select '2020-02-20 10:30:25.457'::timestamp;			-- "2020-02-20 10:30:25.457"
select '2020-02-20 10:30:25.457'::timestamptz;			-- "2020-02-20 10:30:25.457+00"
select '2020-02-20 10:30:25.457+09'::timestamptz;		-- "2020-02-20 01:30:25.457+00"	==> 항상 시스템의 TIMEZONE(supabase:UTC)로 저장됨에 주의!!


-- string to interval
select '10 minute'::interval;		-- "00:10:00"
select '10 hour'::interval;			-- "10:00:00"
select '10 day'::interval;			-- "10 days"
select '10 week'::interval;			-- "70 days"
select '10 month'::interval;		-- "10 mons"
select '10 year'::interval;			-- "10 years"
select '10 century'::interval;		-- "1000 years"

select '10 sec'::interval;			-- "00:00:10"
select '10 min'::interval;			-- "00:10:00"
select '10 h'::interval;			-- "10:00:00"





-- Implicit to Explicit Conversion
-- 원래 암시적으로 형변환이 되는 경우라도
-- 명시적으로 형변환 해주는 게 가능하고, 그런 처리가 바람직한 경우가 있음



-- factorial 함수
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION factorial(n int) RETURNS bigint AS $$
DECLARE
    result bigint := 1;
BEGIN
    IF n < 0 THEN
        RAISE EXCEPTION 'Negative input not allowed';
    END IF;
    FOR i IN 1..n LOOP
        result := result * i;
    END LOOP;
    RETURN result;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

select factorial(20);

DROP FUNCTION factorial(integer);
-------------------------------------------------------------------


-- round
select round(10, 4);
select round( CAST(10 AS NUMERIC), 4);


-- cast with text
select substr('123456', 2);			-- "23456"
select substr('123456', 2, 3);		-- "234"
select 
	substr('123456', 2) as "Implicit",
	substr(CAST('123456' as TEXT),2) as "Explicit";




-- table data conversion
-- 테이블을 새로 만든다

create table ratings (
	rating_id		serial		primary key,
	rating			varchar(1)	not null
);

select * from ratings;

insert into ratings(rating) values ('A'), ('B'), ('C'), ('D');



-- 시나리오1. 회사 방침이 변경
-- 현재 A,B,C 등 char 형태 rating에서 numeric 형태로 rating 방식을 바꾸어야 한다면?

select rating_id,
	CASE rating
		when 'A' then 5
		when 'B' then 4
		when 'C' then 3
		when 'D' then 2
		when 'E' then 1
		else 0
	END AS rating_numeric
from ratings;


UPDATE ratings
SET rating = CASE rating
    WHEN 'A' THEN '5'
    WHEN 'B' THEN '4'
    WHEN 'C' THEN '3'
    WHEN 'D' THEN '2'
    WHEN 'E' THEN '1'
    ELSE rating
END;

select * from ratings;
drop table ratings;



-- 시나리오2. 회사 방침이 변경
-- 기존 rating 값(A,B,C,...)들이 있는 상태에서 새로운 rating값(5,4,3,...)도 입력되어 혼재되어 있다.
-- 기존 rating은 새로운 rating(숫자)로 바꾸고, 숫자값인 경우는 그대로 두어라.

insert into ratings(rating) values (5), (2), (1);

select * from ratings;

-- 숫자이면 int로 cast, 문자이면 숫자로
SELECT rating_id,
	CASE
		WHEN rating ~ '^[0-9]$' THEN rating::int
		WHEN rating = 'A' THEN 5
		WHEN rating = 'B' THEN 4
		WHEN rating = 'C' THEN 3
		WHEN rating = 'D' THEN 2
		WHEN rating = 'E' THEN 1
		ELSE NULL
	END AS rating_new
FROM ratings;


