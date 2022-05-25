/* DML(Data Manipulation Language) */

-- DML 실행
-- 1)테이블에 새로운 행을 추가할 때 - INSERT
-- 2)기존의 행을 변경할 때 -- UPDATE
-- 3)기존의 행을 제거할 때 -- DELETE
-- 완전한 트랜젝션 커밋이 보장되어야 함

-- CTAS(CREATE TABLE AS SELECT)
-- 선택한 테이블과 구조가 같은 테이블 생성. 단, NOT NULL을 제외한 제약조건은 복사X
DROP TABLE emp1;
CREATE TABLE emp1 AS SELECT * FROM employees;
SELECT COUNT(*) FROM emp1; -- 107
-- SELECT 서브쿼리지만 괄호() 포함하지 않음. WHERE절이 FALSE일 때는 구조만 복사
DROP TABLE emp2 IF EXISTS;
CREATE TABLE emp2 AS SELECT * FROM employees WHERE 1=2;
SELECT COUNT(*) FROM emp2; -- 0

-- INSERT 기본
-- INSERT 절 하나당 하나의 행 추가
-- 컬럼별 데이터타입을 맞춰서 입력해야 함
-- 테이블 구조 확인:
DESC departments;  -- department_id, department_name, managr_id, location_id
INSERT INTO departments 
VALUES (280, 'Data Analytics', null, 1700);
SELECT * FROM departments WHERE department_id=280;
INSERT INTO departments
    (department_id, department_name, location_id)
VALUES 
    (290, 'Data Analytics', 1700);
SELECT * FROM departments WHERE department_id>=280;
ROLLBACK; -- commit 안된 DML 실행취소

-- INSERT 서브쿼리로 다중 행 삽입
-- 여러개 행 추가 가능
DROP TABLE managers;
CREATE TABLE managers AS
SELECT employee_id, first_name, job_id, salary, hire_date
FROM employees
WHERE 1=2; -- 테이블 구조만 복사
-- EMPLOYEES 테이블로부터 SELECT 구문으로 조회한 결과를 MANAGERS 테이블에 삽입
INSERT INTO managers 
    (employee_id, first_name, job_id, salary, hire_date) -- 생략가능
    SELECT employee_id, first_name, job_id, salary, hire_date
    FROM employees
    WHERE job_id LIKE '%MAN'; -- 12개 행 삽입
SELECT * FROM managers;

-- UPDATE 기본
-- 기존의 행 갱신. 하나 이상의 행 갱신 가능
DROP TABLE emps;
CREATE TABLE emps AS SELECT * FROM employees; -- 새 테이블 생성
ALTER TABLE emps
ADD (CONSTRAINTS emps_emp_id_pk PRIMARY KEY (employee_id),
     CONSTRAINTS emps_manager_id_fk FOREIGN KEY (manager_id)
        REFERENCES emps(employee_id)
); -- 테이블 제약조건 추가
-- 103번 사원의 사원 아이디, 이름, 급여
SELECT employee_id, first_name, salary
FROM emps
WHERE employee_id=103;  -- 급여 9000
-- 업데이트: 103 사원의 급여를 10% 인상
UPDATE emps
SET salary=salary*1.1
WHERE employee_id=103;
-- 103 사원정보 다시 확인
SELECT employee_id, first_name, salary
FROM emps
WHERE employee_id=103;  -- 급여 9900
COMMIT; -- DML문 트랜젝션 명시적 종료

-- UPDATE 서브쿼리로 다중 열 갱신
-- 변경 전 데이터
SELECT employee_id, first_name, job_id, salary, manager_id
FROM emps
WHERE employee_id IN (108, 109);
-- 109번 사원의 직무, 급여, 매니저를 108번 사원과 동일하게 변경
UPDATE emps
SET (job_id, salary, manager_id) = (SELECT job_id, salary, manager_id
                                    FROM emps
                                    WHERE employee_id=108)
WHERE employee_id=109;
-- 변경 후 데이터
SELECT employee_id, first_name, job_id, salary, manager_id
FROM emps
WHERE employee_id IN (108, 109);

