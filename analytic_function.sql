/* 5. 분석 함수 */
-- 그룹 단위로 값을 계산한다는 점에서 그룹 함수와 유사하지만,
-- 행마다 1개의 결과 행을 반환한다는 점에서 차이
-- 윈도우(window): 분석함수에서의 그룹
-- 분석함수는 SELECT 절과 ORDER BY 절에만 사용할 수 있음

-- 순위 구하기 함수 - RANK, DENSE_RANK, ROW_NUMBER
-- RANK: 해당 값에 대한 순위 (중복순위 계산. 2등 2명이면 다음은 4등)
-- DENSE_RANK: 해당 값에 대한 순위 (중복순위 계산 안함)
-- ROW_NUMBER: 조건을 만족하는 모든 행의 일련번호 생성
-- 급여가 큰 사원부터 이름, 급여, 순위 출력
select employee_id, department_id, salary,
    RANK()          OVER (ORDER BY salary desc) sal_rank,
    DENSE_RANK()    OVER (ORDER BY salary desc) sal_dense_rank,
    ROW_NUMBER()    OVER (ORDER BY salary desc) sal_number
from employees;

-- 가상순위와 분포(최대값1일 때 상대적 위치) - CUME_DIST, PERCENT_RANK
-- CUME_DIST(상대적 위치): 첫번째 행 1/N, 두번째 행 2/N, 세번째 행 3/N, ...
-- PERCENT_RANK(백분율 순위): 첫번째 행 0, 두번째 행 1/N-1, 세번째 행 2/N-1, ...
-- 급여순 사원 아이디, 부서번호, 급여정보. 급여의 상대적 위치와 백분율 순위
select employee_id, department_id, salary,
    CUME_DIST()     OVER (ORDER BY salary desc) sal_cume_dist,
    PERCENT_RANK()  OVER (ORDER BY salary desc) sal_pct_rank
from employees;
-- COMMISSION_PCT 열의 누적분포
select employee_id, department_id, salary,
    CUME_DIST()     OVER (ORDER BY commission_pct desc) comm_cume_dist,
    PERCENT_RANK()  OVER (ORDER BY commission_pct desc) comm_pct_rank
from employees; -- 1~n행 값 같은 경우 CUME_DIST는 모두 n/N값, PCT_RANK는 모두 0

-- 비율 함수 - RATIO_TO_REPORT
-- 그룹 내에서 해당 값의 백분율을 소수점으로 제공 (0<반환값<=1)
-- IT_PROG인 사원들을 대상으로 부서내 전체 급여에서 본인이 차지하는 비율
select first_name, salary,
    round(RATIO_TO_REPORT(salary) OVER (), 4) as salary_ratio
from employees
where job_id='IT_PROG';

-- 분석함수가 행마다 한 개의 결과를 반환한다는 의미 확인
select department_id,
    round(AVG(salary) OVER (PARTITION BY department_id), 2)
from employees;  -- 107행 (부서별 급여 평균을 구하고 각 행마다 각 부서 대응값 반환)
select department_id, round(AVG(salary), 2)
from employees
GROUP BY department_id; -- 12행

-- 분배함수 - NTILE
-- 전체 데이터 분포를 n개의 구간으로 나누어 표시
-- 부서번호가 50인 사원들(45명)을 10구간으로 나누어 표시
select employee_id, department_id, salary,
    NTILE(10) OVER (ORDER BY salary desc) sal_quart_tile
from employees
where department_id=50; -- 구간1~5까지는 5명, 구간6~10은 4명

-- LAG(열,n[,0]): 윈도우의 이전 n번째 행의 값 가져오기. 없으면 0 출력
-- LEAD(열,n[,1]): 윈도우의 이후 n번째 행의 값 가져오기. 없으면 1 출력
-- 모든 사원 본인 급여 순위 한 단계 이전과 이후 순위 급여 출력
select employee_id, salary,
    LAG(salary,1,0) OVER (ORDER BY salary) as lower_sal,
    LEAD(salary,1,0) OVER (ORDER BY salary) as higher_sal
from employees
order by salary;

-- LISTAGG(expr, 'delimiter') WITHIN GROUP(ORDER BY 열)
-- 표현식을 '구분자'로 연결해서 여러 행을 하나의 행으로 변환
-- WITHIN GROUP절은 합쳐진 한 행 안에서의 순서 (생략 가능)
-- 부서별 사원의 이름
select department_id, first_name
from employees
group by deparment_id; -- first_name이 group by에 명시되지 않고 select절에 와서 오류
select department_id, 
    LISTAGG(first_name,',') WITHIN GROUP(ORDER BY hire_date) as names
