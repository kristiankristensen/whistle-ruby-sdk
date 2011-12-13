module Whistle
  module Sdk
    class AuthSession < Base
      attr_accessor :auth_url, :realm, :username, :password
      attr_reader :auth_pipe, :auth_token, :account_id, :owner_id, :api_url, :api_pipe, :api_token

      def initialize(options)
        @auth_url = options[:url]
        @realm = options[:realm]
        @username = options[:username]
        @password = options[:password]

        @auth_pipe = create_conn_object(auth_url)
      end

      def is_authenticated?
        return !auth_token.nil?
      end

      def new_session
        authenticate! unless is_authenticated?
        return ApiSession.new(:auth_token => api_token, :api_url => api_url, :realm => realm, :account_id => account_id, :owner_id => owner_id)
      end

      def get_credentials_hash
        return Digest::MD5.hexdigest("#{username}:#{password}")
      end

      def authenticate!
        req = {:data => {:credentials => get_credentials_hash, :realm => realm}, :verb => 'PUT'}
        response = auth_pipe.put 'user_auth', req
        @auth_token = response.body.auth_token
        @account_id = response.body.data.account_id
        @owner_id = response.body.data.owner_id

        @api_url = select_session_endpoint_app('voip')
        @api_pipe = create_conn_object(api_url)
        shared_auth
      end

      def shared_auth
        req = {:data => {:realm => realm, :account_id => account_id, :shared_token => auth_token}, :verb => 'PUT'}
        resp = @api_pipe.put 'shared_auth', req
        @api_token = resp.body.auth_token
        return api_token
      end

      def get_endpoint_apps
        auth_pipe.get "accounts/#{account_id}/users/#{owner_id}", 'X-Auth-Token' => auth_token
      end

      def select_session_endpoint_app(name)
        apps = get_endpoint_apps
        @api_url = apps.body.data.apps[name].api_url
        return api_url
      end
    end
  end
end
