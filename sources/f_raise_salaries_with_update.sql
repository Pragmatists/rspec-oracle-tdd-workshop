CREATE OR REPLACE PROCEDURE hr.raise_salaries(
  p_percent INTEGER,
  p_department_name VARCHAR2 DEFAULT NULL
)
IS
  BEGIN
    UPDATE employees e
    SET salary = LEAST(
        salary * (1 + p_percent / 100),
        (SELECT j.max_salary
         FROM jobs j
         WHERE e.job_id = j.job_id)
    )
    WHERE p_department_name IS NULL
          OR e.department_id = (SELECT s.department_id
                                FROM departments s
                                WHERE s.department_name = p_department_name)
    ;
  END;