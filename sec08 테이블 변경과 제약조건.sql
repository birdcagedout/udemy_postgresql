-- Section8. Modifying table structure, add constraints
--           https://www.postgresql.org/docs/17/ddl-alter.html


------------------------------ 이론 시작

-- ALTER TABLE 문법
-- (1) column을 add, remove, type-change 할 때
-- (2) constraint를 add, remove 할 때 ==> constraint를 수정하려면 drop 후 add 해야 한다(수정 불가)
-- (3) column이나 table이름을 rename 할 때


-- 1-1) column add
ALTER TABLE 테이블이름 
ADD COLUMN 열이름 타입 [제약조건];


-- 1-2) column remove
ALTER TABLE 테이블이름 
DROP COLUMN 열이름 [CASCADE];


-- 1-3) column 타입 변경
ALTER TABLE 테이블이름
ALTER COLUMN 열이름 TYPE 새로운타입; -- 주의: 이미 입력된 값들이 새로운타입에 맞아야 한다.




-- 2-1) constraint add: 종류에 따라 조금씩 다르다
-- 원칙)
ALTER TABLE 테이블이름 
ADD [CONSTRAINT 제약조건이름] CHECK (열이름 <> '');

ALTER TABLE 테이블A이름 
ADD [CONSTRAINT 제약조건이름] FOREIGN KEY (A의열이름) REFERENCES 참조할테이블B이름(B의열이름);

ALTER TABLE 테이블이름 
ADD [CONSTRAINT 제약조건이름] UNIQUE (열이름);

ALTER TABLE 테이블이름 
ADD [CONSTRAINT 제약조건이름] PRIMARY KEY (열이름);


-- 예외 2개
-- 예외1) NOT NULL은 column의 속성을 바꿔야 한다
ALTER TABLE 테이블이름 
ALTER COLUMN 열이름 SET NOT NULL;

ALTER TABLE 테이블이름 
ALTER COLUMN 열이름 DROP NOT NULL;


-- 예외2) DEFAULT도 column의 속성을 바꿔야 한다
ALTER TABLE 테이블이름
ALTER COLUMN 열이름 SET DEFAULT 기본값;

ALTER TABLE 테이블이름
ALTER COLUMN 열이름 DROP DEFAULT;



-- 2-2) constraint remove: 

-- 원칙) 제약조건이름을 먼저 찾고, 이름을 특정해서 지운다
제약조건 이름 찾기: (psql에서) \d 테이블이름;

ALTER TABLE 테이블이름 
DROP CONSTRAINT 제약조건이름;


-- 예외 2개
-- 예외1) NOT NULL 제거
ALTER TABLE 테이블이름
ALTER COLUMN 열이름 DROP NOT NULL;

-- 예외2) DEFAULT값 제거
ALTER TABLE 테이블이름
ALTER COLUMN 열이름 DROP DEFAULT;





-- 3) column이나 table이름을 rename
ALTER TABLE 테이블이름
RENAME TO 새테이블이름;

ALTER TABLE 테이블이름
RENAME COLUMN 열이름 TO 새열이름;



--------------------- 이론 끝





--------------------- 실습 시작

-- 일단 mydata 데이터베이스를 선택 후 새로운 테이블을 만든다
create table persons(
	person_id		serial		primary key,
	first_name		varchar(20)	not null,
	last_name		varchar(20)	not null
);

select * from persons;


-- column add
alter table persons
add column age int not null;

select * from persons;

-- column 여러개 add
alter table persons
add column nationality varchar(20) not null,
add column email varchar(100) unique;

select * from persons;



-- rename a table
alter table persons
rename to users;

select * from users;

alter table users
rename to persons;

select * from persons;


-- rename a column
alter table persons
rename column age to person_age;

select * from persons;

alter table persons
rename column person_age to age;

select * from persons;


-- drop a column
alter table persons
drop column age;


select * from persons;


-- add a column
alter table persons
add column age varchar(10);

select * from persons;


-- change column type ==> 에러 발생
alter table persons
alter column age TYPE int;

-- ERROR:  column "age" cannot be cast automatically to type integer
-- HINT:  You might need to specify "USING age::integer". 

-- 해결방법: varchar -> int로 자동형변환이 불가능할 수 있기 때문에 명시적인 type cast가 필요하다.
alter table persons
alter column age TYPE int USING age::int;


select * from persons;


--------------------------------------------------------------
-- USING

-- 1) 명시적 형변환에 사용
--    - ALTER TABLE문에서 TYPE 변환 시 (암시적 형변환이 불가능/불안전할 때) 사용

