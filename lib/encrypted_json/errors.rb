module EncryptedJson
  class Error < RuntimeError; end
  class InputError < Error; end
  class SignatureError < Error; end
  class EncryptionError < Error; end
  class DecryptionError < Error; end
end