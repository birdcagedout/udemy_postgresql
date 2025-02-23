-- Udemy https://www.udemy.com/course/postgresqlmasterclass/learn/lecture/22232724#overview
-- Section2. Introduction to PostgreSQL



-- 6. Creating a Database ROLE (adam)
--    Role은 하나의 사용자를 뜻하는 user ID일 수도 있고, 여러 사용자를 묶어놓은 user group의 개념일 수도 있다.
--    따라서 아래 7번과 같이 database의 owner를 adam으로 하여 생성하려고 하는 경우,
--    현재 사용자 ID가 adam이 아닌 경우 에러가 발생한다.
--    따라서 6.5번과 같이 adam이라는 ROLE을 현재 user인 postgres에게 부여하여
--    마치 postgres라는 user는 adam이라는 group의 멤버인 것처럼 ROLE을 사용할 수 있다. 
CREATE ROLE adam WITH
	LOGIN
	NOSUPERUSER
	CREATEDB
	NOCREATEROLE
	INHERIT
	NOREPLICATION
	NOBYPASSRLS
	CONNECTION LIMIT -1
	PASSWORD 'xxxxxx';


-- 6.5 Role을 만들고 나면
-- 현재 user(예를 들어 postgres 계정으로 로그인한 경우)를 adam ROLE에 추가하여야 한다.
-- 그래야 아래 7번과 같이 learning이라는 database를 adam 소유로 생성할 수 있다.
GRANT adam TO postgres;



-- 현재 adam이라는 ROLE을 가진 모든 사용자를 보고 싶다면
SELECT member_role.rolname AS member
FROM pg_auth_members
JOIN pg_roles AS member_role ON pg_auth_members.member = member_role.oid
JOIN pg_roles AS role_role ON pg_auth_members.roleid = role_role.oid
WHERE role_role.rolname = 'adam';



-- 7. Creating a Database (adam소유의 learning이라는 database ==> 실습은 여기서)
CREATE DATABASE learning
    WITH
    OWNER = adam
    ENCODING = 'UTF8'
    LOCALE_PROVIDER = 'libc'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;


-- 이제부터는 learning 데이터베이스로 변경해야 한다.
-- psql에서 \c learning 하거나
-- pgadmin에서는 learning에서 우클릭 후 query tool을 연다.




-- 9. Install sample data files on server
-- 1) sample_data에서 customers.sql, products.sql, purchases.sql을 모두 열어서 모두 실행(F5)


/*
learning=# select * from public.customers;
 customer_id | first_name | last_name 
-------------+------------+-----------
           1 | John       | Doe
           2 | Jeff       | Smith
           3 | Mike       | Steel
           4 | Mark       | Benjamin
           5 | Hannah     | Rose
(5 rows)
*/


/*
learning=# select *from products;
 product_id | product_name | unit_price 
------------+--------------+------------
          1 | Computer     |     500.00
          2 | Mouse        |      20.00
          3 | Printer      |     300.00
          4 | Monitor      |     200.00
          5 | Microphone   |     215.00
          6 | Laptop       |     800.00
(6 rows)
*/


/*
learning=# select *from purchases;;
 purchase_id | product_id | customer_id 
-------------+------------+-------------
           1 |          1 |           1
           2 |          3 |           1
           3 |          6 |           2
           4 |          6 |           2
           5 |          3 |           3
           6 |          2 |           3
           7 |          4 |           4
           8 |          2 |           4
           9 |          3 |           5
          10 |          6 |           5
(10 rows)
*/







-- 10. Install Human Resources (hr) database
-- hr 이라는 database를 생성하고,
CREATE DATABASE hr
    WITH
    OWNER = adam
    ENCODING = 'UTF8'
    LOCALE_PROVIDER = 'libc'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;


-- hr로 새로운 연결을 만든 다음(hr/leibniz@local_postgresql)
-- 새로운 query tool을 열어서 hr.sql을 실행한다




