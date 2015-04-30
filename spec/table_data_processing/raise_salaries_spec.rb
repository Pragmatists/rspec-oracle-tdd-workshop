require_relative '../spec_helper'
require_relative '../reference_data/reference_data'

def current_salary_of(employee)
  refresh(employee)[:salary]
end

describe 'Raise Employees salaries' do

  it 'should raise all by percent' do
    employee = ReferenceData::Employees.alice_with_salary_100

    plsql.hr.raise_salaries(10)

    expect(current_salary_of(employee)).to eq 110
  end

  it 'should not raise salary above max' do
    employee = ReferenceData::Employees.bob_with_max_salary_1000

    plsql.hr.raise_salaries(8000)

    expect(current_salary_of(employee)).to eq 1000
  end

  it 'should raise salaries only in specified department' do
    it_employee = ReferenceData::Employees.find({dept: 'IT', salary: 80})
    marketing_employee = ReferenceData::Employees.find({dept: 'Marketing', salary: 100})

    plsql.hr.raise_salaries(10, 'IT')

    expect(current_salary_of(it_employee)).to eq 88
    expect(current_salary_of(marketing_employee)).to eq 100

  end

  def refresh(employee)
    plsql.hr.employees.first(employee_id: employee[:employee_id])
  end

end