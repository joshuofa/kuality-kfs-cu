Given /^I am logged in as a KFS Fiscal Officer$/ do
  visit LoginPage do |page|
    page.username.set 'jguillor'
    page.login
  end
end

Given(/^I am logged in as a KFS User$/) do
  visit LoginPage do |page|
    page.username.set 'khuntley'
    page.login
  end
end