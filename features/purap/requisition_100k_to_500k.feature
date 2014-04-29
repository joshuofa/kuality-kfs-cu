Feature: Purap Preq Building Blocks

  [KFSQA-745] PURAP E2E PO - Approved (PURAP E2E-003d) - vendor selected, >$100K, >$500K, <$5MM

  [KFSQA-744] PURAP E2E PO - Approved (PURAP E2E-003c) - vendor selected, >$100K, <$500K

  @KFSQA-745 @E2E @PO @PURAP @cornell @coral
  Scenario: PURAP E2E PO - Approved (PURAP E2E-003d) - vendor selected, >$100K, >$500K, <$5MM
    Given I login as a PURAP eSHop user
    And I create the Requisition document with:
      | Item Quantity       | 1800     |
      | Item Cost           | 1000     |
      | Item Commodity Code | 12142203 |
      | Item Catalog Number | 10101157 |
      | Item Description    | ANIM     |
      | Account Number      | R589854  |
      | Object Code         | 6540     |
      | Percent             | 100      |
    And I add an Attachment to the Requisition document
    And I enter Delivery Instructions and Notes to Vendor
    And I calculate my Requisition document
    And I submit the Requisition document
    And the Requisition document goes to ENROUTE
    And I switch to the user with the next Pending Action in the Route Log for the Requisition document
    And I view the Requisition document on my action list
    And I approve the Requisition document
    And the Requisition document goes to ENROUTE
    # commodity reviewer
    And I switch to the user with the next Pending Action in the Route Log for the Requisition document
    And I view the Requisition document on my action list
    And I approve the Requisition document
    And the Requisition document goes to ENROUTE
    And I switch to the user with the next Pending Action in the Route Log for the Requisition document
    And I view the Requisition document on my action list
    And I approve the Requisition document
    And the Requisition document goes to FINAL
    And I am logged in as a Purchasing Processor
    And I submit a Contract Manager Assignment of '10' for the Requisition
    And I am logged in as a PURAP Contract Manager
    And I retrieve the Requisition document
    And the View Related Documents Tab PO Status displays
    And the Purchase Order Number is unmasked
    And I Complete Selecting Vendor 27015-0
    And I enter a Vendor Choice of 'Lowest Price'
    And I calculate and verify the GLPE tab
    And I submit the Purchase Order document
    And the Purchase Order document goes to ENROUTE
    And I switch to the user with the next Pending Action in the Route Log for the Purchase Order document
    And I view the Purchase Order document on my action list
    And I approve the Purchase Order document
    And the Purchase Order document goes to ENROUTE
    And I switch to the user with the next Pending Action in the Route Log for the Purchase Order document
    And I view the Purchase Order document on my action list
    And I approve the Purchase Order document
    And the Purchase Order document goes to FINAL
    Then in Pending Action Requests an FYI is sent to FO and Initiator
    And the Purchase Order Doc Status is Open
    Given I am logged in as "db18"
    And   I visit the "e-SHOP" page
    And   I view the Purchase Order document via e-SHOP
    Then  the Document Status displayed 'Completed'
    And   the Delivery Instructions displayed equals what came from the PO
    And   the Attachments for Supplier came from the PO


  @KFSQA-744 @E2E @PO @PURAP @cornell @coral
  Scenario: PURAP E2E PO - Approved (PURAP E2E-003c) - vendor selected, >$100K, <$500K
    Given I login as a PURAP eSHop user
    And   I create the Requisition document with:
      | Item Quantity       | 180      |
      | Item Cost           | 1000     |
      | Item Commodity Code | 12142203 |
      | Item Catalog Number | 10101157 |
      | Item Description    | ANIM     |
      | Account Number      | 1093603  |
      | Object Code         | 6540     |
      | Percent             | 100      |
    And  I select the Payment Request Positive Approval Required
    And   I add an Attachment to the Requisition document
    And   I enter Delivery Instructions and Notes to Vendor
    And   I calculate my Requisition document
    And   I submit the Requisition document
    And   the requisition document goes to ENROUTE
    And   I switch to the user with the next Pending Action in the Route Log for the Requisition document
    And   I view the Requisition document on my action list
    And   I approve the Requisition document
    And   the Requisition document goes to ENROUTE
    And   I switch to the user with the next Pending Action in the Route Log for the Requisition document
    And   I view the Requisition document on my action list
    And   I approve the Requisition document
    And   the Requisition document goes to ENROUTE
    # commodity reviewer
    And   I switch to the user with the next Pending Action in the Route Log for the Requisition document
    And   I view the Requisition document on my action list
    And   I approve the Requisition document
    And   the Requisition document goes to FINAL
    And   I am logged in as a Purchasing Processor
    And   I submit a Contract Manager Assignment of '10' for the Requisition
    And I am logged in as a PURAP Contract Manager
    And   I retrieve the Requisition document
    And   the View Related Documents Tab PO Status displays
    And   the Purchase Order Number is unmasked
    And   I Complete Selecting Vendor 27015-0
    And I enter a Vendor Choice of 'Lowest Price'
    And I calculate and verify the GLPE tab
    And   I submit the Purchase Order document
    And   the Purchase Order document goes to ENROUTE
    And   I switch to the user with the next Pending Action in the Route Log for the Purchase Order document
    And   I view the Purchase Order document on my action list
    And   I approve the Purchase Order document
    And   the Purchase Order document goes to FINAL
    Then  in Pending Action Requests an FYI is sent to FO and Initiator
    And   the Purchase Order Doc Status is Open
    Given I login as a Accounts Payable Processor to create a PREQ
    And   I fill out the PREQ initiation page and continue
    And   I change the Remit To Address
    And   I enter the Qty Invoiced and calculate
    And   I enter a Pay Date
    And   I attach an Invoice Image
    And   I calculate PREQ
    And   I submit the Payment Request document
    And   the Payment Request document goes to ENROUTE
    # FO
    And   I switch to the user with the next Pending Action in the Route Log for the Payment Request document
    And   I view the Payment Request document on my action list
    And   I approve the Payment Request document
    And   the Payment Request document goes to ENROUTE
    # Accounting Reviewer
    And   I switch to the user with the next Pending Action in the Route Log for the Payment Request document
    And   I view the Payment Request document on my action list
    And   I approve the Payment Request document
    And   the Payment Request document goes to FINAL
    And   the Payment Request Doc Status is Department-Approved

