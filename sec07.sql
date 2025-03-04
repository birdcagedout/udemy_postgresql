-- Section7. Data Types

-- 1) Boolean: 3가지 값 가능(true, false, null)
-- true  : TRUE,  'true',  't', 'y', 'yes', '1'
-- false : FALSE, 'false', 'f', 'n', 'no',  '0'

-- 테이블 생성
CREATE TABLE table_boolean (
	product_id		serial primary key,
	is_available	boolean
);


insert into table_boolean(is_available) values(TRUE);
insert into table_boolean(is_available) values(FALSE);
insert into table_boolean(is_available) values(null);
insert into table_boolean(is_available) values('true');
insert into table_boolean(is_available) values('false');
insert into table_boolean(is_available) values('y');
insert into table_boolean(is_available) values('n');
insert into table_boolean(is_available) values('1');
insert into table_boolean(is_available) values('0');
insert into table_boolean(is_available) values(1);		-- ERROR
insert into table_boolean(is_available) values(0);		-- ERROR

select * from table_boolean;


select * from table_boolean where is_available = '1';
select * from table_boolean where is_available = '0';
select * from table_boolean where is_available = 'true';
select * from table_boolean where is_available = 'false';
select * from table_boolean where is_available = 't';
select * from table_boolean where is_available = 'f';


-- true 생략하기
select * from table_boolean where is_available;

-- NOT 사용하기
select * from table_boolean where NOT is_available;

-- IS TRUE / IS FALSE 사용 가능(나머지값들은 IS 뒤에 사용 불가)
select * from table_boolean where is_available is TRUE;
select * from table_boolean where is_available is FALSE;
select * from table_boolean where is_available is '1';		-- ERROR
select * from table_boolean where is_available is 'no';	-- ERROR


-- default value 만들기
ALTER TABLE table_boolean
ALTER COLUMN is_available
SET DEFAULT FALSE;

insert into table_boolean(product_id) values(13);	


-- 기존에 있던 null값을 false로 바꾸지는 않는다.(단지 표시상에 null 대신 [default]로 표시된다)
select * from table_boolean where is_available is null;






-- 2) CHAR, VARCHAR, TEXT : Character data

-- CHARACTER(n), CHAR(n)            : 고정길이(n은 디폴트값 1), 빈칸(space)이 padding된다
-- CHARACTER VARYING(n), VARCHAR(n) : 가변길이(n=최대길이), 빈칸 padding이 없다
-- TEXT, VARCHAR 					 : 길이제한 없음, 빈칸 padding이 없다


select CAST('Adnan' AS CHARACTER(10)) AS "Name";	-- "Adnan     "
select 'Adnan'::char(10) as "Name";				-- "Adnan     "
select 'Adnan'::char as "Name";					-- "A" ==> char(1)과 같음


select 'Adnan'::varchar(10) as "Name";				-- "Adnan" ==> 빈칸 패딩이 없음에 주의
select 'Adnan'::varchar as "Name";					-- "Adnan" ==> 빈칸 패딩이 없음에 주의


create table char_test (
	id		serial primary key,
	char1	char,
	char2	char(5),
	var1	varchar,
	var2	varchar(5)
);


insert into char_test(char1, char2, var1, var2) 
values ('ABC', '1234567', 'ABCDEFGHIJKL', '1234567');		-- ERROR: value too long for type character(1) 

insert into char_test(char1, char2, var1, var2) 
values ('A', '1234567', 'ABCDEFGHIJKL', '1234567');		-- ERROR: value too long for type character(5) 

insert into char_test(char1, char2, var1, var2) 
values ('A', '12345', 'ABCDEFGHIJKL', '1234567');		-- ERROR: value too long for type character varying(5) 

insert into char_test(char1, char2, var1, var2) 
values ('A', '12345', 'ABCDEFGHIJKL', '12345');		-- OK

select * from char_test;


-- n = 한글 글자수
insert into char_test(char1, char2, var1, var2) 
values ('김', '김씨표류기', '김씨이씨박씨쿵따리쌰바라', '똠방각하2');





-- 3) NUMBERS : 숫자는 담을 수 있지만 null값은 담을 수 없다

-- 3-1) integers : smallint(2Bytes), int(4Bytes), bigint(8Bytes)
-- 3-2) 실수
--      3-2-1) fixed-point(정밀 소수점)   : 정확하게 값 저장, 저장공간 가변, 느리다 ==> NUMERIC, DECIMAL
--      3-2-2) floating-point(부동 소수점): 근사치로 값 저장, 저장공간 일정, 빠르다 ==> REAL, DOUBLE PRECISIOM 
-- 3-3) serial : smallserial(2Bytes), serial(4bytes), bigserial(8bytes) ==> 1부터 시작



