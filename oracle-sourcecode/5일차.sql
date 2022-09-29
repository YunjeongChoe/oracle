--변환 함수 TO_NUMBER 숫자데이터 타입으로
SELECT '12' * '300'
FROM dual;

CREATE TABLE ex5_1 (
    col1 varchar2(1000)
);

INSERT INTO ex5_1 VALUES('123');
INSERT INTO ex5_1 VALUES('92');
INSERT INTO ex5_1 VALUES('1111');
INSERT INTO ex5_1 VALUES('999');

SELECT *
FROM ex5_1
--ORDER BY 1 DESC;             --이렇게 하면 내림차순으로 정렬이 안됨
ORDER BY TO_NUMBER(col1) desc; --이렇게 해야됨 




--CUSTOMERS 테이블에서 CUST_YEAR_OF_BIRTH를 활용하여 80년 이후 출생자를 출력하시오
--이름, 출생년도, 나이(올해년도-출생년도), 성별 출력 
--나이 오름차순, 나이가 같으면 이름 오름차 순 
SELECT CUST_NAME
     , CUST_YEAR_OF_BIRTH
     , CUST_GENDER
     , TO_CHAR(sysdate, 'YYYY') - CUST_YEAR_OF_BIRTH as 나이 --(alias는 order by에서 
FROM CUSTOMERS                                               --수있지만 where절에서는 못씀)
WHERE CUST_YEAR_OF_BIRTH >= 1980
ORDER BY 3 asc, 1 asc;          --3은 3번째에 위치하는 절(나이), 1은 첫번째(cust_name)





/*집계함수 
  대상 데이터에서 특정 그룹으로 묶어 그 그룹에 대해 총합, 평균, 최대값, 최소값 등을 구하는 함수
*/
--COUNT <-로우의 건수집계
SELECT COUNT(*)                       --null포함(107건)
     , COUNT(ALL department_id)       --default ALL(106건)
     , COUNT(department_id)           --all은 중복 포함(106건)
     , COUNT(distinct department_id)  --중복제거 (11건)
FROM employees;



--AVG:평균
SELECT AVG(mem_mileage)
FROM member;

--employees의 평균 급여와 직원수를 출력하시오
SELECT ROUND(AVG(salary),2) as 평균급여
     , COUNT(*) as 직원수
FROM employees;



SELECT ROUND(AVG(salary),2)
     , MIN(salary)
     , MAX(salary)
     , SUM(salary)
FROM employees;


--50부서의 직원 수와 평균 최소 최대 급여를 출력하시오
SELECT COUNT(employee_id)      as 직원수 
     , ROUND(AVG(salary),2)    as 평균급여 
     , MIN(salary)             as 최소 
     , MAX(salary)             as 최대
FROM employees
WHERE department_id = 50
OR    department_id = 60;


--부서별 직원수랑 평균급여
--GROUP BY 절
SELECT department_id
     , COUNT(employee_id)      as 부서별직원수 
     , ROUND(AVG(salary),2)    as 부서평균급여 
FROM employees
GROUP BY department_id         --집계함수를 제외한 select 절에 들어간 컬럼은 GROUP BY절에 들어가야함
ORDER BY 1;


--member테이블 직업별 고객수를 출력하시오
SELECT
    *
FROM member;

SELECT mem_job
     , COUNT(mem_id)    as 고객수 
FROM member
GROUP BY mem_job
ORDER BY 고객수 desc;




--dictinct 중복제거
SELECT distinct mem_job
FROM member;

--년도별, 지역별, 대출총액을 구하시오 
SELECT substr(period,1,4) as 년도
     , region
     , sum(loan_jan_amt) as 대출총액
FROM kor_loan_status
WHERE substr(period,1,4) = '2013'
GROUP BY substr(period,1,4), region
HAVING SUM(loan_jan_amt) >=500000
ORDER BY 2;

--실행순서 : FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY



--3명 이상 있는 직업만 출력하시오
SELECT mem_job
     , COUNT(mem_id)    as 고객수 
FROM member
GROUP BY mem_job
HAVING COUNT(mem_id) >=3
ORDER BY 고객수 desc;


SELECT * FROM employees;
--employees 테이블에서 직원수가 30명 이상인 부서와 직원수를 출력하시오
SELECT department_id
     , COUNT(employee_id) as 직원수 
FROM employees
GROUP BY department_id
HAVING COUNT(employee_id) >= 30; 



--의사컬럼 ROWNUM : 테이블에 없는데 있는것 처럼 사용, 서브쿼리로 사용 
--임시로 번호가 생김 
SELECT ROWNUM as rnum
     , a.*
FROM member a;         --a는 테이블에 준 alias



--고용요일별 입사직원수를 조회하시오

--enmployees에 있는 직원 
--SELECT * FROM employees;
--
--SELECT TO_CHAR(hire_date, 'd') 
--     , emp_id
--FROM employees;

SELECT TO_CHAR(hire_date, 'day') as 요일 
    , COUNT(employee_id)         as 직원수 
FROM employees
GROUP BY TO_CHAR(hire_date, 'day')
ORDER by 2 desc;


SELECT cust_gender
     , cust_name
     , DECODE(cust_gender, 'M', '남자', 'F', '여자' , '?') gender
                        --조건1  결과1  조건2  결과2   그밖 
FROM customers;




--직원의 고용일자 컬럼을 활용하여 년도별, 요일별, 입사인원수를 출력하시오 (정렬:년도)
--(TO_CHAR, DECODE, GROUP BY, COUNT, SUM.. 사용)
--1)고용일자 데이터로 년도 컬럼 생성, 요일컬럼 생성,
--2)생성한 데이터로 집계 

SELECT *
FROM employees;

SELECT TO_CHAR (hire_date, 'YYYY') as 년도
     , SUM(DECODE(TO_CHAR(hire_DATE, 'day'),'1', '1',0 )) as 일요일 
     , SUM(DECODE(TO_CHAR(hire_DATE, 'day'),'2', '1',0 )) as 월요일 
     , SUM(DECODE(TO_CHAR(hire_DATE, 'day'),'3', '1',0 )) as 화요일 
     , SUM(DECODE(TO_CHAR(hire_DATE, 'day'),'4', '1',0 )) as 수요일 
     , SUM(DECODE(TO_CHAR(hire_DATE, 'day'),'5', '1',0 )) as 목요일 
     , SUM(DECODE(TO_CHAR(hire_DATE, 'day'),'6', '1',0 )) as 금요일 
     , SUM(DECODE(TO_CHAR(hire_DATE, 'day'),'7', '1',0 )) as 토요일 
     , COUNT (hire_date) as 년도별전체     
FROM employees
GROUP BY TO_CHAR (hire_date, 'YYYY')
ORDER BY 1;






--



