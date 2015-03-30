CREATE OR REPLACE PACKAGE hr.emp IS
  FUNCTION calculate_salary(precEmp hr.employees%ROWTYPE, pnMaxSalary NUMBER, pnPercent NUMBER)
    RETURN hr.EMPLOYEES%ROWTYPE;

  PROCEDURE main(pnPercent NUMBER, pnDeptName VARCHAR2 DEFAULT NULL);

END;


CREATE OR REPLACE PACKAGE BODY hr.emp IS

  PROCEDURE main(pnPercent NUMBER, pnDeptName VARCHAR2 DEFAULT NULL)
  IS
    recEmp hr.EMPLOYEES%ROWTYPE;

    BEGIN
      FOR z IN (SELECT
                  e.salary,
                  j.max_salary,
                  e.EMPLOYEE_ID
                FROM hr.employees e, hr.jobs j
                WHERE e.job_id = j.job_id
                      AND pnDeptName IS NULL
                      OR e.DEPARTMENT_ID = (SELECT d.DEPARTMENT_ID
                                            FROM hr.DEPARTMENTS d
                                            WHERE d.DEPARTMENT_NAME = pnDeptName))
      LOOP
        recEmp.EMPLOYEE_ID := z.EMPLOYEE_ID;
        recEmp.salary := z.salary;

        recEmp := CALCULATE_SALARY(precEmp => recEmp, pnMaxSalary => z.max_salary, pnPercent => pnPercent);

        UPDATE hr.employees e
        SET e.salary = recEmp.salary
        WHERE e.employee_id = recEmp.employee_id;

      END LOOP;
    END;

  FUNCTION calculate_salary(precEmp hr.employees%ROWTYPE, pnMaxSalary NUMBER, pnPercent NUMBER)
    RETURN hr.EMPLOYEES%ROWTYPE
  IS
    recEmp hr.employees%ROWTYPE;
    BEGIN
      recEmp := precEmp;
      recEmp.salary := least(pRecEmp.salary * (1 + pnPercent / 100), pnMaxSalary);
      RETURN recEmp;
    END;

END;