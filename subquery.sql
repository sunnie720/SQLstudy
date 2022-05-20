/* 서브쿼리 */
-- 다른 SELECT 문장의 절에 내장된 SELECT 문장
-- 서브쿼리가 SELECT 절에 사용되면, 스칼라(Scalar)서브쿼리
-- 서브쿼리가 FROM 절에 있으면, 인라인 뷰(Inline view)
-- 서브쿼리가 WHERE 절에 있으면, 중첩(Nested)서브쿼리
-- 중첩 서브쿼리 중에서 참조하는 테이블이 부모/자식 관계를 가지면, 상호연관 서브쿼리

-- Nancy의 급여보다 급여를 많이 받는 사원이름, 급여 (Nancy의 급여는 얼마?를 먼저 알아야함)
select first_name, salary
from employees
where salary > (SELECT salary
                FROM employees
                WHERE first_name='Nancy');

-- 단일행 서브쿼리
-- 서브쿼리 결과가 하나의 행 ('=', '>=' 등 단일행 연산자 사용)
-- 103번 사원의 직무와 같은 사원의 이름과 직무, 입사일
select first_name, job_id, hire_date
from employees
where job_id=(SELECT job_id
              FROM employees
              WHERE employee_id=103);

-- 다중행 서브쿼리
-- 서브쿼리의 결과가 2개 행 이상 (IN, EXISTS, ANY, SOME, ALL 등 다중행 연산자 사용)
-- David 사원의 급여보다 급여를 많이 받는 사원이름, 급여
-- David 사원이 여러명임 (다중행 반환)
select first_name, department_id, salary
from employees
where first_name='David'; -- 3개 행
-- 어떤(ANY) David를 골라도 그 David보다 급여를 많이 받는 사원이름, 급여 (David 최솟값과 비교)
select first_name, salary
from employees
where salary > ANY (SELECT salary
                    FROM employees
                    WHERE first_name='David');
-- 모든(ALL) David보다도 급여를 많이 받는 사원이름, 급여 (David 최댓값과 비교)
select first_name, salary
from employees
where salary > ANY (SELECT salary
                    FROM employees
                    WHERE first_name='David');
-- IN 연산자
-- David와 같은 부서
SELECT first_name, department_id, job_id
FROM employees
WHERE department_id IN (SELECT department_id
                        FROM employees
                        WHERE first_name='David');
-- EXISTS 연산자
SELECT first_name, department_id, job_id
FROM employees e
WHERE EXISTS (SELECT *
              FROM departments d
              WHERE d.manager_id=e.employee_id);

-- 상호연관 서브쿼리
-- 서브쿼리가 메인쿼리의 값을 이용하고, 그렇게 구해진 서브쿼리의 값을 다시 메인쿼리가 이용
-- 자신이 속한 부서의 평균보다 많은 급여를 받는 사원의 이름과 급여
-- 메인쿼리의 테이블을 서브쿼리에서 사용
SELECT first_name, salary
FROM employees a
WHERE salary > (SELECT avg(salary)
                FROM employees b
                WHERE b.department_id=a.department_id);

-- 스칼라 서브쿼리(SELECT 절에 사용하는 서브쿼리)
-- 모든 사원이름, 부서이름 (Join 보다 성능 좋음)
SELECT first_name, (SELECT department_name
                    FROM departments d
                    WHERE d.department_id=e.department_id) department_name
FROM employees e
ORDER BY first_name;
SELECT first_name, department_name
FROM employees e
JOIN departments d ON (e.department_id=d.department_id)
ORDER BY first_name;

-- 인라인뷰 (FROM 절에 서브쿼리)
-- 급여를 가장 많이 받는 사람부터 상위 10명의 사원 이름과 급여
-- 인라인뷰+분석함수
SELECT row_number, first_name, salary
FROM (SELECT first_name, salary,
      row_number() OVER (ORDER BY salary DESC) as row_number
      FROM employees)
WHERE row_number BETWEEN 1 AND 10;
-- ROWNUM 의사열 이용
SELECT rownum, first_name, salary
FROM (SELECT first_name, salary
      FROM employees
      ORDER BY salary DESC)
WHERE rownum<=10;
-- 단, ROWNUM은 첫행부터 조회가 되어야만 하므로 상위 11~20위는 조회 불가
SELECT rownum, first_name, salary
FROM (SELECT first_name, salary
      FROM employees
      ORDER BY salary DESC)
WHERE rownum BETWEEN 11 AND 20; -- 아무것도 출력되지 않음
-- 3중쿼리(인라인뷰+ROWNUM 의사열) 사용 ★★★
-- ROWNUM을 포함한 행을 그대로 인라인뷰로 사용해서 ROWNUM 조회
SELECT rnum, first_name, salary
FROM (SELECT first_name, salary, rownum as rnum
      FROM (SELECT first_name, salary
            FROM employees
            ORDER BY salary DESC)
      )
WHERE rnum BETWEEN 11 AND 20;
-- 인라인뷰+분석함수
SELECT row_number, first_name, salary
FROM (SELECT first_name, salary,
      row_number() OVER (ORDER BY salary DESC) as row_number
      FROM employees)
WHERE row_number BETWEEN 11 AND 20;

-- 계층형 쿼리★★★
-- 수직적 관계를 맺고 있는 행들의 계층형 정보를 조회 (계급구조, BOM 등)
-- 직원 계급구조 확인
SELECT employee_id,
       LPAD(' ', 3*(LEVEL-1)) || first_name || ' ' || last_name,
       LEVEL -- 의사(Pseudo) 열
FROM employees
START WITH manager_id IS NULL  -- 레벨1 시작 (가장 상위 계급)
CONNECT BY PRIOR employee_id=manager_id  -- 레벨1 사원번호가 = 매니저번호로 연결
ORDER SIBLINGS BY first_name;
-- 113번 사원의 사원-매니저 관계도 (역순)
SELECT employee_id,
       LPAD(' ', 3*(LEVEL-1)) || first_name || ' ' || last_name,
       LEVEL
FROM employees
START WITH employee_id=113
CONNECT BY PRIOR manager_id=employee_id; -- 레벨1 매니저번호가 = 사원번호로 연결








