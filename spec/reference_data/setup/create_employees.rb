require_relative '../../spec_helper'

module EmployeeData
  def self.cleanup
    employee_email = %w(last@example.com WithSal100 WithMaxSal_1000 MarketingWithSalary100 ItWithSalary80)
    plsql.hr.employees.delete("where email in ('#{(employee_email *"','")}')")
    plsql.hr.jobs.delete(job_id: '1000job')
    plsql.commit
  end
  def self.create
    plsql.hr.jobs.insert ({
      job_id: '1000job',
      job_title: '100-1000 job',
      min_salary: 100,
      max_salary: 1000
    })

    default_employee = {
        :last_name => 'Last',
        :email => 'last@example.com',
        :hire_date => Date.today,
        :job_id => plsql.hr.jobs.first[:job_id],
        :commission_pct => nil,
        :salary => 200
    }

    emps = [
        default_employee.merge({
            employee_id: plsql.hr.employees_seq.nextval,
            first_name:     'Alice',
            last_name:      'With salary 100',
            email:          'WithSal100',
            salary:         100,
        }),
        default_employee.merge({
            employee_id: plsql.hr.employees_seq.nextval,
            first_name:     'Bob',
            last_name:      'With max salary 1000',
            email:          'WithMaxSal_1000',
            job_id:         plsql.hr.jobs.first(max_salary:1000)[:job_id],
            salary:         980,
        }),
        default_employee.merge({
                               employee_id: plsql.hr.employees_seq.nextval,
                               email:          'MarketingWithSalary100',
                               salary: 100,
                               department_id: plsql.hr.departments.first(department_name:'Marketing')[:department_id]
                               }),
        default_employee.merge({
                               employee_id: plsql.hr.employees_seq.nextval,
                               email:          'ItWithSalary80',
                               salary: 80,
                               department_id: plsql.hr.departments.first(department_name:'IT')[:department_id]
                               }),
    ]
    plsql.hr.employees.insert emps
    plsql.commit
  end
end
EmployeeData.cleanup
EmployeeData.create

