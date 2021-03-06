require 'open-uri'
require 'hpricot'

class SoftwareMarketplatzParser
  def initialize
  end

  def parse
    @parsed_pages = []
    parse_index("http://#{uri.host}#{uri.path}")
    doc.search('//a').each do |a|
      if a.attributes['href'].match(/^\/f_liste/)
        parse_index("http://#{uri.host}/#{a.attributes['href']}")
      end
    end
  end

  def parse_index( page )
    puts "parsing index: #{page}"
    doc.search('//a').each do |a|
      if a.attributes['href'].match(/^firmeninformation/)
        parse_page(a.attributes['href']) unless @parsed_pages.include?(a.attributes['href'])
      end
    end
  end

  def parse_page( page )
    puts "parsing page: #{page}"
    lead = User.find_by_email('mattbeedle@googlemail.com').leads.build :rating => 3, :source => 'Imported'
    doc = Hpricot(open("http://#{uri.host}/#{page}"))
    fieldsets = doc.search('//fieldset')
    fieldset = nil
    fieldsets.each do |f|
      fieldset = f if f.inner_html.match(/Allgemeine Informationen/)
    end
    lead.company = Iconv.iconv('utf-8', 'iso-8859-1', fieldset.inner_html.split('</b>')[1].strip_html)
    fieldset.inner_html.split('</b>').last.split('<br />').each_with_index do |data, index|
      case index
      when 1 then lead.address = Iconv.iconv('utf-8', 'iso-8859-1', data)
      when 2
        data =~ /([0-9]{5})/
        lead.postal_code = $1
        lead.city = Iconv.iconv('utf-8', 'iso-8859-1', data.split(/\s/).last)
      when 3 then lead.phone = Iconv.iconv('utf-8', 'iso-8859-1', data)
      #when 4 then lead.fax = data
      when 7
        name = data.split('</p>').first.gsub(/,[^,]*/, '')
        puts name
        if result = name.match(/^[\w]{0,5}\./)
          lead.title = result[0].gsub(/\./, '')
          name.gsub!(/#{result[0]}/, '').strip
        end
        names = name.strip.split(/\s/)
        lead.first_name = Iconv.iconv('utf-8', 'iso-8859-1', names.shift)
        lead.last_name = Iconv.iconv('utf-8', 'iso-8859-1', names.join(' '))
      end
    end
    lead.save
    @parsed_pages << page
  rescue URI::InvalidURIError => e
    puts e
  end

  def parsed_pages
    @parsed_pages
  end

  def uri
    @uri ||= URI.parse('http://www.software-marktplatz.de/itanbieter_deutschland-d.html')
  end

  def doc
    @doc ||= Hpricot(open("http://#{uri.host}#{uri.path}"))
  end
end
