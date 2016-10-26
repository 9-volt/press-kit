describe Parsers::Publika do
  include_context :db

  let(:storage) { LocalStorage.new("spec/fixtures/publika/") }
  let(:valid_ids) { %w(10211 1223871) }
  let(:invalid_ids) { %w(21) }

  it_behaves_like "a parser" do
    it "saves to the database" do
      doc = parser.load_doc(valid_ids[0])
      hash = parser.parse(doc, valid_ids[0])
      parser.save(hash)

      expect(ParsedPage.where(source: "publika", article_id: valid_ids[0])).not_to be nil
    end
  end
end
