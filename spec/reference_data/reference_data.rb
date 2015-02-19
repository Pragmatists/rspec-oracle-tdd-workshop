module ReferenceData
  class Employees
    def self.alice_with_salary_100
      plsql.hr.employees.first(last_name: 'With salary 100')
    end

    def self.bob_with_max_salary_1000
      plsql.hr.employees.first(last_name: 'With max salary 1000')
    end

    def self.find(params)
      dept, salary = params.values
      query = <<-SQL
      SELECT e.* FROM hr.employees e JOIN hr.departments d ON (e.department_id = d.department_id)
       WHERE d.department_name= :d AND e.salary = :s
      SQL
      plsql.select :first, query, dept, salary
    end

  end
end