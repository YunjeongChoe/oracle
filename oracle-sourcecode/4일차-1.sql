/*
member   : 고객 
cart     : 장바구니
product  : 상품
buyer    ; 거래처
buyprod  : 거래상품
lprod    : 상품카테고리 
*/

--member(고객) 중 대전에 거주하고, 직업이 회사원인 고객을 출력 
SELECT * FROM member;

SELECT mem_name   /*고객명*/
    , mem_job     /*고객직업*/
    , mem_add1    /*고객주소*/
    , mem_mail    /*고객메일*/
FROM member 
WHERE mem_add1 LIKE '%대전%'
AND mem_job = '회사원';

----------------------------------------------------------------------------

/*함수 (function)
 오라클 데이터베이스에서 함수는 특정 연산처리 결과를 '단일값'으로 반환하는 객체 
 내장함수와 사용자 정의함수가 있음
*/
--ABS 매개변수로 숫자를 받아 절대값 반환 
SELECT ABS(-10)
    ,  ABS(-10.123)
    ,  ABS(10)
FROM dual ;   --dual <-임시테이블 개념 (테스트용)



--ROUND(n, i)
--i 디폴트는 0
--매개변수, n을 소수점 (i + 1)번째에서 반올림한 결과를 반환
--i가 음수이면 소수점 왼쪽에서 반올림
SELECT ROUND(10.154)
     , ROUND(10.526, 1)
     , ROUND(16.123,-1)
FROM dual;

--employees 직원의 일당을 계산하여 출력하시오 (한 달 30일 기준)
--                                       소수점 둘째자리까지 표현
SELECT emp_name
     , salary
     , round(salary / 30, 2) as 일당 
FROM employees;



--MOD(m, n) m을 n으로 나눈 나머지를 반환
SELECT MOD(4, 2)
     , MOD(5, 2)
FROM dual;


SELECT *
FROM TB_INFO;



--INFO_NO가 짝수이면 짝수를, 홀수이면 홀수를 출력하시오
--1.필요한 컬럼 출력 
SELECT info_no
     , nm
FROM TB_INFO;

--2.MOD함수를 사용하여 나머지 출력  3,해당 나머지의 출력결과에 따른 표현식 작성 
SELECT CASE WHEN MOD(info_no, 2) = 0 THEN '짝수'
       ELSE '홀수'
       END as 짝홀
       , nm
FROM TB_INFO;



--문자 함수 
--문자 함수는 연산 대상이 문자이며 반환값은 함수에 따라 문자 또는 숫자를 반환함

--INITCAP : 첫글자 대문자, LOWER : 모두 소문자, UPPER : 대문자
SELECT INITCAP('pengsu')
     , LOWER('PengSu')
     , UPPER('pengsu')
FROM dual;

SELECT LOWER(emp_name)
     , UPPER(emp_name)
     , emp_name
FROM employees;
----------------------------------------------
SELECT LOWER(emp_name)
     , UPPER(emp_name)
     , emp_name
FROM employees;
WHERE LOWER (emp_name) LIKE LOWER('%donald%');
            --where절에emp_name을 lower로 변환시켜 검색가능하게 함


--SUBSTR(char, pos, len) 문자열 char에서 pos번째 부터 len만큼 문자열을 자른뒤에 반환
--len을 쓰지 않으면 pos번째 부터 나머지 모든 문자 변환
SELECT substr('ABCD EFG',1,4)   --괄호안에 첫번째 숫자는 시작위치, 두번째 숫자는 자를 글자 수 
      ,substr('ABCD EFG',2,4)
      ,substr('ABCD EFG',2) 
      ,substr('ABCD EFG',-4,2)    --pos마이너스이면 뒤에서 pos만큼
FROM dual;


SELECT mem_regno1
     , mem_regno2
     , mem_name
FROM member;
--이름 : 김은대 주민번호 760115-1******
--형태로 출력하시오 

SELECT '이름:'||substr(mem_name,1) || ' 주민번호:'||substr(mem_regno1,1) ||'-'|| substr(mem_regno2,1,1)||'******'  as 정보
FROM member;





--LPAD, RPAD L:왼쪽, R:오른쪽에 지정한 문자로 채움
SELECT LPAD(123,    5, '0')
     , LPAD(1  ,    5, '0')
     , LPAD(11234,  5, '0')
     , RPAD(123,    5, '0')
     , RPAD(1     , 5, '0')
     , RPAD(11234 , 5, '0')
FROM dual;

SELECT LPAD(INFO_NO, 10, '0'), nm
FROM TB_INFO;



--LTRIM, RTRIM, TRIM 공백제거
SELECT LTRIM(' 안녕하세요 ')
     , RTRIM(' 안녕하세요 ')
     , TRIM(' 안녕하세요 ')
