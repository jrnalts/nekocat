require 'rails_helper'

RSpec.describe "keyword_mappings/edit", type: :view do
  before(:each) do
    @keyword_mapping = assign(:keyword_mapping, KeywordMapping.create!(
      channel_id: "MyString",
      keyword: "MyString",
      message: "MyString"
    ))
  end

  it "renders the edit keyword_mapping form" do
    render

    assert_select "form[action=?][method=?]", keyword_mapping_path(@keyword_mapping), "post" do

      assert_select "input[name=?]", "keyword_mapping[channel_id]"

      assert_select "input[name=?]", "keyword_mapping[keyword]"

      assert_select "input[name=?]", "keyword_mapping[message]"
    end
  end
end
