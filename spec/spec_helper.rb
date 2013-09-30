require "encrypted_json"
RSpec::Matchers.define :round_trip_private_encrypted_json do
	match do | actual |
		encrypter = EncryptedJson::Secure.new(File.read("spec/private.pem"), 'abcd')
		decrypter = EncryptedJson::Secure.new(File.read("spec/public.pem"))

		@encoded = encrypter.encrypt(actual)
		@decoded = decrypter.decrypt(@encoded)

		if @encoded == actual
			fail_because :not_encrypted
		elsif @decoded != actual
			fail_because :mismatch
		else
			true
		end
	end

	def fail_because(reason_code)
		@reason = reason_code
		false
	end

	failure_message_for_should do | actual | 
		if @reason == :not_encrypted
			"Expected encrypted to be different to original input: #{actual}"
		elsif @reason == :mismatch
			"Expected decdoe to equal original input, got '#{@decoded}'"
		end
	end
end

RSpec::Matchers.define :round_trip_public_encrypted_json do
	match do | actual |
		encrypter = EncryptedJson::Secure.new(File.read("spec/public.pem"))
		decrypter = EncryptedJson::Secure.new(File.read("spec/private.pem"), 'abcd')

		@encoded = encrypter.encrypt(actual)
		@decoded = decrypter.decrypt(@encoded)

		if @encoded == actual
			fail_because :not_encrypted
		elsif @decoded != actual
			fail_because :mismatch
		else
			true
		end
	end

	def fail_because(reason_code)
		@reason = reason_code
		false
	end

	failure_message_for_should do | actual | 
		if @reason == :not_encrypted
			"Expected encrypted to be different to original input: #{actual}"
		elsif @reason == :mismatch
			"Expected decdoe to equal original input, got '#{@decoded}'"
		end
	end
end