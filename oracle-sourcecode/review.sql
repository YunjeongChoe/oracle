SELECT * FROM member;
--member(고객) 중 대전에 거주하고, 직업이 회사원인 고객을 출력 
SELECT mem_name
     , mem_add1
     , mem_job
FROM member
WHERE mem_add1 LIKE '%대전%'
AND mem_job = '회사원';



--SUBSTR 문자 빼오는거 
SELECT * FROM member;
--이름 : 김은대 주민번호 760115-1******
--형태로 출력하시오 
SELECT '이름:' || substr(mem_name,1) ||' '|| '주민번호:' || substr(mem_regno1,1) ||'-'||substr(mem_regno2,1,1) || '******'
     
FROM member;




--INSTR 위치반환 함수 
SELECT * FROM member;
--mem_mail에 @의 위치를 출력하시오 
SELECT mem_name
     , mem_mail
     , INSTR(mem_mail,'@',1) as idx
FROM member;





--문제 : email주소의 @앞 문자열을 id @뒤 문자열을 domain으로 출력하시오
--ex)name  id       domain
--ex)김은대 pyodab   ycos.co.kr

SELECT mem_name
     , mem_mail
     , INSTR(mem_mail,'@',1) as idx
     , SUBSTR(mem_mail,1, INSTR(mem_mail,'@')-1) as id
     , SUBSTR(mem_mail, INSTR(mem_mail,'@')+1) as domain
FROM member;









SELECT * FROM employees;
--employees 직원의 일당을 계산하여 출력하시오 (한 달 30일 기준)
--                                       소수점 둘째자리까지 표현











SELECT * FROM TB_INFO;
--INFO_NO가 짝수이면 짝수를, 홀수이면 홀수를 출력하시오
--1.필요한 컬럼 출력 






--오늘부터 이번 달 마지막 날까지 D-DAY를 구하시오





--현재일자를 기준으로 사원테이블(employees)의 입사일자를 참조해서 근속년수가 23년 이상인 사원을 출력하시오







-- products 테이블에서 상품 최저 금액(min_price)가 50 원 '미만'인 제품명을 출력하시오





--30원 이상 ~ 50원 미만일 경우 , 카테고리가 sw/other일 경우



--40 or 50번 부서 직원을 조회하시오




--CUSTOMERS 테이블에서 CUST_YEAR_OF_BIRTH를 활용하여 80년 이후 출생자를 출력하시오
--이름, 출생년도, 나이(올해년도-출생년도), 성별 출력 
--나이 오름차순, 나이가 같으면 이름 오름차 순 



--employees의 평균 급여와 직원수를 출력하시오


--50부서의 직원 수와 평균 최소 최대 급여를 출력하시오



--member테이블 직업별 고객수를 출력하시오



--년도별, 지역별, 대출총액을 구하시오 



--3명 이상 있는 직업만 출력하시오



--employees 테이블에서 직원수가 30명 이상인 부서와 직원수를 출력하시오


--고용요일별 입사직원수를 조회하시오
--enmployees에 있는 직원




--직원의 고용일자 컬럼을 활용하여 년도별, 요일별, 입사인원수를 출력하시오 (정렬:년도)
--(TO_CHAR, DECODE, GROUP BY, COUNT, SUM.. 사용)
--1)고용일자 데이터로 년도 컬럼 생성, 요일컬럼 생성,
--2)생성한 데이터로 집계 



