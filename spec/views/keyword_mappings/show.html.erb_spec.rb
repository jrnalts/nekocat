require 'rails_helper'

RSpec.describe "keyword_mappings/show", type: :view do
  before(:each) do
    @keyword_mapping = assign(:keyword_mapping, KeywordMapping.create!(
      channel_id: "Channel",
      keyword: "Keyword",
      message: "Message"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Channel/)
    expect(rendered).to match(/Keyword/)
    expect(rendered).to match(/Message/)
  end
end