from employees
GROUP BY department_id; -- first_name을 집계함수처럼 한 행으로 합쳐주면 가능 
-- order by 없어도 department_id로 정렬됨

-- 윈도우 절
-- 파티션으로 분할된 그룹에 대해 다시 그룹을 만드는 역할
-- 분석 함수를 적용할 구간을 만들 때 사용
-- 윈도우 절 생략 시 윈도우 하한은 현재 행
-- ROWS BETWEEN n PRECEDING AND m FOLLOWING 
-- 이전 n개 행부터 이후 m개 행까지가 윈도우!

-- FIRST_VALUE: 현재값보다 적은값 or 직전값 구하기
-- LAST_VALUE: 현재값보다 큰값 or 다음값 구하기
-- 급여와 급여의 1행 직전값, 1행 직후값 출력 (윈도우: 1직전~1직후)
select employee_id,
  FIRST_VALUE(salary) 
    OVER (ORDER BY salary ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) lower_sal,
  salary as my_sal,
  LAST_VALUE(salary)
    OVER (ORDER BY salary ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) higher_sal
from employees;
-- 급여와 급여의 1행 직전값, 2행 직후값 출력 (1직전~2직후)
select employee_id,
  FIRST_VALUE(salary) 
    OVER (ORDER BY salary ROWS BETWEEN 1 PRECEDING AND 2 FOLLOWING) lower_sal,
  salary as my_sal,
  LAST_VALUE(salary)
    OVER (ORDER BY salary ROWS BETWEEN 1 PRECEDING AND 2 FOLLOWING) higher_sal
from employees;
-- 급여와 급여의 1행 직전값, 2행 직후값 출력 (1직전~2직후)
select employee_id,
  FIRST_VALUE(salary) 
    OVER (ORDER BY salary ROWS 1 PRECEDING) lower_sal,
  salary as my_sal,
  LAST_VALUE(salary)
    OVER (ORDER BY salary ROWS BETWEEN 1 PRECEDING AND 2 FOLLOWING) higher_sal
from employees;

-- 선형회귀 함수
-- REGR_AVGX(y,x): x의 평균 (x,y 모두 not null인 값만 사용) 
-- REGR_AVGY(y,x): y의 평균 (x,y 모두 not null인 값만 사용) 
-- SALARY를 독립 변수, COMMISSION_PCT를 종속 변수로 
select 
    avg(salary), -- 모든 사원의 평균 급여
    REGR_AVGX(commission_pct, salary) -- 보너스를 받는 사람의 평균 급여
from employees;
-- 보너스를 받는 사람의 평균 급여는 아래와 동일
select avg(salary)
from employees
where commission_pct IS NOT NULL;

-- REGR_COUNT(y,x): y,x가 모두 NOT NULL인 쌍의 개수
-- 부서별 manager_id와 department_id가 모두 NOT NULL인 행의 수
select distinct department_id,
    REGR_COUNT(manager_id, department_id) 
      OVER (PARTITION BY department_id) as "regr_count"
from employees
order by department_id; -- (90) 개수 2, (null) 개수 0
-- 비교) 부서별 사원 수
select department_id, count(*)
from employees
group by department_id
order by department_id; -- (90) 개수 3, (null) 개수 1

-- REGR_SLOPE(y,x): 회귀 직선의 기울기 (=모공분산/모분산)
-- REGR_INTERCEPT(y,x): 회귀 직선의 y절편 (= AVG(y) - 기울기*AVG(x))
-- 세일즈부서 사원들의 근무일에 따른 급여의 직무별 기울기와 편향(bias; y절편)
-- (근무일(IV)에 따른 급여(DV), 직무별(PARTITION) 기울기) 
select 
    job_id, employee_id, salary, 
    round(SYSDATE-hire_date) "WORKING_DAY",
    round(REGR_SLOPE(salary, SYSDATE-hire_date) 
      OVER (PARTITION BY job_id), 2) "REGR_SLOPE",
    round(REGR_INTERCEPT(salary, SYSDATE-hire_date) 
      OVER (PARTITION BY job_id), 2) "REGR_INTERCEPT"