-- 2) JOIN 시 공통컬럼이 있으면 ON 대신 사용 ===> 이 용법만 SQL 표준 문법임
SELECT *
FROM orders
JOIN customers USING (customer_id);

-- 3) DELETE문에서 다른 테이블과 조인할 필요가 있을 때
DELETE FROM orders
USING customers
WHERE orders.customer_id = customers.customer_id
  AND customers.inactive = true;

-- 4) 인덱스 생성 시 메소드 지정
CREATE INDEX idx_name ON employees USING btree (employee_id);
--------------------------------------------------------------



-- 만약 엄한 데이터가 있었다면 어떻게 되었을까?

-- 원래대로 varchar(10)으로 돌려놓는다 ==> int가 varchar(10)로 변환되는 것은 안전함. 암시적으로 타입 캐스팅이 가능하므로 에러 없음
alter table persons
alter column age TYPE varchar(10);

insert into persons(first_name, last_name, nationality, email, age)
values 
	('jae', 'kim', 'korea', 'bird@a.com', '47'),
	('angie', 'jollie', 'us', 'aj@b.com', '40''s');		-- 문자열 리터럴에 '를 넣으려면: '를 2개 넣어야 1개 표현 가능

select * from persons;


-- 이제 varchar 타입의 age를 int로 타입 변환 해본다
-- ERROR:  invalid input syntax for type integer: "40's" 
alter table persons
alter column age TYPE int USING age::int;

-- 할수없이 고쳐야만 타입을 변환할 수 있다.
update persons
set age = '45'
where age = '40''s';

select * from persons;


-- 이제 age열의 타입변환 가능하다
alter table persons
alter column age TYPE int using age::int;

select * from persons;		-- 안전하게 int로 변환되었다(47, 45)


-- 이제 age열에 not null도 추가해보자
alter table persons
alter column age set not null;

-- not null은 제약조건이 아니라, 열의 속성이다. 아래의 표를 보자.
-- <not null 설정 전>
mydata=> \d persons
                                         "public.persons" 테이블
     필드명    |          형태           | 정렬규칙   | NULL허용  |                   초기값
-------------+------------------------+----------+----------+--------------------------------------------
 person_id   | integer                |          | not null | nextval('persons_person_id_seq'::regclass)
 first_name  | character varying(20)  |          | not null |
 last_name   | character varying(20)  |          | not null |
 nationality | character varying(20)  |          | not null |
 email       | character varying(100) |          |          |
 age         | integer                |          |          |
인덱스들:
    "persons_pkey" PRIMARY KEY, btree (person_id)
    "persons_email_key" UNIQUE CONSTRAINT, btree (email)

-- <not null 설정 후>
mydata=> \d persons
                                         "public.persons" 테이블
     필드명    |          형태           | 정렬규칙   | NULL허용  |                   초기값
-------------+------------------------+----------+----------+--------------------------------------------
 person_id   | integer                |          | not null | nextval('persons_person_id_seq'::regclass)
 first_name  | character varying(20)  |          | not null |
 last_name   | character varying(20)  |          | not null |
 nationality | character varying(20)  |          | not null |
 email       | character varying(100) |          |          |
 age         | integer                |          | not null |
인덱스들:
    "persons_pkey" PRIMARY KEY, btree (person_id)
    "persons_email_key" UNIQUE CONSTRAINT, btree (email)

-- 위에서 보는 것처럼 별도의 constraint가 만들어지지 않았다. column의 속성값만 변경되었다.




-- DEFAULT값 입력
alter table persons
add column is_enabled varchar(1);

select * from persons;		-- null값이 기본적으로 들어가 있다


alter table persons 
alter column is_enabled set default 'Y';

select * from persons;		-- null값이 'Y'로 바뀌지는 않는다. 단, 이전 [null]로 표시된 것이 [default]로 표시된다(실제값은 null이다)


insert into persons(first_name, last_name, nationality, email, age)	-- is_enabled 없이 입력 
values ('john', 'benjamin', 'us', 'aa@bb.com', 40);

select * from persons;




-- constraints add
CREATE TABLE web_links(
	link_id		serial			primary key,
	link_url	varchar(255)	not null,
	link_target	varchar(20)
);

select * from web_links;

insert into web_links(link_url, link_target)
values ('https://www.google.com', '_blank');

-- unique 추가
alter table web_links
add constraint unique_web_url unique(link_url);

