SELECT PERIOD
     , DECODE(grouping_id(period, gubun), 1, '소계'
                                        , 3, '총계'
                                        , gubun) as gubun
     , SUM(LOAN_JAN_AMT) total_jan
FROM kor_loan_status
WHERE PERIOD LIKE '2013%'
GROUP BY ROLLUP(PERIOD, GUBUN);
-- ROLLUP은 전체합계(통계)가 필요할 때 씀


--member의 직업별 마일리지의 합계를 출력하시오
SELECT mem_job
     , SUM(mem_mileage) as 마일리지합계
     , grouping_id(mem_job) as groupid
FROM member
GROUP BY ROLLUP(mem_job);




SELECT SUM(mem_mileage) as 마일리지합계
     , DECODE(grouping_id(mem_job), 1, '합계', mem_job) as 직업 
FROM member
GROUP BY ROLLUP(mem_job);





SELECT *
FROM member;

SELECT *
FROM cart;

SELECT member.mem_name   /*고객이름*/
     , member.mem_hp     /*고객전화번호*/
     , cart.cart_prod    /*상품아이디*/
     , cart.cart_qty     /*구매수량*/
     , prod.prod_name    /*상품명*/
     , prod.prod_sale    /*상품구매가*/
FROM member
   , cart
   , prod
WHERE member.mem_id = cart.cart_member
AND   cart.cart_prod = prod.prod_id
AND   member.mem_name = '김은대';



SELECT a.mem_name 
     , c.prod_name
     , sum(b.cart_qty * c.prod_sale) as 총사용금액 
FROM member a   --테이블에도 alias 줄 수 있음
   , cart b
   , prod c 
WHERE a.mem_id = b.cart_member
AND   b.cart_prod = c.prod_id
AND   a.mem_name = '김은대'
GROUP BY a.mem_id, a.mem_name, c.prod_id, c.prod_name
order by 3 desc;



--동등조인 (equi-join) 두 테이블에 데이터가 동등하게 있는 row만 추출 
--내부조인 (inner join)이라고도 함

SELECT a.emp_name
     , b.department_name
FROM  employees a
    , departments b
WHERE a.department_id = b.department_id;


--직원번호, 직원이름, 급여, 직업아이디, 직업명을 출력하시오
--급여가 15000 이상인 직원만

select * from employees;
select * from jobs;

SELECT a.employee_id
     , a.emp_name
     , a.salary
     , a.job_id
     , b.job_title
FROM  employees a
    , jobs b
WHERE a.job_id = b.job_id
AND   a.salary >= 15000;


--테이블 생성 CREATE
--테이블 삭제 DROP
--테이블 수정 ALTER
CREATE TABLE ex6_1 (
     col1 varchar2(10) not null
   , col2 varchar2(10) null
   , col3 date default sysdate
);

--DROP TABLE ex6_1;
--컬럼명 수정
ALTER TABLE ex6_1 RENAME COLUMN col1 TO col1_1;
--타입 수정
ALTER TABLE ex6_1 MODIFY col2 VARCHAR(30);
--컬럼 추가
ALTER TABLE ex6_1 ADD col4 number;
--컬럼 삭제
ALTER TABLE ex6_1 DROP COLUMN col4;
--제약조건 추가
ALTER TABLE ex6_1 ADD COLUMN pl_ex6_1 PRIMARY KEY(col1);