-- 3-3) serial
create table table_serial (
	product_id		serial,
	product_name	varchar(100)
);


insert into table_serial(product_name) values('pen');		-- id=1
insert into table_serial(product_name) values('pen');		-- id=2

delete from table_serial where product_id = 2;

insert into table_serial(product_name) values('pencil');	-- id=3 (id 2번이 제거되어도 seq는 빈곳을 채우지 않는다)
insert into table_serial(product_name) values('ballpen');	-- id=4

select * from table_serial;

insert into table_serial(product_id, product_name) values(2, 'pluspen');	-- 이런 짓은 하지 마라(PK와 FK는 건드리지 마라)
insert into table_serial(product_name) values('eraser');	-- 위와 같은 짓을 하더라도 seq는 원래값 그대로 증가한다(id=5)





-- 3-2) numeric, real, double precision
create table table_numbers (
	col_numeric		numeric(20,5),
	col_real		real,
	col_double		double precision
);


select * from table_numbers;



insert into table_numbers(col_numeric, col_real, col_double) 
values 
	(.9, .9, .9),
	(3.13579, 3.13579, 3.13579),
	(4.1357987654, 4.1357987654, 4.1357987654); 



-- NUMBERS 철칙
-- 1) 가능하면 반드시 int형 사용할 것
-- 2) 연산결과가 정확해야 되는 경우 numeric이나 decimal을 사용할 것
-- 3) 충분히 큰 type을 선택할 것





-- DATE / TIME

-- Date : date only
-- Time : time only
-- Timestamp : date & time
-- Timestamptz : date & time with timezone
-- Interval : Date/Time differences


-- 1) DATE
-- CURRENT_DATE : 현재 날짜
-- NOW()        : 현재 날짜 + 시간 + timezone
select CURRENT_DATE;
select current_date;

select local_date;		-- 이런 건 없다
select localdate;		-- 이런 것도 없다

select now();
select now() AT TIME ZONE 'Asia/Seoul' AS seoul_time;	-- 서울 로컬타임으로 바꾸기


-- timezone 보기 / 바꾸기
show TIMEZONE;		-- UTC
SELECT current_setting('TIMEZONE');

SET TIMEZONE TO 'Asia/Seoul';		-- 현재 세션에만 영향. 바꿔도 다시 접속하면 UTC로 되돌아옴
SET TIMEZONE TO 'UTC';



create table table_dates (
	id				serial			primary key,
	employee_name	varchar(100)	not null,
	hire_date		date			not null,
	add_date		date			default CURRENT_DATE
);


insert into table_dates(employee_name, hire_date) values
('Adan', '2020-01-01'),
('Linda', '2020-02-02');

select * from table_dates;




-- 2) Time = Time without time zone
create table table_time (
	id			serial			primary key,
	class_name	varchar(100)	not null,
	start_time	time 			not null,
	end_time	time			not null
);

insert into table_time(class_name, start_time, end_time) values
('Math', '08:00:00', '09:00:00'),
('Chemistry', '09:01:00', '10:00:00');


select * from table_time;


select CURRENT_TIME;
select current_time at time zone 'Asia/seoul';

select local_time;		-- 이런 건 없지만
select localtime;		-- 이런 건 있다!!! ==> 하지만 timezone을 지정하지 않은 local time은 쓰레기일 뿐이다(세팅된 UTC의 local time임)



select time '10:00' - time '04:00';	-- 결과는 Interval

select CURRENT_TIME, CURRENT_TIME + interval '3 minutes';
select CURRENT_TIME, CURRENT_TIME + interval '-5 hours 3 minutes';




-- 3) timestamp
create table table_timestamp (
	ts		timestamp,
	tstz	timestamptz
);


insert into table_timestamp(ts, tstz) values
('2020-02-22 10:10:10-07', '2020-02-22 10:10:10-07');

select * from table_timestamp;

SET TIMEZONE TO 'Asia/Seoul';

select * from table_timestamp;


select current_timestamp;
select timeofday();





-- 4) UUID : 128-bit(32자리 16진수) 8자리-4자리-4자리-4자리-12자리
--           extension 필요: uuid-ossp


/* 참고자료: supabase의 postgres 데이터베이스에는 깔려있다. 다른 데이터베이스를 사용한다면 데이터베이스별로 새로 깔아야 한다.
postgres=> \dx
                                               설치된 확장기능 목록
        이름        | 버전  |   스키마   |                                  설명
--------------------+-------+------------+------------------------------------------------------------------------
 pg_graphql         | 1.5.9 | graphql    | pg_graphql: GraphQL support
 pg_stat_statements | 1.10  | extensions | track planning and execution statistics of all SQL statements executed
 pgcrypto           | 1.3   | extensions | cryptographic functions
 pgjwt              | 0.2.0 | extensions | JSON Web Token API for Postgresql
 pgsodium           | 3.1.8 | pgsodium   | Pgsodium is a modern cryptography library for Postgres.
 plpgsql            | 1.0   | pg_catalog | PL/pgSQL procedural language
 supabase_vault     | 0.2.8 | vault      | Supabase Vault Extension
 uuid-ossp          | 1.1   | extensions | generate universally unique identifiers (UUIDs)
(8개 행)
*/