-- DELETE 기본
-- 테이블 삭제 시, 참조 무결성 제약조건에 주의
-- DELETE: 데이터만 삭제. rollback으로 실행취소 가능
-- TRUNCATE: 데이터만 삭제. rollback으로 실행취소 불가능
-- DROP: 데이터와 구조 모두 삭제. rollback으로 실행취소 불가능
SELECT * FROM emps 
WHERE employee_id=104;
-- 104번 사원 데이터 삭제
DELETE FROM emps 
WHERE employee_id=104;
-- 103번 사원 데이터 삭제 -- 오류: 무결성 제약조건 위반 
DELETE FROM emps 
WHERE employee_id=103; 
SELECT * FROM emps -- 103번 사원 아이디가 다른 사원의 매니저 아이디로 참조되고 있음
WHERE manager_id=103;

-- DELETE 서브쿼리로 다중 행 삭제
DROP TABLE depts;
CREATE TABLE depts AS
SELECT * FROM departments;
DESC depts;
-- emps 테이블에서 부서명이 Shipping인 모든 사원 정보를 삭제
DELETE from emps
WHERE department_id = (SELECT department_id
                       FROM depts
                       WHERE department_name='Shipping'
); -- 45개 행 삭제
COMMIT;

-- RETURNING
-- DML 구문에 의해 영향을 받는 행 검색
-- SQL Developer에서 실행하면 바인드 변수의 값을 입력하라는 창이 실행됨
-- 아래 구문은 SQL Command Line 또는 SQL Plus 이용해서 실행
-- VARIABLE emp_name VARCHAR2(50);
-- VARIABLE emp_sal NUMBER;
-- VARIABLE;
-- DELETE emps
-- WHERE employee_id=109
-- RETURNING first_name, salary INTO :emp_name, :emp_sal;
-- PRINT emp_name;
-- PRINT emp_sal;

-- MERGE
-- INSERT문과 UPDATE문 동시에 사용
CREATE TABLE emps_it AS SELECT * FROM employees WHERE 1=2; 
INSERT INTO emps_it
    (employee_id, first_name, last_name, email, hire_date, job_id)
VALUES
    (105, 'David', 'Kim', 'DAVIDKIM', '06/03/04', 'IT_PROG');
-- emps_it 테이블과 employees 테이블 병합
-- emps_it 테이블에 사원 아이디가 같은 사원이 
-- 있으면 기존 정보를 employees 테이블 내용으로 UPDATE / 없으면 INSERT
MERGE INTO emps_it a
    USING (SELECT * FROM employees WHERE job_id='IT_PROG') b -- 조인 개념
    ON (a.employee_id=b.employee_id)
WHEN MATCHED THEN
    UPDATE SET 
        a.phone_number = b.phone_number,
        a.hire_date = b.hire_date,
        a.job_id = b.job_id,
        a.salary = b.salary,
        a.commission_pct = b.commission_pct,
        a.manager_id = b.manager_id,
        a.department_id = b.department_id
WHEN NOT MATCHED THEN
    INSERT VALUES
    (b.employee_id, b.first_name, b.last_name, b.email,
     b.phone_number, b.hire_date, b.job_id, b.salary,
     b.commission_pct, b.manager_id, b.department_id);
SELECT * FROM emps_it;

-- Multiple INSERT
-- 하나의 INSERT 문으로 하나의 행을 여러 개의 테이블에 동시에 입력

-- UNCONDITIONAL INSERT ALL
-- 조건과 상관없이, 기술된 여러 개의 테이블에 데이터를 입력
-- 300번 사원 정보는 emp1에, 400번 사원 정보는 emp2에 저장
INSERT ALL
  INTO emp1
    VALUES (300, 'Kildong', 'Hong', 'KHONG', '011.624.7902',
            TO_DATE('2015-05-11', 'YYYY-MM-DD'), 'IT_PROG', 6000,
            null, 100, 90)
  INTO emp2
    VALUES (400, 'Kilseo', 'Hong', 'KSHONG', '011.3402.7902',
            TO_DATE('2015-06-20', 'YYYY-MM-DD'), 'IT_PROG', 5500,
            null, 100, 90)
  SELECT * FROM dual;
-- employees 테이블 데이터를 열 단위로 나누어 저장
CREATE TABLE emp_salary AS
  SELECT employee_id, first_name, salary, commission_pct
  FROM employees
  WHERE 1=2;
CREATE TABLE emp_hire_date AS
  SELECT employee_id, first_name, hire_date, department_id
  FROM employees
  WHERE 1=2;
