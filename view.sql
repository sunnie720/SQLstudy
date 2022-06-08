/* 뷰 */
-- 뷰 정보 확인
SELECT * FROM USER_VIEWS;

-- 뷰 생성 권한
-- 현재 사용자에게 주어진 권한 및 ROLE 확인
SELECT * FROM USER_SYS_PRIVS; 
SELECT * FROM USER_ROLE_PRIVS;
-- hr 사용자에게 뷰 생성 권한 부여: GRANT CREATE VIEW TO hr

-- 뷰 생성
-- CREATE VIEW 문장 내에서 서브쿼리(조인,그룹,서브쿼리 포함 가능)로 작성
-- [WITH CHECK OPTION]: 뷰의 제약조건에 의해 엑세스 가능한 행만 DML 가능함 명시
-- [WITH READ ONLY]: 뷰를 통한 DML 작업이 불가능함 명시
-- 60번 부서의 모든 사원에 대한 세부사항을 포함하는 뷰
CREATE OR REPLACE VIEW emp_view_dept60 
AS SELECT employee_id, first_name, last_name, job_id, salary
   FROM employees
   WHERE department_id=60;
DESC emp_view_dept60; 
SELECT * FROM emp_view_dept60;
DROP VIEW emp_view_dept60;
-- 뷰의 열을 특정 이름으로: 1) SELECT 절에 열별칭 사용 2) CREATE VIEW 절에 열이름 포함
CREATE OR REPLACE VIEW emp_dept60_salary
AS SELECT employee_id AS empno,
          first_name||' '||last_name AS name,
          salary AS monthly_salary
   FROM employees
   WHERE department_id=60;
DESC emp_dept60_salary;
DROP VIEW emp_dept60_salary;
CREATE VIEW emp_dept60_salary (empno, name, monthly_salary)
AS SELECT employee_id, first_name||' '||last_name, salary
   FROM employees
   WHERE department_id=60;
DESC emp_dept60_salary;

-- 뷰 질의
-- 뷰 질의 시 오라클 서버 작업 단계
-- 1) USER_VIEWS 데이터 사전 테이블에서 뷰 정의 검색
-- 2) 기반 테이블에 대한 액세스 권한 확인
-- 3) 데이터를 기본 테이블에서 검색 또는 기본 테이블의 데이터에 갱신
SELECT * FROM USER_VIEWS;

-- 뷰 수정
-- CREATE OR REPLACE VIEW 절 사용
CREATE OR REPLACE VIEW emp_dept60_salary
AS SELECT employee_id AS empno,
          first_name || ' ' || last_name AS name,
          job_id AS job, -- 기존 뷰에서 job 추가
          salary
FROM employees
WHERE department_id=60;
DESC emp_dept60_salary;

-- 복합 뷰 생성
-- 복합 뷰: 두 개 이상 테이블로부터 값을 디스플레이 하는 뷰, DML 불가능
-- 모든 사원의 아이디, 이름, 부서이름, 직무이름 뷰 (DEPARTMENTS, JOBS 테이블 조인)
CREATE VIEW emp_view
AS SELECT employee_id id, 
          first_name name, 
          department_name department, 
          job_title job
FROM employees e
LEFT JOIN departments d ON e.department_id=d.department_id
LEFT JOIN jobs j ON e.job_id=j.job_id;
SELECT * FROM emp_view;
-- hr 스키마에 이미 저장되어 있는 대표적은 복합 뷰
SELECT * FROM emp_details_view;

-- 뷰 삭제
DROP VIEW emp_dept60_salary;

-- 뷰를 이용한 DML 연산
-- 실행 규칙
-- 1) 단순 뷰에서 DML 연산을 수행할 수 있음
-- 2) 행 제거 불가능 조건: 뷰에 그룹함수, GROUP BY절, DISTINCT 포함
-- 3) 행 수정 불가능 조건: 뷰에 위 2)조건, 표현식으로 정의된 열, ROWNUM 의사열 포함
-- 4) 행 추가 불가능 조건: 뷰에 위 3)조건 포함, 뷰에 선택하지 않은 NN열이 기본테이블에 존재
DROP TABLE emps;
CREATE TABLE emps -- 실습용 테이블 생성
AS SELECT * FROM employees;

