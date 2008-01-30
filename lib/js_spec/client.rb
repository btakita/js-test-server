
module JsSpec
  class Client
    class << self
      def run
        response = Net::HTTP.start(JsSpec::DEFAULT_HOST, JsSpec::DEFAULT_PORT) do |http|
          http.post('/runners/firefox', {})
        end

        body = response.body
        if body.empty?
          puts "SUCCESS"
          return true
        else
          puts "FAILURE"
          puts body
          return false
        end
      end
    end
  end
end