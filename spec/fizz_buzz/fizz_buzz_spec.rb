require 'rspec'
require_relative '../spec_helper'


describe 'Fizz Buzz' do

  [
      [1, '1'],
      [2, '2'],
      [3, 'Fizz'],
      [6, 'Fizz'],
      [5, 'Buzz'],
      [10, 'Buzz'],
      [15, 'FizzBuzz'],
  ].each do |number, expected|

    it "should give #{expected} for #{number}" do
      expect(plsql.fizz_buzz_answer_for(number)).to eq (expected)
    end

  end

end