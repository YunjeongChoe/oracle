SELECT a.employee_id, a.emp_name
     , a.department_id, b.department_name
FROM employees a
   , departments b
WHERE a.department_id = b.department_id;

CREATE OR REPLACE VIEW emp_dept AS
SELECT a.employee_id, a.emp_name
     , a.department_id, b.department_name
FROM employees a
   , departments b
WHERE a.department_id = b.department_id;


--뷰 생성 권한 필요 (sys계정에서 권한부여)
GRANT CREATE VIEW TO java;
--emp_dept 조회할 수 있는 권한 부여 
GRANT SELECT ON emp_dept TO study;





--(1) study 계정 생성 및 접속권한부여
--계정 생성
CREATE USER study IDENTIFIED BY study;
--접속 권한 부여 
GRANT CONNECT TO study;
--(2) java 계정에서 만든 view 객체를 조회할 수 있는 권한을 study계정에게 부여
--emp_dept 조회할 수 있는 권한 부여 
GRANT SELECT ON emp_dept TO study;
--(3) study 계정에서 emp_dept 조회가능 
SELECT * from java.emp_dept;
--java붙이는 이유 : 다른계정명을 붙인다. "스키마" 라고 부름 
SELECT * from java.channels;


CREATE OR REPLACE VIEW tb_hak AS
SELECT 학번 as hak_no
     , 이름 as han_nm
FROM  학생;
GRANT SELECT ON tb_hak TO study;
GRANT INSERT ON tb_hak TO study;

/*VIEW 뷰는 실제 데이터는 테이블에 있지만 마치 테이블처럼 사용.
  (1)자주 사용하는 SQL을 뷰로 만들어 편리하게 이용가능 
  (2)데이터 보안 측면에서 중요한 컬럼은 감출 수 있다. 
  단순 뷰
    - 테이블 하나로 생성하여 insert/update/delete 가능
    - 그룹함수 불가능
  복합 뷰
    - 여러개 테이블로 생성 insert/update/delete 불가능
    - 그룹함수 가능
    
   CONNECT, RESOURCE, DBA (롤)
   롤 : 다수 사용자와 다양한 권한을 효과적으로 관리하기 위해 권한을 그룹화 한 개념
   CONNECT : 사용자가 데이터베이스 접속할 수 있는 권한을 그룹화 한 개념
   RESOURCE : 테이블, 시퀀스, 트리거와 같은 객체 생성 권한을 그룹화 한 개념 
   DBA : 모든 권한.*/
   
SELECT *
FROM DBA_ROLE_PRIVS;
WHERE GRANTEE = 'JAVA';
--
SELECT *
FROM DBA_SYS_PRIVS
WHERE GRANTEE ='JAVA';

SELECT *
FROM DBA_SYS_PRIVS
WHERE GRANTEE ='RESOURCE';





/* 시노님 Synonym '동의어'란 뜻으로 객체 각자의 고유한 이름에 대한 동의어를 만드는 것
   PUBLIC 모든 사용자 접근가능
    PRIVATE 특정 사용자만 사용 (디폴트)*/
--시노님 생성 권한 부여 (system계정에서)
GRANT CREATE SYNONYM TO java;    

--channels 테이블 시노님을 syn_channel로 부여 
CREATE OR REPLACE SYNONYM syn_channel
FOR channels;

SELECT *
FROM syn_channel;
GRANT SELECT ON syn_channel TO study;
--public 시노님 부여 및 삭제는 DBA권한이 있어야 함.

CREATE OR REPLACE PUBLIC SYNONYM hak
FOR java.학생;
GRANT SELECT ON hak TO study;

DROP SYNONYM syn_channel;
DROP VIEW emp_dept;


select *
from user_constraints
where CONSTRAINT_NAME LIKE '%PK%';


--comment 
COMMENT ON TABLE TB_INFO IS '4월반';
COMMENT ON COLUMN TB_INFO.PC_NO IS '컴퓨터번호';
COMMENT ON COLUMN TB_INFO.INFO_NO IS '기본번호';
COMMENT ON COLUMN TB_INFO.NM IS '이름';
COMMENT ON COLUMN TB_INFO.HOBBY IS '취미';



/* 시퀀스 객체 SEQUENCE
   자동 순번을 반환하는 객체로 (CURRVAL, NEXTVAL)사용*/
   
CREATE SEQUENCE my_seq
INCREMENT BY 1         --증감숫자
START WITH   1         --시작숫자
MINVALUE     1         --최솟값
MAXVALUE     999999    --최댓값
NOCYCLE                --디폴트 NOCYCLE 최대, 최소 도달중지
NOCACHE ;              --디폴트 NOCACHE 메모리에 값 미리 할당 여부

