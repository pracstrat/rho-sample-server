require File.join(File.dirname(__FILE__),'..','spec_helper')

describe "Todo" do
  it_should_behave_like "SpecHelper" do
    before(:each) do
      setup_test_for Todo,'testuser'
    end

    it "should process Todo query" do
      pending
    end

    it "should process Todo create" do
      pending
    end

    it "should process Todo update" do
      pending
    end

    it "should process Todo delete" do
      pending
    end
  end  
end