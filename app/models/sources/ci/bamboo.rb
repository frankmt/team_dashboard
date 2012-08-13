require 'open-uri'

module Sources
  module Ci
    class Bamboo < Sources::Ci::Base

      def get(server_url, project, options = {})
        response = request_build_status(server_url, project)
        {
          :label => build_result(response)["planName"],
          :current_status => parse_status(build_result(response)["lifeCycleState"]),
          :last_build_time => Time.now,
          :last_build_status => parse_build_status(build_result(response)["state"])
        }
      end

      private

      def build_result(response)
        response["results"]["result"][0]
      end

      def request_build_status(server_url, project)
        url = "#{server_url}rest/api/latest/result/#{project}.json?expand=results[0].result"
        Rails.logger.debug("Requesting from #{url} ...")
        ::HttpService.request(url)
      end

      def parse_status(result)
        result == "Finished" ? 0 : -1
      end
      
      def parse_build_status(result)
        case result
        when /Successful/
          0
        when /Failed/
          1
        else
          -1
        end
      end
      
    end
      
  end
end
