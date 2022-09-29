/* 정규식
  1-1 : .(dot)은 모든 문자와 match
        [] <-- 문자 한 글자를 의미
         ^ 시작을 의미함 / $ 끝을 의미 
        [^] 부정을 의미
*/

SELECT mem_name, mem_hometel
FROM member
WHERE REGEXP_LIKE (mem_hometel, '^..-');



SELECT mem_name, mem_hometel
FROM member
WHERE REGEXP_LIKE (mem_hometel, '^[0-9][0-9]-');   --시작이 숫자 두개 하이픈이 나오는 것들만 출력

/*{m} : 정확히 m회 매치
  {m,}/ : 최소한 m회 배치 
  {m, n} : 최소 m회 최대 n회 매치
  ? : 0 or 1회 매치
  + : 1 ~ 1회이상 매치 
  * ; 0번 이상 매치
  
  /* -- 8이 3번 출현하는 전화번호*/
  
  
SELECT mem_name, mem_hometel
FROM member
WHERE REGEXP_LIKE (mem_hometel,'[8]{2,}');


--이메일 주소 중 영문자 3번 이하 출현 후 @이 있는 이메일 주소를 출력하시오 
--
SELECT mem_name, mem_mail
FROM member
WHERE REGEXP_LIKE (mem_mail,'^[a-zA-Z]{1, 3}@');



--숫자가 포함되지 않는 비밀번호 검색
SELECT mem_name, mem_pass
FROM MEMBER
WHERE REGEXP_LIKE(mem_pass, '^[0-9+$]');



--한글이 포함되지 않은 주소를 출력하시오 
SELECT mem_name, mem_add2
FROM member
WHERE REGEXP_LIKE (mem_add2, '^[^가-힣]+$');


/* () <-- 패턴 그룹을 의미
   |  <-- 또는 
*/

SELECT *
FROM member         --()|() 그룹으로 묶을 때
WHERE REGEXP_LIKE(mem_name, '신|오');      --신 or 오


--J로 시작하며, 세번째 문자가 M or N인 이름을 가진 직원

SELECT emp_name
FROM employees
WHERE REGEXP_LIKE (emp_name, '^J.(n|m)');





/* REGEXP_SUBSTR (대상문자, 패턴, 시작위치, 매칭순번)*/
SELECT REGEXP_SUBSTR('C-01-02-03','[^-]+',1,1) as re1    --하이픈이 아닌거에서의 첫번째 
     , REGEXP_SUBSTR('C-01-02-03','[^-]+',1,2) as re2
     , REGEXP_SUBSTR('C-01-02-03','[^-]+',1,3) as re3
FROM dual;



SELECT mem_mail
     , REGEXP_SUBSTR(mem_mail, '[^@]+',1,1) as ids
     , REGEXP_SUBSTR(mem_mail, '[^@]+',1,2) as domain
FROM member;



SELECT REGEXP_REPLACE('Oracle is th   Information...','( ){2,}',' ')
     , REPLACE('Oracle is th   Information...','  ',' ')
FROM dual;










select * from member;
select * from cart;
select * from products;


SELECT *
FROM (  SELECT rownum as No
               ,count(*) over () as allcnt
              , a.*
        FROM  (SELECT mem_name
                    , mem_id
                    , mem_mail
                    , mem_mileage
               FROM member
               ORDER BY 1 ) a
      )
WHERE No between 1 and 10;





SELECT rownum as No
      , prod_name as 상품명
      , SUUM() 
FROM member a 
    , cart b
    , products c
WHERE a.mem_id = b.cart_member;





