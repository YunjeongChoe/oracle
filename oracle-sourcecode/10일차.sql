/*
 STUDY 계정에 create_table 스크립트를 실해하여 
 테이블 생성후 1~ 5 데이터를 임포트한 뒤 
 아래 문제를 출력하시오 
 (문제에 대한 출력물은 이미지 참고)
*/ 




--풀이




-----------1번 문제 ---------------------------------------------------
--1988년 이후 출생자의 직업이 의사,자영업 고객을 출력하시오 (어린 고객부터 출력)
----------------------------------------------------------------------
SELECT *
FROM customer
WHERE substr(birth, 1, 4) >= 1988
AND job in ('자영업', '의사')
ORDER BY birth DESC;



-----------2번 문제 --------------------------------------------------
--강남구에 사는 고객의 이름, 전화번호를 출력하시오 
---------------------------------------------------------------------
SELECT customer_name
     , phone_number
FROM  customer a
     , address b
WHERE b.zip_code = a.zip_code
AND b.address_detail LIKE'강남구';




----------3번 문제 ---------------------------------------------------
--CUSTOMER에 있는 회원의 직업별 회원의 수를 출력하시오 (직업 NULL은 제외)
---------------------------------------------------------------------
SELECT job 
     , count(*) as cnt
FROM customer
WHERE job is not null
GROUP BY job
ORDER BY 2 desc;



----------4-1번 문제 --------------------------------------------------
-- 가장 많이 가입(처음등록)한 요일과 건수를 출력하시오 
----------------------------------------------------------------------
SELECT *
FROM  (select TO_CHAR(first_reg_date, 'day') as 요일
            , count(*)           as 건수 
       from customer 
       group by TO_CHAR(first_reg_date, 'day')
       order by 2 DESC
       )
WHERE rownum = 1;




----------4-2번 문제 ---------------------------------------------------
-- 남녀 인원수를 출력하시오 
-----------------------------------------------------------------------
--풀이 1
SELECT CASE WHEN SEX_CODE = 'M' then '남자'
            WHEN SEX_CODE = 'F' then '여자'
            WHEN SEX_CODE IS NULL AND groupid = 0 then '미등록'
            ELSE '합계'
           END as gender
           ,cnt
            
FROM(SELECT sex_code
          , GROUPING_ID(sex_code) as groupid
          , count (*) as cnt
     FROM customer
     GROUP BY ROLLUP(SEX_CODE)
     );




--풀이 2
SELECT DECODE(gender, 'F', '여자', 'M', '남자','N','미등록','합계') as gender
       ,cnt
FROM(SELECT gender
          , count(*) cnt
     FROM ( select DECODE(sex_code, null, 'n', sex_code) as gender
            from customer
           )
     GROUP BY rollup(gender)
    );





----------5번 문제 ---------------------------------------------------
--월별 예약 취소 건수를 출력하시오 (많은 달 부터 출력)
---------------------------------------------------------------------

SELECT TO_CHAR(TO_DATE(reserv_date),'MM') as 월 
     , count(cancel)           as 취소건수
FROM reservation
WHERE cancel = 'Y'
GROUP BY TO_CHAR(TO_DATE(reserv_date),'MM')
ORDER BY 2 DESC;


--1월부터 12월
SELECT LPAD(level,2,'0') as 월
FROM dual
CONNECT BY level <= 12 ;

SELECT a.월
     , NVL(b.취소건수,0) as 취소건수
FROM (SELECT LPAD(level,2,'0') as 월
      FROM dual
      CONNECT BY level <= 12) a
    , (SELECT TO_CHAR(TO_DATE(reserv_date),'MM') as 월 
             , count(*)                        as 취소건수
      FROM reservation
      WHERE cancel = 'Y'
      GROUP BY TO_CHAR(TO_DATE(reserv_date),'MM')
      ORDER BY 2 DESC) b
WHERE a.월 = b.월(+)
ORDER BY 1;



----------6번 문제 -----------------------------------------------------------
 -- 전체 상품별 '상품이름', '상품매출' 을 내림차순으로 구하시오 
-----------------------------------------------------------------------------

SELECT a.product_name               as 상품이름
     , sum(b.sales)                 as 상품매출 
FROM item a
   , order_info b
WHERE a.item_id = b.item_id
GROUP BY a.product_name, a.item_id
ORDER BY 2 DESC;



---------- 7번 문제 ---------------------------------------------------------------------------
-- 모든상품의 월별 매출액을 구하시오 
-- 매출월, SPECIAL_SET, PASTA, PIZZA, SEA_FOOD, STEAK, SALAD_BAR, SALAD, SANDWICH, WINE, JUICE
----------------------------------------------------------------------------------------------

