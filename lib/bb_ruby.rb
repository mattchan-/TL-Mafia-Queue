$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module BBRuby
  VERSION = '0.9.5'

  # allowable image formats
  @@imageformats = 'png|bmp|jpg|gif|jpeg'
  @@quote_matcher = '(&spoil;|&apos;|)'

  # built-in BBCode tabs that will be processed
  @@tags = {
    # tag name => [regex, replace, description, example, enable/disable symbol]
    'Bold' => [
      /\[b(:.*)?\](.*?)\[\/b\1?\]/mi,
      '<strong>\2</strong>',
      'Embolden text',
      'Look [b]here[/b]',
      :bold],
    'Italics' => [
      /\[i(:.+)?\](.*?)\[\/i\1?\]/mi,
      '<em>\2</em>',
      'Italicize or emphasize text',
      'Even my [i]cat[/i] was chasing the mailman!',
      :italics],
    'Underline' => [
      /\[u(:.+)?\](.*?)\[\/u\1?\]/mi,
      '<u>\2</u>',
      'Underline',
      'Use it for [u]important[/u] things or something',
      :underline],
    'Strikeout' => [
      /\[s(:.+)?\](.*?)\[\/s\1?\]/mi,
      '<del>\2</del>',
      'Strikeout',
      '[s]nevermind[/s]',
      :strikeout],
    'Red' => [
      /\[red(:.*)?\](.*?)\[\/red\1?\]/mi,
      '<span style="color:red;">\2</span>',
      'Change text color to red',
      '[red]This is red text[/red]',
      :red],
    'Green' => [
      /\[green(:.*)?\](.*?)\[\/green\1?\]/mi,
      '<span style="color:green;">\2</span>',
      'Change text color to green',
      '[green]This is green text[/green]',
      :green],
    'Blue' => [
      /\[blue(:.*)?\](.*?)\[\/blue\1?\]/mi,
      '<span style="color:blue;">\2</span>',
      'Change text color to blue',
      '[blue]This is blue text[/blue]',
      :blue],
    'Color' => [
      /\[color=#{@@quote_matcher}(\w+|\#\w{6})\1(:.+)?\](.*?)\[\/color\3?\]/im,
      '<span style="color: \2;">\4</span>',
      'Change text color',
      '[color=red]This is red text[/color]',
      :color],
    'Center' => [
      /\[center(:.*)?\](.*?)\[\/center\1?\]/mi,
      '<div style="text-align:center">\2</div>',
      'Center elements',
      '[center]Look here[/center]',
      :center],
    'Horizontal Rule' => [
      /\[hr(:[^\[]+)?\]/mi,
      '<hr>',
      'Add a horizontal rule',
      'There is a horizontal rule [hr] between this sentence',
      :hr],
    'Quote' => [
      /\[quote(:.*)?\](.*?)\[\/quote\1?\]/mi,
      '<div class="quote"><hr>\2<hr></div>',
      'Quote',
      "[quote]Now is the time...[/quote]",
      :quote],
    'Spoiler' => [
      /\[spoiler\](.*?)\[\/spoiler\1?\]/mi,
      '<a class="spoiler" href="#"><span>+ Show</span> Spoiler<span> +</span></a><div class="spoiler_content" style="display:none">\1</div>',
      'spoiler',
      '[spoiler]spoiler[/spoiler]',
      :spoiler],
    'Spoiler (with description)' => [
      /\[spoiler(:.*)?=(?:&spoil;)?(.*?)(?:&spoil;)?\](.*?)\[\/spoiler\1?\]/mi,
      '<a class="spoiler" href="#"><span>+ Show</span> Spoiler [\2]<span> +</span></a><div class="spoiler_content" style="display:none">\3</div>',
      'Quote with citation',
      "[quote=mike]Now is the time...[/quote]",
      :quote],
    'Code' => [
      /\[code(:.+)?\](.*?)\[\/code\1?\]/mi,
      '<pre style="width: -20px; overflow-x:auto; font: 9pt monospace; margin: 0 5px; padding: 4px 6px; border: 1px solid black; background-color: #EBEFF2;">\2</pre>',
      'Code Text',
      '[code]some code[/code]',
      :code],
    'Ordered List' => [
      /\[ol\](.*?)\[\/ol\]/mi,
      '<ol>\1</ol>',
      'Ordered list',
      'My favorite people (alphabetical order): [ol][li]Jenny[/li][li]Alex[/li][li]Beth[/li][/ol]',
      :orderedlist],
    'Unordered List' => [
      /\[ul\](.*?)\[\/ul\]/mi,
      '<ul>\1</ul>',
      'Unordered list',
      'My favorite people (order of importance): [ul][li]Jenny[/li][li]Alex[/li][li]Beth[/li][/ul]',
      :unorderedlist],
    'List Item' => [
      /\[li\](.*?)\[\/li\]/mi,
      '<li>\1</li>',
      'List item',
      'See ol or ul',
      :listitem],
    'List Item (alternative)' => [
      /\[\*(:[^\[]+)?\]/mi,
      '<li>\2',
      'List item (alternative)',
      '[*]list item',
      :listitem],
    'Unordered list (alternative)' => [
      /\[list(:.*)?\]((?:(?!\[list(:.*)?\]).)*)\[\/list(:.)?\1?\]/mi,
      '<ul>\2</ul>',
      'Unordered list item',
      '[list][*]item 1[*] item2[/list]',
      :list],
    'Ordered list (numerical)' => [
      /\[list=1(:.*)?\](.+)\[\/list(:.)?\1?\]/mi,
      '<ol>\2</ol>',
      'Ordered list numerically',
      '[list=1][*]item 1[*] item2[/list]',
      :list],
    'Ordered list (alphabetical)' => [
      /\[list=a(:.*)?\](.+)\[\/list(:.)?\1?\]/mi,
      '<ol sytle="list-style-type: lower-alpha;">\2</ol>',
      'Ordered list alphabetically',
      '[list=a][*]item 1[*] item2[/list]',
      :list],
    'Definition List' => [
      /\[dl\](.*?)\[\/dl\]/im,
      '<dl>\1</dl>',
      'List of terms/items and their definitions',
      '[dl][dt]Fusion Reactor[/dt][dd]Chamber that provides power to your... nerd stuff[/dd][dt]Mass Cannon[/dt][dd]A gun of some sort[/dd][/dl]',
      :definelist],
    'Definition Term' => [
      /\[dt\](.*?)\[\/dt\]/mi,
      '<dt>\1</dt>',
      'List of definition terms',
      '[dt]definition term[/dt]',
      :defineterm],
    'Definition Definition' => [
      /\[dd\](.*?)\[\/dd\]/mi,
      '<dd>\1</dd>',
      'Definition definitions',
      '[dd]my definition[/dd]',
      :definition],
    'Link' => [
      /\[url=(.*?)\](.*?)\[\/url\]/mi,
      '<a href="\1">\2</a>',
      'Hyperlink to somewhere else',
      'Maybe try looking on [url=http://google.com]Google[/url]?',
      :link],
    'Link (Implied)' => [
      /\[url\](.*?)\[\/url\]/mi,
      '<a href="\1">\1</a>',
      'Hyperlink (implied)',
      "Maybe try looking on [url]http://google.com[/url]",
      :link],
    'Link (Automatic)' => [
      /(\A|\s)((https?:\/\/|www\.)[^\s<]+)/,
      ' <a href="\2">\2</a>',
      'Hyperlink (automatic)',
      'Maybe try looking on http://www.google.com',
      :link],  
    'Image (Resized)' => [
      /\[img(:.+)? size=#{@@quote_matcher}(\d+)x(\d+)\2\](.*?)\[\/img\1?\]/im,
      '<img src="\5" style="width: \3px; height: \4px;" />',
      'Display an image with a set width and height', 
      '[img size=96x96]http://www.google.com/intl/en_ALL/images/logo.gif[/img]',
      :image],
    'Image (Alternative)' => [
      /\[img=([^\[\]].*?)\.(#{@@imageformats})\]/im,
      '<img src="\1.\2" alt="" />',
      'Display an image (alternative format)', 
      '[img=http://myimage.com/logo.gif]',
      :image],
    'Image' => [
      /\[img(:.+)?\]([^\[\]].*?)\.(#{@@imageformats})\[\/img\1?\]/im,
      '<img src="\2.\3" alt="" />',
      'Display an image',
      'Check out this crazy cat: [img]http://catsweekly.com/crazycat.jpg[/img]',
      :image]
  }

  class << self
    # Convert a string with BBCode markup into its corresponding HTML markup
    #
    # === Basic Usage
    #
    # The first parameter is the string off BBCode markup to be processed
    #
    #   text = "[b]some bold text to markup[/b]"
    #   output = BBRuby.to_html(text)
    #   # output => "<strong>some bold text to markup</strong>"
    #
    # === Custom BBCode translations
    #
    # You can supply your own BBCode markup translations to create your own custom markup
    # or override the default BBRuby translations (parameter is a hash of custom translations).
    #
    # The hash takes the following format: "name" => [regexp, replacement, description, example, enable_symbol]
    #
    #  custom_blockquote = {
    #    'Quote' => [
    #      /\[quote(:.*)?=(.*?)\](.*?)\[\/quote\1?\]/mi,
    #      '<div class="quote"><p><cite>\2</cite></p><blockquote>\3</blockquote></div>',
    #      'Quote with citation',
    #      '[quote=mike]please quote me[/quote]',
    #      :quote
    #    ]
    #  }
    #
    # === Enable and Disable specific tags
    #
    # BBRuby will allow you to only enable certain BBCode tags, or to explicitly disable certain tags.
    # Pass in either :disable or :enable to set your method, followed by the comma-separated list of tags
    # you wish to disable or enable
    #
    #   BBRuby.to_html(text, {}, true, :enable, :image, :bold, :quote)
    #   BBRuby.to_html(text, {}, true, :disable, :image, :video, :color)
    #
    def to_html(text, tags_alternative_definition={}, escape_html=true, method=:disable, *tags)
      text = process_tags(text, tags_alternative_definition, escape_html, method, *tags)
      
      # parse spacing
      text.gsub!( /\r\n?/, "\n" )
      text.gsub!( /\n/, "<br />\n" )

      # return markup
      text
    end

    def parse_post(text, tags_alternative_definition={}, escape_html=true, method=:disable, *tags)
      if escape_html
        text.gsub!( '&', '&' )
        text.gsub!( '<', '<' )
        text.gsub!( '>', '>' )
      end

      formatted = text.gsub(/\[quote\]/, '<div class="quote"><hr>\2')
      formatted.gsub!(/\[\/quote\]/, '<hr></div>')

      BBRuby.to_html(formatted, tags_alternative_definition, false, method, tags)
    end
    
    # The same as BBRuby.to_html except the output is passed through simple_format first
    #
    # Returns text transformed into HTML using simple formatting rules. Two or more consecutive newlines(\n\n) 
    # are considered as a paragraph and wrapped in <p> tags. One newline (\n) is considered as a linebreak and 
    # a <br /> tag is appended. This method does not remove the newlines from the text.
    #
    def to_html_with_formatting(text, tags_alternative_definition={}, escape_html=true, method=:disable, *tags)
      text = process_tags(text, tags_alternative_definition, escape_html, method, *tags)
      
      # parse spacing
      simple_format( text )
    end

    # Returns the list of tags processed by BBRuby in a Hash object
    def tag_list
      @@tags
    end
    
    private
    
    def process_tags(text, tags_alternative_definition={}, escape_html=true, method=:disable, *tags)
      text = text.dup
      
      # escape "<, >, &" and quotes to remove any html
      if escape_html
        text.gsub!( '&', '&amp;' )
        text.gsub!( '<', '&lt;' )
        text.gsub!( '>', '&gt;' )
        text.gsub!( '"', '&quot;' )
        text.gsub!( "'", '&apos;' )
      end
      
      tags_definition = @@tags.merge(tags_alternative_definition)

      # parse bbcode tags
      case method
      when :enable
        tags_definition.each_value { |t| text.gsub!(t[0], t[1]) if tags.include?(t[4]) }
      when :disable
        # this works nicely because the default is disable and the default set of tags is [] (so none disabled) :)
        tags_definition.each_value { |t| text.gsub!(t[0], t[1]) unless tags.include?(t[4]) }
      end
      
      text
    end
    
    # extracted from Rails ActionPack
    def simple_format( text )
      start_tag = '<p>'
      text = text.to_s.dup
      text.gsub!(/\r\n?/, "\n")                     # \r\n and \r => \n
      text.gsub!(/\n\n+/, "</p>\n\n#{start_tag}")  # 2+ newline  => paragraph
      text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />')  # 1 newline   => br
      text.insert 0, start_tag
      text << "</p>"
    end
  end # class << self

end # class BBRuby

class String
  # Convert a string with BBCode markup into its corresponding HTML markup
  #
  # === Basic Usage
  #
  #   text = "[b]some bold text to markup[/b]"
  #   output = text.bbcode_to_html
  #   # output => "<strong>some bold text to markup</strong>"
  #
  # === Custom BBCode translations
  #
  # You can supply your own BBCode markup translations to create your own custom markup
  # or override the default BBRuby translations (parameter is a hash of custom translations).
  #
  # The hash takes the following format: "name" => [regexp, replacement, description, example, enable_symbol]
  #
  #  custom_blockquote = {
  #    'Quote' => [
  #      /\[quote(:.*)?=(.*?)\](.*?)\[\/quote\1?\]/mi,
  #      '<div class="quote"><p><cite>\2</cite></p><blockquote>\3</blockquote></div>',
  #      'Quote with citation',
  #      '[quote=mike]please quote me[/quote]',
  #      :quote
  #    ]
  #  }
  #
  #  output = text.bbcode_to_html(custom_blockquote)
  #
  # === Enable and Disable specific tags
  #
  # BBRuby will allow you to only enable certain BBCode tags, or to explicitly disable certain tags.
  # Pass in either :disable or :enable to set your method, followed by the comma-separated list of tags
  # you wish to disable or enable
  #
  #   output = text.bbcode_to_html({}, true, :enable, :image, :bold, :quote)
  #   output = text.bbcode_to_html({}, true, :disable, :image, :video, :color)
  #
  # === HTML auto-escaping
  #
  # By default, BBRuby will auto-escape HTML.  You can prevent this by passing in false as the second
  # parameter
  #
  #   output = text.bbcode_to_html({}, false)
  #
  def bbcode_to_html(tags_alternative_definition = {}, escape_html=true, method=:disable, *tags)
    BBRuby.parse_post(self, tags_alternative_definition, escape_html, method, *tags)
  end

  # Replace the string contents with the HTML-converted markup
  def bbcode_to_html!(tags_alternative_definition = {}, escape_html=true, method=:disable, *tags)
    self.replace(BBRuby.to_html(self, tags_alternative_definition, escape_html, method, *tags))
  end

  def bbcode_to_html_with_formatting(tags_alternative_definition = {}, escape_html=true, method=:disable, *tags)
    BBRuby.to_html_with_formatting(self, tags_alternative_definition, escape_html, method, *tags)
  end

  # Replace the string contents with the HTML-converted markup using simple_format
  def bbcode_to_html_with_formatting!(tags_alternative_definition = {}, escape_html=true, method=:disable, *tags)
    self.replace(BBRuby.to_html_with_formatting(self, tags_alternative_definition, escape_html, method, *tags))
  end
end
