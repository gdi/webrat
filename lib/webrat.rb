require "rubygems"

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__))) unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))

module Webrat
  class WebratError < StandardError
  end

  VERSION = '0.3.2'

  def self.require_xml
    if on_java?
      # We need Nokogiri's CSS to XPath support, even if using REXML and Hpricot for parsing and searching
      require "nokogiri/css"
      require "hpricot"
      require "rexml/document"
    else
      require "nokogiri"
      require "webrat/core/nokogiri"
    end
  end
  
  def self.on_java?
    RUBY_PLATFORM =~ /java/
  end
  
end

Webrat.require_xml

require "webrat/core"
