require 'spec_helper'

describe Uploadcare::Uploader do
  before :each do
    @uploader = Uploadcare::Uploader.new(CONFIG)
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
      uploader = Uploadcare::Uploader.new CONFIG.merge({public_key: 'invalid'})
      uploader.upload_file File.join(File.dirname(__FILE__), 'view.png')
    }.to raise_error(ArgumentError)
  end
end
