And /^I edit an Account to enter a Sub Fund Program in lower case$/ do
  visit(MainPage).account
  on AccountLookupPage do |page|
    page.subfund_program_code.set 'BOARD' #TODO config
    page.search
    page.edit_random
  end
  on AccountPage do |page|
    @account = make AccountObject
    page.description.set random_alphanums(40, 'AFT')
    page.subfund_program_code.set 'board' #TODO config
    page.save
  end
  step 'I add the account to the stack'
end

When /^I enter a Sub-Fund Program Code of (.*)$/ do |sub_fund_program_code|
  on AccountPage do |page|
    page.subfund_program_code.set sub_fund_program_code
    page.save
    @account.subfund_program_code = sub_fund_program_code
  end
  step 'I add the account to the stack'
end


When /^I enter (.*) as an invalid Major Reporting Category Code$/  do |major_reporting_category_code|
  on AccountPage do |page|
    page.major_reporting_category_code.fit major_reporting_category_code
    page.save
    @account.major_reporting_category_code = major_reporting_category_code
  end
  step 'I add the account to the stack'
end


When /^I enter (.*) as an invalid Appropriation Account Number$/  do |appropriation_account_number|
  on AccountPage do |page|
    page.appropriation_account_number.fit appropriation_account_number
    page.save
    @account.appropriation_account_number = appropriation_account_number
  end
  step 'I add the account to the stack'
end


