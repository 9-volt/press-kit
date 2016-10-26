describe Fetchers::InProfunzime do
  it_behaves_like "a fetcher" do
    let(:fetcher) { subject }

    let(:valid_ids) { %w(1652731 ) }

    let(:invalid_ids) { %w(3323) }
  end
end