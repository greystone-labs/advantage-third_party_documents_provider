# frozen_string_literal: true
RSpec.describe Advantage::ThirdPartyDocumentsProvider::Onbase do
  subject { described_class.new(host: "http://onbase:9090", api_key: "1234") }

  describe "#get_document_types" do 
    it { subject }

    it "returns hash of documentTypeGroup and documentTypeGroupId" do 
      VCR.use_cassette("document_types") do
        response = subject.get_document_types
      end
      binding.pry
    end
  end
end
