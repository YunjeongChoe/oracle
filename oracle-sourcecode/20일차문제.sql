
/*
 user 를 (유저이름/비번 study/study) 생성하고 권한을 주고
 create_table 스크립트를 실해하여 
 테이블 생성후 1~ 5 데이터를 임포트한 뒤 
 아래 문제를 출력하시오 
 (문제에 대한 출력물은 이미지 참고)
*/

-----------1-1번 문제 ----------------------------------------------
ITEM 테이블에서 카테고리 아이디가 FOOD인 것만 출력하시오.
---------------------------------------------------------------------
select category_id
    , product_name
    , product_desc
from item
where category_id = 'FOOD';


-----------1-2번 문제 ----------------------------------------------
강남구에 사는 고객의 이름, 전화번호를 출력하시오 
---------------------------------------------------------------------

select * from customer;
select * from address;

SELECT customer_name 
     , phone_number
FROM customer
WHERE zip_code = 135100;



-----------2번 문제 ------------------------------------------------
/*
CUSTOMER 테이블에서 출생년도가 1996년 부터 조회하시오 (1996 ~ 2020)
MAIL_ID 컬럼은 이메일 앞부분@
MAIL_DOMAIN 컬럼은 이메일 @뒷부분
REG_DATE, BIRTH 은 'YYYY-MM-DD'형태로 
*/
---------------------------------------------------------------------
SELECT customer_name
     , phone_number
     , REGEXP_SUBSTR(email, '[^@]+',1,1) as mail_id
     , REGEXP_SUBSTR(email, '[^@]+',1,2) as mail_domain
     , to_char(first_reg_date, 'YYYY-MM-DD') as reg_date
     , DECODE(sex_code, 'M', '남자', 'F', '여자') as sex_nm
     , to_char(to_date(birth),'YYYY-MM-DD') as birth
FROM customer
WHERE substr(birth,1,4) >= 1996
ORDER BY first_reg_date;

select * from customer;



-----------3-1번 문제 ---------------------------------------------------
/*
CUSTOMER에 있는 회원의 ZIP_CODE를 활용하여 
서울의 구별로 남자,여자,회원정보없는,전체 인원 수를 출력하시오 
*/
---------------------------------------------------------------------
select * from customer;
select * from address;

SELECT address_detail as zip_nm
     , SUM(DECODE(sex_code, 'M', 1, 0)) as 남자회원
     , SUM(DECODE(sex_code, 'F', 1, 0)) as 여자회원
     , SUM(DECODE(sex_code, null, 1, 0)) as 성별없음
     , COUNT(*) as 전체
FROM customer a
    , address b
WHERE a.zip_code = b.zip_code(+)
GROUP BY address_detail
ORDER BY 5 DESC;




----------3-2번 문제 ---------------------------------------------------

/*CUSTOMER에 있는 회원의 직업별 회원의 수를 출력하시오 
직업 NULL은 제외 
*/
-----------------------------------------------------------------------
SELECT count(customer_name) as 회원수
     , job as 직업
FROM CUSTOMER
GROUP BY job 
HAVING COUNT(job) >= 1
ORDER BY 1 desc;



-----------4번 문제 ---------------------------------------------------
/*
고객별 지점 방문횟수와 방문객의 합을 출력하시오 
방문횟수가 4번이상만 조회 (예약 취소건 제외) 
*/
---------------------------------------------------------------------

select a.customer_id 
      , customer_name
      , branch
      , count(branch) as brach_cnt
      , sum(visitor_cnt)  as visitor_sum_cnt
from customer a
    , reservation b
where a.customer_id = b.customer_id
and cancel not like 'Y'
group by branch, a.customer_id, customer_name
having count(branch) >= 4
order by 4 desc ;



-----------5번 문제 ---------------------------------------------------
/*
    4번 문제에서 가장많이 동일지점에 방문한 1명만 출력하시오 
*/
---------------------------------------------------------------------
SELECT customer_id 
FROM  (select a.customer_id 
              , customer_name
              , branch
              , count(branch) as brach_cnt
              , sum(visitor_cnt)  as visitor_sum_cnt
        from customer a
            , reservation b
        where a.customer_id = b.customer_id
        and cancel not like 'Y'
        group by branch, a.customer_id, customer_name
        having count(branch) >= 4
        order by 4 desc
       )
WHERE rownum = 1;


-----------6번 문제 ---------------------------------------------------
/*
5번 문제 고객의 구매 품목별 합산금액을 출력하시오(5번문제의 쿼리를 활용하여)
*/
----------------------------------------------------------------------
SELECT b.product_name
     , ( SELECT customer_id 
        FROM  (select a.customer_id 
                      , customer_name
                      , branch
                      , count(branch) as brach_cnt
                      , sum(visitor_cnt)  as visitor_sum_cnt
                from customer a
                    , reservation b
                where a.customer_id = b.customer_id
                and cancel not like 'Y'
                group by branch, a.customer_id, customer_name
                having count(branch) >= 4
                order by 4 desc
               )
        WHERE rownum = 1
        )
FROM order_info a
    , item b
group by b.product_name;


select * from order_info;
;



-----------7번 문제 ---------------------------------------------------
/*
ITEM 테이블에 신규 데이터를 입력하는 구문의 첫번째 데이터인 코드값 ()에 들어갈 쿼리를 완성하여 입력하시오.
ITEM 코드 값을 조회해서 생성하는 SQL을 작성하시오 

EX) SELECT ITEM_ID FROM ITEM 로 조회되는 값의 수에 +1 즉 총자리수는 5자리임 문자1 + 숫자5 현재 M0010 있으니 M0011 이 입력되어야함.

INSERT INTO ITEM VALUES ((    ),'SOUP','스프','FOOD',7000);
*/
---------------------------------------------------------------------





-----------8번 문제 ---------------------------------------------------
/*
7번 문제 스프 -> 수프로 
     7000 -> 7500 으로 수정하는 SQL을 작성하시오 
*/
---------------------------------------------------------------------
-----------9번 문제 ---------------------------------------------------
/*
전체 상품의 총 판매량과 총 매출액, 전용 상품의 판매량과 매출액을 출력하시오 
 reservation, order_info 테이블을 활용하여 
 온라인 전용상품의 총매출을 구하시오 
 */
-----------10번 문제 ---------------------------------------------------
/*
매출월별 총매출, 전용상품이외의 매출, 전용상품 매출, 전용상품판매율, 총예약건, 예약완료건, 예약취소건, 예약취소율을 출력하시오 
*/
---------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------- 총문제 10개 