Feature: Pre-Encumbrance

  [KFSQA-654] Open Encumbrances Lookup not displaying pending entries generated from the PE eDoc.
  [KFSQA-739] Background: Cornell University needs to process pre-encumbrances with expense object
              codes and verify the Accounting Line persists to the GL
  [KFSQA-753] Cornell University needs to process pre-encumbrances with expense
              object codes and verify proper offsets are used.

  @KFSQA-654 @sloth
  Scenario: Open Encumbrances Lookup will display pending entries from PE eDoc
    Given I am logged in as a KFS Chart Manager
    And   I clone a random Account with the following changes:
      | Name        | Test Account             |
      | Chart Code  | IT                       |
      | Description | [KFSQA-654] Test Account |
    Given I am logged in as a KFS Chart Administrator
    When  I blanket approve a Pre-Encumbrance Document that encumbers the random Account
    And   the Pre-Encumbrance document goes to FINAL
    And   I do an Open Encumbrances lookup for the Pre-Encumbrance document with Balance Type PE and Include All Pending Entries
    Then  the Lookup should return results

  @KFSQA-739 @wip
  Scenario: E2E - PE Created, Approved and Accounting Line persists and updates GL
    Given   I am logged in as a KFS User for the PE document
    And     I start an empty Pre-Encumbrance document
    And     I add a source Accounting Line to the Pre-Encumbrance document with the following:
      | Chart Code   | IT      |
      | Number       | U243700 |
      | Object Code  | 4023    |
      | Amount       | 100     |
    And     I save the Pre-Encumbrance document
    And     the Pre-Encumbrance document accounting lines equal the General Ledger Pending entries
    And     I submit the Pre-Encumbrance document
    And     I am logged in as a KFS Chart Administrator
    And     I view the Pre-Encumbrance document
    And     I blanket approve the Pre-Encumbrance document
    And     the Pre-Encumbrance document goes to one of the following statuses:
      | PROCESSED |
      | FINAL     |
    When    I am logged in as a KFS Chart Manager
    Then    the Pre-Encumbrance document accounting lines equal the General Ledger entries

  @KFSQA-740 @wip
  Scenario: E2E - PE Created, Approved and Accounting Line persists and updates GL
    Given   I am logged in as a KFS User for the PE document
    And     I start an empty Pre-Encumbrance document
    And     I add a source Accounting Line to the Pre-Encumbrance document with the following:
      | Chart Code   | IT      |
      | Number       | G003704 |
      | Object Code  | 6100    |
      | Amount       | 1000    |
    And     I save the Pre-Encumbrance document
    And     I remember the Pre-Encumbrance document number
    And     the Pre-Encumbrance document accounting lines equal the General Ledger Pending entries
    And     I submit the Pre-Encumbrance document
    And     I am logged in as a KFS Chart Administrator
    And     I view the Pre-Encumbrance document
    And     I blanket approve the Pre-Encumbrance document
    And     the Pre-Encumbrance document goes to one of the following statuses:
      | PROCESSED |
      | FINAL     |
    And     I am logged in as a KFS Chart Manager
    And     the Pre-Encumbrance document accounting lines equal the General Ledger entries
    And     I am logged in as a KFS User for the PE document
    And     I start an empty Pre-Encumbrance document
    And     I add a target Accounting Line to the Pre-Encumbrance document with the following:
      | Chart Code   | IT      |
      | Number       | G003704 |
      | Object Code  | 6100    |
      | Amount       | 200     |
    And     I save the Pre-Encumbrance document
    And     the Pre-Encumbrance document accounting lines equal the General Ledger Pending entries
    And     I submit the Pre-Encumbrance document
    And     I am logged in as a KFS Chart Administrator
    And     I view the Pre-Encumbrance document
    And     I blanket approve the Pre-Encumbrance document
    And     the Pre-Encumbrance document goes to one of the following statuses:
      | PROCESSED |
      | FINAL     |
    When    I am logged in as a KFS Chart Manager
    Then    The oustanding encumbrance for account G003704 and object code 6100 is 800

  @KFSQA-753 @nightly-jobs @cornell @wip
  Scenario: Generate Proper Offsets Using a PE to generate an Encumbrance
    Given I am logged in as a KFS User
    When  I submit a Pre-Encumbrance document that encumbers Account G003704
    And   the Object Codes for the Pre-Encumbrance document appear in the document's GLPE entry
    And   I view the Pre-Encumbrance document
    And   I blanket approve the Pre-Encumbrance document
    Then  the Pre-Encumbrance document goes to FINAL
    And   the Pre-Encumbrance document has matching GL and GLPE offsets
    Given Nightly Batch Jobs run
    And   I am logged in as a KFS User
    Then  the Pre-Encumbrance document GL Entry Lookup matches the document's GL entry