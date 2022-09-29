CREATE TABLE ex1_2(
    col1 varchar2(3)         --디폴트 byte
    ,col2 varchar2(3 byte)
    ,col3 varchar2(3 char)  --길이로 본다
);

INSERT INTO ex1_2 (col1) VALUES('오라클');  --오류
INSERT INTO ex1_2 (col2) VALUES('오라클'); --오류
INSERT INTO ex1_2 (col3) VALUES('오라클');

INSERT INTO ex1_2 (col1, col2) VALUES('abc','123');

SELECT lengthb(col3)간
     , col3
     
FROM ex1_2 ;





/*날짜 데이터 삽입
DATE : 년월일시분초
TIMESTAMP : 년월일시분초, 밀리세컨드
*/
CREATE TABLE ex1_3 (
    col1 DATE
    ,col2 TIMESTAMP
);
--SYSDATE, SYSTIMESTAMP <- 현재시간
INSERT INTO ex1_3 VALUES(SYSDATE, SYSTIMESTAMP);

SELECT * FROM ex1_3;






/*숫자 데이터 타입
 number(p, s)
 p : 소수점 기준으로 모든 유효숫자 자릿수
 s : s가 양수이면 소수점 이하,
     s가 음수이면 소수점 기준 왼쪽 유효숫자 자릿수를 나타냄
*/
CREATE TABLE ex1_4(
    col1 number(3)
    ,col2 number(3,2)
    ,col3 number(5,-2)
);
CREATE TABLE ex1_5(
    col1 number
);


INSERT INTO ex1_4 (col1) VALUES(0.7898); --반올림
INSERT INTO ex1_4 (col1) VALUES(99.5);   --반올림
INSERT INTO ex1_4 (col1) VALUES(1004);   --오류
SELECT * FROM ex1_4;


INSERT INTO ex1_4 (col2) VALUES(0.7898); --소수점 3번째 자리에서 반올림 
INSERT INTO ex1_4 (col2) VALUES(2.234);   
INSERT INTO ex1_4 (col2) VALUES(23.23);   --오류


INSERT INTO ex1_4 (col3) VALUES(12345.343); -- -2 십의자리 까지 반올림
INSERT INTO ex1_4 (col3) VALUES(12345);
INSERT INTO ex1_4 (col3) VALUES(1234575);
select * from ex1_4; 








/* 1.제약조건
    1.not null
*/
CREATE TABLE ex1_6 (
    col1 varchar(50)             --기본 null 허용 
    ,col2 varchar(50) not null   --null 허용하지 않음 
);
INSERT INTO ex1_6 (col1) VALUES ('안녕하세요');    --오류
INSERT INTO ex1_6 (col2) VALUES ('안녕하세요');

SELECT * FROM ex1_6;

-- 2.UNIQUE 제약조건
CREATE TABLE ex1_7(
    col1 varchar2(50)
    ,col2 varchar2(50) unique --유일해야함
);
INSERT INTO ex1_7 VALUES('abc','abc');
INSERT INTO ex1_7 VALUES('abc','abc');  --오류
INSERT INTO ex1_7 (col1) VALUES('abc');
INSERT INTO ex1_7 (col2) VALUES('ABC');
SELECT * FROM ex1_7;


-- 3.Check 제약조건
CREATE TABLE ex1_8(
    nm varchar2(30) not null
    ,age number
    ,gender char(1)
    ,constraint ck_ex_age check(age between 1 and 150)     --'ck_ex_age'해당 제약조건의 이름 
    ,constraint ck_ex_gender check(gender in ('M','F'))
);
INSERT INTO ex1_8 VALUES ('짱구',10,'M');      --정상처리 
INSERT INTO ex1_8 VALUES ('홍길동','200','M'); --오류 check 1~150보다 큼 
INSERT INTO ex1_8 VALUES ('펭수','11','P');    --오류 check M or F가 아님 

SELECT * FROM ex1_8;








