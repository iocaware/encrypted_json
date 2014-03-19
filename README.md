[![Gem Version](https://badge.fury.io/rb/encrypted_json.png)](http://badge.fury.io/rb/encrypted_json)
# EncryptedJson

This is a library to do encryption of JSON 

## Installation

Add this line to your application's Gemfile:

    gem 'encrypted_json'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install encrypted_json

## Usage

**Encryption**

```ruby
require "encrypted_json"

data = {}
data['test'] = "This is a test key"
data['hash'] = {}
data['hash']['key'] = "value"
data['array'] = [1,2,3]

e = EncryptedJson::Secure.new(File.read("private_key.pem"), 'password')
new_json = e.encrypt(data.to_json)
```

The json that will go into the encryption method will look exactly like you think it would
```json
{"test":"This is a test key","hash":{"key":"value"},"array":[1,2,3]}
```

The encrypted Json will come out different however

```json
["a6b95c04656c7baaabe70aae2c961beb417612c4","BEJnO9e+LIqXnFuD7ra24nGv7aWItfz6vBwBEAmpm6VJ3qVV6gFj4MhuKMKt\n7Z5sOfUDmwluN60xWOAu4m9MFI61aoLpsFCWcHTpQHkITc0PC8zNBx09pvTl\n8JugPDEr9BznBiHlmJBDKfbIfyUHvQkKNfCQJ6XGKU3U1Upm+J06QGe3erui\nzOmsdELfjcSJ9V8bS4qEIKZSsHccZHx0zFQQsWgjLlX47ZRFVSf3RvYdQ+qJ\n8I+pAlrmsi4vZ3IYXA9Y0nFIfpL1QrnQ93n/X9FGhYLrmt7+o/HDJw6+3uMM\nCEZ7YiWT+zYGhvMMMqTePKa+3XPTkQkl0P5VSuSWJ1tczeBI\n"]
```

The first node is the digital signature (HMAC) of the data, the second portion is the data encrypted with the private key. 

**Decryption**

```ruby
require "encrypted_json"

encrypted_json = "["a6b95c04656c7baaabe70aae2c961beb417612c4","BEJnO9e+LIqXnFuD7ra24nGv7aWItfz6vBwBEAmpm6VJ3qVV6gFj4MhuKMKt\n7Z5sOfUDmwluN60xWOAu4m9MFI61aoLpsFCWcHTpQHkITc0PC8zNBx09pvTl\n8JugPDEr9BznBiHlmJBDKfbIfyUHvQkKNfCQJ6XGKU3U1Upm+J06QGe3erui\nzOmsdELfjcSJ9V8bS4qEIKZSsHccZHx0zFQQsWgjLlX47ZRFVSf3RvYdQ+qJ\n8I+pAlrmsi4vZ3IYXA9Y0nFIfpL1QrnQ93n/X9FGhYLrmt7+o/HDJw6+3uMM\nCEZ7YiWT+zYGhvMMMqTePKa+3XPTkQkl0P5VSuSWJ1tczeBI\n"]"

e = EncryptedJson::Secure.new(File.read("public.key"))
data = JSON.parse(e.decrypt(encrypted_json))
```

**Errors**

There are multiple errors that can happen

* InputError - this is self explanitory
* SignatureError - this is an error when the signature does not match when doing decryption. 
* EncryptionError - this just means there was a problem during encryption
* DecryptionError - this just means there was a problem during decryption
