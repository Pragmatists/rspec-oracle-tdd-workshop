CREATE OR REPLACE PROCEDURE hr.raise_salaries(p_percent INTEGER, p_department_name VARCHAR2 DEFAULT NULL) IS
  BEGIN
    hr.EMP.main(pnPercent => p_percent, pnDeptName => p_department_name);

  END;