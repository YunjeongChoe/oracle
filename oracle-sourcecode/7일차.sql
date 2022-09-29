SELECT *
FROM 과목;

SELECT * 
FROM 학생
    , 수강내역
WHERE 학생.학번 = 수강내역.학번
AND 학생.이름 = '최숙경';



SELECT * 
FROM 학생                                   --조인 조건에 만족하는 데이터가 어느 한 쪽의 값이
    , 수강내역                               --null이어도 모두 추출해야할 때 사용.
WHERE 학생.학번 = 수강내역.학번(+)             --null이 포함되는 쪽에 (+)에 사용 
AND 학생.이름 = '윤지미';



SELECT 학생.학번
     , 학생.이름
     , COUNT(수강내역.수강내역번호) 수강건수
FROM  학생
     ,수강내역
WHERE 학생.학번 = 수강내역.학번(+)
GROUP BY  학생.학번
        , 학생.이름;
        
        
        
SELECT 학생.이름
     , 수강내역.강의실
     , 과목.과목이름 
FROM 학생                                   
    , 수강내역
    , 과목
WHERE 학생.학번 = 수강내역.학번(+)
AND 수강내역.과목번호 = 과목.과목번호(+);

--모든 교수의 강의이력 출력
--교수이름, 전공, 강의내역번호, 과목번호, 강의실
SELECT *
FROM 강의내역;  

SELECT 교수.교수이름
     , 교수.전공
     , 강의내역.강의내역번호
     , 강의내역.과목번호
     , 강의내역.강의실
FROM   교수
     , 강의내역
WHERE  교수.교수번호 = 강의내역.교수번호(+);



        
SELECT 교수.교수이름
     , 교수.전공
     , COUNT (강의내역.강의내역번호) as 강의건수      --정확하게 하려면 COUNT (*) 해당컬럼에만 카운트  
FROM   교수, 강의내역
WHERE  교수.교수번호 = 강의내역.교수번호(+)  
GROUP BY 교수.교수이름
        , 교수.전공
ORDER BY 3 desc;



        
SELECT 교수.교수이름
     , 교수.전공
     , COUNT (강의내역.강의내역번호) as 강의건수      
FROM   교수, 강의내역
WHERE  교수.교수번호 = 강의내역.교수번호(+)  
GROUP BY 교수.교수이름
        , 교수.전공
ORDER BY 3 desc;
--정확하게 하려면 COUNT (*)
--특정 컬럼만 조회할 때 COUNT는 null값을 세지 않음



SELECT count (department_id)
     , count (*)
     , count (distinct department_id)
FROM employees;



SELECT * from 수강내역;
--학생들의 '수강건수'와 '수강학점합계'를 출력하시오 (과목에 학점)
--1.각 테이블 별 필요한 컬럼 조회
 SELECT 학생.학번
     , 학생.이름
FROM 학생;

SELECT 수강내역번호
     , 학번
     ,과목번호
FROM  수강내역;


SELECT 과목번호
FROM 과목;
    
    
--2.조인 후 필요한 컬럼 조회
SELECT 학생.학번
     , 학생.이름
     , 수강내역.수강내역번호
     , 과목,학점
FROM 학생, 수강내역, 과목
WHERE 학생.학번 = 수강내역.학번(+)
AND 수강내역.과목번호 = 과목.과목번호(+);

--3.집계함수 사용
SELECT 학생.이름
     , COUNT (수강내역.수강내역번호)   as 수강건수 
     , NVL(SUM (과목,학점),0)        as 학점합계 
FROM 학생, 수강내역, 과목
WHERE 학생.학번 = 수강내역.학번(+)
AND 수강내역.과목번호 = 과목.과목번호(+)
GROUP BY 학생.학번
        ,학생.이름
ORDER BY 2 DESC;


--건수 체크

/*서브쿼리 (sub query)
  SQL문장 안에 보조로 사용되는 또 다른 SELECT문
  
  1.메인 쿼리와 연관성에 따라
    (1) 연관성 없는 서브쿼리
       --일 대 일로 매핑되어야 함
       --가벼운 테이블에만 사용 (성능의 문제때문에)
    (2) 연관선 있는 서브쿼리
  2.형태(위치)에 따라
    (1)일반 서브쿼리 (SELECT절) 스칼라서브쿼리라고도 함
    (2)인라인뷰 (FROM절)
    (3)중첩쿼리 (WHERE절)
*/
 
