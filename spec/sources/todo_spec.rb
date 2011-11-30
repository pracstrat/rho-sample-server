require File.join(File.dirname(__FILE__),'..','spec_helper')

describe "Todo" do
  it_should_behave_like "SpecHelper" do
    before(:each) do
      setup_test_for Todo,'testuser'
    end

    it "should process Todo query" do
      test_query.size.should > 0
      query_errors.should == {}
    end

    it "should process Todo create" do
      @todo = {
        'content' => 'foo',
        'done' => 'true'
      }
      new_todo_id = test_create(@todo)
      create_errors.should == {}
      md[new_todo_id]['content'].should == @todo['content']
      md[new_todo_id]['done'].should == @todo['done']
    end

    it "should process Todo update" do
      @todo = {
        'content' => 'foo',
        'done' => 'true'
      }
      new_todo_id = test_create(@todo)
      @new_todo = {
        'content' => 'bar'
      }
      test_update(new_todo_id => @new_todo)
      update_errors.should == {}
      test_query
      md[new_todo_id]['content'].should == @new_todo['content']
    end

    it "should process Todo delete" do
      @todo = {
        'content' => 'foo',
        'done' => 'true'
      }
      new_todo_id = test_create(@todo)
      test_delete(new_todo_id => @todo)
      delete_errors.should == {}
      md.should == {}
    end
  end  
end