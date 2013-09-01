Feature: A User account is created

  Most people think that genetic testing is an oracle, that it will 
  tell you the future; it doesn't - it just tells you a version of what
  can be. It is up to them to change their futures.

  Background:
    Given there is a genetic sequence for this user

  Scenario: a new sequence is submitted
    When the sequence passed validation
    Then sum the attributes of each genotype
    Then make a report for that sequence

  Scenario: User requests to know something about an attribute
    Given there is at least one report
    Then find all entries of this attribute in the reports
    Then compile the comments from each of these reports
