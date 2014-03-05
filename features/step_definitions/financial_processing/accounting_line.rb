Then /^"([^"]*)" should not be displayed in the Accounting Line section$/ do |msg|
 on(AdvanceDepositPage).errors.should_not include msg
end

When /^I add a (source|target) Accounting Line for the (.*) document$/ do |line_type, document|
  doc_object = snake_case document
  page_klass = Kernel.const_get(get(doc_object).class.to_s.gsub(/(.*)Object$/,'\1Page'))

  on page_klass do
    case line_type
      when 'source'
        get(doc_object).
          add_source_line({
                     chart_code:               @account.chart_code,
                     account_number:           @account.number,
                     object:                   '4480',
                     reference_origin_code:    '01',
                     reference_number:         '777001',
                     amount:                   '25000.11'
                   })
      when 'target'
        get(doc_object).
          add_target_line({
                     chart_code:               @account.chart_code,
                     account_number:           @account.number,
                     object:                   '4480',
                     reference_origin_code:    '01',
                     reference_number:         '777002',
                     amount:                   '25000.11'
                   })
    end
  end
end

When /^I enter a (source|target) Accounting Line Description on the (.*) document$/ do |line_type, document|
  doc_object = get(snake_case(document))
  doc_object.accounting_lines[line_type.to_sym][0].edit line_description: "Hey #{line_type} edit works!"
end

When /^I remove (source|target) Accounting Line #([0-9]*) from the (.*) document$/ do |line_type, line_number, document|
  get(snake_case(document)).accounting_lines[line_type.to_sym].delete_at(line_number.to_i - 1)
end

Then /^the Accounting Line Description for the (.*) document equals the General Ledger Accounting Line Description$/ do |document|
  doc_object = get(snake_case(document))
  on AccountingLine do |lines|
    # We expect equal from and to lines, so this should be legit.
    0..doc_object.accounting_lines[:source].length do |l|
      lines.result_source_line_description(l).should == doc_object.accounting_lines[:source][l].line_description
      (lines.result_target_line_description(l).should == doc_object.accounting_lines[:target][l].line_description) unless doc_object.accounting_lines[:target].nil?
    end
  end
end

# This step is a little hairy and has potential to get much hairier. We may need to split it into
# multiple steps on document type if it gets worse.
And /^I add balanced Accounting Lines to the (Advance Deposit|Budget Adjustment|Credit Card Receipt|Disbursement Voucher|Distribution Of Income And Expense|General Error Correction|Internal Billing|Indirect Cost Adjustment|Journal Voucher|Non-Check Disbursement|Pre-Encumbrance|Service Billing|Transfer Of Funds) document$/ do |document|
  doc_object = get(snake_case(document))
  page_klass = Kernel.const_get(doc_object.class.to_s.gsub(/(.*)Object$/,'\1Page'))

  on page_klass do

    # Everybody has a source line at least
    new_source_line = {
        chart_code:     @accounts[0].chart_code,
        account_number: @accounts[0].number,
        object:         '4480',
        line_description: 'What a wonderful From line description!'
    }
    new_source_line.merge!({ amount: '100' }) unless document == 'Budget Adjustment'

    case document
      when'Budget Adjustment'
        new_source_line.merge!({
                               current_amount:   '250.11',
                               base_amount:      '125'
                             })
      when 'Advance Deposit'
      when'Auxiliary Voucher'
        new_source_line.merge!({
                                 object: '6690',
                                 debit:  '100',
                                 #credit: '100'
                               })
        new_source_line.delete(:amount)
      when 'General Error Correction'
        new_source_line.merge!({
                               reference_number:      '777001',
                               reference_origin_code: '01'
                             })
      when 'Pre-Encumbrance'
        new_source_line.merge!({
                                 object: '6100'
                               })
      when 'Internal Billing'
        new_source_line.merge!({
                                 object: '4023'
                               })
      when 'Indirect Cost Adjustment'
        new_source_line.delete(:object)
      when 'Transfer Of Funds'
        new_source_line.merge!({
                                   object: '8070'
                               })
      else
    end
    doc_object.add_source_line(new_source_line)

    # Some docs don't have a target line
    unless (document == 'Advance Deposit') || (document == 'Auxiliary Voucher') || (document == 'Pre-Encumbrance')
      new_target_line = {
          chart_code:     @accounts[1].chart_code,
          account_number: @accounts[1].number,
          object:         '4480',
          line_description: 'What a wonderful To line description!'
      }
      new_target_line.merge!({ amount: '100' }) unless document == 'Budget Adjustment'

      case document
        when'Budget Adjustment'
          new_target_line.merge!({
                               current_amount:   '250.11',
                               base_amount:      '125'
                             })
        when'General Error Correction'
          new_target_line.merge!({
                               reference_number:      '777002',
                               reference_origin_code: '01'
                             })
        when 'Pre-Encumbrance'
          new_target_line.merge!({
                                   object: '6100'
                                 })
        when 'Internal Billing'
          new_target_line.merge!({
                                   object: '4023'
                                 })
        when 'Indirect Cost Adjustment'
          new_target_line.delete(:object)
        when 'Transfer Of Funds'
          new_target_line.merge!({
                                   object: '7070'
                                 })
      end
      doc_object.add_target_line(new_target_line)
    end

    pending 'Test test'
  end
