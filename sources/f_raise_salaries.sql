CREATE OR REPLACE PROCEDURE hr.raise_salaries(p_percent INTEGER, p_department_name VARCHAR2 DEFAULT NULL) IS
  BEGIN
    IF p_department_name IS NULL THEN
      UPDATE employees e
      SET salary = (SELECT least(e.salary * (1 + p_percent / 100), j.max_salary)
                    FROM hr.jobs j
                    WHERE j.job_id = e.job_id);
    ELSE
      UPDATE employees e
      SET salary = (SELECT least(e.salary * (1 + p_percent / 100), j.max_salary)
                    FROM hr.jobs j
                    WHERE j.job_id = e.job_id)
      WHERE e.department_id = (SELECT d.department_id FROM hr.departments d WHERE d.department_name = p_department_name);
    END IF;
  END;