-- 추가되었는지 확인해보려면 psql에서 \d web_links
mydata=> \d web_links
                                        "public.web_links" 테이블
   필드명    |          형태          | 정렬규칙 | NULL허용 |                   초기값
-------------+------------------------+----------+----------+--------------------------------------------
 link_id     | integer                |          | not null | nextval('web_links_link_id_seq'::regclass)
 link_url    | character varying(255) |          | not null |
 link_target | character varying(20)  |          |          |
인덱스들:
    "web_links_pkey" PRIMARY KEY, btree (link_id)
    "unique_web_url" UNIQUE CONSTRAINT, btree (link_url)


-- unique: link_url에는 같은 값을 넣을 수 없다.
-- ERROR:  duplicate key value violates unique constraint "web_links_link_url_key"
-- Key (link_url)=(https://www.google.com) already exists. 
insert into web_links(link_url, link_target)
values ('https://www.google.com', '_blank');


-- 다른값은 넣을 수 있다
insert into web_links(link_url, link_target)
values ('https://www.amazon.com', '_blank');

select * from web_links;


-- unique 삭제
alter table web_links
drop constraint unique_web_url;

-- 삭제 확인
mydata=> \d web_links
                                        "public.web_links" 테이블
   필드명    |          형태          | 정렬규칙 | NULL허용 |                   초기값
-------------+------------------------+----------+----------+--------------------------------------------
 link_id     | integer                |          | not null | nextval('web_links_link_id_seq'::regclass)
 link_url    | character varying(255) |          | not null |
 link_target | character varying(20)  |          |          |
인덱스들:
    "web_links_pkey" PRIMARY KEY, btree (link_id)



-- add 뒤의 [constraint 제약조건이름] 부분은 생략 가능 ==> 자동으로 이름 만들어짐
alter table web_links
add unique(link_url);

-- 확인
mydata=> \d web_links
                                        "public.web_links" 테이블
   필드명    |          형태          | 정렬규칙 | NULL허용 |                   초기값
-------------+------------------------+----------+----------+--------------------------------------------
 link_id     | integer                |          | not null | nextval('web_links_link_id_seq'::regclass)
 link_url    | character varying(255) |          | not null |
 link_target | character varying(20)  |          |          |
인덱스들:
    "web_links_pkey" PRIMARY KEY, btree (link_id)
    "web_links_link_url_key" UNIQUE CONSTRAINT, btree (link_url)



-- 특정 열에 정해진 특정값만 입력될 수 있도록(allow a column to accept certain values only) 제약조건 설정
-- is_enabled 열에 'y', 'n'만 입력 가능
alter table web_links
add column is_enabled char(1) check(is_enabled in ('y', 'n'));

select * from web_links;

update web_links
set is_enabled = 'y'
where link_id = 1;

select * from web_links;

-- 그 외의 값을 넣으면
-- ERROR:  new row for relation "web_links" violates check constraint "web_links_is_enabled_check"
-- Failing row contains (1, https://www.google.com, _blank, _). 
update web_links
set is_enabled = '_'
where link_id = 1;


-- 대소문자는 구별할까? ==> 구분한다. 'Y', 'N'은 안 됨
update web_links
set is_enabled = 'Y'
where link_id = 1;

update web_links
set is_enabled = 'N'
where link_id = 2;


-- 제약조건은 수정할 수 없고, drop 후 다시 add 해야 한다.
-- drop 하려면 \d 테이블명으로 먼저 constraint 이름을 확인한다
mydata=> \d web_links
                                        "public.web_links" 테이블
   필드명    |          형태          | 정렬규칙 | NULL허용 |                   초기값
-------------+------------------------+----------+----------+--------------------------------------------
 link_id     | integer                |          | not null | nextval('web_links_link_id_seq'::regclass)
 link_url    | character varying(255) |          | not null |
 link_target | character varying(20)  |          |          |
 is_enabled  | character(1)           |          |          |
인덱스들:
    "web_links_pkey" PRIMARY KEY, btree (link_id)
    "web_links_link_url_key" UNIQUE CONSTRAINT, btree (link_url)
체크 제약 조건:
    "web_links_is_enabled_check" CHECK (is_enabled = ANY (ARRAY['y'::bpchar, 'n'::bpchar]))


-- 제약조건 drop 후 add
alter table web_links
drop constraint web_links_is_enabled_check;	-- 따옴표는 없다

alter table web_links
add check(is_enabled in ('y', 'n', 'Y', 'N'));

select * from web_links;

-- 이제 'N'도 입력 가능하다
update web_links
set is_enabled = 'N'
where link_id = 3;

select * from web_links;


