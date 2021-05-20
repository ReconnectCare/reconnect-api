module Exceptions
  class ApiDataError < StandardError
    attr_reader :errors, :status

    def initialize message = nil
      super
      @status = 422
    end

    def set_errors errors
      @errors = errors
      self
    end

    def set_status status
      @status = status
      self
    end
  end
end
