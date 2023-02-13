# frozen_string_literal: true

RSpec.describe Advantage::ThirdPartyDocumentsProvider::Onbase do
  subject { described_class.new(host: "http://onbase:9090", api_key: "1234") }

  describe "#get_document_types" do
    it { subject }

    it "returns hash of documentTypeGroup and documentTypeGroupId" do
      VCR.use_cassette("document_types") do
        response = subject.get_document_types

        expect(response.first.keys).to eq(%w[documentTypeGroup documentTypeGroupId documentTypeName
                                             documentTypeId])
      end
    end
  end

  describe "#upload" do
    it { subject }
    let(:document_type) do
      { "documentTypeGroup" => "FHA MAP Documents",
        "documentTypeGroupId" => 166,
        "documentTypeName" => "Zoning Report {FHAMAP}",
        "documentTypeId" => 4410 }
    end
    let(:keywords) { { keyword1: "value1" } }

    it "creates an upload object" do
      VCR.use_cassette("upload_job") do
        response = subject.create_upload(document_type_name: document_type["documentTypeName"], keywords: keywords)
      end
    end
  end
end
