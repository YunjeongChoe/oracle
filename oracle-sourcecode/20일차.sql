DECLARE
BEGIN
	-- FOR문을 통한 커서 패치작업 ( 커서 선언시 정의 부분을 FOR문에 직접 기술)
	FOR emp_rec IN ( SELECT emp_name
                         FROM employees
                         WHERE department_id = 90	
	               ) 
	LOOP
	  -- 사원명을 출력, 레코드 타입은 레코드명.컬럼명 형태로 사용
	  DBMS_OUTPUT.PUT_LINE(emp_rec.emp_name);
	END LOOP;
END;

/**
 명시적 커서는 "CURSOR 커서명 IS SELECT ..." 형태로 선언한 뒤, '커서명'을 참조해서 사용했다. 
 즉 명시적 커서를 사용할 때는 커서명을 마치 변수처럼 사용했는데, 정확히 말하면 
 변수라기보다는 '상수'라고 할 수 있다. 
 커서를 변수처럼 할당한뒤 다시 다른 값을 할당해서 사용하려면 커서변수를 사용해야한다. 
**/
DECLARE
  TYPE hak_type IS RECORD (
      이름 학생.이름%TYPE
      ,전공 학생.전공%TYPE
      ,평점 학생.평점%TYPE
      );
    v_hak hak_type;
BEGIN
   FOR   hak_rec IN (select 이름, 전공, 평점
                     from 학생
                    )
    LOOP
    v_hak := hak_rec;
      DBMS_OUTPUT.PUT_LINE(hak_rec.이름||':'|| hak_rec.전공||':'||hak_rec.평점);
      END LOOP;
    END;
    






DECLARE
   -- 숫자-문자 쌍의 연관배열 선언
   TYPE av_type IS TABLE OF VARCHAR2(40) INDEX BY PLS_INTEGER;
   -- 연관배열 변수 선언
   vav_test av_type;
BEGIN
  -- 연관배열에 값 할당
  vav_test(10) := '10에 대한 값';
  vav_test(20) := '20에 대한 값';
  
  --연관배열 값 출력
  DBMS_OUTPUT.PUT_LINE(vav_test(10));
  DBMS_OUTPUT.PUT_LINE(vav_test(20));

END;




--20
DECLARE
   -- 숫자-문자 쌍의 연관배열 선언
   TYPE av_type IS TABLE OF VARCHAR2(40) INDEX BY VARCHAR2(30);    --INDEX BY가 키 값
        
   -- 연관배열 변수 선언
   vav_test av_type;
BEGIN
  -- 연관배열에 값 할당
  vav_test('A') := '10에 대한 값';
  vav_test('B') := '20에 대한 값';
  
  --연관배열 값 출력
  DBMS_OUTPUT.PUT_LINE(vav_test('A'));
  DBMS_OUTPUT.PUT_LINE(vav_test('B'));
END;
  
  
  
  
  
  DECLARE
   -- 5개의 문자형 값으로 이루어진 VARRAY 선언
   TYPE va_type IS VARRAY(5) OF VARCHAR2(20);
   -- VARRY 변수 선언
   vva_test va_type;
   vn_cnt NUMBER := 0;
BEGIN
  -- 생성자를 사용해 값 할당 (총 5개지만 최초 3개만 값 할당)
  vva_test := va_type('FIRST', 'SECOND', 'THIRD', '', '');
  
  LOOP
     vn_cnt := vn_cnt + 1;     
     -- 크기가 5이므로 5회 루프를 돌면서 각 요소 값 출력 
     IF vn_cnt > 5 THEN 
        EXIT;
     END IF;
     -- VARRY 요소 값 출력 
     DBMS_OUTPUT.PUT_LINE(vva_test(vn_cnt));
  END LOOP;
END;
  
  
  


-- FIRST와 LAST 메소드 함수 타입에 : 컬렉션의 첫번째 인덱스 반환, 마지막인덱스 반환
DECLARE
  -- 중첩 테이블 선언
  TYPE nt_typ IS TABLE OF VARCHAR2(10);
  
  -- 변수 선언
  vnt_test nt_typ;
BEGIN
  -- 생성자를 사용해 값 할당
  vnt_test := nt_typ('FIRST', 'SECOND', 'THIRD', 'FOURTH', 'FIFTH');

  -- FIRST와 LAST 메소드를 FOR문에서 사용해 컬렉션 값을 출력
  FOR i IN vnt_test.FIRST..vnt_test.LAST
  LOOP
  
     DBMS_OUTPUT.PUT_LINE(i || '번째 요소 값: ' || vnt_test(i));
  END LOOP;

END;








DECLARE
    -- 요소타입을 employees%ROWTYPE 로 선언, 즉 테이블형 레코드를 요소 타입으로 한 중첩테이블 
    TYPE nt_type IS TABLE OF employees%ROWTYPE;

   -- 중첩테이블 변수선언
   vnt_test nt_type;
