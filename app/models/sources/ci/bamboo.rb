require 'open-uri'

module Sources
  module Ci
    class Bamboo < Sources::Ci::Base

      def get(server_url, project, options = {})
        result = request_build_status(server_url, project)
        {
          :label => result["results"]["result"][0]["planName"],
          :current_status => parse_status(result["results"]["result"][0]["lifeCycleState"])
        }
      end

      private

      def request_build_status(server_url, project)
        url = "#{server_url}rest/api/latest/result/#{project}.json?expand=results[0].result"
        Rails.logger.debug("Requesting from #{url} ...")
        JSON.parse(::HttpService.request(url))
      end

      def parse_status(result)
        result == "Finished" ? 0 : -1
      end
    end
      
  end
end