-- 필요하다면 설치
create extension if not exitsts "uuid-ossp";

-- v1은 MAC address와 현재시간 등을 조합하여 생성
-- v4는 완전히 랜덤하게 생성(실행할 때마다 다르게)
select uuid_generate_v4();		-- "3b71043e-ba51-4ca8-b883-505132218644"


create table table_uuid (
	product_id		uuid	default uuid_generate_v4(),
	product_name	varchar(100)	not null
);


insert into table_uuid(product_name) values ('ABC');
insert into table_uuid(product_name) values ('XYZ');

select * from table_uuid;




-- 5) Array : 모든 기본 타입들의 Array가 존재한다.
--            예를 들어 int[] char[] text[]
create table table_array (
	id		serial,
	name	varchar(100),
	phones	text[]
);


select * from table_array;

-- Array[]으로 감싸서 넣어주어야 한다
insert into table_array(name, phones) 
values ('Adam', Array ['010-1234-5678', '010-3333-4444']);

insert into table_array(name, phones) 
values ('Linda', Array ['010-9999-8888', '010-6666-5555']);

insert into table_array(name, phones) 
values ('Eric', Array ['010-0000-1111']);

insert into table_array(name, phones) 
values ('Tom', Array ['']);

-- 이렇게 Array를 생략할 수 없다
insert into table_array(name, phones) 
values ('John', ['010-2222-2222']);


-- 값을 읽어올 때는 Array의 index는 1부터 시작
select name, phones[1] from table_array;

select * from table_array where phones[1] = '010-9999-8888';


-- 특정 번호를 가진 누군가를 찾고 싶다면
select * from table_array where '010-9999-8888' in phones;			-- ERROR
select * from table_array where '010-9999-8888' = any(phones);		-- OK





-- 6) hstore(hash store): k-v쌍을 저장 (단, k와 v는 text string이어야 한다)
create extension if not exists hstore;


create table table_hstore (
	book_id		serial			primary key,
	title		varchar(100)	not null,
	book_info	hstore
);

select * from table_hstore;


insert into table_hstore (title, book_info)
values (
	'title1', 
	'
		"publisher" => "ABC books",
		"paper_cost" => "10.00",
		"e_cost" => "5.85"
	'
);


insert into table_hstore (title, book_info)
values (
	'title2', 
	'
		"publisher" => "GOOD books",
		"paper_cost" => "20.00",
		"e_cost" => "12.50"
	'
);


-- 값을 꺼내올 때(화살표와 작은따옴표)
select book_info->'publisher' from table_hstore;

-- 값을 꺼내올 때(map형태)
select book_info['publisher'] from table_hstore;





-- 7) JSON: (https://www.rfc-editor.org/rfc/rfc8259)
--			정의) JSON is a text format for the serialization of structured data. ==> 통신, 저장
--			JSON can represent four primitive types (strings, numbers, booleans, and null) 
--          and two structured types (objects and arrays).

--    Postgresql에서의 JSON
--    1. postgresql has built-in support for JSON
--    2. JSON은 알고보면 text 타입이다
--    3. JSONB는 binary version of JSON
--    4. JSON은 text 그 자체를 그대로 저장한다(space, tab, indentation 등)
--    5. JSONB는 binary data라서 space나 indentation등이 무시될 수도 있다.
--    결론: 원본 json 포맷을 그대로 보존해야 하는 경우만 json을 사용하고, 나머지는 jsonb 사용

create table table_json (
	id 		serial		primary key,
	docs 	JSON
);



-- json 타입의 값을 표현할 때는 반드시 홑따옴표('')로 묶어주어야 한다. ==> 예외 없음
insert into table_json (docs) values
('[1,2, 3,4, 5,6]'),		-- k,v Array 형식일 때는 key가 반드시 ""로 감싸질 필요가 없다
('{"key": "value"}');		-- k:v 이 경우 key는 반드시 ""로 감싸져야 한다. value가 string일 때도 당연히 ""으로 감싸야 한다


-- k:v 형태일 때 value가 string이 아니라면 value는 ""으로 감싸지 않아도 된다
insert into table_json (docs) values
('{"k": 1}');


