Feature: Vendor Create

  [KFSQA-638] Vendor Create e2e - Standard-Individual, Contract No, Insurance No, Cornell University
              pays vendors for good and services. The University captures legal, tax and procurement
              information based on ownership type as required by federal laws, state laws, and
              university policies.

  [KFSQA-635] Vendor Create e2e - Standard, Contract Yes, Insurance Yes, Cornell University
              pays vendors for good and services. The University captures legal, tax and
              procurement information based on ownership type as required by federal laws,
              state laws, and university policies.

  [KFSQA-633] Vendor Create - VN E2E-1a - e-SHOP vendor, Cornell University pays vendors for goods and
              services. The University captures legal, tax and procurement information based on ownership
              type as required by federal laws, state laws, and university policies.

  [KFSQA-634] Vendor Create VN E2E-1b - Foreign vendor, Cornell University pays vendors for goods and
              services. The University captures legal, tax and procurement information based on ownership
              type as required by federal laws, state laws, and university policies.

  [KFSQA-636] Vendor Create e2e - Standard, Contract = Yes, Insurance = No, Cornell University pays
              vendors for goods and services. The University captures legal, tax and procurement information
              based on ownership type as required by federal laws, state laws, and university policies.

  [KFSQA-637] Vendor Create e2e - Standard-Individual, Contract = No, Insurance = Yes, Cornell University
              pays vendors for goods and services. The University captures legal, tax and procurement
              information based on ownership type as required by federal laws, state laws, and university policies.

  [KFSQA-774] I want to create a DV vendor with ACH/Check as the default payment method. Per Cornell policy,
              on subsequent lookups, The initiator will not be allowed to view the Tax ID and Attachments for this vendor.

  [KFSQA-775] I want to create a DV vendor with Wire as the default payment method. Per Cornell policy, on
              subsequent lookups, The initiator will not be allowed to view the Tax ID and Attachments for this vendor.

  [KFSQA-776] I want to create a DV vendor with foreign draft as the default payment method. Per Cornell policy,
              on subsequent lookups, The initiator will not be allowed to view the Tax ID and Attachments for this vendor.

  @KFSQA-638 @cornell @tortoise
  Scenario: I want to create a vendor with ownership type INDIVIDUAL
    Given   I am logged in as a Vendor Initiator
    When    I start an empty Vendor document
    And     I save the Vendor document
    And     I add an attachment to the Vendor document
    And     I submit the Vendor document
    And     the Vendor document goes to ENROUTE
    And     I am logged in as a Vendor Reviewer
    And     I view the Vendor document
    And     I approve the Vendor document
    Then    the Vendor document goes to FINAL
    When    I am logged in as a Vendor Initiator
    Then    the Vendor document should be in my action list

  @KFSQA-635 @cornell @tortoise
  Scenario: I want to create a vendor with ownership type CORPORATION that is NON-FOREIGN
    Given   I am logged in as a Vendor Contract Editor(cu)
    When    I create a Corporation and Non-Foreign Vendor with Contract and Insurance
    And     I save the Vendor document
    And     I add an attachment to the Vendor document
    And     I submit the Vendor document
    And     the Vendor document goes to ENROUTE
    And     I am logged in as a Vendor Reviewer
    And     I view the Vendor document
    And     I approve the Vendor document
    Then    the Vendor document goes to FINAL
    When    I am logged in as a Vendor Contract Editor(cu)
    Then    the Vendor document should be in my action list

  @KFSQA-633 @cornell @tortoise
  Scenario: I want to create a vendor with ownership type CORPORATION that is e-SHOP
    Given   I am logged in as a Vendor Initiator
    When    I create a Corporation and e-SHOP Vendor
    And     I save the Vendor document
    And     I add an attachment to the Vendor document
    And     I submit the Vendor document
    And     the Vendor document goes to ENROUTE
    And     I am logged in as a Vendor Reviewer
    And     I view the Vendor document
    And     I approve the Vendor document
    Then    the Vendor document goes to FINAL
    When    I am logged in as a Vendor Initiator
    Then    the Vendor document should be in my action list

  @KFSQA-634 @cornell @tortoise
  Scenario: I want to create a vendor with ownership type CORPORATION that is Foreign
    Given   I am logged in as a Vendor Initiator
    When    I create a Corporation and Foreign Vendor
    And     I save the Vendor document
    And     I add an attachment to the Vendor document
    And     I submit the Vendor document
    And     the Vendor document goes to ENROUTE
    And     I am logged in as a Vendor Reviewer
    And     I view the Vendor document
    And     I approve the Vendor document
    Then    the Vendor document goes to FINAL
    When    I am logged in as a Vendor Initiator
    Then    the Vendor document should be in my action list

  @KFSQA-636 @cornell @tortoise
  Scenario: I want to create a vendor with ownership type CORPORATION that is NON-FOREIGN with Contract
    Given   I am logged in as a Vendor Contract Editor(cu)
    When    I create a Corporation and Non-Foreign Vendor with Contract
    And     I save the Vendor document
    And     I add an attachment to the Vendor document
    And     I submit the Vendor document
    And     the Vendor document goes to ENROUTE
    And     I am logged in as a Vendor Reviewer
    And     I view the Vendor document
    And     I approve the Vendor document
    Then    the Vendor document goes to FINAL
    When    I am logged in as a Vendor Contract Editor(cu)
    Then    the Vendor document should be in my action list

  @KFSQA-637 @cornell @tortoise
  Scenario: I want to create a vendor with ownership type INDIVIDUAL that is NON-FOREIGN with Insurance
    Given   I am logged in as a Vendor Initiator
    When    I create an Individual and Non-Foreign Vendor with Insurance
    And     I save the Vendor document
    And     I add an attachment to the Vendor document
    And     I submit the Vendor document
    And     the Vendor document goes to ENROUTE
    And     I am logged in as a Vendor Reviewer
    And     I view the Vendor document
    And     I approve the Vendor document
    Then    the Vendor document goes to FINAL
    When    I am logged in as a Vendor Initiator
    Then    the Vendor document should be in my action list

  @KFSQA-774 @KFSQA-775 @cornell @slug
  Scenario Outline: I want to create a DV vendor with ACH/Check or Wire as the default payment method.
    Given   I am logged in as a Vendor Initiator
    When    I create a DV Vendor
    And     I enter a default payment method <default_payment_method> on Vendor Page
    And     I add an attachment to the Vendor document
    And     I submit the Vendor document
    Then    the Vendor document goes to ENROUTE
    And     I am logged in as a Vendor Reviewer
    And     I view the Vendor document
    And     I approve the Vendor document
    Then    the Vendor document goes to FINAL
    Given   I am logged in as a Vendor Initiator
    When    I view the Vendor document
    Then    I can not view the Tax ID and Attachments on Vendor page
  Examples:
    | default_payment_method |
    | P                      |
    | W                      |

  @KFSQA-776 @cornell @tortoise
  Scenario: I want to create a DV vendor with foreign draft as the default payment method.
    Given   I am logged in as a Vendor Initiator
    When    I create a DV Vendor
    And     I enter a default payment method F on Vendor Page
    And     I add an attachment to the Vendor document
    And     I add an Address to a Vendor with following fields:
      | Address Type   | TX - TAX             |
      | Address 1      | UFFICIO ROMA TRULLO  |
      | Address 2      | CASELLA POSTALE 1234 |
      | City           | Hanover              |
      | Zip Code       | 00149 ROMA RM        |
      | Country        | Italy                |
    And     I submit the Vendor document
    Then    the Vendor document goes to ENROUTE
    And     I am logged in as a Vendor Reviewer
    And     I view the Vendor document
    And     I change Remit Address and the Foreign Tax Address
    And     I save the Vendor document
    And     I view the Vendor document
    And     the Address changes persist
    And     I approve the Vendor document
    Then    the Vendor document goes to FINAL
    Given   I am logged in as a Vendor Initiator
    When    I view the Vendor document
    Then    I can not view the Tax ID and Attachments on Vendor page
