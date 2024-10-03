require "openssl"

module Encrypt
  private
  def self.get_cipher = OpenSSL::Cipher::AES128.new(:CBC)
  def self.keygen(pass, salt) = OpenSSL::PKCS5.pbkdf2_hmac_sha1(pass, salt, 2000, 16)


  public
  def self.encrypt(data, password)
    raise TypeError unless data.is_a?(Hash)
    data=data.to_json
    cipher = get_cipher
    cipher.encrypt
    iv = cipher.random_iv
    cipher.key=keygen(password, iv)

    encrypted_data = cipher.update(data) + cipher.final

    Base64.urlsafe_encode64(encrypted_data) + '.' + Base64.urlsafe_encode64(iv)
  end

  def self.decrypt(encrypted, password)
    cipher = get_cipher
    cipher.decrypt
    encrypted, salt = encrypted.split('.').map{|str| Base64.urlsafe_decode64(str)}
    cipher.iv=salt
    cipher.key=keygen(password, salt)

    data = cipher.update(encrypted) + cipher.final

    ActiveSupport::JSON.decode(data)
  end
end