-- DML 가능한 뷰
CREATE OR REPLACE VIEW emp_dept60
AS SELECT * FROM emps WHERE department_id=60;
-- 뷰를 통해 기본 테이블 emps에서 104번 사원 정보 삭제
DELETE FROM emp_dept60 WHERE employee_id=104;
-- 기본 테이블 emps에서 104번 사원 정보 확인 -- no row selected
SELECT * FROM emps WHERE employee_id=104;

-- 행 제거 불가능한 뷰
CREATE OR REPLACE VIEW emp_dept60
AS SELECT DISTINCT * FROM emps WHERE department_id=60;
-- 뷰를 통해 기본 테이블 emps에서 106번 사원 정보 삭제 시도 -- 오류
DELETE FROM emp_dept60 WHERE employee_id=106; 

-- 행 수정 불가능한 뷰
CREATE OR REPLACE VIEW emp_dept60
AS SELECT
        employee_id,
        first_name || ', ' || last_name AS name, 
        salary*12 AS annual_salary -- 표현식
    FROM emps WHERE department_id=60;
-- 106번 사원 정보 수정 시도 -- 오류
UPDATE emp_dept60 SET annual_salary=annual_salary*1.1
WHERE employee_id=106;
-- 수정할 수 없어도 제거는 가능
DELETE FROM emp_dept60 WHERE employee_id=106;

-- 행 추가 불가능한 뷰
CREATE OR REPLACE VIEW emp_dept60 
AS SELECT employee_id, first_name, last_name, email, salary 
   FROM emps WHERE department_id=60;
DESC emp_dept60;
-- hire_date, job_id는 NN열이지만 선택되지 않음
DESC emps;
-- hire_date, job_id열은 null 불가이므로 뷰를 통해 추가하려고 하면 에러
INSERT INTO emp_dept60
    VALUES (500, 'JinKyoung', 'Heo', 'HEOJK', 8000);

-- WITH CHECK OPTION
-- 무결성 제약조건과 데이터 검증 체크 허용
-- 즉, 뷰를 가지고 검색할 수 없는 행 삽입 또는 갱신을 허용하지 않음
CREATE OR REPLACE VIEW emp_dept60
AS SELECT employee_id, first_name, hire_date, salary, department_id
   FROM emps
   WHERE department_id=60
WITH CHECK OPTION;
-- 105번 사원의 부서를 10으로 변경 시도 -- 에러
---- 부서번호 10번으로 바뀌면 뷰가 더이상 원래 뷰에 있던 사원정보 볼 수 없음. 따라서 불허
UPDATE emp_dept60
SET department_id=10 
WHERE employee_id=105;

-- WITH READ ONLY
-- DML 연산 수행될 수 없도록 명시
CREATE OR REPLACE VIEW emp_dept60
AS SELECT employee_id, first_name, hire_date, salary, department_id
   FROM emps
   WHERE department_id=60
WITH READ ONLY;
select * from emp_dept60;
-- 뷰에서 행 제거하려고 하면 에러
DELETE FROM emp_dept60
WHERE employee_id=105;

-- 인라인 뷰
-- FROM 절에 서브쿼리가 온 것
-- SQL 구문에서 사용 가능한 별칭(상관 이름)을 사용하는 서브쿼리
-- 급여를 가장 많이 받는 사람부터 상위 10명 사원의 이름과 급여 출력
SELECT row_number, first_name, salary
FROM (SELECT first_name, salary,
             ROW_NUMBER() OVER (ORDER BY salary DESC) row_number
      FROM employees) 
WHERE row_number<=10;