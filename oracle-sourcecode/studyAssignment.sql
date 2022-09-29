/*
 STUDY 계정에 create_table 스크립트를 실해하여 
 테이블 생성후 1~ 5 데이터를 임포트한 뒤 
 아래 문제를 출력하시오 
 (문제에 대한 출력물은 이미지 참고)
*/
-----------1번 문제 ---------------------------------------------------
--1988년 이후 출생자의 직업이 의사,자영업 고객을 출력하시오 (어린 고객부터 출력)
---------------------------------------------------------------------


SELECT *
FROM customer
WHERE substr(birth, 1, 4) >= 1988
AND job in ('자영업', '의사')
ORDER BY birth DESC;






-----------2번 문제 ---------------------------------------------------
--강남구에 사는 고객의 이름, 전화번호를 출력하시오 
---------------------------------------------------------------------
select * from address;
select * from customer;



SELECT customer_name
     , phone_number
FROM  address b
     , customer a
WHERE b.zip_code = a.zip_code
AND address_detail LIKE'강남구';





----------3번 문제 ---------------------------------------------------
--CUSTOMER에 있는 회원의 직업별 회원의 수를 출력하시오 (직업 NULL은 제외)
---------------------------------------------------------------------
select * from customer;

SELECT job 
     , count(customer_name) as cnt
FROM customer
GROUP BY job
HAVING COUNT(job) >= 1
ORDER BY 2 desc;




----------4-1번 문제 ---------------------------------------------------
-- 가장 많이 가입(처음등록)한 요일과 건수를 출력하시오 
---------------------------------------------------------------------

select * from customer;


SELECT *
FROM  (select TO_CHAR(first_reg_date, 'day') as 요일
            , count(customer_name)           as 건수 
       from customer 
       group by TO_CHAR(first_reg_date, 'day')
       order by 2 DESC
       )
WHERE rownum = 1;



----------4-2번 문제 ---------------------------------------------------
-- 남녀 인원수를 출력하시오 
---------------------------------------------------------------------

select DECODE(grouping id(sex_code, 'M', '남자', 'F', '여자' , '미등록'),'합계') gender
     , COUNT(*) as cnt
FROM customer
GROUP BY Rollup (DECODE(sex_code, 'M', '남자', 'F', '여자' , '미등록'));

SELECT sex_code
     , DECODE(grouping_id(sex_code, gender), 'M', '남자'
                                           , 'F', '여자') as gender
     , COUNT(*) as cnt
FROM customer
GROUP BY ROLLUP(sex_code);        



----------5번 문제 ---------------------------------------------------
--월별 예약 취소 건수를 출력하시오 (많은 달 부터 출력)
---------------------------------------------------------------------

SELECT TO_CHAR(TO_DATE(reserv_date), 'MM') as 월 
     , count(*)           as 취소건수
FROM reservation
WHERE cancel = 'Y'
GROUP BY TO_CHAR(TO_DATE(reserv_date), 'MM')
ORDER BY 2 DESC;



----------6번 문제 ---------------------------------------------------
 -- 전체 상품별 '상품이름', '상품매출' 을 내림차순으로 구하시오 
-----------------------------------------------------------------------------



SELECT a.product_name               as 상품이름
     , sum(a.price * b.quantity)    as 상품매출 
FROM item a
   , order_info b
WHERE a.item_id = b.item_id
GROUP BY a.product_name
ORDER BY 2 DESC;





---------- 7번 문제 ---------------------------------------------------
-- 모든상품의 월별 매출액을 구하시오 
-- 매출월, SPECIAL_SET, PASTA, PIZZA, SEA_FOOD, STEAK, SALAD_BAR, SALAD, SANDWICH, WINE, JUICE
----------------------------------------------------------------------------

select * from item;
select * from order_info;
select * from reservation;


       



select b.*
      a.product_name
 from   (SELECT substr(c.reserv_date,1,6)
       , sum(b. sales * b.quantity)
    FROM  order_info b
     , reservation c
    WHERE b.reserv_no = c.reserv_no
    GROUP BY substr(c.reserv_date,1,6)
    )b
    item a;










---------- 8번 문제 ---------------------------------------------------
-- 월별 온라인_전용 상품 매출액을 일요일부터 월요일까지 구분해 출력하시오 
-- 날짜, 상품명, 일요일, 월요일, 화요일, 수요일, 목요일, 금요일, 토요일의 매출을 구하시오 
----------------------------------------------------------------------------
select * from address;
select * from customer;
select * from item;
select * from order_info;
select * from reservation;


--(SELECT substr(c.reserv_date,1,6)



select product_name
from item a 
   , order_info b;
where a.item_id = b.item_id LIKE 'M0001';

SELECT substr(b.reserv_date,1,6) as 날짜
     , a.product_name

from item a, reservation b







---------- 9번 문제 ----------------------------------------------------
-- 고객수, 남자인원수, 여자인원수, 평균나이, 평균거래기간(월기준)을 구하시오 (성별 생년 NULL 제외, MONTHS_BETWEEN, AVG, ROUND 사용(소수점 1자리 까지)
----------------------------------------------------------------------------
select * from address;
select * from customer;
select * from item;
select * from order_info;
select * from reservation;












---------- 10번 문제 ----------------------------------------------------
--매출이력이 있는 고객의 주소, 우편번호, 해당지역 고객수를 출력하시오
----------------------------------------------------------------------------
select * from address;
select * from customer;
select * from item;
select * from order_info;
select * from reservation;