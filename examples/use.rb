$LOAD_PATH.unshift(File.dirname(__FILE__), '..', 'lib')

require 'rubygems'
require 'yaml'
require 'whistle-sdk'
require 'pp'

config = YAML.load(File.open('examples/config.yml'))


#api_url = 'http://apps001-demo-ord.2600hz.com:8000/v1'
#api_url = ''

api = Whistle::Sdk::AuthSession.new(:url => config['whistle']['url'],
                  :realm => config['whistle']['realm'],
                  :username => config['whistle']['username'],
                  :password => config['whistle']['password'])

session = api.new_session

devices = session.list_devices.data

device_id = devices[0].id

device = session.get_device(device_id)
pp device

#new_device = session.create_device()
#pp new_device

pp session.get_device_statuses
