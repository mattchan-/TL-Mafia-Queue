class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include BBRuby
end

#class String
#  def bbcode_to_html
#    parser = RbbCode::Parser.new
#    parser.parse(self)
#  end
#end
