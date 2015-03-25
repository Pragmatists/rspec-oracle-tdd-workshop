require 'rspec'
require_relative '../spec_helper'
require 'ruby-plsql'

describe 'Employee migration' do

  it 'table Employee should not exist' do
    # given -> test state
    expect{plsql.employees}.to raise_exception
  end

  context 'when I execute migrate' do

    before(:context) do
      # when -> exec migration
      # plsql.execute <<-SQL
      #   CREATE TABLE EMPLOYEES(ID INTEGER)
      # SQL
      # plsql.execute <<-SQL
      #   ALTER TABLE EMPLOYEES ADD CONSTRAINT EMPLOYEES_PK PRIMARY KEY (ID)
      # SQL
    end

    it 'table Employee should be created' do
      # then -> test state
      expect(plsql.employees).to be_a(PLSQL::Table)
    end

    it 'table Employee should have a primary key on ID' do
      # then -> test state
      expect(plsql.user_constraints.first(table_name:'EMPLOYEES',constraint_type:'P')[:constraint_name]).to eq('EMPLOYEES_PK')
    end

    after(:context) do
      # after all -> exec migration rollback
      plsql.execute <<-SQL
        DROP TABLE EMPLOYEES
      SQL
    end

  end

end