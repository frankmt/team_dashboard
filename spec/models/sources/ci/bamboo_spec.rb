require "spec_helper"

describe Sources::Ci::Bamboo do

  before do
    @ci = Sources::Ci::Bamboo.new
    @server_url = "http://localhost/"
    @project = "test-build"
  end

  describe "label" do
    
    it "should return project name in the label" do
      expected_url = "http://localhost/rest/api/latest/result/test-build.json?expand=results[0].result"
      json_response = %{{"results":{"result":[{"planName":"planName","projectName":"projName","state":"Successful","number":200}]}}}

      ::HttpService.expects(:request).with(expected_url).returns(json_response)
      @ci.get(@server_url, @project)[:label].should == "planName"
    end

  end

end
