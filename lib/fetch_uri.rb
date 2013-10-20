# -*- encoding : utf-8 -*-
require 'uri'
require 'net/http'
require 'rest-client'
require 'json'

def fetch_uri(uri_str, limit = 10)
  raise ArgumentError, 'HTTP redirect too deep' if limit == 0

  uri = URI.parse(uri_str)
  response = Net::HTTP.get_response(uri)
  case response
  when Net::HTTPSuccess     then response
  when Net::HTTPRedirection then fetch_uri(new_location(uri, response['location']), limit - 1)
  else
    response.error!
  end
end

def post_uri(uri_str, args = {}, limit = 10)
  raise ArgumentError, 'HTTP redirect too deep' if limit == 0

  uri = URI.parse(uri_str)
  response = Net::HTTP.post_form(uri, args)
  case response
  when Net::HTTPSuccess     then response
  when Net::HTTPRedirection then post_uri(new_location(uri, response['location']), args, limit - 1)
  else
    response.error!
  end
end

def new_location(uri, location)
  target = URI.parse(location)
  return target.to_s if target.host

  uri.path = target.path
  uri.opaque = target.opaque
  uri.query = target.query
  uri.fragment = target.fragment
  return uri.to_s
end

def post_link(addr, title, user, channel, endpointUri, accessToken)
	puts "post_link called: address: #{addr} title: #{title}, user: #{user}, channel: #{channel}"
	jsonData = { Url: addr, User: user, Title: title, Channel: channel}
	response = RestClient.post endpointUri, jsonData.to_json, { :content_type => :json, :accept => :json, 'Linx-Access-Token' => accessToken}
	puts "post_link: status code #{response.code}"
	if response.code != 200
		puts "post_link: response #{response.to_str}"
	end
	response.code == 200 ? JSON.parse(response)["Data"]["Title"] : nil
end