SELECT SUBSTR(a.reserv_date, 1, 6)   as 매출월
     , SUM(DECODE(b.item_id, 'M0001', b.sales, 0)) as SPECIAL_SET
     , SUM(DECODE(b.item_id, 'M0002', b.sales, 0)) as PASTA
     , SUM(DECODE(b.item_id, 'M0003', b.sales, 0)) as PIZZA
     , SUM(DECODE(b.item_id, 'M0004', b.sales, 0)) as SEA_FOOD
     , SUM(DECODE(b.item_id, 'M0005', b.sales, 0)) as STEAK
     , SUM(DECODE(b.item_id, 'M0006', b.sales, 0)) as SALAD_BAR
     , SUM(DECODE(b.item_id, 'M0007', b.sales, 0)) as SALAD
     , SUM(DECODE(b.item_id, 'M0008', b.sales, 0)) as SANDWICH
     , SUM(DECODE(b.item_id, 'M0009', b.sales, 0)) as WINE
     , SUM(DECODE(b.item_id, 'M0010', b.sales, 0)) as JUICE
FROM reservation a --날짜에 해당하는 데이터 
    , order_info b --매출에 해당하는 데이터
WHERE a.reserv_no = b.reserv_no
GROUP BY SUBSTR(a.reserv_date, 1, 6)
ORDER BY 1;


--1월부터 12월까지
SELECT t1.매출월
      , NVL(t2.PASTA, 0) PASTA
FROM(select LPAD(level,2,'0') as 매출월
     from dual
     connect by level <= 12) t1
     ,(SELECT SUBSTR(a.reserv_date, 1, 6)   as 매출월
             , SUM(DECODE(b.item_id, 'M0001', b.sales, 0)) as SPECIAL_SET
             , SUM(DECODE(b.item_id, 'M0002', b.sales, 0)) as PASTA
             , SUM(DECODE(b.item_id, 'M0003', b.sales, 0)) as PIZZA
             , SUM(DECODE(b.item_id, 'M0004', b.sales, 0)) as SEA_FOOD
             , SUM(DECODE(b.item_id, 'M0005', b.sales, 0)) as STEAK
             , SUM(DECODE(b.item_id, 'M0006', b.sales, 0)) as SALAD_BAR
             , SUM(DECODE(b.item_id, 'M0007', b.sales, 0)) as SALAD
             , SUM(DECODE(b.item_id, 'M0008', b.sales, 0)) as SANDWICH
             , SUM(DECODE(b.item_id, 'M0009', b.sales, 0)) as WINE
             , SUM(DECODE(b.item_id, 'M0010', b.sales, 0)) as JUICE
        FROM reservation a --날짜에 해당하는 데이터 
           , order_info b  --매출에 해당하는 데이터
        WHERE a.reserv_no = b.reserv_no
        GROUP BY SUBSTR(a.reserv_date, 1, 6)
        ORDER BY 1) t2
WHERE a.매출월 = b.매출월(+)
ORDER BY 1 ;




---------- 8번 문제 ------------------------------------------------------------
-- 월별 온라인_전용 상품 매출액을 일요일부터 월요일까지 구분해 출력하시오 
-- 날짜, 상품명, 일요일, 월요일, 화요일, 수요일, 목요일, 금요일, 토요일의 매출을 구하시오 
-------------------------------------------------------------------------------

SELECT substr(reserv_date, 1, 6)    as 년월 
     , product_name                 as 상품명
     , sum(decode(dayz, '1', sales, 0))  as 일요일 
     , sum(decode(dayz, '2', sales, 0))  as 월요일 
     , sum(decode(dayz, '3', sales, 0))  as 화요일 
     , sum(decode(dayz, '4', sales, 0))  as 수요일 
     , sum(decode(dayz, '5', sales, 0))  as 목요일 
     , sum(decode(dayz, '6', sales, 0))  as 금요일
     , sum(decode(dayz, '7', sales, 0))  as 토요일 
FROM  (select a.reserv_date, c.product_name, b.sales
             , to_char(to_date(a.reserv_date),'d') as dayz
        from reservation a, order_info b, item c
        where a.reserv_no = b.reserv_no
        and b.item_id = c.item_id
        and c.product_desc = '온라인_전용상품'
        )
GROUP BY substr(reserv_date, 1, 6), product_name
ORDER BY 1 ;



---------- 9번 문제 ---------------------------------------------------------------------
-- 고객수, 남자인원수, 여자인원수, 평균나이, 평균거래기간(월기준)을 구하시오 (성별 NULL/BIRTH 제외
--MONTHS_BETWEEN, AVG, ROUND 사용(소수점 1자리 까지)
----------------------------------------------------------------------------------------

SELECT count(*)                       as 고객수
     , sum(decode(sex_code, 'M',1,0)) as 남자인원수
     , sum(decode(sex_code, 'F',1,0)) as 여자인원수
     , round(avg(months_between(sysdate, to_date(birth))/12),1) as 평균나이 
     , round(avg(months_between(sysdate, first_reg_date)),1)    as 평균거래기간
FROM CUSTOMER
WHERE sex_code is not null
AND birth is not null;



---------- 10번 문제 ----------------------------------------------------
--매출이력이 있는 고객의 주소, 우편번호, 해당지역 고객수를 출력하시오
------------------------------------------------------------------------

SELECT c.address_detail
     , count(distinct a.customer_id) as cnt
FROM customer a
   , reservation b
   , address c
WHERE a.customer_id = b.customer_id
AND a.zip_code = c.zip_code
AND b.cancel = 'N'
GROUP BY c.zip_code, c.address_detail
ORDER BY 2 DESC;


