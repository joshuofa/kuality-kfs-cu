Feature: Account Close

  [KFSQA-551/KFSQA-587] As a KFS Chart Manager, the Account cannot be closed with open encumbrances.

  @KFSQA-551 @KFSQA-587
  Scenario: As a KFS Chart Manager, the Account cannot be closed with open encumbrances.
    Given I am logged in as a KFS Chart Manager
    And   I clone a random Account with the following changes:
      | Name        | Test Account             |
      | Chart Code  | IT                       |
      | Description | [KFSQA-551] Test Account |
    Given I am logged in as a KFS User
    When  I blanket approve a Pre-Encumbrance Document that encumbers the random Account
    Then  the Pre-Encumbrance posts a GL Entry with one of the following statuses
      | PENDING   |
      | COMPLETED |
      | PROCESSED |
    Given Nightly Batch Jobs run
    And   I am logged in as a KFS Chart Manager
    When  I close the Account
    And   I submit the Account document
    Then  I should get an error saying "This Account cannot be closed because it has an open Encumbrance."
#    When  I blanket approve a Pre-Encumbrance Document that disencumbers the random Account
#    And   Nightly Batch Jobs run
#    And   I close the Account by clicking submit
#    Then  The document should have no errors