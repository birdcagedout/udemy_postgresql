-- Section5. Querying Data
-- 35. Select all data from a table


-- 주의1) "SELECT ~ FROM ~" 구문애서 FROM절을 SELECT절보다 먼저 처리한다.
-- 주의2) 필요한 열만 선택하여 SELECT할 것.
-- 주의3) 열이름에 AS로 별명을 붙일 때는 큰따옴표만 사용 가능

-- 주의4) "SELECT ~ FROM ~ ORDER BY ~" 구문에서 FROM절 -> SELECT절 -> ORDER BY절 순서로 처리된다. 
SELECT *
FROM movies
ORDER BY 
	release_date ASC,
	movie_name DESC;

