/* 제약조건(Constraints) */
-- 테이블의 해당 열에 사용자가 원치 않은 데이터가 입력, 수정, 삭제되는 것을 방지하기 위한 조건
-- NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY, CHECK
-- 테이블에 정의된 제약조건 확인: USER_CONSTRAINTS 데이터 딕셔너리
---- SELECT * FROM USER_CONSTRAINTS;

-- 제약조건 정의
-- 테이블 레벨 제약조건, 열 레벨 제약조건
-- CREATE TABLE 테이블이름 (열이름 data_type [DEFAULT] [열제약조건], [테이블제약조건]);
-- 열 레벨 제약조건
-- ... (열이름 data_type [DEFAULT] CONSTRAINT 제약조건명 constraint_type);
-- 테이블 레벨 제약조건
-- ... CONSTRAINT 테이블제약조건명 constraint_type (열이름);

-- 제약조건 관리
-- 제약조건 추가
-- ALTER TABLE 테이블이름 ADD CONSTRAINT 제약조건이름 constraint_type (열이름);
-- 제약조건 조회
-- USER_CONSTRAINTS 데이터 딕셔너리 뷰 확인  또는
-- USER_CONSTRAINTS 테이블 질의
---- SELECT constraint_name, constraint_type, status 
---- FROM USER_CONSTRAINTS WHERE table_name='테이블이름';
---- SELECT * FROM USER_CONSTRAINTS;
-- 제약조건 비활성화
-- ALTER TABLE 테이블이름 DISABLE [NOVALIDATE | VALIDATE] CONSTRAINT 제약조건명 [CASCADE];
---- DISABLE NOVALIDATE: 기본값. 해당 열의 제약조건만 사용X
---- DISABLE VALIDATE: 테이블의 데이터 수정(INSERT,UPDATE,DELETE)금지
-- 제약조건 활성화
-- ALTER TABLE 테이블이름 ENABLE [NOVALIDATE | VALIDATE] CONSTRAINT 제약조건명;
---- DISABLE NOVALIDATE: 이미 저장한 데이터는 제약조건 체크X
---- DISABLE VALIDATE: 기본값. 이미 저장한 데이터도 제약조건 체크 (만족 못하면 제약조건 활성화 불가)

/* 연습문제 */
--1. member 테이블 생성 -> 사용자 아이디가 PK
-- 사용자 아이디(15), 이름(20), 비밀번호(20), 전화번호(15), 이메일(100)
CREATE TABLE member (
    user_id     varchar2(15)    PRIMARY KEY,
    name        varchar2(20)    NOT NULL,
    password    varchar2(20)    NOT NULL,
    phone       varchar2(15),
    email       varchar2(100)
    );
DROP TABLE member;
-- 또는
CREATE TABLE member (
    user_id     varchar2(15)    NOT NULL,
    name        varchar2(20)    NOT NULL,
    password    varchar2(20)    NOT NULL,
    phone       varchar2(15),
    email       varchar2(100)
    );
ALTER TABLE member
ADD CONSTRAINTS member_userid_pk PRIMARY KEY (user_id);
DROP TABLE member;

--2. 테이블 생성 및 제약조건 추가
-- DEPT 테이블의 DEPTNO열은 주키(PRIMARY KEY) 열. 제약조건 이름: pk_dept
-- EMP 테이블의 EMPNO열은 주키(PRIMARY KEY) 열. 제약조건 이름: pk_emp
-- EMP 테이블의 DEPTNO열은 DEPT 테이블의 DEPTNO열 참조하는 외래키. 제약조건 이름: fk_deptno
CREATE TABLE dept (
    deptno  number(2),
    dname   varchar2(14),
    loc     varchar2(13),
    CONSTRAINT pk_dept PRIMARY KEY(deptno)
);
CREATE TABLE emp (
    empno   number(4,0),
    ename   varchar2(10),
    job     varchar2(9),
    mgr     number(4,0),
    hiredate    date,
    sal     number(7,2),
    comm    number(7,2),
    deptno  number(2,0),
    CONSTRAINT pk_emp PRIMARY KEY(empno),
    CONSTRAINT fk_deptno FOREIGN KEY(deptno) REFERENCES dept(deptno)
);
