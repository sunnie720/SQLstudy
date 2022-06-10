/* View 연습문제 */

--1. 직무별 급여 평균과 사원의 급여 차이를 구하는 뷰★
---- 열: 사원이름, 직무아이디, 직무별 급여평균(최대와 최소의 평균)과 사원급여의 차이
CREATE OR REPLACE VIEW sal_gap_view_by_job (name, job_id, sal_gap_by_job)
AS SELECT e.first_name, e.job_id,
          round(A.avg_job_sal-e.salary,0) AS sal_gap
   FROM employees e 
   LEFT JOIN (SELECT job_id, 
                    (max_salary+min_salary)/2 AS avg_job_sal
              FROM jobs) A 
        ON e.job_id=A.job_id;
SELECT * FROM sal_gap_view_by_job ORDER BY job_id;

--2. 모든 사원아이디, 이름, 부서이름, 직무이름 출력하는 뷰
CREATE OR REPLACE VIEW emps_view
AS SELECT e.employee_id, e.first_name, d.department_name, j.job_title
   FROM employees e
   LEFT JOIN departments d ON e.department_id=d.department_id
   LEFT JOIN jobs j ON e.job_id=j.job_id;
SELECT * FROM emps_view;

