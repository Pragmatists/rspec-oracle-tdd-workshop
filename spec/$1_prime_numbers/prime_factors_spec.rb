require 'rspec'
require_relative '../spec_helper'


describe 'Prime factors finder' do

  [
      [1, []],
      [2, [2]],
      [3, [3]],
      [4, [2, 2]],
      [6, [2, 3]],
      [8, [2, 2, 2]],
      [9, [3, 3]],
  ].each do |number, expected|
    it "should find factors of #{number}" do
      expect(plsql.generate_prime_factors(number)).to eq expected
    end
  end
end