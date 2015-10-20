require_relative '../spec_helper'
require_relative '../reference_data/reference_data'

def current_salary_of(employee)
  refresh(employee)[:salary]
end

describe 'Raise Employees salaries' do

  it 'should raise all by percent'

  it 'should not raise salary above max'

  it 'should raise salaries only in specified department'

end

def refresh(employee)
  plsql.hr.employees.first(employee_id: employee[:employee_id])
end