from employees
where department_id=80 -- 세일즈 부서
order by job_id, employee_id desc;

-- REGR_R2(y,x): 회귀분석에 관한 결정계수 
-- 세일즈부서 사원들의 근무일에 따른 급여의 직무별 기울기, y 절편, 결정계수
select 
    job_id, employee_id, salary, 
    round(SYSDATE-hire_date) "WORKING_DAY",
    round(REGR_SLOPE(salary, SYSDATE-hire_date) 
      OVER (PARTITION BY job_id), 2) "REGR_SLOPE",
    round(REGR_INTERCEPT(salary, SYSDATE-hire_date) 
      OVER (PARTITION BY job_id), 2) "REGR_INTERCEPT",
    round(REGR_R2(salary, SYSDATE-hire_date) 
      OVER (PARTITION BY job_id), 2) "REGR_R2"
from employees
where department_id=80; -- 세일즈 부서

-- 피벗 테이블
-- 사원들의 주별, 일별 판매 실적
-- 관계형 데이터베이스 형식: 아래 방향으로 추가 (행 추가)
drop table sales_data;
CREATE TABLE sales_data(
    employee_id NUMBER(6),
    week_id     NUMBER(2),
    week_day    VARCHAR2(10),
    sales       NUMBER(8,2)
);
INSERT INTO sales_data values(1101, 4, 'SALES_MON', 100);
INSERT INTO sales_data values(1101, 4, 'SALES_TUE', 150);
INSERT INTO sales_data values(1101, 4, 'SALES_WED', 80);
INSERT INTO sales_data values(1101, 4, 'SALES_THU', 60);
INSERT INTO sales_data values(1101, 4, 'SALES_FRI', 120);
INSERT INTO sales_data values(1102, 5, 'SALES_MON', 300);
INSERT INTO sales_data values(1102, 5, 'SALES_TUE', 300);
INSERT INTO sales_data values(1102, 5, 'SALES_WED', 230);
INSERT INTO sales_data values(1102, 5, 'SALES_THU', 120);
INSERT INTO sales_data values(1102, 5, 'SALES_FRI', 150);
SELECT * FROM sales_data;
-- 스프레드시트(피벗 테이블; 크로스탭 리포트) 형식: 오른쪽 방향으로 추가 (열 추가)
-- 알아보기는 편하지만 분석하기는 어려움 
-- DECODE 함수 포함 복잡, 비직관적 코드를 작성하지 않고 간단히 PIVOT 함수 이용

-- PIVOT 
-- week_day를 펼쳐서 보겠다
select * 
from sales_data
PIVOT
(
  sum(sales)
  FOR week_day IN('SALES_MON' as sales_mon, 
                  'SALES_TUE' as sales_tue,
                  'SALES_WED' as sales_wed,
                  'SALES_THU' as sales_thu,
                  'SALES_FRI' as sales_fri)
) -- 열별칭 지정 안하면 열헤딩에 홑따옴표 그대로 출력됨
order by employee_id, week_id;
-- 인덱스(e.g. week_id) 일부 제외하고 집계하려면 1) 뷰(view) 사용
CREATE OR REPLACE VIEW sales_data_view AS
    select employee_id, week_day, sales  -- week_id 제외
    from sales_data;
select * 
from sales_data_view  -- 뷰
PIVOT
(
  sum(sales)
  FOR week_day IN('SALES_MON' as sales_mon, 
                  'SALES_TUE' as sales_tue,
                  'SALES_WED' as sales_wed,
                  'SALES_THU' as sales_thu,
                  'SALES_FRI' as sales_fri)
)
order by employee_id;
-- 인덱스(e.g. week_id) 일부 제외하고 집계하려면 1) WITH 절 사용
WITH temp AS (
    select employee_id, week_day, sales  -- week_id 제외
    from sales_data 
)
select * 
from temp  -- temp 테이블
PIVOT
(
  sum(sales)
  FOR week_day IN('SALES_MON' as sales_mon, 
                  'SALES_TUE' as sales_tue,
                  'SALES_WED' as sales_wed,
                  'SALES_THU' as sales_thu,
                  'SALES_FRI' as sales_fri)
)
order by employee_id;

-- UNPIVOT
select employee_id, week_id, week_day, sales
from sales
UNPIVOT 
(
  sales
  FOR week_day
  IN(sales_mon, sales_tue, sales_wed, sales_thu, sales_fri)
);





    