/*
기본키 Primary Key (PK) -not null이면서 unique
외래키 Foreign Key (FK)
*/
CREATE TABLE dep (
    deptno number(3) primary key
    ,deptname varchar2(20)
    ,floor number(5)
);
CREATE TABLE emp (
    empno number(5) primary key
    ,empname varchar2(20)
    ,title varchar2(20)
    ,dno number(3) constraint emp_fk references dep(deptno)
    ,salary number
);
INSERT INTO dep VALUES(1, '영업', 8);
INSERT INTO dep VALUES(2, '기획', 10);
INSERT INTO dep VALUES(3, '개발', 9);
INSERT INTO emp VALUES(1001, '김창섭','대리',2,2000000);
INSERT INTO emp VALUES(1002, '박영권','과장',3,3000000);
INSERT INTO emp VALUES(1003, '펭수','사장',5,10000000);     --오류 참조 

select *
from dep
    , emp
where dep.deptno = emp.dno
and emp.empname = '김창섭';

select * from dep;
select * from emp;








/* 4.DEFAULT 제약조건
*/
CREATE TABLE ex1_9 (
    col1 varchar2(10)
    ,col2 date default sysdate
    ,col3 date default sysdate - 1   -- -1은 전
);
INSERT INTO ex1_9 (col1) VALUES ('1');
INSERT INTO ex1_9 (col1) VALUES ('2');
INSERT INTO ex1_9 (col1) VALUES ('3');
INSERT INTO ex1_9 VALUES ('4','20220101','20220401');
select * from ex1_9;



SELECT *                --테이블 컬럼 전체 조회
FROM employees;    식   --보고자 하는 테이블

SELECT employee_id      --보고자하는 컬럼 기술
    , emp_name
    , email
FROM employees;


--60 부서 직원만 조회
SELECT emp_name       as nm          --Alias(별칭)
    , phone_number    as 전화번호
    , salary          as "월 급"     --띄어쓰기하려면 쌍따옴표 사용
    , email           이메일         --as 안써도 문법상 컴럼 옆에 문구는 별칭으로 인
FROM employees
WHERE department_id = 60;                  --where절 검색 조건
ORDER BY salary desc, emp_name desc ;      --정렬조건 ASC 오름차순, DESC 내림차순

--FROM -> WHERE -> SELECT -> ORDER BY (실행순서) -WHERE절에서 별칭을 쓸 수 없다







/*INSERT : 데이터삽입*/
CREATE TABLE ex3_1 (
     col1 varchar2(30)
    ,col2 number
    ,col3 date
);
--1.기본형태
INSERT INTO ex3_1 (col1, col2, col3)
VALUES ('abc', 10, sysdate);             --문자열은 작은따옴표(바챠타입), 숫자는 그냥, 데이터는 데이터형태 

--2.컬럼명 생략
INSERT INTO ex3_1 VALUES ('efg', 10, sysdate);

--3.select ~ insert
INSERT INTO ex3_1
SELECT emp_name
     , salary
     , hire_date
FROM employees;

select  * from ex3_1;


-----employee 테이블의 emp_name과 department_id를 다음 테이블에 저장하시오.
CREATE TABLE ex3_2(
     nm varchar2(30)
    ,dep_no number
);


SELECT emp_name
      ,department_id
FROM employees;


INSERT INTO ex3_2
SELECT emp_name
      ,department_id
FROM employees;

select * from ex3_2;

-----------------------------------------

/*데이터 수정 UPDATE*/

SELECT *
FROM emp;


UPDATE emp               --수정하고자 하는 테이터 
SET salary = 2500000블   --수정 데이터
   ,title = '책임'
WHERE empno = 1001;      --수정될 데이터 검색 조건 (보통 PK값을 사용함)


/*DELETE 데이터 삭제*/
DELETE emp
WHERE empno = 1001;     --검색조건이 없으면 emp 데이터가 전부 삭제됨 


-------------------------------
/*테이블 만들어보기*/

CREATE TABLE TB_INFO (
    INFO_NO NUMBER(3) primary key not null
    ,PC_NO VARCHAR2(10) not null
    ,NM VARCHAR2(20)
    ,EMAIL VARCHAR2(100)
    ,HOBBY varchar2(1000)
);


-------------------

CREATE TABLE ex3_3 (
    seq number
    ,nm varchar2(20)
    ,dt date
    ,constraint pk_3_3 primary key (seq, nm)
);
    
INSERT INTO ex3_3 VALUES(1,'a',sysdate);
INSERT INTO ex3_3 VALUES(1,'b',sysdate);
INSERT INTO ex3_3 VALUES(1,'a',sysdate);   --오류
INSERT INTO ex3_3 VALUES(2,'a',sysdate);


SELECT * FROM ex3_3;



