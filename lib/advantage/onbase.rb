require 'faraday'
module Advantage
  module ThirdPartyDocumentsProvider
    class Onbase
      attr_accessor :host, :port, :api_key

      def initialize(host: nil, api_key: nil)
        self.host = host || ENV.fetch("ONBASE_API_HOST")
        self.api_key = api_key || ENV.fetch("ONBASE_API_APIKEY")
      end

      def get_document_types
        endpoint = "/v1/DocumentTypes"
        conn = Faraday.new(
          url: host,
          headers: {'Content-Type' => 'application/json', "x-api-key" => api_key}
        )

        response = conn.get(endpoint)
        if response.success?
          JSON.parse(response.body) 
        else
          raise Error.new("Unable to capture DocumentTypes")
        end
      end
    end
  end
end

__END__
curl -H "x-api-key: 1234" http://localhost:9090/v1/DocumentTypes  --head
curl -X POST -H "x-api-key: 1234" http://localhost:9090/v1/upload

$ curl -X 'POST'    -H "x-api-key: 1234"   'http://localhost:9090/v1/Upload'   -H 'accept: text/plain'   -H 'Content-Type: application/json'   -d '{
  "documentTypeName": "Amenities {FHAMAP}",
  "keywords": {
    "additionalProp1": "string",
    "additionalProp2": "string",
    "additionalProp3": "string"
  },
  "fileCount": 1
}'
