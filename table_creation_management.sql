/* 테이블 생성과 관리 */
-- 테이블 생성(CREATE TABLE)
-- CREATE TABLE 테이블이름 (열이름 data_type(n) [DEFAULT]);
-- CREATE TABLE 테이블이름 AS SELECT~; (a.k.a CTAS)

-- 테이블 구조 변경(ALTER TABLE)
-- 열 추가: ALTER TABLE 테이블이름 ADD (열이름 data_type(n) [DEFAULT]); 
-- 열 수정: ALTER TABLE 테이블이름 MODIFY (열이름 data_type(n));
-- 열 삭제: ALTER TABLE 테이블이름 DROP COLUMN 열이름;
-- 열이름 변경: ALTER TABLE 테이블이름 RENAME COLUMN 기존열이름 TO 새열이름;
-- SET UNUSED: 나중에 삭제할 수 있도록 "사용되지 않았음"으로 표시. 삭제한 것처럼 인식
---- 해당 열은 USER_UNUSED_COL_TABS라는 딕셔너리 뷰에 저장 (SET USED는 존재X)
-- ALTER TABLE 테이블이름 SET UNUSED (열이름);
-- DROP UNUSED COLUMNS: "UNUSED"로 표시된 열 제거
-- ALTER TABLE 테이블이름 DROP UNUSED COLUMNS;

-- 객체(테이블) 이름 변경: RENAME 기존테이블이름 TO 새테이블이름;

-- 테이블 삭제(DROP TABLE)
-- DROP TABLE 테이블이름 [CASCADE CONSTRAINTS];
-- CASCADE CONSTRAINTS: 참조 제약조건이 있는 열을 포함하더라도 테이블 삭제

-- 테이블 데이터 비우기(TRUNCATE)
-- TRUNCATE TABLE 테이블이름;
-- 데이터는 삭제하지만 테이블 구조는 삭제되지 않음
---- DELETE         : 행데이터 삭제, 테이블구조 삭제X, 롤백 가능
---- TRUNCATE TABLE : 행데이터 삭제, 테이블구조 삭제X, 롤백 불가능
---- DROP TABLE     : 테이블구조(인덱스,제약조건,권한 등 포함) 삭제, 롤백 불가능

/* 연습문제 */
--1. member테이블: 사용자아이디(15), 이름(20), 비밀번호(20), 전화번호(15), 이메일(100)
CREATE TABLE member (
    user_id     varchar2(15)    NOT NULL,
    name        varchar2(20)    NOT NULL,
    password    varchar2(20)    NOT NULL,
    phone       varchar2(15),
    email       varchar2(100)
    );

--2. 사용자아이디, 이름, 비밀번호, 전화번호, 이메일 저장
-- user123, 사용자, a1234567890, 011-234-5678, user@user.com
INSERT INTO member 
    VALUES ('user123', '사용자', 'a1234567890', '011-234-5678', 'user@user.com');

--3. 사용자아이디가 user123인 사용자의 모든 정보 조회
SELECT * 
FROM member
WHERE user_id='user123';

--4. 사용자아이디가 user123인 사용자의 이름, 비밀번호, 전화번호, 이메일 수정
-- 홍길동, a1234, 011-222-3333, user@user.co.kr
UPDATE member 
SET name='홍길동', password='a1234', 
    phone='011-222-3333', email='user@user.co.kr'
WHERE user_id='user123';

--5. 사용자아이디가 user123이고 비밀번호가 a1234인 회원의 정보 삭제
DELETE FROM member
WHERE user_id='user123' and password='a1234';

--6. member테이블 모든 행 삭제 (TRUNCATE 이용)
TRUNCATE TABLE member;
SELECT * FROM member;

--7. member테이블 삭제
DROP TABLE member;