require 'spec_helper'

describe Uploadcare::Api do
  before :each do
    @api = Uploadcare::Api.new(
      public_key: $UPLOADCARE_PUBLIC_KEY,
      private_key: $UPLOADCARE_PRIVATE_KEY,
      api_url_base: $UPLOADCARE_API_URL_BASE
    )
    @uploader = Uploadcare::Uploader.new(
      public_key: $UPLOADCARE_PUBLIC_KEY,
      upload_url_base: $UPLOADCARE_UPLOAD_URL_BASE
    )
  end

  it 'should requre public_key and private_key' do
    expect { Uploadcare::Api.new public_key: 'key' }.to raise_error(ArgumentError)
    expect { Uploadcare::Api.new private_key: 'key' }.to raise_error(ArgumentError)
  end

  it 'should show account' do
    account = @api.account
    account.should be_an_instance_of(Uploadcare::Account)
    account.public_key.should == $UPLOADCARE_PUBLIC_KEY
  end

  it 'should return list of files' do
    files = @api.files
  end
end