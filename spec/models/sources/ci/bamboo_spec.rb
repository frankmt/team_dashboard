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
      hash_response = {"results" => {"result" => [{"planName" => "planName","projectName" => "projName","state" => "Successful","number" => 200}]}}
      ::HttpService.expects(:request).with(@expected_url).returns(hash_response)
      @ci.get(@server_url, @project)[:label].should == "planName"
    end

  end

  describe "status" do

    it "should return 0 for finished state" do
      hash_response = {"results" => {"result" => [{"lifeCycleState" => "Finished"}]}}
      ::HttpService.expects(:request).with(@expected_url).returns(hash_response)
      @ci.get(@server_url, @project)[:current_status].should == 0
    end

    it "should returns -1 otherwise" do
      hash_response = {"results" => {"result" => [{"lifeCycleState" => "Whatever"}]}}
      ::HttpService.expects(:request).with(@expected_url).returns(hash_response)
      @ci.get(@server_url, @project)[:current_status].should == -1
    end
  end

  describe "build_status" do

    it "should return 0 for successful" do
      hash_response = {"results" => {"result" => [{"state" => "Successful"}]}}
      ::HttpService.expects(:request).with(@expected_url).returns(hash_response)
      @ci.get(@server_url, @project)[:last_build_status].should == 0
    end

    it "should return 1 for failure" do
      hash_response = {"results" => {"result" => [{"state" => "Failed"}]}}
      ::HttpService.expects(:request).with(@expected_url).returns(hash_response)
      @ci.get(@server_url, @project)[:last_build_status].should == 1 
    end

    it "should returns -1 otherwise" do
      hash_response = {"results" => {"result" => [{"state" => "CRAZY"}]}}
      ::HttpService.expects(:request).with(@expected_url).returns(hash_response)
      @ci.get(@server_url, @project)[:last_build_status].should == -1 
    end
  end

end
