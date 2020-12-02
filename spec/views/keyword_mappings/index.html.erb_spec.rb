require 'rails_helper'

RSpec.describe "keyword_mappings/index", type: :view do
  before(:each) do
    assign(:keyword_mappings, [
      KeywordMapping.create!(
        channel_id: "Channel",
        keyword: "Keyword",
        message: "Message"
      ),
      KeywordMapping.create!(
        channel_id: "Channel",
        keyword: "Keyword",
        message: "Message"
      )
    ])
  end

  it "renders a list of keyword_mappings" do
    render
    assert_select "tr>td", text: "Channel".to_s, count: 2
    assert_select "tr>td", text: "Keyword".to_s, count: 2
    assert_select "tr>td", text: "Message".to_s, count: 2
  end
end