When /^I save an Account document with only the ([^"]*) field populated$/ do |field|
  # TODO: Swap this out for Account#defaults
  default_fields = {
      description:          random_alphanums(40, 'AFT'),
      chart_code:           get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE),
      number:               random_alphanums(7),
      name:                 random_alphanums(10),
      organization_code:    '01G0',#TODO config?
      campus_code:          get_aft_parameter_value(ParameterConstants::DEFAULT_CAMPUS_CODE),
      effective_date:       '01/01/2010',
      postal_code:          get_random_postal_code('*'),
      city:                 get_generic_city,
      state:                get_random_state_code,
      address:              get_generic_address_1,
      type_code:            get_aft_parameter_value(ParameterConstants::DEFAULT_CAMPUS_TYPE_CODE),
      sub_fund_group_code:  'ADMSYS',#TODO config?
      higher_ed_funct_code: '4000',#TODO config?
      restricted_status_code:     'U - Unrestricted',#TODO config?
      fo_principal_name:          get_aft_parameter_value(ParameterConstants::DEFAULT_FISCAL_OFFICER),
      supervisor_principal_name:  get_aft_parameter_value(ParameterConstants::DEFAULT_SUPERVISOR),
      manager_principal_name: get_aft_parameter_value(ParameterConstants::DEFAULT_MANAGER),
      budget_record_level_code:   'C - Consolidation',#TODO config?
      sufficient_funds_code:      'C - Consolidation',#TODO config?
      expense_guideline_text:     'expense guideline text',
      income_guideline_text: 'incomde guideline text',
      purpose_text:         'purpose text',
      labor_benefit_rate_cat_code: 'CC'#TODO config?
  }

  # TODO: Make the Account document creation with a single field step more flexible.
  case field
    when 'Description'
      default_fields.each {|k, _| default_fields[k] = '' unless k.to_s.eql?('description') }
  end

  @account = create AccountObject, default_fields.merge({press: :save})
  step 'I add the account to the stack'
end

When /^I enter an invalid (.*)$/  do |field_name|
  case field_name
    when 'Sub-Fund Program Code'
      step "I enter a Sub-Fund Program Code of #{random_alphanums(4, 'XX').upcase}"
    when 'Major Reporting Category Code'
      step "I enter #{random_alphanums(6, 'XX').upcase} as an invalid Major Reporting Category Code"
    when 'Appropriation Account Number'
      step "I enter #{random_alphanums(6, 'XX').upcase} as an invalid Appropriation Account Number"
    when 'Labor Benefit Rate Code'
      step "I enter #{random_alphanums(1, 'X').upcase} as an invalid Labor Benefit Rate Category Code"
  end
end


Then /^I should get (invalid|an invalid) (.*) errors?$/ do |invalid_ind, error_field|
  on AccountPage do |page|
    case error_field
      when 'Sub-Fund Program Code'
        page.errors.should include "Sub-Fund Program Code #{page.subfund_program_code.value} is not associated with Sub-Fund Group Code #{page.sub_fund_group_code.value}."
      when 'Major Reporting Category Code'
        page.errors.should include "Major Reporting Category Code (#{page.major_reporting_category_code.value}) does not exist."
      when 'Appropriation Account Number'
        page.errors.should include "Appropriation Account Number #{page.appropriation_account_number.value} is not associated with Sub-Fund Group Code #{page.sub_fund_group_code.value}."
      when 'Labor Benefit Rate Code'
        page.errors.should include 'Invalid Labor Benefit Rate Code'
        page.errors.should include "The specified Labor Benefit Rate Category Code #{page.labor_benefit_rate_category_code.value} does not exist."
    end
  end
end


And /^I enter (Sub Fund Program Code|Sub Fund Program Code and Appropriation Account Number) that (is|are) associated with a random Sub Fund Group Code$/ do |codes, is_are|
  account = get_kuali_business_object('KFS-COA','Account','subFundGroupCode=*&extension.programCode=*&closed=N&extension.appropriationAccountNumber=*&active=Y&accountExpirationDate=NULL')
  on AccountPage do |page|
    page.sub_fund_group_code.set account['subFundGroup.codeAndDescription'].sample.split('-')[0].strip
    page.subfund_program_code.set account['extension.programCode'].sample
    @account.sub_fund_group_code = page.sub_fund_group_code_new
    @account.subfund_program_code = page.subfund_program_code_new
    unless codes == 'Sub Fund Program Code'
      page.appropriation_account_number.set account['extension.appropriationAccountNumber'].sample
      @account.appropriation_account_number = page.appropriation_account_number_new
    end
  end
end


When /^I input a lowercase Major Reporting Category Code value$/  do
  major_reporting_category_code = get_kuali_business_object('KFS-COA','MajorReportingCategory','active=Y')['majorReportingCategoryCode'].sample
  on(AccountPage).major_reporting_category_code.fit major_reporting_category_code.downcase
  @account.major_reporting_category_code = major_reporting_category_code.downcase
end

And /^I create an Account with an Appropriation Account Number of (.*) and Sub-Fund Program Code of (.*)/ do |appropriation_accountNumber, subfund_program_code|
  @account = create AccountObject
  on AccountPage do |page|
    page.appropriation_account_number.set appropriation_accountNumber
    page.subfund_program_code.set subfund_program_code
    @account.document_id = page.document_id
  end
  step 'I add the account to the stack'
end


And /^I enter an Appropriation Account Number that is not associated with the Sub Fund Group Code$/  do
  # the account# is not used as its own appropriation account#
  on AccountPage do |page|
    page.appropriation_account_number.fit page.account_number_old
    @account.appropriation_account_number = page.appropriation_account_number_new
  end
end


When /^I enter (.*) as an invalid Labor Benefit Rate Category Code$/  do |labor_benefit_rate_category_code|
  on AccountPage do |page|
    page.labor_benefit_rate_category_code.fit labor_benefit_rate_category_code
    page.save
    @account.labor_benefit_rate_category_code = labor_benefit_rate_category_code
  end
end

And /^I clone Account (.*) with the following changes:$/ do |account_number, table|
  unless account_number.empty?
    account_number = account_number == 'nil' ? nil : account_number
    updates = table.rows_hash
    updates.delete_if { |k,v| v.empty? }
    updates['Indirect Cost Recovery Active Indicator'] = updates['Indirect Cost Recovery Active Indicator'].to_sym unless updates['Indirect Cost Recovery Active Indicator'].nil?

    visit(MainPage).account
    on AccountLookupPage do |page|
      page.chart_code.fit     get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
      page.account_number.fit account_number
      page.search
      page.wait_for_search_results
      page.copy_random
    end
    on AccountPage do |page|
      @document_id = page.document_id
      @account = make AccountObject, description: updates['Description'],
                                     name:        updates['Name'],
                                     chart_code:  updates['Chart Code'],
                                     number:      random_alphanums(7),
                                     document_id: page.document_id,
                                     press: nil
      page.description.fit @account.description
      page.name.fit        @account.name
      page.chart_code.fit  @account.chart_code
      page.number.fit      @account.number
      page.supervisor_principal_name.fit @account.supervisor_principal_name
      #only attempt data entry for ICR tab when all the required ICR data is provided
      if updates['Indirect Cost Recovery Chart Of Accounts Code'] && updates['Indirect Cost Recovery Account Number'] &&
         updates['Indirect Cost Recovery Account Line Percent'] && updates['Indirect Cost Recovery Active Indicator']
        @account.icr_accounts.add chart_of_accounts_code: updates['Indirect Cost Recovery Chart Of Accounts Code'],
                                  account_number:         updates['Indirect Cost Recovery Account Number'],
                                  account_line_percent:   updates['Indirect Cost Recovery Account Line Percent'],
                                  active_indicator:       updates['Indirect Cost Recovery Active Indicator']
      end

      page.errors.should == []  #fail the test and do not continue if errors exist on page after performing data changes
      page.blanket_approve
      sleep 5
    end

    step 'I add the account to the stack'
  end
end

And /^I find an expired Account$/ do
  visit(MainPage).account
  on AccountLookupPage do |page|
    # FIXME: These values should be set by a service.
    page.chart_code.fit     get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
    page.account_number.fit '147*'
    page.search
    page.sort_results_by('Account Expiration Date')
    page.sort_results_by('Account Expiration Date') # Need to do this twice to get the expired ones in front

    col_index = page.column_index(:account_expiration_date)
    account_row_index = page.results_table
                            .rows.collect { |row| row[col_index].text if row[col_index].text.split('/').length == 3}[1..page.results_table.rows.length]
                            .collect { |cell| DateTime.strptime(cell, '%m/%d/%Y') < DateTime.now }.index(true) + 1 # Finds the first qualified one.
    account_row_index = rand(account_row_index..page.results_table.rows.length)

    # We're only really interested in these parts
    @account = make AccountObject
    @account.number = page.results_table[account_row_index][page.column_index(:account_number)].text
    @account.chart_code = page.results_table[account_row_index][page.column_index(:chart_code)].text
    @account.account_expiration_date = DateTime.strptime(page.results_table[account_row_index][page.column_index(:account_expiration_date)].text, '%m/%d/%Y')
    step 'I add the account to the stack'
  end
end

And /^I use these Accounts:$/ do |table|
  existing_accounts = table.raw.flatten

  visit(MainPage).account
  on AccountLookupPage do |page|
    existing_accounts.each do |account_number|
      # FIXME: These values should be set by a service.
      page.chart_code.fit     get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
      page.account_number.fit account_number
      page.search

      # We're only really interested in these parts
      @account = make AccountObject
      @account.number = page.results_table[1][page.column_index(:account_number)].text
      @account.chart_code = page.results_table[1][page.column_index(:chart_code)].text
      step 'I add the account to the stack'
    end
  end

end

When /^I start to copy a Contracts and Grants Account$/ do
  cg_account_number = get_account_of_type 'Contracts & Grants with ICR'
  visit(MainPage).account
  on AccountLookupPage do |alp|
    alp.chart_code.fit     get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
    alp.account_number.fit cg_account_number
    alp.search

    alp.item_row(cg_account_number).exist?.should
    alp.copy_random
  end

  @account = make AccountObject
  @account.absorb! :old
  @account.edit description: @account.description # This will be auto-generated, but not auto-populated
  #               number:      @account.number
  step 'I add the account to the stack'
end

And /^the fields from the old Account populate those in the new Account document$/ do
  # I make a temporary data object by absorbing the 'New' Account information
  # I compare that 'New' d.o. to the 'Old' d.o. (@account)
  @account = make AccountObject
  @account.absorb! :new
  step 'I add the account to the stack'

  (@accounts[0] == @accounts[1]).should
end

And /^I add the account to the stack$/ do
  @accounts = @accounts.nil? ? [@account] : @accounts + [@account]
end

And /^I update the Account with the following changes:$/ do |updates|
  updates = updates.rows_hash.snake_case_key

  # Now go through and make sure anything with "Same as Original" pulls from the previous one.
  # We assume that we have at least two accounts in the stack and that the last one is the account to update.
  updates.each do |k, v|
    new_val = case v
                when 'Same as Original'
                  @accounts[-2].instance_variable_get("@#{k}")
                when 'Checked'
                  :set
                when 'Unchecked'
                  :clear
                when 'Random'
                  case k
                    when :description
                      random_alphanums(37, 'AFT')
                    when :number
                      random_alphanums(7).upcase
                    else
                      v # No change
                  end
                else
                  v # No change
              end
    updates.store k, new_val
  end

  # If you need to support additional fields, you'll need to implement them above.

  @account.edit updates

  # Now, let's make sure the changes persisted.
  on AccountPage do |page|
    values_on_page = page.account_data_new
    values_on_page.keys.each do |cfda_field|
      unless updates[cfda_field].nil?
        @account.instance_variable_get("@#{cfda_field}").should == updates[cfda_field]
        values_on_page[cfda_field].should == @account.instance_variable_get("@#{cfda_field}")
      end
    end
  end

  @accounts[-1] = @account # Update that stack!
end

And /^I update the Account's Contracts and Grants tab with the following changes:$/ do |updates|
  updates = updates.rows_hash.snake_case_key

  # Now go through and make sure anything with "Same as Original" pulls from the previous one.
  # We assume that we have at least two accounts in the stack and that the last one is the account to update.
  updates.each do |k, v|
    new_val = case v
                when 'Same as Original'
                  @accounts[-2].instance_variable_get("@#{k}")
                when 'Checked'
                  :set
                when 'Unchecked'
                  :clear
                else
                  v
              end
    updates.store k, new_val
  end
  # If you need to support additional fields, you'll need to implement them above.

  @account.edit updates

  # Now, let's make sure the changes persisted.
  on AccountPage do |page|
    values_on_page = page.account_data_new
    [
      :contract_control_chart_of_accounts_code, :contract_control_account_number,
      :account_icr_type_code, :indirect_cost_rate, :cfda_number, :cg_account_responsibility_id,
      :invoice_frequency_code, :invoice_type_code, :everify_indicator, :cost_share_for_project_number
    ].each do |cfda_field|
      unless updates[cfda_field].nil?
        @account.instance_variable_get("@#{cfda_field}").should == updates[cfda_field]
        values_on_page[cfda_field].should == @account.instance_variable_get("@#{cfda_field}")
      end
    end
  end

  @accounts[-1] = @account # Update that stack!
end

And /^I copy the old Account's Indirect Cost Recovery tab to the new Account$/ do
  update = @accounts[-2].icr_accounts.to_hash
  @account.edit update
  @accounts[-1] = @account # Update that stack!
end

And /^I add an additional Indirect Cost Recovery Account if the Account's Indirect Cost Recovery tab is empty$/ do
  if @account.icr_accounts.length < 1 || @account.icr_accounts.account_line_percent_sum < 100
    @account.icr_accounts.add chart_of_accounts_code: get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE),
                              account_number:         '',
                              account_line_percent:   (@account.icr_accounts.length < 1 ? '100' : (100 - @account.icr_accounts.account_line_percent_sum).to_s),
                              active_indicator:       :set
    @accounts[-1] = @account # Update that stack!
  end
