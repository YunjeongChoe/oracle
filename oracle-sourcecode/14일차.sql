/* 분석함수
   분석함수(매개변수) OVER (PARTITION BY expr1, expr2...
                          ORDER BY expr3, expr4///
                          WINDOW 절...
                          ) 
   PARTITON BY : 계산 대상 그룹지정
   ORDER BY : 대상 그룹에 대한 정렬
   WINDOW : 파티션으로 분할된 그룹에 대해 더 상세한 그룹을 분할 
   
*/

SELECT department_id, emp_name
     , ROW_NUMBER() OVER (PARTITION BY department_id                 --GROUP BY절에 들어가는거라고 생각하면 됨 
                          ORDER BY emp_name) as dep_row              --ODER BY는 정렬 조건 
     , ROUND(AVG(salary) OVER(PARTITION BY department_id)) as dep_avg
     , ROUND(AVG(salary) OVER()) as all_avg
FROM employees;


--모든 학생의 이름, 전공 전공별 평점평균, 전체 평균평점을 출력하시오  

SELECT 이름, 전공
     , ROUND(AVG(평점) OVER(PARTITION BY 전공), 2) as 전공평균평점 
     , ROUND(AVG(평점) OVER (), 2)                 as 전체평균평점 
FROM  학생;

--RANK() 동일값 순위 건너뜀    DENSE_RANK() 건너뛰지 않음 

SELECT department_id
      , emp_name
      , salary
      , RANK () OVER(PARTITION BY department_id
                     ORDER BY salary DESC) as rank_dep
      , DENSE_RANK() OVER(PARTITION BY department_id
                      ORDER BY salary DESC) as dense_rank_dep
      , DENSE_RANK() OVER(ORDER BY salary DESC) as all_dense_rank_dep
FROM employees
WHERE department_id IN (30,60);

--부서별로 월급을 가장 많이 박는 직원 1명씩 출력하시오
--(부서없는 직원은 제외)
SELECT *
FROM (SELECT emp_name
           , department_id
           , salary
           , RANK() OVER(PARTITION BY department_id
                          ORDER BY salary desc) as dep_rank              
      FROM employees
      WHERE department_id is not null
     )
WHERE dep_rank = 1;

--부서별 월급 비용이 많이 드는 순위를 출력하시오 (가장 많은 부서가 1등)
SELECT a.*
      , RANK() OVER(ORDER BY dep_sum DESC) as rank
FROM ( SELECT department_id
            , SUM(salary)    as dep_sum
        FROM employees
        WHERE department_id is not null
        GROUP BY department_id) a ;
        
        
SELECT department_id
     , SUM(salary) as all_sum
     , RANK() OVER(ORDER BY SUM(salary) DESC) as dep_rank
FROM employees
GROUP BY department_id;


--cart, prod 활용하여 물품별 판매합계금액(prod_sale)의 순위를 출력하시오
--(dense_rank사용)

select * from cart;
select * from prod;



SELECT prod_name
     , prod_id
     ,SUM(cart_qty * prod_sale) as 상품판매금액
     , dense_rank() OVER (ORDER BY SUM(cart_qty * prod_sale) DESC) as 순위 
FROM cart a, prod b 
WHERE a.cart_prod = b.prod_id(+)
GROUP BY prod_name, prod_id;


/* LAG 선행로우 값 반환
   LEAD 후행로우 값 반환
*/

SELECT emp_name
     , department_id
     , salary
                   --1단계 앞 로우의 emp_name
     , LAG(emp_name, 1, '가장높음') OVER(PARTITION BY department_id
                                        ORDER BY salary DESC) as ap_emp
                   --1단계 뒤 로우의 eml_name
     , LEAD(emp_name, 1, '가장낮음') OVER(PARTITION BY department_id
                                         ORDER BY salary DESC) as ap_emp
FROM employees
WHERE department_id IN (30, 60);


--각 학생들의 평점이 1단계 높은 학생의 이름과의 평점차이를 출력하시오 가장 높은 학생은 이름: '1등' 차이:0
select * from 학생;

SELECT 이름
     , round(평점,2) as 평점 
     , LAG(이름, 1, '1등') OVER(ORDER BY 평점 DESC) as 나보다위친구
     , ROUND(LAG(평점, 1, 평점) OVER(ORDER BY 평점 DESC) - 평점,2) as 평점차이  
FROM 학생
WHERE 평점 is not null;






