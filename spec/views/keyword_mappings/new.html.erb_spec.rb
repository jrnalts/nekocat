require 'rails_helper'

RSpec.describe "keyword_mappings/new", type: :view do
  before(:each) do
    assign(:keyword_mapping, KeywordMapping.new(
      channel_id: "MyString",
      keyword: "MyString",
      message: "MyString"
    ))
  end

  it "renders new keyword_mapping form" do
    render

    assert_select "form[action=?][method=?]", keyword_mappings_path, "post" do

      assert_select "input[name=?]", "keyword_mapping[channel_id]"

      assert_select "input[name=?]", "keyword_mapping[keyword]"

      assert_select "input[name=?]", "keyword_mapping[message]"
    end
  end
end
