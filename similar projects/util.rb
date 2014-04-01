def fetch_article_bounds
  response = Typhoeus.get('http://civil.ge/eng/')
  doc = Nokogiri::HTML(response.body)

  node = doc.xpath("//div[@id='top2']/div/a[starts-with(@href, 'article.php?id=')]").first
  if not node or not node['href']
    return nil
  end

  return node['href'][/\d+$/].to_i
end

def parse_payload(body)
  payload = OpenStruct.new(:title => nil, :date => nil, :body => nil)

  doc = Nokogiri::HTML(body)
  
  title_node = doc.xpath("//div[@id='titletext']").first
  body_node = doc.css('#maintext').first
  if not title_node or not body_node
    return nil
  end

  date_node = title_node.xpath("following-sibling::table/tr/td[@class='botoomtext']").first

  payload.title = title_node.text.strip
  payload.body = body_node.text.strip

  if (date_node)
    begin
      #payload.date = DateTime.strptime(date_node.text.strip, "/ %d %b.'%y / %OH:%OM")
      payload.date = DateTime.strptime(date_node.text[/\/ .*? \/ \d{2}:\d{2}/], "/ %d %b.'%y / %OH:%OM")
    rescue ArgumentError
      $stderr.puts "Invalid date: #{date_node.text.strip}"
    end
  end

  return payload
end

def build_request(context)
  index = context.index += 1

  request = Typhoeus::Request.new(BASE_URL+index.to_s, followlocation: true)
  request.on_complete do |response|
    payload = parse_payload(response.body)

    if not payload
      $stderr.puts "PAYLOAD FAILURE @ #{index}"
      #context.finished = true
    else 
      $stderr.puts "\nIndex #{index}, GOT #{payload.title} @ #{payload.date}"
      #context.results.write(JSON.pretty_generate(payload.marshal_dump))
    end

    #if not context.finished
    if context.index <= context.last_index
      $stderr.print "." 
      context.hydra.queue(build_request(context))
    end
  end

  return request
end

