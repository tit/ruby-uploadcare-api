require 'spec_helper'

describe Uploadcare::Uploader do
  before :each do
    @uploader = Uploadcare::Uploader.new(
      public_key: $UPLOADCARE_PUBLIC_KEY,
      upload_url_base: $UPLOADCARE_UPLOAD_URL_BASE
    )
  end

  it "should require public_key" do
    expect {
      Uploadcare::Uploader.new
    }.to raise_error(ArgumentError)
  end

  it "should upload file with valid public key" do
    file_id = ''
    expect {
      file_id = @uploader.upload_file File.join(File.dirname(__FILE__), 'view.png')
    }.to_not raise_error(ArgumentError)

    file_id.size.should > 0
  end

  it 'should require valid public key for file upload' do
    expect {
      uploader = Uploadcare::Uploader.new(
        public_key: 'invalid',
        upload_url_base: $UPLOADCARE_UPLOAD_URL_BASE
      )
      uploader.upload_file File.join(File.dirname(__FILE__), 'view.png')
    }.to raise_error(ArgumentError)
  end
end