/*
hr=# \dt
              릴레이션 목록
 스키마 |    이름     |  형태  | 소유주
--------+-------------+--------+---------
 public | countries   | 테이블 | leibniz
 public | departments | 테이블 | leibniz
 public | employees   | 테이블 | leibniz
 public | job_history | 테이블 | leibniz
 public | jobs        | 테이블 | leibniz
 public | locations   | 테이블 | leibniz
 public | regions     | 테이블 | leibniz
(7개 행)


hr=# select * from countries;
 country_id |       country_name       | region_id
------------+--------------------------+-----------
 AR         | Argentina                |         2
 AU         | Australia                |         3
 BE         | Belgium                  |         1
 BR         | Brazil                   |         2
 CA         | Canada                   |         2
 CH         | Switzerland              |         1
 CN         | China                    |         3
 DE         | Germany                  |         1
 DK         | Denmark                  |         1
 EG         | Egypt                    |         4
 FR         | France                   |         1
 HK         | HongKong                 |         3
 IL         | Israel                   |         4
 IN         | India                    |         3
 IT         | Italy                    |         1
 JP         | Japan                    |         3
 KW         | Kuwait                   |         4
 MX         | Mexico                   |         2
 NG         | Nigeria                  |         4
 NL         | Netherlands              |         1
 SG         | Singapore                |         3
 UK         | United Kingdom           |         1
 US         | United States of America |         2
 ZM         | Zambia                   |         4
 ZW         | Zimbabwe                 |         4
(25개 행)


hr=# select * from departments;
 department_id |   department_name    | manager_id | location_id
---------------+----------------------+------------+-------------
            10 | Administration       |        200 |        1700
            20 | Marketing            |        201 |        1800
            30 | Purchasing           |        114 |        1700
            40 | Human Resources      |        203 |        2400
            50 | Shipping             |        121 |        1500
            60 | IT                   |        103 |        1400
            70 | Public Relations     |        204 |        2400
            80 | Sales                |        145 |        2500
            90 | Executive            |        100 |        1700
           100 | Finance              |        108 |        1700
           110 | Accounting           |        205 |        1700
           120 | Treasury             |          0 |        1700
           130 | Corporate Tax        |          0 |        1700
           140 | Control And Credit   |          0 |        1700
           150 | Shareholder Services |          0 |        1700
           160 | Benefits             |          0 |        1700
           170 | Manufacturing        |          0 |        1700
           180 | Construction         |          0 |        1700
           190 | Contracting          |          0 |        1700
           200 | Operations           |          0 |        1700
           210 | IT Support           |          0 |        1700
           220 | NOC                  |          0 |        1700
           230 | IT Helpdesk          |          0 |        1700
           240 | Government Sales     |          0 |        1700
           250 | Retail Sales         |          0 |        1700
           260 | Recruiting           |          0 |        1700
           270 | Payroll              |          0 |        1700
(27개 행)



hr=# select * from employees limit 15;
 employee_id | first_name | last_name |            email             | phone_number | hire_date  |   job_id   |  salary  | commission_pct | manager_id | department_id
-------------+------------+-----------+------------------------------+--------------+------------+------------+----------+----------------+------------+---------------
         100 | Steven     | King      | steven.king@company.com      | 515.123.4567 | 2010-06-17 | AD_PRES    | 24000.00 |           0.00 |          0 |            90
         101 | Neena      | Kochhar   | neena.kochhar@company.com    | 515.123.4568 | 2010-06-18 | AD_VP      | 17000.00 |           0.00 |        100 |            90
         102 | Lex        | De Haan   | lex.de haan@company.com      | 515.123.4569 | 2010-06-19 | AD_VP      | 17000.00 |           0.00 |        100 |            90
         103 | Alexander  | Hunold    | alexander.hunold@company.com | 590.423.4567 | 2010-06-20 | IT_PROG    |  9000.00 |           0.00 |        102 |            60
         104 | Bruce      | Ernst     | bruce.ernst@company.com      | 590.423.4568 | 2010-06-21 | IT_PROG    |  6000.00 |           0.00 |        103 |            60
         105 | David      | Austin    | david.austin@company.com     | 590.423.4569 | 2011-06-22 | IT_PROG    |  4800.00 |           0.00 |        103 |            60
         106 | Valli      | Pataballa | valli.pataballa@company.com  | 590.423.4560 | 2011-06-23 | IT_PROG    |  4800.00 |           0.00 |        103 |            60
         107 | Diana      | Lorentz   | diana.lorentz@company.com    | 590.423.5567 | 2011-06-24 | IT_PROG    |  4200.00 |           0.00 |        103 |            60
         114 | Den        | Raphaely  | den.raphaely@company.com     | 515.127.4561 | 2011-07-01 | PU_MAN     | 11000.00 |           0.00 |        100 |            30
         115 | Alexander  | Khoo      | alexander.khoo@company.com   | 515.127.4562 | 2012-07-02 | PU_CLERK   |  3100.00 |           0.00 |        114 |            30
         116 | Shelli     | Baida     | shelli.baida@company.com     | 515.127.4563 | 2012-07-03 | PU_CLERK   |  2900.00 |           0.00 |        114 |            30
         117 | Sigal      | Tobias    | sigal.tobias@company.com     | 515.127.4564 | 2012-07-04 | PU_CLERK   |  2800.00 |           0.00 |        114 |            30
         108 | Nancy      | Greenberg | nancy.greenberg@company.com  | 515.999.4569 | 2012-06-25 | FI_MGR     | 12000.00 |           0.00 |        101 |           100
         109 | Daniel     | Faviet    | daniel.faviet@company.com    | 515.999.4169 | 2012-06-26 | FI_ACCOUNT |  9000.00 |           0.00 |        108 |           100
         110 | John       | Chen      | john.chen@company.com        | 515.999.4269 | 2012-06-27 | FI_ACCOUNT |  8200.00 |           0.00 |        108 |           100
(15개 행)

hr=# select * from job_history;
 employee_id | start_date |  end_date  |   job_id   | department_id
-------------+------------+------------+------------+---------------
         102 | 1993-01-13 | 2010-07-24 | IT_PROG    |            60
         101 | 1989-09-21 | 2010-10-27 | AC_ACCOUNT |           110
         101 | 1993-10-28 | 2020-03-15 | AC_MGR     |           110
         201 | 1996-02-17 | 1999-12-19 | MK_REP     |            20
         114 | 1998-03-24 | 1999-12-31 | ST_CLERK   |            50
         122 | 1999-01-01 | 1999-12-31 | ST_CLERK   |            50
         200 | 1987-09-17 | 1993-06-17 | AD_ASST    |            90
         176 | 1998-03-24 | 1998-12-31 | SA_REP     |            80
         176 | 1999-01-01 | 1999-12-31 | SA_MAN     |            80
         200 | 1994-07-01 | 2020-12-31 | AC_ACCOUNT |            90
(10개 행)

hr=# select * from jobs;
   job_id   |            job_title            | min_salary | max_salary
------------+---------------------------------+------------+------------
 AD_PRES    | President                       |      20000 |      40000
 AD_VP      | Administration Vice President   |      15000 |      30000
 AD_ASST    | Administration Assistant        |       3000 |       6000
 FI_MGR     | Finance Manager                 |       8200 |      16000
 FI_ACCOUNT | Accountant                      |       4200 |       9000
 AC_MGR     | Accounting Manager              |       8200 |      16000
 AC_ACCOUNT | Public Accountant               |       4200 |       9000
 SA_MAN     | Sales Manager                   |      10000 |      20000
 SA_REP     | Sales Representative            |       6000 |      12000
 PU_MAN     | Purchasing Manager              |       8000 |      15000
 PU_CLERK   | Purchasing Clerk                |       2500 |       5500
 ST_MAN     | Stock Manager                   |       5500 |       8500
 ST_CLERK   | Stock Clerk                     |       2000 |       5000
 SH_CLERK   | Shipping Clerk                  |       2500 |       5500
 IT_PROG    | IT Programmer                   |       4000 |      10000
 MK_MAN     | Marketing Manager               |       9000 |      15000
 MK_REP     | Marketing Representative        |       4000 |       9000
 HR_REP     | Human Resources Representative  |       4000 |       9000
 PR_REP     | Public Relations Representative |       4500 |      10500
(19개 행)

hr=# select * from locations;
 location_id |     street_address      | postal_code |        city         |  state_province  | country_id
-------------+-------------------------+-------------+---------------------+------------------+------------
        1000 | 1297 Via Cola di Rie    | 989         | Roma                |                  | IT
        1100 | 93091 Calle della Testa | 10934       | Venice              |                  | IT
        1200 | 2017 Shinjuku-ku        | 1689        | Tokyo               | Tokyo Prefecture | JP
        1300 | 9450 Kamiya-cho         | 6823        | Hiroshima           |                  | JP
        1400 | 2014 Jabberwocky Rd     | 26192       | Southlake           | Texas            | US
        1500 | 2011 Interiors Blvd     | 99236       | South San Francisco | California       | US
        1600 | 2007 Zagora St          | 50090       | South Brunswick     | New Jersey       | US
        1700 | 2004 Charade Rd         | 98199       | Seattle             | Washington       | US
        1800 | 147 Spadina Ave         | M5V 2L7     | Toronto             | Ontario          | CA
        1900 | 6092 Boxwood St         | YSW 9T2     | Whitehorse          | Yukon            | CA
        2000 | 40-5-12 Laogianggen     | 190518      | Beijing             |                  | CN
        2100 | 1298 Vileparle (E)      | 490231      | Bombay              | Maharashtra      | IN
        2200 | 12-98 Victoria Street   | 2901        | Sydney              | New South Wales  | AU
        2300 | 198 Clementi North      | 540198      | Singapore           |                  | SG
        2400 | 8204 Arthur St          |             | London              |                  | UK
(15개 행)

hr=# select * from regions;
 region_id |        region_name
-----------+---------------------------
         1 | Europe
         2 | Americas
         3 | Asia
         4 | Middle East and Africa
(4개 행)
*/






