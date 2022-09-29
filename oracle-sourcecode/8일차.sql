
/*CUSTOMERS 고객 정보를 출력하시오
 (젊은 고객부터 출력)*/

SELECT * FROM sales;
SELECT * FROM customers;
SELECT * FROM countries;



--풀이

--select *
--from all_tab_columns
--where table_name = "customers"; 

select a.cust_name                                      as 이름
     , DECODE(a.cust_gender, 'M', '남자', 'F', '여자')   as 성별
     , TO_CHAR(sysdate,'YYYY') - a.cust_year_of_birth   as 나이
     , a.cust_city                                      as 도시
     , (select country_name
        from countries
        where country_id = a.country_id)                as 국가
from customers a; 



--질의 결과까지 오래 걸리면 join으로 해서 결과내는게 더 빠름
=--직원과 고객의 실적내용이 많은 관계 
SELECT (select cust_name 
      from customers 
      where cust_id = a.cust_id) as 구매고객 
   , (select emp_name
      from employees
      where employee_id = a.employee_id) as 판매직원 
    , count(*)
FROM sales a
GROUP BY a.cust_id, a.employee_id
ORDER BY 3 desc;


--위 쿼리를 join해서 결과내기 

select * from sales;
select * from customers;
select * from employees;


SELECT *
FROM sales a
    , customers b
    , employees c
WHERE a.cust_id = b.cust_id
AND   a.employee_id = c.employee_id;          --1.테이블 조인하기


------------2.
SELECT b.cust_name                   as 고객이름 
     , c.emp_name                    as 직원이름
     , COUNT(*)                      as cnt
FROM sales a
    , customers b
    , employees c
WHERE a.cust_id = b.cust_id
AND   a.employee_id = c.employee_id
GROUP BY b.cust_id, b.cust_name
       , c.employee_id, c.emp_name
ORDER BY 3 DESC;



--세미 조인 (EXISTS <--존재하는 )
SELECT department_id
     , department_name
FROM departments a
WHERE (NOT) EXISTS (select *
              from employees b
              where a.department_id = b.department_id);
              
--수강이력이 없는 학생을 조회 (not을 빼면 수강내역이 있는 학생들만 조회됨)
SELECT *
FROM 학생 a
WHERE NOT EXISTS (select *
                  from 수강내역
                  where 학번 = a.학번);
                  
                  
                  
                  
/* ANSI JOIN
*/
--일반 내부조인 (INNER JOIN)
SELECT *
FROM 학생
    , 수강내역
    , 과목 
WHERE 학생.학번 = 수강내역.학번
AND 수강내역.과목번호 = 과목.과목번호;

--ANSI JOIN 내부조인 (조인관련 내용이 모두 FROM절에 위치함)
SELECT *
FROM 학생
INNER JOIN 수강내역
ON(학생.학번 = 수강내역.학번)
INNER JOIN 과목
ON (수강내역.과목번호 = 과목.과목번호);



--일반 외부조인 OUTER JOIN
SELECT *
FROM 학생
    , 수강내역
    , 과목 
WHERE 학생.학번 = 수강내역.학번(+)
AND 수강내역.과목번호 = 과목.과목번호(+);


--ANSI 외부조인
SELECT *
FROM 학생
LEFT OUTER JOIN 수강내역                 --OUTER <-숨김가능 LEFT JOIN이라고 가능. (+)랑 같은뜻 
ON(학생.학번 = 수강내역.학번)
LEFT OUTER JOIN 과목
ON(수강내역.과목번호 = 과목.과목번호);

   --RIGHT으로 바꿨을때 
SELECT *
FROM 수강내역
RIGHT JOIN 학생                 
ON(학생.학번 = 수강내역.학번)
RIGHT OUTER JOIN 과목
ON(수강내역.과목번호 = 과목.과목번호);  






--FULL OUTER JOIN
CREATE TABLE test_a (emp_id number);
CREATE TABLE test_b (emp_id number);
INSERT INTO test_a VALUES(10);
INSERT INTO test_a VALUES(20);
INSERT INTO test_a VALUES(40);

INSERT INTO test_b VALUES(10);
INSERT INTO test_b VALUES(20);
INSERT INTO test_b VALUES(30);

SELECT a.emp_id
     , b.emp_id
FROM test_a a, test_b b
WHERE a.emp_id(+) = b.emp_id(+);     --일반조인에서는 안됨




SELECT a.emp_id
     , b.emp_id
FROM test_a a
FULL OUTER JOIN test_b b
ON(a.emp_id = b.emp_id);




--2000년도(검색조건) 판매(금액)왕을 출력하시오 (sales)
--직원명은 서브쿼리사용 (select)
--(1)sales 테이블을 활용하여 직원별 판매금액(amount_sold), 수량을 집계
--(2)판매금액컬럼을 기준으로 정렬하여 1건 출력
--(3)사번으로 employees테이블 이용하여 이름가져오기 


select * from sales;
select * from employees;

SELECT (select emp_name
        from employees
        where employee_id = a.employee_id) as 이름
      , employee_id as 사번
      , amount_sold as 판매금액
      
FROM sales a;


--풀이
SELECT (select emp_name                                 --스칼라 서브쿼리 (이름 뽑으려고)
        from employees 
        where employee_id = a.employee_id) as 직원
        ,판매수량 
        ,TO_CHAR(판매금액, '999,999,999.99') as 판매금액
FROM (
        SELECT employee_id                             --인라인뷰 (테이블처럼 보려고 ) 
             , SUM(quantity_sold) 판매수량
             , SUM(amount_sold)   판매금액 
        FROM sales
        WHERE to_char(sales_date, 'YYYY') = '2000'
        GROUP BY employee_id
        ORDER BY 3 DESC
    ) a;
WHERE rownum = 1;


select * from sales;
select * from products;
--2000년도 최다판매상품(수량으로) 1~3등까지 출력하시오
--(1)필요한 컬럼 출력
--(2)집계 및 정렬 후 3건 출력
--(3)상품아이디로 상품명 출력


SELECT (select prod_name
        from products
        where prod_id = a.prod_id) as 상품명
        ,판매금액
        ,판매수량
FROM ( select prod_id
            , sum(amount_sold) 판매금액
            , sum(quantity_sold) 판매수량
        from sales
        WHERE to_char(sales_date, 'YYYY') = '2000'
        GROUP BY prod_id
        ORDER BY 3 desc
        ) a 
WHERE rownum = 1;

      
      












