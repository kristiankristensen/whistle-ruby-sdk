module Whistle
  module Sdk
    class Base
      def create_conn_object(url)
        Faraday.new(:url => url,
                    :user_agent => 'Whistle Ruby SDK') do |builder|
          builder.use Faraday::Response::Mashify
          builder.use Faraday::Response::ParseJson
#          builder.use Faraday::Response::Logger
          builder.use Faraday::Response::RaiseError
          builder.use Faraday::Request::JSON
          builder.use Faraday::Request::UrlEncoded
          builder.adapter Faraday.default_adapter
        end
      end
    end

  end
end
