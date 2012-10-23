$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
$LOAD_PATH << File.join(File.dirname(__FILE__))

require 'rubygems'
require 'pry'
require 'rspec'
require 'uploadcare'

$UPLOADCARE_PUBLIC_KEY = ENV['UPLOADCARE_PUBLIC_KEY']
$UPLOADCARE_PRIVATE_KEY = ENV['UPLOADCARE_PRIVATE_KEY']
$UPLOADCARE_UPLOAD_URL_BASE = ENV['UPLOADCARE_UPLOAD_URL_BASE'] || 'https://upload.uploadcare.com'
$UPLOADCARE_API_URL_BASE = ENV['UPLOADCARE_API_URL_BASE'] || 'https://api.uploadcare.com'