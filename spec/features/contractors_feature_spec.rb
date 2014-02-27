require File.dirname(__FILE__) + '/../spec_helper'

describe "demo", :type => :feature do

  before(:each) do
    visit "/contractors?demo=y"
  end

  it "page loads with data in table with no errors" do
    page.should have_css("table#contractors-table tr")
    page.should_not have_content "Loading..."
    get_rows.each do |row|
      within(row){
        [".first_name", ".last_name", ".roles a", '.phone', '.notes'].each do |css|
          page.should have_css css
        end
        find(".first_name").should_not eq nil
        find(".last_name").should_not eq nil
      }
    end
  end

  it "Sorting by first name column" do
    find('th', :text=>"First Name").click
    page.should have_css ".first_name.sorting_asc"
    first_names = all("table#contractors-table tbody tr > td:nth-child(2)").map(&:text)
    first_names.should eq first_names.sort
  end
  
  it "Searching for records" do
    search_text = ([*('A'..'Z'),*('a'..'z')]-%w(0 1 I O)).sample(2).join

    find("#contractors-table_filter input").set(search_text)
    page.should_not have_content "Loading..."
    rows = get_rows.map(&:text)
    
    if page.has_css?(".dataTables_empty")
      find(".dataTables_empty").text.should eq "No matching records found"
    else
      rows.each do |row|
        row.downcase.should include search_text.downcase
      end
    end
  end

  it "Edit the phone number", js: true do
    phone_num = rand(10 ** 10)
    page.should_not have_content "Loading..."
    rows = get_rows
    row = rows[rand(rows.count)]
    within(row){
      find(".phone").click
      sleep 1
      within(".phone"){
        fill_in "value", with: phone_num
        find("input").native.send_keys(:enter)
        sleep 1
      }
      find(".phone").text.to_i.should eq phone_num
    }
  end

  def get_rows
    all("table#contractors-table tbody tr")
  end

end