SELECT my_seq.nextval    --값 증가      --테스트 하면 값이 증가가 되고 되돌릴 수 없음. ㅎ
     , my_seq.currval    --현재값       --현재값 출력하기전에 nextval 먼저 해야 함.
FROM dual;

SELECT my_seq.currval
FROM dual;



CREATE TABLE ex9_1 (
    seq number
  , dt  timestamp default systimestamp
);

INSERT INTO ex9_1(seq) VALUES(my_seq.nextval);

SELECT seq
     , dt
FROM ex9_1;



--ex9_2 테이블에 seq 값이 000000001 ~ 0000010000과 같은 형태로 저장되도록 INSERT문을 작성하시오
CREATE TABLE ex9_2 (
    seq varchar2(10) primary key
  , dt  timestamp default systimestamp
);

SELECT LPAD(my_seq.nextval,10,'0')
FROM dual;

INSERT INTO ex9_2 (seq) VALUES(LPAD(my_seq.nextval,10,'0'));

select * from ex9_2;



SELECT *
FROM ex9_2;

SELECT nvl(max(seq),0) + 1      --현재 테이블에서 가장 큰 값 +1을 나타냄
FROM ex9_1;

INSERT INTO ex9_1(seq)
VALUES((SELECT nvl(max(seq),0) + 1 FROM ex9_1));


SELECT * FROM ex9_1;




/* 과목 테이블에 머신러닝 과목이 있으면 학점을 6으로 업데이트
                            없으면  번호를 생성하여 인서트
                            (과목이름 : 머신러닝, 학점: 3)
*/

MERGE INTO 과목 a                      --대상 테이블
USING DUAL                             --비교 테이블
ON (a.과목이름='머신러닝')               --비교내용
WHEN MATCHED THEN                      --비교내용이 TRUE
 UPDATE SET a.학점 = 6
WHEN NOT MATCHED THEN                  --비교내용이 FALSE 
 INSERT (a.과목번호, a.과목이름, a.학점)
 VALUES ((SELECT NVL(MAX(과목번호),0) + 1
          FROM 과목),'머신러닝',3);      

SELECT * FROM 과목;





--이탈리아의 2000년 연평균 매출보다 월평균 매출이 높은 월과 평균 월평균 매출액을 출력하시오 

-- 년 평균 보다 높은 월에 구하고 해당 월에 평균을 출력하세요

--sales a, customers b, countries c 사용 
--sales_month, amount_sold, country_id, country_name, cust_id
/*  select 월평균.월, 월평균.값
    from ()월평균 
        ,()년평균
    where 월평균.값 > 년평균.값*/
--(1) 관련 테이블 조인 및 검색조건 조회
--(2) 연평균 조회
--(3) 월평균 조회
--(4) (2)번을 활용하여 (3)에서 조회 


-- 2000년 연평균
-- 2000년 월평균
-- 이탈리아


select * from sales;
select * from customers;
select * from countries;



select * from sales;
DESC sales;

select avg(amount_sold) 
from sales 
WHERE sales_month LIKE '2000%';


--106

SELECT round(avg(amount_sold)) as 년평균
FROM sales a, customers b, countries c
WHERE sales_month BETWEEN '200001' and '200012'
AND a.cust_id = b.cust_id(+)
AND b.country_id = c.country_id(+)
AND c.country_name = 'Italy';


SELECT sales_month
       ,round(avg(amount_sold)) as 월평균
FROM sales a, customers b, countries c
WHERE sales_month LIKE '2000%'
AND a.cust_id = b.cust_id(+)
AND b.country_id = c.country_id(+)
AND c.country_name = 'Italy'
GROUP BY sales_month;
 
 
 
 
 
SELECT b.*
FROM (SELECT round(avg(amount_sold)) as 년평균
      FROM sales a, customers b, countries c
      WHERE sales_month LIKE '2000%'
      AND a.cust_id = b.cust_id
      AND b.country_id = c.country_id
      AND c.country_name = 'Italy' )a
    ,(SELECT sales_month
            ,round(avg(amount_sold)) as 월평균
      FROM sales a, customers b, countries c
      WHERE sales_month LIKE '2000%'
      AND a.cust_id = b.cust_id
      AND b.country_id = c.country_id
      AND c.country_name = 'Italy'
      GROUP BY sales_month) b
WHERE a.년평균 < b.월평균;



