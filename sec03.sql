-- section3. Creating and Modifying Tables
-- 14. 15. movies라는 데이터베이스를 만든다
CREATE DATABASE movies
    WITH
    OWNER = adam
    ENCODING = 'UTF8'
    LOCALE_PROVIDER = 'libc'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;





-- 16.테이블을 만든다
-- 1) actor 테이블
CREATE TABLE actors (
	actor_id	SERIAL			PRIMARY KEY,
	first_name	VARCHAR(150),
	last_name	VARCHAR(150)	NOT NULL,
	gender		CHAR(1),
	date_of_birth	DATE,
	add_date		DATE,
	update_date		DATE
);



-- 2) directors 테이블
CREATE TABLE directors (
	director_id		SERIAL		PRIMARY KEY,
	first_name		VARCHAR(150),
	last_name		VARCHAR(150),
	date_of_birth	DATE,
	nationality		VARCHAR(20),
	add_date		DATE,
	update_date		DATE
);



-- 3) movies 테이블
CREATE TABLE movies (
	movie_id		SERIAL			PRIMARY KEY,
	movie_name		VARCHAR(100)	NOT NULL,
	movie_length	INT,
	movie_lang		VARCHAR(20),
	age_certificate	VARCHAR(10),
	release_date	DATE,
	director_id		INT	REFERENCES directors(director_id)
);




-- 4) movies_revenues 테이블
CREATE TABLE movies_revenues (
	revenue_id				SERIAL	PRIMARY KEY,
	movie_id				INT	REFERENCES movies(movie_id),
	revenues_domestic		NUMERIC(10,2),
	revenues_international	NUMERIC(10,2)
);




-- 5) juction 테이블(movies - actors) 만들기
CREATE TABLE movies_actors (
	movie_id		INT REFERENCES movies(movie_id),
	actor_id		INT REFERENCES actors(actor_id),
	PRIMARY KEY (movie_id, actor_id)		-- 2개 열을 조합하여 pk 만들기
);


-- 두개 열이 모두 pk로 지정됨을 볼 수 있다.
select * from movies_actors;






-- 20. movies 샘플 데이터 입력하기 
-- 순서대로...
-- 1) directors.sql
-- 2) actors.sql
-- 3) movies.sql
-- 4) movies_actors.sql
-- 5) movies_revenues.sql






-- 21. mydata 데이터베이스 만들기
CREATE DATABASE mydata
    WITH
    OWNER = adam
    ENCODING = 'UTF8'
    LOCALE_PROVIDER = 'libc'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;


-- mydata로 데이터베이스 바꾼 후
\c mydata


-- accounts 테이블 생성
CREATE TABLE public.accounts
(
    account_id serial NOT NULL,
    user_name character varying(100),
    user_password character varying(50),
    user_email character varying(255),
    add_date time with time zone,
    update_date time with time zone,
    PRIMARY KEY (account_id)
);

ALTER TABLE IF EXISTS public.accounts
    OWNER to adam;



-- 23. Using pgAdmin - View table structure, and create column
DROP TABLE 테이블이름;



	

