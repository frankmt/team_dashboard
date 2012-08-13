require 'open-uri'

module Sources
  module Ci
    class Bamboo < Sources::Ci::Base

      def get(server_url, project, options = {})
        result = request_build_status(server_url, project)
        {
          :label             => ""
        }
      end

    end
  end
end
