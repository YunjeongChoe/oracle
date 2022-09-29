/* WITH 절
  별칭으로 사용한 SELECT문을 다른 SELECT문에서 참조가능함. (반복되는 쿼리가 있다면 WITH절로 사용하면면 변수처럼 사용가능)
  통계쿼리나 튜닝할 때 많이 사용
  temp라는 임시 테이블을 사용하여 장시간 걸리는 쿼리 결과를 임시리 저장하여 사용함.
  oracle 9이상에서 지원함 
  가독성이 좋음
*/

WITH T1 as (
   SELECT 학생.이름
        , 학생.학번
        , 학생.평점
        , 학생.전공
        , 수강내역.수강내역번호
        , 수강내역.과목번호
   FROM 학생, 수강내역
   WHERE 학생.학번 = 수강내역.학번(+)
   ), T2 as (
    SELECT 학번, 이름, COUNT(수강내역번호) as cnt
    FROM t1
    GROUP BY 학번, 이름
  ) ,T3 as (
   SELECT T1.학번, T1.이름, 과목.과목이름
   FROM 과목, T1
   WHERE 과목.과목번호 = T1.과목번호
  )
SELECT *
FROM T2, T3
WHERE T2.학번 = T3.학번
;

/* 문제 (일반쿼리로 작성)
   kor_loan_status 테이블에서 '연도별', '최종월(마지막월)' 기준으로 가장 대출이 많은 도시와 잔액을 구하시오 
   1. 연도별 최종월 (2011년은 12월이지만 2013은 11월)
         -연도별 가장 큰 월을 구한다.
   2. 연도별 최종월을 기준으로 대출잔액이 가장 큰 금액을 추출
   3. 월별 지역별 대출잔액과 2의 결과를 비교하여 금액이 같은건 추출
*/
SELECT *
FROM kor_loan_status;

--년월별 지역별 대출합계 
SELECT period
     , region
     , sum(loan_jan_amt) as jan_amt
FROM kor_loan_status
GROUP BY period
       , region; 
       
--SELECT *
--FROM ( SELECT period
--             , region
--             , sum(loan_jan_amt) as jan_amt
--        FROM kor_loan_status
--        GROUP BY period
--               , region
--    ) b2
--    ,() c
--WHERE b2.period = c.period
--AND   b2.jan_amt = c.max_jam;
               
       

       
       
--최종월 
SELECT MAX(period) as max_month
FROM kor_loan_status
GROUP BY substr(period,1,4);

--최종월의 대출 가장 큰 값 

SELECT  period                                --최종월
      , MAX(jan_amt) as max_jam               --대출 가장 큰 값
FROM (SELECT period
         , region
         , sum(loan_jan_amt) as jan_amt       --년월별 지역별 대출합계 
      FROM kor_loan_status
      GROUP BY period, region) b
    ,(SELECT MAX(period) as max_month         --최종 월
      FROM kor_loan_status
      GROUP BY substr(period,1,4)
      )a
WHERE period = '201311'
GROUP BY period;



SELECT b2.*
FROM ( SELECT period
             , region
             , sum(loan_jan_amt) as jan_amt
        FROM kor_loan_status
        GROUP BY period
               , region
    ) b2
    ,(SELECT  period                                  --최종월
              , MAX(jan_amt) as max_jam               --대출 가장 큰 값
      FROM (SELECT period
                 , region
                 , sum(loan_jan_amt) as jan_amt       --년월별 지역별 대출합계 
              FROM kor_loan_status
              GROUP BY period, region) b
            ,(SELECT MAX(period) as max_month         --최종 월
              FROM kor_loan_status
              GROUP BY substr(period,1,4)
              )a
       WHERE b.period = a.max_month
       GROUP BY period
    ) c
WHERE b2.period = c.period
AND   b2.jan_amt = c.max_jam;






