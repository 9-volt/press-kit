require_relative '../../parsers/protv'

describe Parsers::ProTV do
  it_behaves_like "a parser" do
    let(:parser) { described_class.new }

    let(:valid_ids) { %w(126971 126981 126991) }
    let(:invalid_ids) { %w(727) }

    before do
      parser.page_dir = 'spec/fixtures/protv/'
    end
  end
end
