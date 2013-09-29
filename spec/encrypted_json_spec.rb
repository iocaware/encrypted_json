require 'spec_helper'

describe EncryptedJson do 
	describe "round trip encryption/decryption" do
		it 'round trip as string' do 
			"a string".should round_trip_encrypted_json
		end
	end
end