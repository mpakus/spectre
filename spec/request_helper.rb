module Request
  module JsonHelpers
    def json
      @json ||= JSON.parse(response.body)
    end
  end
end