BEGIN
  -- 빈 생성자로 초기화
  vnt_test := nt_type();
  
  -- 사원테이블 전체를 중첩테이블에 담는다. 
  FOR rec IN ( SELECT * FROM employees) 
  LOOP
     -- 요소 1개 추가 
     vnt_test.EXTEND;         --공간확장
     
     -- LAST 메소드를 사용하면 항상 위에서 추가한 요소의 인덱스를 가져온다. 
     vnt_test ( vnt_test.LAST) := rec;
     
  END LOOP;
   
  -- 출력
  FOR i IN vnt_test.FIRST..vnt_test.LAST
  LOOP
       DBMS_OUTPUT.PUT_LINE(vnt_test(i).employee_id || ' - ' ||   vnt_test(i).emp_name);
  END LOOP;

END;
    



DECLARE
  input_string  VARCHAR2 (200) := 'The Oracle';  -- 암호화할 VARCHAR2 데이터
  output_string VARCHAR2 (200); -- 복호화된 VARCHAR2 데이터 

  encrypted_raw RAW (2000); -- 암호화된 데이터 
  decrypted_raw RAW (2000); -- 복호화할 데이터 

  num_key_bytes NUMBER := 256/8; -- 암호화 키를 만들 길이 (256 비트, 32 바이트)
  key_bytes_raw RAW (32);        -- 암호화 키 

  -- 암호화 슈트 
  encryption_type PLS_INTEGER; 
  
BEGIN
	 -- 암호화 슈트 설정
	 encryption_type := DBMS_CRYPTO.ENCRYPT_AES256 + -- 256비트 키를 사용한 AES 암호화 
	                    DBMS_CRYPTO.CHAIN_CBC +      -- CBC 모드 
	                    DBMS_CRYPTO.PAD_PKCS5;       -- PKCS5로 이루어진 패딩
	
   DBMS_OUTPUT.PUT_LINE ('원본 문자열: ' || input_string);

   -- RANDOMBYTES 함수를 사용해 암호화 키 생성 
   key_bytes_raw := DBMS_CRYPTO.RANDOMBYTES (num_key_bytes);
   
   -- ENCRYPT 함수로 암호화를 한다. 원본 문자열을 UTL_I18N.STRING_TO_RAW를 사용해 RAW 타입으로 변환한다. 
   encrypted_raw := DBMS_CRYPTO.ENCRYPT ( src => UTL_I18N.STRING_TO_RAW (input_string, 'AL32UTF8'),   
                                          typ => encryption_type,
                                          key => key_bytes_raw
                                        );
                                        
   -- 암호화된 RAW 데이터를 한번 출력해보자
   DBMS_OUTPUT.PUT_LINE('암호화된 RAW 데이터: ' || encrypted_raw);                                     
   -- 암호화 한 데이터를 다시 복호화 ( 암호화했던 키와 암호화 슈트는 동일하게 사용해야 한다. )
   decrypted_raw := DBMS_CRYPTO.DECRYPT ( src => encrypted_raw,
                                          typ => encryption_type,
                                          key => key_bytes_raw
                                        );
   
   -- 복호화된 RAW 타입 데이터를 UTL_I18N.RAW_TO_CHAR를 사용해 다시 VARCHAR2로 변환 
   output_string := UTL_I18N.RAW_TO_CHAR (decrypted_raw, 'AL32UTF8');
   -- 복호화된 문자열 출력 
   DBMS_OUTPUT.PUT_LINE ('복호화된 문자열: ' || output_string);
END;

  
  
  
  
  -- HASH 함수
DECLARE
  input_string  VARCHAR2 (200) := 'The Oracle';  -- 입력 VARCHAR2 데이터
  input_raw     RAW(128);                        -- 입력 RAW 데이터 
  encrypted_raw RAW (2000); -- 암호화 데이터 
BEGIN
	-- VARCHAR2를 RAW 타입으로 변환
  input_raw := UTL_I18N.STRING_TO_RAW (input_string, 'AL32UTF8');
	
	
  DBMS_OUTPUT.PUT_LINE('----------- HASH 함수 -------------');
  encrypted_raw := DBMS_CRYPTO.HASH( src => input_raw,
                                     typ => DBMS_CRYPTO.HASH_SH1);
                                     
  DBMS_OUTPUT.PUT_LINE('입력 문자열의 해시값 : ' || RAWTOHEX(encrypted_raw));   
END;




CREATE OR REPLACE FUNCTION fn_pw_encode (input_pw varchar2)
RETURN VARCHAR2
IS
   input_raw     RAW(128);      -- 입력 RAW 데이터 
   encrypted_raw RAW (2000);    -- 암호화 데이
BEGIN
  input_raw := UTL_I18N.STRING_TO_RAW (input_pw, 'AL32UTF8');	
  DBMS_OUTPUT.PUT_LINE('----------- HASH 함수 -------------');
  encrypted_raw := DBMS_CRYPTO.HASH( src => input_raw,
                                     typ => DBMS_CRYPTO.HASH_SH1);

RETURN RAWTOHEX(encrypted_raw);  
END;


SELECT fn_pw_encode('abc123')
FROM dual;




SELECT mem_name
     , mem_pass
     , fn_pw_encode(mem_pass)
FROM member;




CREATE TABLE ex_mem1 AS
SELECT mem_id
     , mem_name
     , fn_pw_encode(mem_pass) as mem_pass
FROM member;

SELECT *
FROM ex_mem1 a
WHERE mem_id = 'a001'
AND mem_pass = fn_pw_encode(:pw)
;


UPDATE ex_mem1
SET mem_pass = fn_pw_encode(:pw)
WHERE mem_id = 'a001';










