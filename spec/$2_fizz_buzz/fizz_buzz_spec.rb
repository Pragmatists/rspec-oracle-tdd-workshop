require 'rspec'
require_relative '../spec_helper'


describe 'Fizz Buzz' do
  it 'should give 1 for 1' do
    expect(plsql.fizz_buzz_answer_for(1)).to eq ('1')
  end
end