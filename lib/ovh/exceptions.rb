module OVH
  # Base OVH API exception, all specific exceptions inherits from it.
  class APIError < StandardError
    def initialize(msg = nil, http_response = nil)
      super(msg)
      @query_id = http_response&.dig("X-Ovh-Queryid")
    end

    def to_s
      s = super.to_s
      if @query_id
        s += " (Query ID: #{@query_id})"
      end
      return s
    end
  end

  # Raised when the request fails at a low level (DNS, network, ...)
  class HTTPError < APIError
  end

  # Raised when trying to sign request with invalid key
  class InvalidKey < APIError
  end

  # Raised when trying to sign request with invalid consumer key
  class InvalidCredential < APIError
  end

  # Raised when api response is not valid json
  class InvalidResponse < APIError
  end

  # Raised when region is not in `REGIONS`.
  class InvalidRegion < APIError
  end

  # Raised when attempting to modify readonly data.
  class ReadOnlyError < APIError
  end

  # Raised when requested resource does not exist.
  class ResourceNotFoundError < APIError
  end

  # Raised when request contains bad parameters.
  class BadParametersError < APIError
  end

  # Raised when trying to create an already existing resource.
  class ResourceConflictError < APIError
  end

  # Raised when there is an error from network layer.
  class NetworkError < APIError
  end

  # Raised when there is an error from network layer.
  class NotGrantedCall < APIError
  end

  # Raised when there is an error from network layer.
  class NotCredential < APIError
  end

  # Raised when there is an error from network layer.
  class Forbidden < APIError
  end
end
