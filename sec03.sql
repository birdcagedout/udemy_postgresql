-- section3. Creating and Modifying Tables
-- 14. movies라는 데이터베이스를 만든다
-- 테이블을 만든다



-- 1) actor 테이블
CREATE TABLE actors (
	actor_id	SERIAL	PRIMARY KEY,
	first_name	VARCHAR(150),
	last_name	VARCHAR(150)	NOT NULL,
	gender		CHAR(1),
	date_of_birth	DATE,
	add_date		DATE,
	update_date		DATE
);



-- 2) directors 테이블
CREATE TABLE directors (
	director_id	SERIAL	PRIMARY KEY,
	first_name	VARCHAR(150),
	last_name	VARCHAR(150),
	date_of_birth	DATE,
	nationality	VARCHAR(20),
	add_date	DATE,
	update_date	DATE
);



-- movies 테이블
CREATE TABLE movies (
	movie_id	SERIAL	PRIMARY KEY,
	movie_name	VARCHAR(100)	NOT NULL,
	movie_length	INT,
	movie_lang	VARCHAR(20),
	age_certificate	VARCHAR(10),
	release_date	DATE,
	director_id	INT	REFERENCES directors(director_id)
);





-- movies_revenues 테이블
CREATE TABLE movies_revenues (
	revenue_id	SERIAL	PRIMARY KEY,
	movie_id	INT	REFERENCES movies(movie_id),
	revenues_domestic	NUMERIC(10,2),
	revenues_international	NUMERIC(10,2)
);