end

And /^I add balanced Accounting Lines to the Auxiliary Voucher document$/ do
  on AuxiliaryVoucherPage do
    new_source_line = {
        chart_code:     @accounts[0].chart_code,
        account_number: @accounts[0].number,
        line_description: 'What a wonderful From line description!',
        object: '6690',
        debit:  '100'
    }
    @auxiliary_voucher.add_source_line(new_source_line)
    new_source_line.delete(:debit)
    new_source_line.merge!({credit: '100'})
    @auxiliary_voucher.add_source_line(new_source_line)
  end
end

And /^I add a (source|target) Accounting Line to the (.*) document with the following:$/ do |line_type, document, table|
  accounting_line_info = table.rows_hash
  accounting_line_info.delete_if { |k,v| v.empty? }
  unless accounting_line_info['Number'].nil?
    doc_object = snake_case document
    page_klass = Kernel.const_get(get(doc_object).class.to_s.gsub(/(.*)Object$/,'\1Page'))

    on page_klass do
      case line_type
        when 'source'
          new_source_line = {
              chart_code:     accounting_line_info['Chart Code'],
              account_number: accounting_line_info['Number'],
              object:         accounting_line_info['Object Code'],
              amount:         accounting_line_info['Amount']
          }
          case document
            when'Budget Adjustment'
              new_source_line.merge!({
                                         object: '6510',
                                         current_amount:   accounting_line_info['Amount'],
                                         base_amount:      accounting_line_info['Amount']
                                     })
              new_source_line.delete(:amount)
            when 'Advance Deposit'
            when'Auxiliary Voucher', 'Journal Voucher'
              new_source_line.merge!({
                                         object: '6690',
                                         debit:  accounting_line_info['Amount']
                                     })
              new_source_line.delete(:amount)
              get(doc_object).add_source_line(new_source_line)
              new_source_line.merge!({
                                         credit:  accounting_line_info['Amount']
                                     })
              new_source_line.delete(:debit)
            when 'General Error Correction'
              new_source_line.merge!({
                                         reference_number:      '777001',
                                         reference_origin_code: '01'
                                     })
            when 'Pre-Encumbrance'
              new_source_line.merge!({
                                         object: '6100'
                                     })
            when 'Internal Billing', 'Service Billing'
              new_source_line.merge!({
                                         object: '4023'
                                     })
            when 'Indirect Cost Adjustment'
              new_source_line.delete(:object)
            when 'Non-Check Disbursement'
              new_source_line.merge!({
                                         reference_number:      '777001'
                                     })
            when 'Transfer Of Funds'
              new_source_line.merge!({
                                         object: '8070'
                                     })
            else
          end
          get(doc_object).add_source_line(new_source_line)
        when 'target'
          new_target_line = {
              chart_code:     accounting_line_info['Chart Code'],
              account_number: accounting_line_info['Number'],
              object:         accounting_line_info['Object Code'],
              amount:         accounting_line_info['Amount']
          }
          case document
            when'Budget Adjustment'
              new_target_line.merge!({
                                         object: '6540',
                                         current_amount:   accounting_line_info['Amount'],
                                         base_amount:      accounting_line_info['Amount']
                                     })
              new_target_line.delete(:amount)
            when'General Error Correction'
              new_target_line.merge!({
                                         reference_number:      '777002',
                                         reference_origin_code: '01'
                                     })
            when 'Pre-Encumbrance'
              new_target_line.merge!({
                                         object: '6100'
                                     })
            when 'Internal Billing', 'Service Billing'
              new_target_line.merge!({
                                         object: '4023'
                                     })
            when 'Indirect Cost Adjustment'
              new_target_line.delete(:object)
            when 'Transfer Of Funds'
              new_target_line.merge!({
                                         object: '7070'
                                     })
          end
          get(doc_object).add_target_line(new_target_line)
      end
    end
  end
