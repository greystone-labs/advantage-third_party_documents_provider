# frozen_string_literal: true
def doc_type(name)
  # fetch string between {}
  regex = /\{(.*?)}/
  name.slice(regex, 1)
end

RSpec.describe Advantage::ThirdPartyDocumentsProvider::Onbase do
  subject { described_class.new(host: "http://onbase:9090", api_key: "1234") }

  describe "#get_document_types" do
    it { subject }

    it "returns hash of documentTypeGroup and documentTypeGroupId" do
      VCR.use_cassette("document_types") do
        response = subject.get_document_types

        expect(response.first.keys).to eq(%w[documentTypeGroup documentTypeGroupId documentTypeName
                                             documentTypeId])

        # NOTE: scripts that are helpful to get info about the response
        # response.map{|r| r["documentTypeName"]}.uniq
        # response.group_by { |i| i["documentTypeGroup"] } 
        # response.group_by { |i| doc_type(i["documentTypeName"]) } 
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


      document_type.deal_type.to eq ('FHA')
    end
  end
end