-- 이렇게 홑따옴표로 묶지 않으면 ERROR
insert into table_json (docs) values
([10,20, 30,40, 50,60]);


-- 이렇게 string을 홑따옴표로 묶어도 ERROR
insert into table_json (docs) values
('{"key2": 'value2'}');


-- json에는 단일한 primitive 값을 넣을 수도 있다. (k:v쌍만 들어가는 게 아니다)
-- 단, json 데이터는 SQL문자열 리터럴, 다시말해 ''으로 감싸야 하는데, ''의 내부가 유효한 string이려면 "hello"여야 한다.
-- 즉, json 데이터는 '"hello~"'여야 한다.

insert into table_json (docs) values		-- ERROR
('hello~');

insert into table_json (docs) values		-- OK
('"hello~"');


-- 그럼 단일한 primitive 타입인 숫자, null 등은 ""가 필요없을까? ==> 그렇다. 필요없다.
insert into table_json (docs) values
('10');

insert into table_json (docs) values
('null');

insert into table_json (docs) values
('0.314');

-- 그럼에도 불구하고 "100"이라는 string을 표현하고 싶다면 ""로 감싸도 된다.
insert into table_json (docs) values
('"100"');


select * from table_json;


-- ERROR: @> 연산자는 json 타입에는 지원되지 않고, jsonb 타입에서만 지원된다.
select * 
from table_json
where docs @> '2';


-- 굳이 이렇게 사용할 수는 있으나 권장되지는 않고
select * 
from table_json
where docs::jsonb @> '[2]'::jsonb;


-- 차라리 jsonb를 사용하거라
alter table table_json
alter column docs
type jsonb;


-- jsonb를 사용하니까 index를 사용할 수 있다
create index on table_json using GIN (docs jsonb_path_ops);




-- 8) network addresses 타입

/* 주로 cidr이나 inet만 쓰게 될 거다
이름			저장 사이즈				특징
------------------------------------------------------------------
cidr		7 or 19 bytes			IPv4 & IPv6 networks (네크워크만 저장가능. host부분이 모두 0이어야 한다)
inet		7 or 19 bytes			IPv4 & IPv6 hosts and networks (host부분이 모두 0이 아니어도 된다)
macdddr		6 bytes					MAC address
macaddr8	8 bytes					MAC address (EUI-64 format)
*/


-- netmask를 알고가자
-- /24는 앞부터 24bit(3byte)까지가 네트워크 주소이고, 그 이하는 host 주소라는 의미
-- 예를 들어 192.168.0.1/24인 경우 이 네트워크는 192.168.0.1 ~ 192.168.0.254 범위의 host를 가진 네트워크라는 의미
-- (맨 끝의 0은 네트워크 주소이고, 255는 broadcast 주소이므로 제외)


-- 두가지의 차이를 보고 싶다면
SELECT '192.168.1.10/24'::inet;		-- host 주소까지 모두 저장 가능
SELECT '192.168.1.10/24'::cidr;		-- ERROR: invalid cidr value: "192.168.1.10/24". Value has bits set to right of mask. 
SELECT '192.168.1.0/24'::cidr;			-- 이렇게 해줘야 저장 가능



create table table_netaddr (
	id		serial		primary key,
	ip		inet
);


insert into table_netaddr(ip) values
('4.35.221.243'),
('4.152.207.126'),
('4.152.207.238'),
('4.249.111.162'),
('12.1.223.132'),
('12.8.192.60');


select * from table_netaddr;



-- netmask를 적용한 형태로 변경
-- 즉, 개별 host ip(192.168.0.1)를 네트워크 주소를 포함하는 형태로 변환하기
select 
	ip,
	set_masklen(ip, 24) as inet_24
from table_netaddr;



-- 하지만, 위의 예는 진정한 inet -> cidr이 아니다.
-- cidr은 host부분(mask의 오른쪽 숫자)이 모두 0이어야 하기 때문이다.
-- 이번엔 진짜 inet -> cidr 변환을 해보자
select 
	ip,
	set_masklen(ip, 24) as inet_24,
	set_masklen(ip::cidr, 24) as cidr_24		-- 진짜 cidr
from table_netaddr;



-- 위의 작업을 mask를 증가시키면서 살펴보자
select 
	ip,
	set_masklen(ip, 24) as inet_24,
	set_masklen(ip::cidr, 24) as cidr_24,		-- 진짜 cidr
	set_masklen(ip::cidr, 25) as cidr_24,		-- 진짜 cidr
	set_masklen(ip::cidr, 26) as cidr_24,		-- 진짜 cidr
	set_masklen(ip::cidr, 27) as cidr_24,		-- 진짜 cidr
	set_masklen(ip::cidr, 28) as cidr_24		-- 진짜 cidr
from table_netaddr;

