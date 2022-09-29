SELECT department_id
     , LPAD(' ', 3 * (level - 1)) || department_name as 부서명
     , level
FROM departments
START WITH parent_id is null                          --최상위(root)조건 

CONNECT BY PRIOR department_id = parent_id;          --계층구조 조건



SELECT manager_id
     , employee_id
     , level
     , LPAD(' ', 3 * (level - 1)) || emp_name as 직원명
FROM employees
START WITH manager_id is null
CONNECT BY PRIOR employee_id = manager_id;



--30 부서직원의 관리자
SELECT a.employee_id
       , level
       , LPAD(' ', 3 * (level - 1)) ||  a.emp_name
       , b.department_name
       , b.department_id
FROM employees a
   , departments b
WHERE a.department_id = b.department_id
AND a.department_id = 30                            --start with 전 검색조건 
START WITH a.manager_id is null
CONNECT BY PRIOR a.employee_id = a.manager_id
ORDER SIBLINGS BY a.emp_name desc;
      
      
--부서 아이디 : 230 부서명 : IT 헬프데스크
--팀의 하위 부서가 신설됐습니다.

--5 level에 해당하는 IT 데이터 수집팀을 부서테이블에 INSERT 후 조회하시오.

INSERT INTO departments (department_id, department_name, parent_id)
VALUES ('','','');


INSERT INTO departments (department_id, department_name, parent_id) VALUES ('280', 'IT 데이터 수집', '230');

SELECT department_id
     , LPAD(' ', 3 * (level - 1)) || department_name as 부서명
     , level
FROM departments
START WITH parent_id is null                          
CONNECT BY PRIOR department_id = parent_id; 

--(1) 테이블 생성 ex) 테이블 명 : 팀
--(2) 데이터 삽입
--(3) 걔층형쿼리 조회 
select * from employees;

CREATE TABLE 팀 (
     아이디 number
     ,이름 varchar2(10)
     ,직책 varchar2(10)
     ,상위아이디 number
);

INSERT INTO 팀 VALUES(1, '이사장', '사장', 0);
INSERT INTO 팀 VALUES(2, '김부장', '부장', 1);
INSERT INTO 팀 VALUES(3, '서차장', '차장', 2);
INSERT INTO 팀 VALUES(4, '장과장', '과장', 3);
INSERT INTO 팀 VALUES(5, '박과장', '과장', 3);
INSERT INTO 팀 VALUES(6, '이대리', '대리', 4);
INSERT INTO 팀 VALUES(7, '김대리', '대리', 5);
INSERT INTO 팀 VALUES(8, '최사원', '사원', 6);
INSERT INTO 팀 VALUES(9, '강사원', '사원', 6);
INSERT INTO 팀 VALUES(10, '박사원', '사원', 7);


select * from 팀;

SELECT 이름
     , LPAD(' ', 3 * (level - 1)) || 직책 as 직책
     , level
FROM 팀
START WITH 상위아이디 = 0                       --이 조건에 맞는 row로부터 
CONNECT BY PRIOR 아이디 = 상위아이디;


--무한루프 상활일 경우 
--CONNECT_BY_ISCYCLE  셀렉문에 넣고
--CONNECT BY NOCYCLE PRIOR 하면 문제가 되는 데이터를 찾을수 있음 (1로 나옴)



SELECT department_id
     , parent_id
     , LPAD(' ', 3 * (level - 1)) || department_name as 부서명
     , level
     , CONNECT_BY_ROOT department_name as 최상위데이터
     , CONNECT_BY_ISLEAF as 하위있는지    --마지막이면 1, 자식 있으면 0
     , SYS_CONNECT_BY_PATH (department_name, '|') as 연결정보 
FROM departments
START WITH parent_id is null                          
CONNECT BY PRIOR department_id = parent_id; 


--level은 오라클에서 실행되는 모든 쿼리 내에서 사용가능한 가상의 열로 (CONNECT BY 절과 함께 사용된다.
--트리 내에서 어떤 단계에 있는지를 나타내는 정수값
--정수형 데이터가 필요할 때 사용 
SELECT level
FROM dual
CONNECT BY LEVEL <= 12;

--201701 ~ 201712
SELECT '2017'||lpad(level,2,'0') as 년월
FROM dual
CONNECT BY LEVEL <= 12;


SELECT period            as 년월
     , sum(loan_jan_amt) as 합계
FROM kor_loan_status
WHERE period like '2011%'
GROUP BY period;

--201101    0
--201102    0
--     :
--201112    10331611.1       

SELECT a.년월
      , nvl(b.합계,0) as 합계 
FROM  (SELECT '2017'||lpad(level,2,'0') as 년월
        FROM dual
        CONNECT BY LEVEL <= 12
        ) a
        ,(SELECT period            as 년월
               , sum(loan_jan_amt) as 합계
        FROM kor_loan_status
        WHERE period like '2011%'
        GROUP BY period
        ) b
WHERE a.년월 = b.년월(+)
ORDER BY 1;

--20220401 부터 4월 마지막날까지 데이터를 출력하시오 

SELECT TO_CHAR(sysdate, 'YYYYMM') || lpad(level,2,'0') as 일자 
FROM dual
CONNECT BY level <= to_char(last_Day(sysdate),'dd');


--reservation 테이블을 활용하여 금천 지점의 요일별 예약수를 출력하시오 (취소 제외)
--(1)요일별 예약수 집계
--(2) 1~7의 요일 데이터 생성
--(3) 1,2를 조인하여 출력 

select * from reservation;

SELECT b.예약수 
     , nvl(b.요일,0)
FROM  (SELECT to_char(to_date(reserv_date), 'day') as 요일
               ,count(cancel) as 예약수
            FROM reservation
            WHERE branch LIKE '금천'
            GROUP BY to_char(to_date(reserv_date), 'day')) a
    ,(SELECT to_char(to_date(reserv_date), 'day') as 요일
           , count(cancel) as 예약수
      FROM reservation
      WHERE branch LIKE '금천'
      AND cancel = 'N'
      GROUP BY to_char(to_date(reserv_date), 'day')
    ) b
ORDER BY 1 desc;