-- 11. Install sample stocks market data
-- 1) learning으로 데이터베이스를 바꾼 후에
\c learning



-- 2) stocks_symbols.sql 실행


/*
hr=# \c learning
접속정보: 데이터베이스="learning", 사용자="leibniz".
learning=#
learning=#
learning=#
learning=# \dt
               릴레이션 목록
 스키마 |      이름      |  형태  | 소유주
--------+----------------+--------+---------
 public | customers      | 테이블 | leibniz
 public | products       | 테이블 | leibniz
 public | purchases      | 테이블 | leibniz
 public | stocks_symbols | 테이블 | leibniz
(4개 행)

learning=# select * from stocks_symbols;
 symbol_id | symbol |             symbol_name             | symbol_type_code |  symbol_sector
-----------+--------+-------------------------------------+------------------+------------------
         1 | AAL    | American Airlines Group Inc         | EQS              | Services
         2 | AAPL   | Apple Inc                           | EQS              | Consumer Goods
         3 | AMZN   | Amazon.com Inc.                     | EQS              | Services
         4 | C      | Citigroup Inc                       | EQS              | Financial
         5 | FB     | Facebook Inc                        | EQS              | Technology
         6 | FB     | FBR Asset Investment Corp           | EQS              | Technology
         7 | GE     | General Electric Co.                | EQS              | Industrial Goods
         8 | GOOG   | Alphabet Inc                        | EQS              | Technology
         9 | GOOG   | Google Inc                          | EQS              |
        10 | NFLX   | NetFlix Inc                         | EQS              | Services
        11 | QQQ    | Invesco QQQ Trust Series 1          | ETF              |
        12 | SPY    | SSGA SPDR S&P 500                   | ETF              |
        13 | TSLA   | Tesla Inc                           | EQS              | Consumer Goods
        14 | XLF    | Financial Select Sector SPDR        | ETF              |
        15 | XLP    | Consumer Staples Select Sector SPDR | ETF              |
(15개 행)
*/


