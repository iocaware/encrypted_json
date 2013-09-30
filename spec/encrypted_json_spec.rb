require 'spec_helper'

describe EncryptedJson do 
	describe "round trip private encryption/decryption" do
		it 'round trip as string' do 
			"a string".should round_trip_private_encrypted_json
		end
		
		it "round-trips an array of strings and ints" do
      		[1, 'a', 2, 'b'].should round_trip_private_encrypted_json
    	end

    	it "round-trips a hash with string keys, string and int values" do
     		{ 'a' => 'b', 'b' => 2 }.should round_trip_private_encrypted_json
    	end

    	it "round-trips a nested array" do
      		[ 'a', [ 'b', [ 'c', 'd' ], 'e' ], 'f' ].should round_trip_private_encrypted_json
    	end

    	it "round-trips a hash/array/string/int structure" do
     		{ 'a' => [ 'b' ], 'd' => { 'e' => 'f' }, 'g' => 10 }.should round_trip_private_encrypted_json
    	end
	end



	describe "round trip public encryption/decryption" do
		it 'round trip as string' do 
			"a string".should round_trip_public_encrypted_json
		end
		
		it "round-trips an array of strings and ints" do
      		[1, 'a', 2, 'b'].should round_trip_public_encrypted_json
    	end

    	it "round-trips a hash with string keys, string and int values" do
     		{ 'a' => 'b', 'b' => 2 }.should round_trip_public_encrypted_json
    	end

    	it "round-trips a nested array" do
      		[ 'a', [ 'b', [ 'c', 'd' ], 'e' ], 'f' ].should round_trip_public_encrypted_json
    	end

    	it "round-trips a hash/array/string/int structure" do
     		{ 'a' => [ 'b' ], 'd' => { 'e' => 'f' }, 'g' => 10 }.should round_trip_public_encrypted_json
    	end
	end

	describe "Secure#encrypt" do

    	it "returns a string" do
    		encrypter = EncryptedJson::Secure.new(File.read("spec/private.pem"), 'abcd').encrypt('test')
      		encrypter.should be_instance_of(String)
    	end

    	it "returns a valid JSON-encoded array" do
     		encrypter = EncryptedJson::Secure.new(File.read("spec/private.pem"), 'abcd').encrypt('test')
      		JSON.parse(encrypter).should be_instance_of(Array)
    	end
  	end

end