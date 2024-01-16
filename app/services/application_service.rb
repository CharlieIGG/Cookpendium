# frozen_string_literal: true

# base service class, used to help classes implement the Class.call pattern
class ApplicationService
  def self.call(*args, **kwargs, &block)
    new(*args, **kwargs, &block).call
  end

  def initialize(*args)
    raise NotImplementedError
  end

  def call
    raise NotImplementedError
  end
end
