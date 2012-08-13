require "spec_helper"

describe Sources::Ci::Bamboo do

  before do
    @ci = Sources::Ci::Bamboo.new
    @server_url = "http://localhost/"
    @project = "test-build"
    @expected_url = "http://localhost/rest/api/latest/result/test-build.json?expand=results[0].result"
  end

  describe "label" do
    
    it "should return project name in the label" do
      json_response = %{{"results":{"result":[{"planName":"planName","projectName":"projName","state":"Successful","number":200}]}}}

      ::HttpService.expects(:request).with(@expected_url).returns(json_response)
      @ci.get(@server_url, @project)[:label].should == "planName"
    end

  end

  describe "status" do

    it "should return 0 for finished state" do
      json_response = %{{"results":{"result":[{"lifeCycleState":"Finished"}]}}}
      ::HttpService.expects(:request).with(@expected_url).returns(json_response)
      @ci.get(@server_url, @project)[:current_status].should == 0
    end

    it "should returns -1 otherwise" do
      json_response = %{{"results":{"result":[{"lifeCycleState":"Whatever"}]}}}
      ::HttpService.expects(:request).with(@expected_url).returns(json_response)
      @ci.get(@server_url, @project)[:current_status].should == -1
    end
  end

end
