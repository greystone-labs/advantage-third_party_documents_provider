require "faraday"
module Advantage
  module ThirdPartyDocumentsProvider
    class Onbase
      attr_accessor :host, :port, :api_key, :connection

      def initialize(host: nil, api_key: nil)
        self.host = host || ENV.fetch("ONBASE_API_HOST")
        self.api_key = api_key || ENV.fetch("ONBASE_API_APIKEY")
        self.connection = Faraday.new(
          url: host,
          headers: { "Content-Type" => "application/json", "x-api-key" => api_key }
        )
      end

      def get_document_types
        endpoint = "/v1/DocumentTypes"
        response = connection.get(endpoint)
        raise Error, "Unable to capture DocumentTypes -> #{response.body}" unless response.success?

        JSON.parse(response.body)
      end

      def create_upload(document_type_name:, keywords: {}, count: 1)
        endpoint = "/v1/upload"
        json = JSON.generate({ documentTypeName: document_type_name, keywords: keywords, fileCount: count })
        response = connection.post(endpoint, json)
        raise Error, "Unable to create upload job -> #{response.body}" unless response.success?

        JSON.parse(response.body)
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
