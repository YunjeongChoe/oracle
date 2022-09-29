--1.
CREATE TABLESPACE TS_STUDY
datafile '/u01/app/oracle/oradata/XE/ts_study.dbf'
size 100m autoextend on next 5M;



--2.
CREATE USER java2 IDENTIFIED BY oracle
DEFAULT TABLESPACE TS_STUDY
TEMPORARY TABLESPACE TEMP;


--3.
GRANT connect, resource TO java2;




--4.
CREATE TABLE EX_MEM (
        MEM_ID varchar2(10) constraint PK_EX_MEM primary key
       , MEM_NAME varchar2(20) not null
       , MEM_JOB varchar2(30) 
       , MEM_MILEAGE number(8,2) 
       , MEM_REG_DATE date default sysdate );
       
       
--5.       
ALTER TABLE EX_MEM MODIFY MEM_NAME VARCHAR(50);



--6.
CREATE SEQUENCE SEQ_CODE
START WITH  1000
MAXVALUE    9999
CYCLE;




--7.
INSERT INTO EX_MEM (MEM_ID, MEM_NAME, MEM_JOB, MEM_REG_DATE) VALUES('hong','홍길동', '주부', sysdate);





--8.
INSERT INTO EX_MEM ( mem_id, mem_name , mem_job , mem_mileage)
SELECT mem_id, mem_name, mem_job, mem_mileage
FROM member
WHERE mem_like in ('독서', '등산', '바둑');







--9.
ALTER TABLE ex_mem 
DROP COLUMN mem_name
WHERE mem_name like '김%';




--10.
SELECT mem_id
     , mem_name
     , mem_job
     , mem_mileage
FROM member
WHERE mem_job = '주부'
AND mem_mileage >= 1000 and mem_mileage <= 3000
ORDER BY 4 DESC;


--11.
SELECT PROD_ID
     , PROD_NAME
     , PROD_SALE
FROM PROD
WHERE PROD_SALE = 23000 
OR PROD_SALE = 26000
OR PROD_SALE = 33000;



--12.
SELECT mem_job 
     , COUNT(mem_name) as mem_cnt
     , ROUND(avg(mem_mileage),0) as AVG_MLG
     , ROUND(max(mem_mileage),0) as MAX_MLG
FROM member
GROUP BY mem_job
HAVING COUNT(mem_job) >= 3
ORDER BY 2 desc;




--13.
SELECT mem_id
     , mem_name
     , mem_job
     , cart_prod
     , cart_qty
FROM  cart a
    , member b
WHERE a.cart_member = b.mem_id
AND substr(cart_no,1, 8) >= 20050728 ;





--14. 
SELECT mem_id
     , mem_name
     , mem_job
     , cart_prod
     , cart_qty
FROM cart
INNER JOIN member
ON(cart.cart_member = member.mem_id)
WHERE substr(cart_no,1, 8) >= 20050728 ;




--15.
SELECT mem_id
     , mem_name
     , mem_job
     , mem_mileage
     , RANK() OVER(PARTITION BY mem_job
                       ORDER BY mem_mileage desc) as 직업별마일리지
FROM member;





