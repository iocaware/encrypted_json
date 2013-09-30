require "json"
require "base64"
require "encrypted_json/version"
require "encrypted_json/errors"
require 'openssl' unless defined?(OpenSSL)

module EncryptedJson
  class Secure

  	def initialize(key, password='', digest='SHA1')
  		if password != ''
  			@key = OpenSSL::PKey::RSA.new(key, password)
  		else
  			@key = OpenSSL::PKey::RSA.new(key)
  		end
  		@digest = digest
  	end

  	def encrypt(input, password = '') 
  		if input.is_a?(String)
  			i = input
  		else
  			i = input.to_json
  		end
  		begin
  			if @key.private?
  				data = Base64.encode64(@key.private_encrypt(i))
  			else
  				data = Base64.encode64(@key.public_encrypt(i))
  			end
  			[sign(i), data].to_json
  		rescue => e
  			raise EncryptionError
  		end
  	end

  	def decrypt(input, password = '')
  		data = ""
  		digest, edata = json_decode(input)
  		begin
  			if @key.private?
  				data = @key.private_decrypt(Base64.decode64(edata))
  			else
  				data = @key.public_decrypt(Base64.decode64(edata))
  			end
  		rescue => e
  			raise DecryptionError
  		end
  		raise SignatureError unless digest == sign(data)
  		begin
  			JSON.parse(data)
  		rescue
  			data
  		end
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
  		OpenSSL::HMAC.hexdigest(digest, secret, input)
  	end
  end
end
