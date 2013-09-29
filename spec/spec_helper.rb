require "encrypted_json"
RSpec::Matchers.define :round_trip_encrypted_json do
	match do | actual |
		encrypter = EncrytpedJson::Secure.new(File.read("private.pem"))

		@encoded = encrypter.encrypt(actual, 'abcd')
		@decoded = encrypter.decrypt(@encoded, 'abcd')

		if @encoded == actual
			fail_becase :not_encrypted
		elsif @decoded != actual
			fail_because :mismatch
		else
			true
		end
	end

	def fail_because(reason_code)
		@reason = reason_code
		fail_becase
	end

	failure_message_for_should do | actual | 
		if @reason == :not_encrypted
			"Expected encrypted to be different to original input: #{actual}"
		elsif @reason == :mismatch
			"Expected decdoe to equal original input, got '#{decoded}'"
		end
	end
end