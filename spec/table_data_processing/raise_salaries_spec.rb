require_relative '../spec_helper'
require_relative '../reference_data/reference_data'

def current_salary_of(employee)
  refresh(employee)[:salary]
end

describe 'Raise Employees salaries' do

  it 'should raise all by percent' do
    employee = ReferenceData::Employees.alice_with_salary_100

    plsql.hr.raise_salaries(p_percent:10)

    expect(current_salary_of(employee)).to eq 110.00
  end

  it 'should not raise salary above max' do
    employee = ReferenceData::Employees.bob_with_max_salary_1000

    plsql.hr.raise_salaries(p_percent:100000)

    expect(current_salary_of(employee)).to eq(1000)
  end

  it 'should raise salaries only in specified department' do
    employee_from_marketing = ReferenceData::Employees.find(department:'Marketing', salary: '100')
    employee_from_it = ReferenceData::Employees.find(department:'IT', salary: '80')

    plsql.hr.raise_salaries(p_percent:10, p_department_name:'Marketing')

    expect(current_salary_of(employee_from_marketing)).to eq(110)
    expect(current_salary_of(employee_from_it)).to eq(80)
  end

  def refresh(employee)
    plsql.hr.employees.first(employee_id: employee[:employee_id])
  end
end