module OVH
  API_READ_ONLY       = %i(GET)
  API_READ_WRITE      = %i(GET POST PUT DELETE)
  API_READ_WRITE_SAFE = %i(GET POST PUT)

  class ConsumerKeyRequest
    attr_reader :access_rules
    def initialize(client)
      @client = client
      @access_rules = []
    end

    def request(redirect_url=nil)
      return @client.request_consumerkey(@access_rules, redirect_url)
    end

    def add_rule(method, path)
      @access_rules << {:method => method, :path => path}
    end

    def add_rules(methods, path)
      methods.each {
        |method|
        @access_rules << {:method => method, :path => path}
      }
    end

    def add_recursive_rules(methods, path)
      path.gsub!(%r{[*/ ]*\z}, "")
      unless path.empty?
        self.add_rules(methods, path)
      end
      self.add_rules(methods, path+'/*')
    end
  end
end