INSERT ALL
  INTO emp_salary VALUES
    (employee_id, first_name, salary, commission_pct)
  INTO emp_hire_date VALUES
    (employee_id, first_name, hire_date, department_id)
  SELECT * FROM employees;

-- CONDITIONAL INSERT ALL
-- 특정 조건들을 기술하여 그 조건에 맞는 행들을 원하는 테이블에 나누어 삽입
CREATE TABLE emp_10 AS SELECT * FROM employees WHERE 1=2;
CREATE TABLE emp_20 AS SELECT * FROM employees WHERE 1=2;
-- 부서번호가 10인 사원은 EMP_10에 저장하고, 부서번호가 20인 사원은 EMP_20에 저장
INSERT ALL
  WHEN department_id=10 THEN
    INTO emp_10 VALUES
        (employee_id, first_name, last_name, email, phone_number,
        hire_date, job_id, salary, commission_pct, manager_id, department_id)
  WHEN department_id=20 THEN
    INTO emp_20 VALUES
        (employee_id, first_name, last_name, email, phone_number,
        hire_date, job_id, salary, commission_pct, manager_id, department_id)
  SELECT * FROM employees;
SELECT * FROM emp_10;
SELECT * FROM emp_20;

-- CONDITIONAL INSERT FIRST
-- 첫 번째 WHEN 절에서 조건을 만족할 경우 다음의 WHEN 절은 수행하지 않음
CREATE TABLE emp_sal5000 AS
  SELECT employee_id, first_name, salary FROM employees WHERE 1=2;
CREATE TABLE emp_sal10000 AS
  SELECT employee_id, first_name, salary FROM employees WHERE 1=2;
CREATE TABLE emp_sal15000 AS
  SELECT employee_id, first_name, salary FROM employees WHERE 1=2;  
CREATE TABLE emp_sal20000 AS
  SELECT employee_id, first_name, salary FROM employees WHERE 1=2;
CREATE TABLE emp_sal25000 AS
  SELECT employee_id, first_name, salary FROM employees WHERE 1=2;  
-- 급여 구간에 따라 각각 다른 테이블에 데이터를 나누어 저장
INSERT FIRST
  WHEN salary <= 5000 THEN
    INTO emp_sal5000 VALUES (employee_id, first_name, salary)
  WHEN salary <= 10000 THEN
    INTO emp_sal10000 VALUES (employee_id, first_name, salary)
  WHEN salary <= 15000 THEN
    INTO emp_sal15000 VALUES (employee_id, first_name, salary)
  WHEN salary <= 20000 THEN
    INTO emp_sal20000 VALUES (employee_id, first_name, salary)
  WHEN salary <= 25000 THEN
    INTO emp_sal25000 VALUES (employee_id, first_name, salary)
  SELECT employee_id, first_name, salary FROM employees;
SELECT COUNT(*) FROM emp_sal5000;  -- 49개
SELECT COUNT(*) FROM emp_sal10000; -- 43
SELECT COUNT(*) FROM emp_sal15000;  --12
SELECT COUNT(*) FROM emp_sal20000;  --2
SELECT COUNT(*) FROM emp_sal25000;  --1

-- PIVOTING INSERT
-- 여러 개의 into 절을 사용할 수 있지만, into 절 뒤에 오는 테이블은 모두 같아야 함
-- 비관계형 데이터베이스를 관계형 데이터베이스 구조로 만들 때 사용 
select * from sales;
-- sales 테이블의 데이터를 UNPIVOT 하여 저장하기 위한 테이블 생성
TRUNCATE TABLE sales_data;
select * from sales_data;
-- sales에 열 단위로 저장되어 있는 테이블의 데이터를 행단위로 저장
INSERT ALL
  INTO sales_data
    VALUES(employee_id, week_id, 'SALES_MON', sales_mon)
  INTO sales_data
    VALUES(employee_id, week_id, 'SALES_TUE', sales_tue)
  INTO sales_data
    VALUES(employee_id, week_id, 'SALES_WED', sales_wed)
  INTO sales_data
    VALUES(employee_id, week_id, 'SALES_THU', sales_thu)
  INTO sales_data
    VALUES(employee_id, week_id, 'SALES_FRI', sales_fri)
  SELECT employee_id, week_id, sales_mon, sales_tue, sales_wed, 
         sales_thu, sales_fri
  FROM sales;
