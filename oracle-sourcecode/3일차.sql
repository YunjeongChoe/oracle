/*
UPDATE TB_INFO
SET hobby = '요리'
WHERE nm = '이앞길';
COMMIT;

SELECT *
FROM TB_INFO
WHERE nm = '이앞길';
*/





/* 연산자 */
-- 수식 연산자 + - 
SELECT employee_id
    , emp_name
    , ROUND(salary / 30,2)     as 일당       --2는 둘째자리까지 반올림하라는 뜻 
    , salary                   as 월급
    , salary - salary * 0.1    as 실수령액
    , salary * 12              as 연봉
    , emp_name || ':' || email as 이메일     --문자연산자 ||
FROM employees;



--논리 연산자 : >, <


SELECT * FROM employees WHERE salary = 2600 ;    --같다 
SELECT * FROM employees WHERE salary <> 2600 ;   --같지 않다 
SELECT * FROM employees WHERE salary != 2600 ;   --같지 않다
SELECT * FROM employees WHERE salary < 2600 ;    --미만
SELECT * FROM employees WHERE salary > 2600 ;    --초과
SELECT * FROM employees WHERE salary <= 2600 ;   --이하
SELECT * FROM employees WHERE salary >= 2600 ;   --이상


-- products 테이블에서 상품 최저 금액(min_price)가 50 원 '미만'인 제품명을 출력하시오
SELECT prod_name
    , prod_min_price
FROM products
WHERE prod_min_price < 50 
ORDER BY prod_min_price DESC;

--30원 이상 ~ 50원 미만일 경우 , 카테고리가 sw/other일 경우 
--SELECT prod_name
--    , prod_min_price
--FROM products
--WHERE prod_min_price < 50 
--AND prod_min_price >=30
--AND prod_category = 'Software/other'
--ORDER BY prod_min_price DESC;

--AND(그리고) [A, B 조건 모두 만족할 때]
--OR(또는)    [A 또는 B 조건에 해당할 때]

--40 or 50번 부서 직원을 조회하시오
SELECT emp_name
     , department_id
FROM employees
WHERE department_id = 40
OR department_id = 50;




/*표현식 CASE*/
SELECT cust_gender
     , cust_name
     , CASE WHEN cust_gender = 'M' then '남자'
            WHEN cust_gender = 'F' then '여자'
            ELSE '?'
        END as 성별 
FROM customers;





--표현식에서 논리연산자 써보기(표현을 바꿀때 하나의 타입이여야 한다=타입 맞춰줘야됨))
SELECT employee_id, salary
    ,CASE WHEN salary <= 5000 THEN 'C등급'
         WHEN salary > 5000 AND salary <= 15000 THEN 'B등급'     --콤마 기준 이게 하나의 컬럼 
         ELSE 'A등급'
        END as grade    --alias를 필수로 써줘야 됨 
FROM employees
ORDER BY 2 desc;   --2의 의미는 셀렉 절에 있는 2번순서(salary) 





/*LIKE 조건식*/
SELECT emp_name
FROM employees
WHERE emp_name LIKE 'A%';   --첫 글자가 A로 시작하는

CREATE TABLE ex3_5 (
    nm varchar2(100)
);
INSERT INTO ex3_5 VALUES('홍길');
INSERT INTO ex3_5 VALUES('홍길동');
INSERT INTO ex3_5 VALUES('홍길상');
INSERT INTO ex3_5 VALUES('길상');
INSERT INTO ex3_5 VALUES('길상홍길');

SELECT *
FROM ex3_5
--WHERE nm LIKE '홍%';    --홍으로 시작하는
--WHERE nm LIKE '%길';    --길로 끝나는
WHERE nm LIKE '%홍%';   --어디든 홍이 포함된
--WHERE nm = '홍';        --완벽하게 홍이여야만 검색됨
--길이까지 맞아야할 때는 % 대신 _ 사용
--WHERE nm LIKE '홍_';    
--WHERE nm LIKE '_길_';   



--이씨 또는 김씨를 검색하시오 
SELECT *
FROM TB_INFO
WHERE nm LIKE '이%'
OR nm LIKE '김%';


--이씨가 아닌 학생을 조회하시오  
SELECT *
FROM TB_INFO
WHERE nm NOT LIKE '이%';       --NOT 부정의 의미



--메일주소가 gmail이 아닌 학생을 조회하시오 
SELECT *
FROM TB_INFO
WHERE email NOT LIKE '%gmail.com';