end

Then /^the values submitted for the Account document persist$/ do
  # Now, let's make sure the changes persisted.
  on AccountPage do |page|
    values_on_page = page.account_data_new

    values_on_page.keys.each do |cfda_field|
      unless values_on_page[cfda_field].nil?
        value_in_memory = @account.instance_variable_get("@#{cfda_field}")

        if values_on_page[cfda_field].is_a? String
          # We'll compare case-insensitively because KFS will correct most values accordingly post-submission.
          values_on_page[cfda_field].upcase.eql_ignoring_whitespace?(value_in_memory.upcase).should be true
        else
          values_on_page[cfda_field].should == value_in_memory
        end
      end
    end
  end
  icra_collection_on_page = @account.icr_accounts.updates_pulled_from_page :old
  icra_collection_on_page.each_with_index { |icra, i| icra.should == @account.icr_accounts[i].to_hash }
end


# Active CG account needs to be non-expired account AND needs to have non-expired continuation account
# Fastest way to obtain this type of account is to have the method look for an account with a NULL account expiration
# date and a NULL continuation account.
And /^I find an unexpired CG Account that has an unexpired continuation account$/ do
  default_chart = get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
  accounts_hash = get_kuali_business_objects('KFS-COA','Account',"chartOfAccountsCode=#{default_chart}&subFundGroup.fundGroupCode=CG&closed=N")
  accounts = accounts_hash['org.kuali.kfs.coa.businessobject.Account']

  unless accounts.nil? || accounts.empty?
    valid_account_not_found = true
    index = 0

    while valid_account_not_found & (index < accounts.size)
      expiration_date = accounts[index]['accountExpirationDate'][0]
      continuation_account = accounts[index]['continuationAccountNumber'][0]
      if expiration_date.eql?('null') && continuation_account.eql?('null')
        @account = make AccountObject
        @account.absorb_webservice_item! accounts[index]
        valid_account_not_found = false
      end
      index += 1
    end #while-loop
  end #if-statement


