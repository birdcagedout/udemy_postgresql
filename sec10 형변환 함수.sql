-- section10. conversion function

-- 1) to_char() : timestamp, interval, integer, double precision, numeric => char
TO_CHAR(표현식, format)


-- 1-1) 0패딩

-- 0개수가 유효자리수와 같으면 그대로 출력하되, 앞에 부호부분은 양수이면 공백으로 처리
select to_char(12345, '00000');					-- " 12345"
select to_char(-12345, '00000');					-- "-12345"
select to_char(12345, 'S00000');					-- "+12345"		==> 부호를 명시하고 싶으면 S 사용

-- 0개수가 유효자리수보다 적으면 overflow 발생 (주의: 앞에서든 뒤에서든 마음대로 자르지 않는다)
select to_char(12345, '0000');						-- " ####"

-- 천단위 표시
select to_char(12345678, '000,000,000');			-- " 012,345,678"
select to_char(12345678, '000,000,000,000');		-- " 000,012,345,678"
select to_char(12345678.9, '000,000,000,000.00');	-- " 000,012,345,678.90"	==> 소수점이하도 0으로 패딩


-- 1-2) 공백패딩 (소수점 이하는 0패딩)

select to_char(12345,  '99999');					-- " 12345"
select to_char(-12345, '99999');					-- "-12345"
select to_char(12345,  'S99999');					-- "+12345"		==> 부호를 명시하고 싶으면 S 사용


select to_char(12345.678, '99,999.999');			-- " 12,345.678"		==> 부호1개
select to_char(12345.678, '999,999.999');			-- "  12,345.678"		==> 부호1개 + 자리수1개
select to_char(12345.678, '9,999,999.999');		-- "    12,345.678"		==> 부호1개 + (자리수2개 + 쉼표 1개)
select to_char(12345.678, '9,999,999.99999');		-- "    12,345.67800"	==> 부호1개 + (자리수2개 + 쉼표 1개) + 소수점이하 2개는 0으로 패딩



-- 1-3) 날짜
select release_date, to_char(release_date, 'DD-MM-YYYY'), to_char(release_date, 'YYYY. MM. DD. (Dy)') from movies;


-- 1-4) timestamp
select