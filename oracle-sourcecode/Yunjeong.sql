/*       객체의 이름은 30byte(한글 1글자 3byte) 넘을 수 없음(제약조건 명칭도)
         객체의 이름은 유일해야함 (동일한 이름 올 수 없음)
         데이터 삽입 시 참조하고 있는 테이블이 있다면 해당 테이블에 참조하고 있는 데이터가 되어야 함
         
        강의내역, 과목, 교수, 수강내역, 학생 테이블을 만드시고 아래와 같은 제약 조건을 준 뒤 
        
        (6)'학생' 테이블의 PK를 '수강내역' 테이블의 '학번' 컬럼이 참조한다 FK 키 설정
        (7)'과목' 테이블의 PK를 '수강내역' 테이블의 '과목번호' 컬럼이 참조한다 FK 키 설정 
        (8)'교수' 테이블의 PK를 '강의내역' 테이블의 '교수번호' 컬럼이 참조한다 FK 키 설정
        (9)'과목' 테이블의 PK를 '강의내역' 테이블의 '과목번호' 컬럼이 참조한다 FK 키 설정
            각 테이블에 엑셀 데이터를 임포트 

    ex) ALTER TABLE 학생 ADD CONSTRAINT PK_학생_학번 PRIMARY KEY (학번);
        
        ALTER TABLE 수강내역 
        ADD CONSTRAINT FK_학생_학번 FOREIGN KEY(학번)
        REFERENCES 학생(학번);
        */
        
ALTER TABLE 학생 ADD CONSTRAINT pk_학생_학번 PRIMARY KEY(학번);
ALTER TABLE 수강내역 ADD CONSTRAINT PK_수강내역번호 PRIMARY KEY(수강내역번호);
ALTER TABLE 과목 ADD CONSTRAINT pk_과목번호 PRIMARY KEY(과목번호);
ALTER TABLE 교수 ADD CONSTRAINT pk_교수번호 PRIMARY KEY(교수번호);
ALTER TABLE 강의내역 ADD CONSTRAINT pk_강의내역 PRIMARY KEY(강의내역번호);

ALTER TABLE 수강내역 ADD CONSTRAINT fk_학번 FOREIGN KEY(학번) REFERENCES 학생(학번);
ALTER TABLE 수강내역 ADD CONSTRAINT fk_과목번호 FOREIGN KEY(과목번호) REFERENCES 과목(과목번호);
ALTER TABLE 강의내역 ADD CONSTRAINT fk_교수번호 FOREIGN KEY(교수번호) REFERENCES 교수(교수번호);
ALTER TABLE 강의내역 ADD CONSTRAINT fk_강의과목 FOREIGN KEY(과목번호) REFERENCES 과목(과목번호);















