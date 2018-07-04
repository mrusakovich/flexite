module Flexite
  class Diff
    def initialize(endpoint)
      @endpoint = "#{endpoint}/diff"
    end

    def check(data)
      post("#{@endpoint}/#{__method__}", data)
    end

    def apply(data)
      post("#{@endpoint}/#{__method__}", data)
    end

    private

    def post(endpoint, data, headers = { 'Content-Type' => 'application/json' })
      uri = URI(endpoint)
      req = Net::HTTP::Post.new(uri, headers)
      req.body = data.to_json

      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
      # TODO: add check/validation of response status and etc....
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
