Feature: REQS, PO, PREQ,PDP

  [KFSQA-853] PUR-5  Sensitive Commodity Data Flag enh

  [KFSQA-854] POs Follow Routing per Organization Review (ORG 0100)

  [KFSQA-855] PUR-10  remove commodity review from PO

  [KFSQA-858] PUR-4 POA Changes to routing and permissions

  [KFSQA-882] GLPEs are wrong on Purchase Order Amendments (POAs)

  [KFSQA-994] I CREATE A CAPITAL ASSET REQS E2E (Individual Assets/New)

  @KFSQA-853 @BaseFunction @REQS @PO @PREQ @PDP @Routing @coral
  Scenario: PUR-5 Sensitive Commodity Data Flag enh
    Given I INITIATE A REQS with following:
      |Vendor Type        | NonB2B      |
      |Add Vendor On REQS | No          |
      |Positive Approval  | Unchecked   |
      |Account Type       | NonGrant    |
      |Commodity Code     | Sensitive   |
      |Amount             | GT APO      |
#    |Default PM         | P           |
  # default PM can ve implemented after alternate PM is moved to upgrade
    And  I EXTRACT THE REQS TO SQ
    When I INITIATE A PREQ

  @KFSQA-854 @BaseFunction @REQS @PO @PREQ @PDP @Routing @coral
  Scenario Outline: POs Follow Routing per Organization Review (ORG 0100)
  Given I INITIATE A REQS with following:
    |Vendor Type        | NonB2B      |
    |Add Vendor On REQS | No          |
    |Positive Approval  | Unchecked   |
    |Account Type       | NonGrant    |
    |Commodity Code     | Sensitive   |
    |Amount             | <amount>    |
    |Level              | <level>     |
    |Routing Check      | Base Org    |
#    |Default PM         | P           |
    # default PM can ve implemented after alternate PM is moved to upgrade
  And  I EXTRACT THE REQS TO SQ
  When I INITIATE A PREQ
  Examples:
  | amount     | level    |
  | 100000     | 1        |
  | 500000     | 2        |
  | 5000000    | 3        |

  @KFSQA-855 @BaseFunction @REQS @PO @PREQ @PDP @Routing @coral
  Scenario Outline: PUR-10  remove commodity review from PO
    Given I INITIATE A REQS with following:
      |Vendor Type        | NonB2B      |
      |Add Vendor On REQS | No          |
      |Positive Approval  | Unchecked   |
      |Account Type       | NonGrant    |
      |Commodity Code     | <commodity> |
      |Amount             | <amount>    |
      |Routing Check      | Commodity   |
#    |Default PM         | P           |
  # default PM can ve implemented after alternate PM is moved to upgrade
    And  I EXTRACT THE REQS TO SQ
    When I INITIATE A PREQ
  Examples:
    | amount     | commodity    |
    | GT APO     | Sensitive    |
    | LT APO     | Sensitive    |
    | GT APO     | Regular      |
    | LT APO     | Regular      |


  @KFSQA-858 @BaseFunction @POA @PDP @coral
  Scenario: PUR-4 POA Changes to routing and permissions
    Given I INITIATE A REQS with following:
      |Vendor Type        | NonB2B      |
      |Add Vendor On REQS | Yes         |
      |Positive Approval  | Unchecked   |
      |Account Type       | NonGrant    |
      |Commodity Code     | Regular     |
      |Amount             | LT APO      |
#    |Default PM         | P           |
  # default PM can ve implemented after alternate PM is moved to upgrade
    And  I EXTRACT THE REQS TO SQ
    And  I INITIATE A POA
    Then the POA Routes to the FO
    And  I INITIATE A PREQ

  @KFSQA-882 @BaseFunction @POA @PO @coral
  Scenario: GLPEs are wrong on Purchase Order Amendments (POAs)
    Given I INITIATE A REQS with following:
      |Vendor Type        | NonB2B      |
      |Add Vendor On REQS | Yes         |
      |Positive Approval  | Unchecked   |
      |Account Type       | NonGrant    |
      |Commodity Code     | Regular     |
      |Amount             | GT APO      |
#    |Default PM         | P           |
  # default PM can ve implemented after alternate PM is moved to upgrade
    And  I EXTRACT THE REQS TO SQ
    And  I INITIATE A POA with following:
      |Item Quantity   | 1       |
      |Item Cost       | 100     |
    Then the Purchase Order Amendment document's GLPE tab shows the new item amount

  @KFSQA-994 @E2E @REQS @PO @PREQ @PDP @pending @coral @wip
  Scenario: I CREATE A CAPITAL ASSET REQS E2E (Individual Assets/New)
    Given I INITIATE A REQS with following:
      |Vendor Type        | NonB2B           |
      |Add Vendor On REQS | Yes              |
      |Positive Approval  | Unchecked        |
      |Account Type       | NonGrant         |
      |Amount             | 1000             |
      |CA System Type     | Individual Assets|
      |CA System State    | New System       |

#    |Default PM         | P           |
# default PM can ve implemented after alternate PM is moved to upgrade
    And  I EXTRACT THE REQS TO SQ
    When I INITIATE A PREQ
    And  I RUN THE NIGHTLY CAPITAL ASSET JOBS
    Given I am logged in as "eap2"
    And   I lookup a Capital Asset to process
    And   I select and create asset