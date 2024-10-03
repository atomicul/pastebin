class Pastedatum
  include Mongoid::Document
  include Mongoid::Timestamps

  field :data, type: String

  def initialize(attrs = nil, &block)
    super

    raise ArgumentError.new("Missing required argument: password") unless attrs[:password].present?
    raise ArgumentError.new("Missing required argument: data") unless attrs[:data].present?

    self.password = attrs[:password]
    self.data = attrs[:data]
  end

  def data=(data)
    write_attribute(:data, Encrypt.encrypt(data, password))
  end

  def data
    Encrypt.decrypt(read_attribute(:data), password)
  end

  def password
    raise "Missing encryption password" unless @password.present?
    @password
  end

  def password=(pass)
    raise TypeError unless pass.is_a?(String)
    @password = pass
  end
end