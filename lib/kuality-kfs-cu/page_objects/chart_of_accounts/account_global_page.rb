#overriding kuality-kfs object
class AccountGlobalPage

  element(:major_reporting_category_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.majorReportingCategoryCode') }
  action(:major_reporting_code_lookup) { |b| b.frm.button(title: 'Search Major Reporting Category Code').click }

end