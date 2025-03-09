-- section10. conversion function

-- 1) to_char() : timestamp, interval, integer, double precision, numeric => char
TO_CHAR(표현식, format)

select to_char(12345.678, '2');			-- "2"
select to_char(12345.678, '000,000');		-- " 012,346"
select to_char(12345.678, '999,999.999');	-- "  12,345.678"


