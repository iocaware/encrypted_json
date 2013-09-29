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

  	def public_encrypt(input) 
  		begin
  			[sign(input), Base64.encode64(key.public_encrypt(input.to_json))]
  		rescue
  			raise EncryptionError
  		end
  	end

  	def public_decrypt(input)
  		data = ""
  		digest, edata = json_decode(input)
  		begin
  			data = Base64.decode64(key.public_decrypt(edata))
  		rescue 
  			raise DecryptionError
  		end
  		raise SignatureError unless digest == sign(data)
  		data
  	end

  	def private_encrypt(input)
  		begin
  			[sign(input), Base64.encode64(key.private_encrypt(input.to_json, password))]
  		rescue
  			raise EncryptionError
  		end
  	end

  	def private_decrypt(input, password)
  		data = ""
  		digest, edata = json_decode(input)
  		begin
  			data = Base64.decode64(key.private_decrypt(edata), password)
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
  		secret = Digest::MD5.hexdigest(key.to_der)
  		OpenSSL::HMAC.hexdigest(digest, secret, input.to_json)
  	end
  end
end
