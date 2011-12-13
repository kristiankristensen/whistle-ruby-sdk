module Whistle
  module Sdk
    class ApiSession < Base
      attr_reader :auth_token, :api_url, :realm, :account_id, :owner_id, :pipe

      def initialize(options)
        @auth_token = options[:auth_token]
        @api_url = options[:api_url]
        @realm = options[:realm]
        @account_id = options[:account_id]
        @owner_id = options[:owner_id]
        @pipe = create_conn_object(api_url)
      end

      def list_devices()
        return pipe.get("accounts/#{account_id}/devices",
                        'X-Auth-Token' => auth_token).body
      end

      def get_device(device_id)
        return pipe.get("accounts/#{account_id}/devices/#{device_id}",
                        'X-Auth-Token' => auth_token).body
      end

      def get_device_statuses
        return pipe.get("accounts/#{account_id}/devices/status",
                        'X-Auth-Token' => auth_token).body
      end

      def create_device(name)
        return pipe.put("accounts/#{account_id}/devices",
                        {:data => {:name => name}},
                        'X-Auth-Token' => auth_token).body
      end
    end
  end
end
