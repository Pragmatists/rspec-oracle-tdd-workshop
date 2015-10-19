require_relative '../spec_helper'
require_relative '../reference_data/reference_data'

def current_salary_of(employee)
  refresh(employee)[:salary]
end

class Department

  attr_reader :id

  def initialize(name:)
    @name = name
    @id = nil
  end

  def create
    return self unless @name
    @id = plsql.hr.departments_seq.nextval
    plsql.hr.departments.insert({
                                    department_id: @id,
                                    department_name: @name
                                })
    self
  end

end


def create_employee(options, department: nil)
  id = plsql.hr.employees_seq.nextval
  department = Department.new(name: department).create
  default_employee = {
      :employee_id => id,
      :last_name => 'Last',
      :email => "#{id}-last@example.com",
      :hire_date => Date.today,
      :job_id => plsql.hr.jobs.first[:job_id],
      :commission_pct => nil,
      :salary => 200,
      :department_id => department.id
  }
  new_employee = default_employee.merge(options)
  plsql.hr.employees.insert([new_employee])
  new_employee
end


describe 'Raise Employees salaries' do

  it 'should raise all by percent' do
    employee = create_employee(salary: 100)

    plsql.hr.raise_salaries(10)

    expect(current_salary_of(employee)).to eq 110
  end

  it 'should not raise salary above max' do
    employee = create_employee(salary: 1000)

    plsql.hr.raise_salaries(8000)

    expect(current_salary_of(employee)).to eq 1000
  end

  it 'should raise salaries only in specified department' do
    will_have_a_raise = create_employee({salary: 80}, department: 'Rising Department')
    sorry_no_raise = create_employee({salary: 100}, department: 'Sluggish Department')

    plsql.hr.raise_salaries(10, 'Rising Department')

    expect(current_salary_of(will_have_a_raise)).to eq 88
    expect(current_salary_of(sorry_no_raise)).to eq 100

  end

  def refresh(employee)
    plsql.hr.employees.first(employee_id: employee[:employee_id])
  end

end