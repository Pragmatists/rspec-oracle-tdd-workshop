Feature: Raise Employees salaries

  Scenario: Raise employees salary by percentage
    Given "Alice" with salary "100"
    When I raise employee salaries by "10%"
    Then Employee "Alice" has salary "110"

  Scenario: Do not exceed maximum salary of 1000
    Given Employee "Bob" with salary "980"
    When I raise employee salaries by "20" pct
    Then Employee "Bob" has salary "1000"