-- 3) stock_types.sql 실행

/*
learning=# select * from stocks_types;
 type_id | type_code |      type_name
---------+-----------+----------------------
       1 | EQS       | Stock
       2 | ETF       | Exchange Traded Fund
(2개 행)
*/



-- 4) stocks_prices.sql 실행 (파일 겁나 크니 주의)


/*
learning=# select * from stocks_prices limit 30;
 price_id | symbol_id | price_date | open_price | high_price | low_price | close_price | change_1d | return_1d
----------+-----------+------------+------------+------------+-----------+-------------+-----------+-----------
        1 |         1 | 2010-01-04 |     4.5621 |     4.6564 |    4.3925 |      4.4962 |   -0.0660 |   -1.4463
        2 |         1 | 2010-01-05 |     4.5150 |     5.0617 |    4.4396 |      5.0052 |    0.5090 |   11.3208
        3 |         1 | 2010-01-06 |     4.8921 |     5.0711 |    4.7130 |      4.7978 |   -0.2074 |   -4.1431
        4 |         1 | 2010-01-07 |     4.7695 |     5.1183 |    4.7601 |      4.9392 |    0.1414 |    2.9470
        5 |         1 | 2010-01-08 |     4.9675 |     5.1183 |    4.7695 |      4.8449 |   -0.0943 |   -1.9084
        6 |         1 | 2010-01-11 |     4.8355 |     4.9298 |    4.6564 |      4.7507 |   -0.0943 |   -1.9455
        7 |         1 | 2010-01-12 |     4.7695 |     4.8543 |    4.6753 |      4.7884 |    0.0377 |    0.7937
        8 |         1 | 2010-01-13 |     4.8261 |     5.1843 |    4.7318 |      5.1654 |    0.3770 |    7.8740
        9 |         1 | 2010-01-14 |     5.1466 |     5.3822 |    5.0994 |      5.2691 |    0.1037 |    2.0073
       10 |         1 | 2010-01-15 |     5.3162 |     5.5047 |    5.1183 |      5.1843 |   -0.0848 |   -1.6100
       11 |         1 | 2010-01-19 |     5.1843 |     5.4011 |    5.1843 |      5.3162 |    0.1320 |    2.5455
       12 |         1 | 2010-01-20 |     5.3256 |     5.5519 |    5.2879 |      5.4105 |    0.0943 |    1.7730
       13 |         1 | 2010-01-21 |     5.5424 |     5.6178 |    5.1088 |      5.1466 |   -0.2639 |   -4.8780
       14 |         1 | 2010-01-22 |     5.1654 |     5.2031 |    4.8166 |      4.9392 |   -0.2074 |   -4.0293
       15 |         1 | 2010-01-25 |     5.0334 |     5.1843 |    4.8543 |      4.9203 |   -0.0189 |   -0.3817
       16 |         1 | 2010-01-26 |     4.9109 |     4.9769 |    4.7601 |      4.7601 |   -0.1602 |   -3.2567
       17 |         1 | 2010-01-27 |     4.8072 |     4.8732 |    4.2134 |      4.5810 |   -0.1791 |   -3.7624
       18 |         1 | 2010-01-28 |     4.7035 |     4.9203 |    4.4396 |      4.8449 |    0.2639 |    5.7613
       19 |         1 | 2010-01-29 |     4.9298 |     5.2879 |    4.8732 |      5.0052 |    0.1602 |    3.3074
       20 |         1 | 2010-02-01 |     5.1183 |     5.3068 |    5.0429 |      5.2785 |    0.2734 |    5.4614
       21 |         1 | 2010-02-02 |     5.3256 |     5.6555 |    5.2974 |      5.6178 |    0.3393 |    6.4286
       22 |         1 | 2010-02-03 |     5.5990 |     5.6367 |    5.3256 |      5.3351 |   -0.2828 |   -5.0336
       23 |         1 | 2010-02-04 |     5.4859 |     5.4859 |    5.1560 |      5.1748 |   -0.1602 |   -3.0035
       24 |         1 | 2010-02-05 |     5.1843 |     5.6838 |    5.1183 |      5.5519 |    0.3770 |    7.2860
       25 |         1 | 2010-02-08 |     5.5424 |     5.7592 |    5.4859 |      5.5896 |    0.0377 |    0.6791
       26 |         1 | 2010-02-09 |     5.7969 |     6.1174 |    5.7969 |      6.0703 |    0.4807 |    8.6003
       27 |         1 | 2010-02-10 |     6.0232 |     6.0609 |    5.8535 |      5.9478 |   -0.1225 |   -2.0186
       28 |         1 | 2010-02-11 |     5.9383 |     6.1457 |    5.8629 |      5.9572 |    0.0094 |    0.1585
       29 |         1 | 2010-02-12 |     5.9100 |     6.5133 |    5.8346 |      6.4190 |    0.4619 |    7.7532
       30 |         1 | 2010-02-16 |     6.5322 |     6.5981 |    6.3625 |      6.4850 |    0.0660 |    1.0279
(30개 행)



learning=# select count(*) from stocks_prices;
 count
-------
 33085
(1개 행)
*/




