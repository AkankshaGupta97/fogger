Feature:
  In order to comply with the General Data Protection Regulation (EU GDPR)
  As a user
  I want to obfuscate (mask) data while moving them to the target database

  Scenario: We want to mask the email column with hashify strategy
    Given there is a source database
    And there is a table users with following columns:
      | name  | type    | length | index   |
      | id    | integer |        | primary |
      | email | string  | 64     |         |
      | desc  | string  | 128    |         |
    And the table users contains following data:
      | id | email      | desc   |
      | 4  | ex4@tsh.io | desc 4 |
      | 3  | ex3@tsh.io | desc 3 |
      | 1  | ex1@tsh.io | desc 1 |
      | 2  | ex2@tsh.io | desc 2 |
    And there is an empty target database
    And the task queue is empty
    And the config test.yaml contains:
    """
    tables:
      users:
        columns:
          email: { maskStrategy: "hashify", options: { template: "%s@example.com" } }
    """
    When I run "run" command with input:
      | --chunk-size | 1000      |
      | --file       | test.yaml |
      | --dont-wait  | true      |
    And worker processes 1 task
    Then the table users in target database should have 4 rows
    And the table users in target database should contain rows:
      | id | email                                        |
      | 4  | 8f2be31e6c018f01a296b94152288d00@example.com |
      | 2  | 8213ac5cd9213797788de22b486b1f27@example.com |
      | 1  | 0d49c52d05ad00c9f002d94ddbe635fb@example.com |
      | 3  | 89f1d876fb477e78c603aaf45e7427fc@example.com |
