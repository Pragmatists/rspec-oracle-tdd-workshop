CREATE OR REPLACE PACKAGE BODY hr.emp IS

  CURSOR c_emps (pnDeptName VARCHAR2) IS
    SELECT e.salary,
      j.max_salary,
      e.EMPLOYEE_ID
    FROM hr.employees e, hr.jobs j
    WHERE e.job_id = j.job_id
          AND pnDeptName IS NULL
          OR e.DEPARTMENT_ID = (SELECT d.DEPARTMENT_ID
                                FROM hr.DEPARTMENTS d
                                WHERE d.DEPARTMENT_NAME = pnDeptName);

  PROCEDURE main(pnPercent NUMBER, pnDeptName VARCHAR2 DEFAULT NULL)
  IS
    TYPE t_emp_tab IS TABLE OF hr.EMPLOYEES%ROWTYPE;
    emp_tab_data t_emp_tab := t_emp_tab();

    TYPE t_emps IS TABLE OF c_emps%ROWTYPE;
    emps_data t_emps;

    BEGIN
      OPEN c_emps(pnDeptName);
      FETCH c_emps BULK COLLECT INTO emps_data;
      CLOSE c_emps;

      FOR i IN 1 .. CARDINALITY(emps_data) LOOP
        emp_tab_data.EXTEND;
        --copy from collection to collection
        emp_tab_data(i).EMPLOYEE_ID := emps_data(i).employee_id;
        emp_tab_data(i).salary :=  emps_data(i).salary;

        emp_tab_data(i) := CALCULATE_SALARY(precEmp => emp_tab_data(i), pnMaxSalary => emps_data(i), pnPercent => pnPercent);
      END LOOP;

      FORALL x IN 1 .. CARDINALITY(emp_tab_data)
      UPDATE hr.employees e
      SET e.salary = emp_tab_data(x).salary
      WHERE e.employee_id = emp_tab_data(x).employee_id
      ;

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