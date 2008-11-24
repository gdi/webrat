require "webrat"

module Webrat
  class RailsSession < Session #:nodoc:

    def doc_root
      File.expand_path(File.join(RAILS_ROOT, 'public'))
    end
    
    def saved_page_dir
      File.expand_path(File.join(RAILS_ROOT, "tmp"))
    end
    
    def get(url, data, headers = nil)
      do_request(:get, url, data, headers)
    end
    
    def post(url, data, headers = nil)
      do_request(:post, url, data, headers)
    end
    
    def put(url, data, headers = nil)
      do_request(:put, url, data, headers)
    end
    
    def delete(url, data, headers = nil)
      do_request(:delete, url, data, headers)
    end
    
    def response_body
      response.body
    end
    
    def response_code
      response.code.to_i
    end
    
  protected
    
    def integration_session
      @context
    end
    
    def do_request(http_method, url, data, headers) #:nodoc:
      update_protocol(url)
      integration_session.request_via_redirect(http_method, remove_protocol(url), data, headers)
    end
  
    def remove_protocol(href) #:nodoc:
      if href =~ %r{^https?://www.example.com(/.*)}
        $LAST_MATCH_INFO.captures.first
      else
        href
      end
    end
    
    def update_protocol(href) #:nodoc:
      if href =~ /^https:/
        integration_session.https!(true)
      elsif href =~ /^http:/
        integration_session.https!(false)
      end
    end
    
    def response #:nodoc:
      integration_session.response
    end
    
  end
end

module ActionController
  module Integration
    class Session #:nodoc:
      unless instance_methods.include?("put_via_redirect")
        require "webrat/rails/redirect_actions"
        include Webrat::RedirectActions
      end

      include Webrat::Methods
    end
  end
end

Webrat.configuration.mode = :rails