-- 12. Install northwind database
-- northwind라는 데이터베이스를 생성하고

CREATE DATABASE northwind
    WITH
    OWNER = adam
    ENCODING = 'UTF8'
    LOCALE_PROVIDER = 'libc'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;



-- northwind.sql을 실행(테이블 개수 많고 데이터 많음 주의)

/*
learning=# \c northwind
접속정보: 데이터베이스="northwind", 사용자="leibniz".
northwind=# \dt
                   릴레이션 목록
 스키마 |          이름          |  형태  | 소유주
--------+------------------------+--------+---------
 public | categories             | 테이블 | leibniz
 public | customer_customer_demo | 테이블 | leibniz
 public | customer_demographics  | 테이블 | leibniz
 public | customers              | 테이블 | leibniz
 public | employee_territories   | 테이블 | leibniz
 public | employees              | 테이블 | leibniz
 public | order_details          | 테이블 | leibniz
 public | orders                 | 테이블 | leibniz
 public | products               | 테이블 | leibniz
 public | region                 | 테이블 | leibniz
 public | shippers               | 테이블 | leibniz
 public | suppliers              | 테이블 | leibniz
 public | territories            | 테이블 | leibniz
 public | us_states              | 테이블 | leibniz
(14개 행)
*/





-- 13. Drop a database
-- Superuser와 database 소유자만 DROP할 수 있다
DROP DATABASE (IF EXISTS) 데이터베이스이름;






