module Tokenable
  extend ActiveSupport::Concern

  module ClassMethods
    def acts_as_tokenable(token_column, token_prefix='', token_length=10)
      class_attribute :token_column, :token_prefix, :token_length
      self.token_column = token_column
      self.token_prefix = token_prefix
      self.token_length = token_length
      before_validation :generate_token, on: :create
    end
  end

  def generate_token
    unless send("#{token_column}?")
      record = true
      while record
        random = token_prefix + token_length.times.map { rand(10)  }.join
        record = self.class.find_by(token_column => random)
      end
      self.send("#{token_column}=", random)
    end
    send(token_column)
  end
end

class ActiveRecord::Base
  include Tokenable
end