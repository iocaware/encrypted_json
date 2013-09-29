require "json"
require "base64"
require "encrypted_json/version"
require "encrypted_json/errors"
require 'openssl' unless defined?(OpenSSL)

module EncryptedJson
  class Secure
  	def initialize(key, digest='SHA1')
  		@key = OpenSSL::PKey::RSA.new(key)
  		@digest = digest
  	end

  	def encrypt(input, password = '') 
  		begin
  			if @key.private?
  				data = Base64.encode64(@key.private_encrypt(input.to_json, password))
  			else
  				data = Base64.encode64(@key.public_encrypt(input.to_json))
  			end
  			[sign(input), data]
  		rescue
  			raise EncryptionError
  		end
  	end

  	def decrypt(input, password = '')
  		data = ""
  		digest, edata = json_decode(input)
  		begin
  			if @key.private?
  				data = Base64.decode64(@key.private_decrypt(edata, password))
  			else
  				data = Base64.decode64(@key.public_decrypt(edata))
  			end
  		rescue 
  			raise DecryptionError
  		end
  		raise SignatureError unless digest == sign(data)
  		data
  	end

  	def json_decode(input)
  		begin
  			parts = JSON.parse(input)
  		rescue TypeError, JSON::ParserError
  			raise InputError
  		end
  		raise InputError unless parts.instance_of?(Array) && parts.length == 2
  		parts		
  	end

  	def sign(input)
  		digest = OpenSSL::Digest.const_get(@digest).new
  		if @key.private?
  			secret = Digest::MD5.hexdigest(@key.public_key.to_der)
  		else
  			secret = Digest::MD5.hexdigest(@key.to_der)
  		end
  		OpenSSL::HMAC.hexdigest(digest, secret, input.to_json)
  	end
  end
end
