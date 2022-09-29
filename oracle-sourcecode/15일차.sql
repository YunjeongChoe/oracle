SET SERVEROUTPUT ON;

--기본 단위를 블록이라고 하며 블록은 : 이름부, 선언부, 실행부, 예외처리부로 구성
--이름부는 블록의 명칭이 오는데 없을 경우 익명블록(DECLARE)
DECLARE
 vi_num number := 10;
 vn_pi CONSTANT number := 3.14;
BEGIN
 DBMS_OUTPUT.PUT_LINE('값:'||vi_num);
 --vn_pi := 4; 오류 
END;



DECLARE 
 vs_emp_name employees.emp_name%TYPE;
 vs_dep_name departments.department_name%TYPE;
BEGIN
  SELECT a.emp_name, b.department_name
  INTO vs_emp_name, vs_dep_name     --INTO 조회 결과 변수에 저장 
  FROM employees a
      , departments b
  WHERE a.department_id = b.department_id
  AND a.employee_id = 100;
  DBMS_OUTPUT.PUT_LINE(vs_emp_name||':'||vs_dep_name);
END; 


--이름을 입력 받아 학번을 출력하는 익명블록 작성
DECLARE
  vs_nm 학생.이름%TYPE := :nm;
  vn_hakno 학생.학번%TYPE;
BEGIN
  SELECT 학번
  INTO vn_hakno 
  FROM 학생
  WHERE 학생.이름 = vs_nm;
   /*입력받은 이름으로 학생테이블에서 학번 조회 SQL*/
  DBMS_OUTPUT.PUT_LINE(vs_nm||':'||vn_hakno);
END; 


BEGIN    --선언부가 필요없으면 BEGIN END 가능
  DBMS_OUTPUT.PUT_LINE(2 * 2);
END;

/*IF*/

DECLARE
  vn_num number := 10;
  vn_user_num number := :su;
BEGIN
  IF vn_user_num > vn_num THEN
    DBMS_OUTPUT.PUT_LINE('10보다 작음');
  ELSIF vn_user_num = vn_num THEN
    DBMS_OUTPUT.PUT_LINE('10임');
  ELSE
    DBMS_OUTPUT.PUT_LINE('10보다 큼');
  END IF;
END;


/* 신입생이 들어왔습니다.
   학번을 생성하여 등록해주세요
   
   가장 마지막학번 앞자리(4) 년도가 올해와 같다면 '마지막학번' +1'
                                      같지않다면 올해 + 000001 번으로 생성
                        
*/

DECLARE vn_year varchar2(4) := TO_CHAR(SYSDATE, 'YYYY');
        vn_max_no  학생.학번%TYPE;
        vn_make_no 학생.학번%TYPE;
BEGIN
 /*학번생성*/
  --(1) 학번조회
  --(2) 번호 앞자리와 올해를 비교하여 학번생성
   SELECT MAX(학번)
   INTO vn_max_no
   FROM 학생;
   IF substr(vn_max_no,1,4) = vn_year THEN
     vn_make_no := vn_max_no + 1;
   ELSE vn_make_no := (vn_year || '000001');
   END IF;
   INSERT INTO 학생(학번, 이름, 전공, 생년월일)
   VALUES(vn_make_no, :이름, :전공, TO_DATE(:생년월일));
   COMMIT;
END;



--단순 LOOP문 
DECLARE
  vn_base number := 3;
  vn_cnt  number := 1;
BEGIN
 LOOP
   DBMS_OUTPUT.PUT_LINE(vn_base||'*'||vn_cnt||'='||vn_base*vn_cnt);
   vn_cnt := vn_cnt + 1;
   EXIT WHEN vn_cnt > 9;   --루프종료 
 END LOOP;
END;    


--중첩 LOOP 
DECLARE
 i number := 2;
 j number ;
BEGIN
 LOOP
   DBMS_OUTPUT.PUT_LINE(i||'단 ==============');
   j := 1;
   LOOP
    DBMS_OUTPUT.PUT_LINE(i||'*'||j||'='||i*j);
    j := j + 1 ;
    EXIT WHEN j > 9;    --j루프 종료 
    END LOOP;
   DBMS_OUTPUT.PUT_LINE(i||'*'||j||'='||i*j);
   i := i + 1 ;
  EXIT WHEN i > 9;          --i루프 종료
 END LOOP;
END;       




--WHILE문 
DECLARE
  vn_base number := 3;
  vn_cnt  number := 1;
BEGIN
 WHILE vn_cnt <= 9       --진입할때 조건. 해당조건이 true면 loop를 돌음 
 LOOP
   DBMS_OUTPUT.PUT_LINE(vn_base||'*'||vn_cnt||'='||vn_base*vn_cnt);
   vn_cnt := vn_cnt + 1;
 END LOOP;
END;




--FOR문 
DECLARE
  i number := 3;
BEGIN
 FOR j In 1..9   --초기값.. in reverse는 거꾸로(9부터 1)
                 --종료 1씩 증가하여 j에 할당  
 LOOP
   DBMS_OUTPUT.PUT_LINE(i||'*'||j||'='||i*j);
 END LOOP;
END;

 
--이중 FOR문
BEGIN
 FOR i In 2..9                
 LOOP
    DBMS_OUTPUT.PUT_LINE(i||'단 ==============');
   
  FOR j IN 1..9              
   LOOP
    DBMS_OUTPUT.PUT_LINE(i||'*'||j||'='||i*j);
    END LOOP;
  END LOOP;
END;



--숫자를 입력받아 입력받은 수 만큼 *을 프린트하는 익명블록을 작성하시오
--ex) 5
--    *****





DECLARE
 i number := :num;
 k number := 0;
 nm varchar2(100) := null;
 BEGIN
  WHILE k < i
   LOOP 
    nm := nm || '*';
    k := k + 1;
   END LOOP;
  DBMS_OUTPUT.PUT_LINE(i || '입력: '|| nm);
END;





       

           