end

And /^I add a source Accounting Line to the (.*) document with a bad object code$/ do |document|
  doc_object = snake_case document
  new_source_line = {
      chart_code:     'IT',
      account_number: 'G003704',
      object:         '4010',
      amount:         '300'
  }
  get(doc_object).add_source_line(new_source_line)
  get(doc_object).accounting_lines[:source].clear
end


Then /^the (.*) document accounting lines equal the General Ledger entries$/ do |document|
  # do a search for GL entries
  # go through each IB accounting line
  # match it with it's two entries in the gl
  doc_object = get(snake_case(document))

  visit(MainPage).general_ledger_entry
  on GeneralLedgerEntryLookupPage do |page|
    # We're assuming that Fiscal Year and Fiscal Period default to today's values
    page.doc_number.fit        doc_object.document_id
    page.balance_type_code.fit ''
    page.pending_entry_approved_indicator_all
    page.search

    # verify number of resuls is twice the number of accounting lines
    (page.results_table.rows.length-1).should == (doc_object.accounting_lines[:source].length + doc_object.accounting_lines[:target].length) * 2

    page.results_table.rows.each do |row|
    end

    all_accounting_lines = doc_object.accounting_lines[:source] + doc_object.accounting_lines[:target]
    all_accounting_lines.each do |accounting_line|
      found_original = false
      found_offset = false

      account_number_col = page.column_index(:account_number)
      amount_col = page.column_index(:transaction_ledger_entry_amount)
      description_col = page.column_index(:transaction_ledger_entry_description)

      page.results_table.rows.each do |row|
        puts row[account_number_col].text
        puts row[amount_col].text
        puts row[description_col].text
        puts row[amount_col].to_f
        puts Float(accounting_line.amount)
        puts Float(row[amount_col] == Float(accounting_line.amount.to_f)
        if row[account_number_col].text == accounting_line.account_number && (Float(row[amount_col]) == Float(accounting_line.amount))
          if row[description_col].text == accounting_line.description
            found_original = true
          else if row[description_col].text == 'TP Generated Offset'
                 found_offset = true
               end
          end
        end
      end
      found_original.should be true
      found_offset.should be true
      end

  end

  #doc_object.accounting_lines.each do |accounting_line|
  #  # find results row with account number and original object code and correct amount
  #  page.results_table.
  #  @account.number = page.results_table[account_row_index][page.column_index(:account_number)].text
  #  @account.chart_code = page.results_table[account_row_index][page.column_index(:chart_code)].text
  #  # find results row with account number and 'TP Generated Offset' along with correct amount
  #end

end