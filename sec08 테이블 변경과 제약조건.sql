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



