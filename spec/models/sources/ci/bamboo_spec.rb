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
      json_response = "{\"results\":{\"result\":[\"planName\":\"reaxchange-deploy\",\"projectName\":\"REAXchange\",\"lifeCycleState\":\"Finished\"}"

      ::HttpService.stub(:request).with(expected_url).and_return(json_response)
      @ci.get(@server_url, @project).label.should == "planName"
    end

  end

end