SELECT emp_name
     , department_name
FROM  employees a
    , departments b
WHERE a.department_id = b.department_id;





--1.일반 서브쿼리 (스칼라서브쿼리) 

SELECT a.emp_name
     , (select department_name
        from departments
        where department_id = a.department_id) as nm
     , a.job_id
     , (select job_title
        from jobs
        where job_id = a.job_id) as job_nm
FROM employees a
;



--학생, 수강내역
SELECT 학생.이름
     , (select 과목이름
        from 과목
        where 과목.과목번호 = 수강내역.과목번호) as 과목명
FROM 학생, 수강내역
WHERE 학생.학번 = 수강내역.학번(+);







--2.인라인뷰 
--SELECT 출력 결과를 테이블처럼 사용

SELECT rownum as rnum
             , a.*
FROM 학생 a;



SELECT *
FROM ( SELECT rownum as rnum
             , a.*
       FROM 학생 a
     ) t1
WHERE t1.rnum BETWEEN 1 and 10;








--평점이 높은 5명의 학생만 출력하시오
--(1). 평점이 높은 학생부터 출력되도록 정렬
SELECT 이름
     , 평점
FROM 학생
ORDER BY 평점 DESC;


--(2).정렬된 결과에 rownum 생성하여 인라인 뷰를 만듦
SELECT rownum as rnum
     , a.*
FROM (SELECT 이름
           , 평점
        FROM 학생
        ORDER BY 평점 DESC
      ) a;

--(3). 2결과에서 2등-5등까지만 나도록 조건
SELECT *
FROM   (SELECT rownum as rnum
         , a.*
        FROM (SELECT 이름
                   , 평점
              FROM   학생
              ORDER BY 평점 DESC) a
        )
WHERE rnum BETWEEN 2 AND 5;








--3. 중첩쿼리 (WHERE절)
--전체 직원의 평균월급 이상 받는 직원만 출력하시오
SELECT emp_name, salary
FROM employees
WHERE salary >= (SELECT AVG(salary)
                 FROM employees)
;


--수강내역이 있는 학생만 학생정보를 조회하시오
SELECT *
FROM 학생
WHERE 학번 IN (SELECT distinct 학번
               FROM 수강내역);
               
--수강내역이 없는 학생
SELECT *
FROM 학생
WHERE 학번 NOT IN (SELECT distinct 학번
                  FROM 수강내역);
                  
--평균평점 이상인 학생만 조회시오   
SELECT 이름
     , 전공
     , 평점 
FROM   학생
WHERE  평점 >=   (SELECT avg(평점)
                  FROM 학생)
;
          
          
          
          
                  
--member, cart
--고객의 cart사용 이력의 최대, 최소 건수를 출력하시오
SELECT min(cnt) as 최소
     , max(cnt) as 최대 
FROM ( SELECT a.mem_id
            , a.mem_name
            , count(b.cart_no) as cnt
       FROM member a, cart b
       WHERE a.mem_id = b.cart_member(+)
       GROUP BY a.mem_id, a.mem_name);






/*member, cart, prod 테이블을 사용하여
  고객별 카트 사용횟수, 구매상품 품목 수,
  전체 상품 구매 수, 총 구매 금액을 출력하시오  중복제거,sum
  (구매이력이 없으면 0건, 정렬조건 카트사용 내림)
  (구매금액 prod_sale 구매수량 cart_qty*/
  
SELECT * FROM member;
SELECT * FROM cart;
SELECT * FROM prod;




SELECT a.mem_name as 이름
     , COUNT(distinct b.cart_no) as 카트사용횟수
     , COUNT(distinct b.cart_prod) as 구매상품_품목_수
     , SUM(b.cart_qty * c.prod_sale) as 총구매금액
     , SUM(b.cart_qty) as 전체상품_구매_수
FROM  member a
    , cart b 
    , prod c 
WHERE a.mem_id = b.cart_member(+)
AND   b.cart_prod = c.prod_id(+)
GROUP BY a.mem_name
ORDER BY 2 DESC;









 
        
        