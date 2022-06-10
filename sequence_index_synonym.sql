--1. 게시판의 게시글 번호를 위한 시퀀스
---- 조건1) 시퀀스 이름: BBS_SEQ
---- 조건2) 게시글 번호는 1씩 증가
---- 조건3) 시퀀스는 1부터 시작하며 최대값을 설정하지 않음
---- 조건4) 캐쉬 개수는 20개, 사이클은 허용치 않음
CREATE SEQUENCE bbs_seq
    INCREMENT BY 1
    START WITH 1
    CACHE 20
    NOCYCLE;
    
--2. 사원의 급여 지급액으로 검색
---- 연봉으로 인덱스 생성 idx_emp_realsal
CREATE INDEX idx_emp_realsal
ON emps(COALESCE(salary+salary*commission_pct,salary));