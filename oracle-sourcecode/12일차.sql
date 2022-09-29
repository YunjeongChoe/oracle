--DBMS_RANDOM.VALUE

--0~10까지 난수 랜덤생성
SELECT DBMS_RANDOM.VALUE() * 10  as 난수1
     , DBMS_RANDOM.VALUE(0, 10) as 난수2
     -- 0 ~ 10 자연수 랜덤생성 
     , ROUND(DBMS_RANDOM.VALUE() * 10) as 난수3
     , ROUND(DBMS_RANDOM.VALUE(0, 10)) as 난수4
FROM dual;

--CREATE TABLE ex12_1 AS
SELECT rownum as seq
     , to_char(sysdate, 'YYYY')|| LPAD(ceil(rownum/1000),2,'0') as months
     , ROUND(DBMS_RANDOM.VALUE(100,1000)) as amt
FROM dual
CONNECT BY level <= 12000;




SELECT *
FROM TB_INFO
ORDER BY DBMS_RANDOM.VALUE;

--TB_INFO에서 DBMS_RANDOM.VALUE 활용하여 SSAM을 제외하고 랜덤으로 학생 1명만 뽑은 SQL을 작성하시오 
SELECT NM
FROM(SELECT *
     FROM TB_INFO
     WHERE pc_no NOT LIKE '%SSAM%'
     ORDER BY DBMS_RANDOM.VALUE)
WHERE rownum = 1;





/* 가장 매출이 높은 지점의 BEST TOP3의 메뉴이름과 가격을 출력하시오
  (1) 가장 매출이 높은 지점명 1개 출력
  (2) 지점의 매뉴 매출 순위 3개출력 
  (3) (1)의 지점명으로 (2)를 조회하여 출력
  study계정의 reservation, order_info, item 활용 
*/


select * from reservation;
select * from order_info;
select * from item;


SELECT branch
FROM    (select a.branch
              , sum(b.quantity*sales)
         from reservation a
             , order_info b
         where a.reserv_no = b.reserv_no
         group by a.branch
         order by 2 desc)
where rownum = 1 ;        
   
   
   
   
SELECT b.product_desc
     , c.price
FROM (SELECT b.item_id
                 , sum(b.sales) as amt
    from reservation a
                , order_info b
    where a.reserv_no = b.reserv_no
    and a.branch =(SELECT branch
                   FROM    (select a.branch
                                  , sum(b.quantity*sales)
                            from reservation a
                                , order_info b
                            where a.reserv_no = b.reserv_no
                            group by a.branch
                            order by 2 desc)
                            where rownum = 1 
                            )
    group by  b.item_id
    order by 2 desc
    ) a
    ,(select product_desc
    from   order_info a , item b
    where a.item_id = b.item_id
    ) b
    , item c
WHERE rownum <= 3;


















SELECT b.item_id
     , sum(b.sales) as amt
FROM reservation a
   , order_info b
WHERE a.reserv_no = b.reserv_no
AND a.branch = (SELECT branch
                FROM    (select a.branch
                                , sum(b.quantity*sales)
                          from reservation a
                              , order_info b
                          where a.reserv_no = b.reserv_no
                          group by a.branch
                          order by 2 desc)
                          where rownum = 1 
                         )
GROUP BY b.item_id
ORDER BY 2 desc;