end



# Active CG account needs to be non-expired account AND needs to have non-expired continuation account
# Fastest way to get this data is to have the method look for an account with a NULL account expiration date and
# a NULL continuation account.
And /^I find an unexpired CG Account not matching the remembered From Account that has an unexpired continuation account$/ do
  default_chart = @remembered_from_account.chart_code
  account_not_to_match = @remembered_from_account.number
  accounts_hash = get_kuali_business_objects('KFS-COA','Account',"chartOfAccountsCode=#{default_chart}&subFundGroup.fundGroupCode=CG&closed=N")
  accounts = accounts_hash['org.kuali.kfs.coa.businessobject.Account']

  unless accounts.nil? || accounts.empty?
    valid_account_not_found = true
    index = 0

    while valid_account_not_found & (index < accounts.size)
      expiration_date = accounts[index]['accountExpirationDate'][0]
      continuation_account = accounts[index]['continuationAccountNumber'][0]
      account_number = accounts[index]['accountNumber'][0]
      if expiration_date.eql?('null') && continuation_account.eql?('null') && !(account_number.eql?(account_not_to_match))
        @account = make AccountObject
        @account.absorb_webservice_item! accounts[index]
        valid_account_not_found = false
      end
      index += 1
    end #while-loop
  end #if-statement
end


And /^I edit the Indirect Cost Rate on the Account to the remembered (From|To) Indirect Cost Rate$/ do |target|
  case target
    when 'From'
      indirect_cost_rate = @remembered_from_indirect_cost_recovery_rate.rate_id
    when 'To'
      indirect_cost_rate = @remembered_to_indirect_cost_recovery_rate.rate_id
  end

  on AccountPage do |page|
    #update the account object with changes and then use that object to edit the page
    @account.account_icr_type_code = '01'
    @account.indirect_cost_rate = indirect_cost_rate
    page.account_icr_type_code.fit @account.account_icr_type_code
    page.indirect_cost_rate.fit @account.indirect_cost_rate
  end
end


And /^I remember the Account as the (From|To) Account$/ do |target|
  case target
    when 'From'
      @remembered_from_account = @account
    when 'To'
      @remembered_to_account = @account
    else
      pending "I don't know how to remember a \" #{target} \" Account."
  end
end