FROM dual;





--REPLACE(char, i, j) 정확한 키워드를 변환 
--대상문자열 char에서 i를 찾아서 j로 치환 
--TRASLATE 대상 문자열을 한글자씩 변환 
SELECT REPLACE('나는 너를 모르는데 너는 나를 알겠는가?','나는','너를')
     , TRANSLATE('나는 너를 모르는데 너는 나를 알겠는가?','나는','너를')  --나->너, 는->를 
FROM dual;



--LENGTH --문자열길이
--LENGTHB  --문자열byte수
SELECT LENGTH('홍길동')
     , LENGTHB('홍길동')
FROM dual;



--INSTR(char, check, pos, i)(위치반환)
--char에서 pos 위치에서부터 i번째 위치하는 check 문자열의 인덱스값 반환
SELECT INSTR('abc abc abc ab','ab')      --디폴트 1, 1
     , INSTR('abc abc abc ab','ab',1 )
     , INSTR('abc abc abc ab','ab',1 ,2)
     , INSTR('abc abc abc ab','ab',4 ,2)
FROM dual;


SELECT mem_name
     , mem_mail
FROM member;
--mem_mail에 @의 위치를 출력하시오 
SELECT mem_name
     , mem_mail
     , INSTR(mem_mail,'@') as idx
FROM member;


--문제 : email주소의 @앞 문자열을 id @뒤 문자열을 domain으로 출력하시오
--ex)name  id       domain
--ex)김은대 pyodab   ycos.co.kr

--SELECT mem_name
--     , mem_mail
--     , INSTR(mem_mail,'@')
--     , SUBSTR 
--FROM member;

SELECT mem_name
     , mem_mail
     , INSTR(mem_mail,'@') as idx
     , SUBSTR(mem_mail,1, INSTR(mem_mail,'@')-1) as id
     , SUBSTR(mem_mail, INSTR(mem_mail,'@')+1) as domain
FROM member;


--날짜 함수
SELECT SYSDATE        as 현재시간 
     , SYSTIMESTAMP   as 현재시간_밀리세컨드 
FROM dual;

--ADD_MONTHS 월 추가평
SELECT ADD_MONTHS(SYSDATE, 1)
     , ADD_MONTHS(SYSDATE, -1)
FROM dual;

--LAST_DAY 마지막날
--NEXT DAY 다음 해당 요일 
SELECT LAST_DAY(SYSDATE)
     , NEXT_DAY(SYSDATE,'금요일')
     , NEXT_DAY(SYSDATE,'목요일')
FROM dual;
     

SELECT SYSDATE + 1
     , SYSDATE + 100
     , ROUND(sysdate, 'month')
     , ROUND(sysdate, 'year')
FROM dual;



--오늘부터 이번 달 마지막 날까지 D-DAY를 구하시오
SELECT last_day(sysdate)||'까지는'|| (last_day(sysdate) - sysdate)||'일 남았습니다.' as d_day
FROM dual;




--변환함수 to 문자 : TO_CHAR
--        to 숫자 : TO_NUMBER
--        to 날짜 : TO_DATE
SELECT TO_CHAR(SYSDATE, 'YYYY')
     , TO_CHAR(SYSDATE, 'YYYY MM DD HH:MI:SS')
     , TO_CHAR(SYSDATE, 'MM')
     , TO_CHAR(SYSDATE, 'YYMMDD')
     , TO_CHAR(SYSDATE, 'YYYY-MM-DD')
     , TO_CHAR(SYSDATE, 'day')          --요일로 변환 
     , TO_CHAR(SYSDATE, 'd')            --1~ 7 요일을 숫자로 반환 
     , TO_CHAR(1234569, '999,999,999')  --천 단위로 구분
     , TO_CHAR(123, 'RN')
FROM dual;


SELECT TO_DATE('2002 02 14','YYYY MM DD')
     , TO_DATE('2002_02_14','YYYY_MM_DD')
     , TO_DATE('2002','YYYY')
     , TO_DATE('200202','YYYYMM')
     , TO_DATE('20020214')
     , TO_DATE('2002.02.14','YYYY.MM.DD')
FROM dual;



SELECT TO_DATE('22020201')
FROM dual;


--현재일자를 기준으로 사원테이블(employees)의 입사일자를 참조해서 근속년수가 23년 이상인 사원을 출력하시오

SELECT * FROM employees;

SELECT emp_name
     , employee_id
     , hire_date
     , (TO_CHAR(SYSDATE, 'YYYY')) - (TO_CHAR(hire_date, 'YYYY')) as 근속년수 
FROM employees
WHERE (TO_CHAR(SYSDATE, 'YYYY')) - (TO_CHAR(hire_date, 'YYYY')) >= 23;
     



     








