/* 트랜잭션(Transaction) */
-- 논리적인 작업 단위이며, 분리되면 안됨
-- COMMIT, ROLLBACK에 의해서 명시적으로 종료하거나, DDL이나 DCL 문장으로 자동 커밋
-- SAVEPOINT로 중간 ROLLBACK할 지점 저장 가능

-- SAVEPOINT & ROLLBACK
-- 단, 세이브포인트로 롤백 되었다고 해서 그 지점까지 커밋되는 것은 아님
-- emps 테이블에서 10번 부서 사원 정보 삭제
DELETE FROM emps WHERE department_id=10;
-- 롤백 지점 생성 (10번 사원 삭제됨)
SAVEPOINT delete_10;
-- 20번 부서 사원 정보 삭제
DELETE FROM emps WHERE department_id=20;
-- 롤백 지점 생성 (10번,20번 사원 삭제됨)
SAVEPOINT delete_20;
-- 30번 부서 사원 정보 삭제
DELETE FROM emps WHERE department_id=30;
SELECT * FROM emps WHERE department_id=30; -- 삭제되어 정보 없음
-- 30번 부서 사원 정보 삭제 취소
ROLLBACK TO SAVEPOINT delete_20;
SELECT * FROM emps WHERE department_id=30; -- 삭제취소되어 정보 나타남

-- LOCK
-- 읽기 일관성
-- 각각의 사용자가 DML 작업을 시작하기 전에, 마지막 커밋 시에 저장된 데이터를 알 수 있도록 보증
-- 다중세션에서 같은 시간에 동일한 데이터를 변경하는 것을 방지
-- 최고레벨 데이터 동시성 제어 모드: LOCK TABLE table_name IN EXCLUSIVE MODE

-- DML과 LOCK
DROP TABLE emp;
CREATE TABLE emp AS
SELECT employee_id AS empno, first_name AS ename,
salary AS sal, department_id AS deptno
FROM employees;









