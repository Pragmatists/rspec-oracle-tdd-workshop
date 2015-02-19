require 'rspec'
require_relative 'spec_helper'


describe 'Fizz Buzz' do
  [
      [1, '1'],
      [2, '2'],
      [3, 'Fizz'],
      [5, 'Buzz'],
      [6, 'Fizz'],
      [10, 'Buzz'],
      [15, 'FizzBuzz'],
  ].each do |number, expected_answer|
    it "should give answer for #{number}" do
      expect(plsql.fizz_buzz_answer_for(number)).to eq (expected_answer)
    end
  end
end