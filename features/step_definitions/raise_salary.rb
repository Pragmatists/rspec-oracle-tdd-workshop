After do |scenario|
  plsql.rollback
end

Given(/^(?:Employee )?"([^"]*)" with salary "([^"]*)"$/) do |name, salary|
  emp = plsql.hr.employees.select(:first, {first_name: name} )
  expect(emp[:salary]).to eq(salary.to_i)
end

When(/^I raise employee salaries by "([^"]*)"(?: pct)?$/) do |percent|
  puts percent.to_i
  plsql.hr.raise_salaries(10)
end


Then(/^Employee "([^"]*)" has salary "([^"]*)"$/) do |name, salary|
  emp = plsql.hr.employees.select(:first, {first_name: name} )
  expect(emp[:salary]).to eq(salary.to_i)
end