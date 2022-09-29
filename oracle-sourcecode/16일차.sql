/*
   이름이 있는 블록
   이름
   IS
     선언부
   BEGIN
      실행부
    EXCEPTION
   END;
*/



--국가번호를 입력 받아 국가명을 반한하는 함수
CREATE OR REPLACE FUNCTION fn_get_coutry(p_id NUMBER)
 RETURN VARCHAR2    -- 리턴타입 
 IS
   vs_country_name countries.country_name%TYPE;
BEGIN
   SELECT country_name
     INTO vs_country_name
   FROM countries
   WHERE country_id = p_id;
   RETURN vs_country_name; --없을경우 '해당국가 없음' 반환 
END;





--입력값에 해당되는 국가명이 없으면 "해당국가 없음'을 리턴하는 함수로 수정하시오 

CREATE OR REPLACE FUNCTION fn_get_coutry(p_id NUMBER)
 RETURN VARCHAR2    -- 리턴타입 
 IS
   vs_country_name countries.country_name%TYPE;
BEGIN
   SELECT COUNT(*)
     INTO vn_num
   FROM countries
   WHERE country_id = p_id;
   --해당 데이터가 있는지 없는지 체크
IF vn_num > 0 THEN
   --있을경우
      SELECT country_name
      INTO vs_country_name
      FROM countries
      WHERE country_id = p_id;
    ELSE
      vs_country_name := '해당국가 없음'; --없을경우 '해당국가 없음' 반환 
      END IF;
   RETURN vs_country_name; --리턴값 
END;


SELECT fn_get_coutry(52777)
FROM dual;



CREATE OR REPLACE FUNCTION fn_year
 RETURN VARCHAR2
IS
BEGIN
 RETURN TO_CHAR(SYSDATE, 'YYYY');
END;

SELECT fn_year(), fn_year    --매개변수가 없을때 아무것도 안써도 됨 괄호도 안써도 됨 
FROM dual;


/*학생 이름을 입력받아 수강학점을 리턴하는 함수를 작성하시오 
  해당 이름의 학생이 없으면 0 or '없음'
  입력값 이름 : varchar2
  리턴값 학점 : varchar2*/

CREATE OR REPLACE FUNCTION fn_get_score(p_name VARCHAR2)
 RETURN VARCHAR2
IS
 vn_score VARCHAR2(30);   --리턴값
 vn_cnt   NUMBER;
BEGIN
--(1) 입력받은 학생이 존재하는지 체크
SELECT COUNT(*)
  INTO vn_cnt
 FROM 학생
 WHERE 이름 = 'p_name';
--(2)학생이 있으면 수강학점 합계
 IF vn_cnt > 0 THEN
    SELECT NVL (SUM(과목.학점),0)
      INTO vn_score
    FROM 학생, 수강내역, 과목
    WHERE 학생.이름 = 'p_name'
    AND 학생.학번 = 수강내역.학번
    AND 수강내역.과목번호 = 과목.과목번호(+);
 ELSE
   vn_score := '없음';
 END IF;
  RETURN vn_score;
END;


SELECT FN_GET_SCORE('최숙경')
FROM dual;
 
 
 
 
/* mem_id를 입력받아 등급을 리턴하는 함수를 만드시오
  VIP : 마일리지 5000 이상 또는 구매 수량 100 이상
  GOLD : 마일리지 5000 미만 3000 이상 또는 최근 구매 수량 50 이상
  SILVER : 나머지
  SELECT FN_GET_MEM_GRADE('a001') <--return VIP
  FROM member;
  (1) 필요한 SQL 작성 (고객별 마일리지, 구매수량(qty))
SELECT SUM(cart_qty), MAX(mem_mileage)
FROM member, cart
WHERE mem_id = 'p_id';
AND member.mem_id = cart.cart_mamber(+);
  (2) (1) 조회데이터로 조건문 작성
    IF ~ VIP
    ELSIF GOLD
    ELSE SILVER
  */


CREATE OR REPLACE FUNCTION fn_get_mem_grade(p_id VARCHAR2)
 RETURN VARCHAR2
IS
 vs_grade VARCHAR2(30);   --리턴값
 vn_mileage   NUMBER;
 vn_qty     NUMBER;
BEGIN

 SELECT SUM(cart_qty), MAX(mem_mileage)
  INTO vn_qty, vn_mileage
 FROM member, cart
 WHERE member.mem_id = p_id
 AND member.mem_id = cart.cart_member(+);
  IF vn_mileage >= 5000 or vn_qty >= 100 THEN
    vs_grade := 'VIP';
  ELSIF vn_mileage < 5000 and vn_mileage >= 3000 or vn_qty >= 50 THEN
    vs_grade := 'GOLD' ;
  ELSE
    vs_grade := 'SILVER';
  END IF;
 RETURN vs_grade;
END;


SELECT mem_id, mem_name, fn_get_mem_grade(mem_id)
FROM member;



/* YYYYMMDD(문자)형태의 날짜를 입력받아 d-day를 계산하는 함수를 만드시오 (네이버 디데이 기준)
   지났다면   : 기준일 부터 1772일째 되는 날 입니다.
   오늘이라면  : 오늘은 기준일부터 1일째 되는 날 입니다.
   남았다면   : 오늘부터 기준일까지는 243일 남았습니다.
    (입력 : 문자열, 리턴 : 문자열)
*/

CREATE OR REPLACE FUNCTION fn_dday(p_date VARCHAR2)
 RETURN VARCHAR2
IS
 vn_date VARCHAR2(300);  --리턴값 

BEGIN
IF to_char(sysdate, 'YYYYMMDD') > p_date THEN
 vn_date := '기준일부터 '|| round(sysdate - to_date(p_date)) || '일째 되는 날 입니다.';
 
ELSIF to_char(sysdate, 'YYYYMMDD') < p_date THEN
 vn_date := '기준일 부터 ' || ceil(to_date(p_date) - sysdate) || '일째 되는 날 입니다.';

ELSE vn_date := '기준일 부터 1일째 되는 날 입니다.';
END IF;
RETURN vn_date;
END;
  


SELECT  fn_dday('20170815')
      , fn_dday('20220502')
      , fn_dday('20221231')
FROM dual;









