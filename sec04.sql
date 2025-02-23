-- Section4. Modifying data in the table
-- movies 데이터베이스로 바꾼다
\c movies



-- 26. Insert a data into table
CREATE TABLE customers (
	customer_id		SERIAL	PRIMARY KEY,
	first_name		VARCHAR(50),
	last_name		VARCHAR(50),
	email			VARCHAR(150),
	age				INT
); 


select * from customers;


-- 특정 열만 골라서 넣을 수 있다
INSERT INTO customers(first_name, last_name, email, age)
VALUES ('Anan', 'Waheed', 'a@bc.com', 40);



-- 열을 생략할 수는 없나? ==> 첫번째가 SERIAL이므로 INT값이 들어가야 돼서 ERROR
INSERT INTO customers
VALUES ('Anan2', 'Waheed2', 'a@bc.com2', 402);


-- 그럼 INT값을 넣어주면 되잖아 ==> ERROR 없음
INSERT INTO customers
VALUES (20, 'Anan2', 'Waheed2', 'a@bc.com2', 402);


-- 20번이 2번째로 입력된 상태에서 다음번 행이 입력되면 SERIAL값은 어떻게 될까? ==> 2가 된다
-- 즉, SERIAL을 수동으로 입력하는 경우 다음번 SERIAL값에 영향을 주지 않는다.
INSERT INTO customers(first_name, last_name, email, age)
VALUES ('Anan', 'Waheed', 'a@bc.com', 40);


-- RETURNING 사용 ==> INSERT된 1개 row 전체 리턴
INSERT INTO customers (first_name)
VALUES ('JOSEPH') RETURNING *;


-- RETURNING 사용 ==> 특정 column만 리턴
INSERT INTO customers (first_name)
VALUES ('Anna') RETURNING customer_id;





-- UPDATE
UPDATE customers
SET 
	email = 'a2@zz.com',
	age = 25
WHERE customer_id = 1;


select * from customers;




-- UPDATE + RETURNING
UPDATE customers
SET 
	first_name = 'Tom',
	age = 55
WHERE customer_id = 20
RETURNING *;



-- UPDATE + RETURNING : 영향을 받은 row가 1개 이상일 수도 있을 때 확인용으로 좋다
UPDATE customers
SET 
	age = 90
WHERE first_name = 'Anan'
RETURNING *;


select * from customers;


-- DELETE
delete from customers
where customer_id = 20;




-- UPSERT: INSERT할 때 중복값이 없으면 INSERT하고, 중복값이 존재하는 경우 UPDATE하는 기능
-- movies 데이터베이스에서 예를 들어
CREATE TABLE t_tags (
	id		serial	primary key,
	tag 	text	unique,						-- tag값은 unique해야 함에 유의
	update_date	timestamp default now()
);


INSERT INTO t_tags(tag) 
VALUES 
	('pen'),
	('pencil');


select * from t_tags;



-- 만약 tag값에 중복된 것이 입력되는 경우 ==> ERROR:  duplicate key value violates unique constraint "t_tags_tag_key"
INSERT INTO t_tags(tag)
VALUES ('pen');



-- 만약 tag값에 중복된 것이 입력되는 경우 ==> INSERT 하지 마라 ==> ERROR 없음(INSERT 0 0)
INSERT INTO t_tags(tag)
VALUES ('pen')
ON CONFLICT (tag)
DO NOTHING;




-- 만약 tag값에 중복된 것이 입력되는 경우 ==> UPDATE 해라(update_date 열의 값만 지금 시간으로)
INSERT INTO t_tags(tag)
VALUES ('pen')
ON CONFLICT (tag)
DO UPDATE SET
	tag = EXCLUDED.tag,
	update_date = NOW();


-- 위에서 EXCLUDED.tag의 의미
-- EXCLUDED는 삽입하려고 했지만 충돌 때문에 제외된 행(즉, 원래 입력하려고 했던 값을 담고 있는 가상의 테이블)을 의미합니다.
-- 따라서 EXCLUDED.tag는 충돌이 발생한 상황에서 새로 삽입하려 했던 tag 값, 이 경우 'pen'을 가리킵니다.



select * from t_tags;


-- 만약 tag값에 중복된 것이 입력되는 경우 ==> 중복값의 이름을 바꾸는 경우
INSERT INTO t_tags(tag)
VALUES ('pen')
ON CONFLICT (tag)
DO UPDATE SET
	tag = EXCLUDED.tag || '1',
	update_date = NOW();
