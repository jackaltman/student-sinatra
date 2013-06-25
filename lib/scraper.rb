require "sqlite3"
require 'open-uri'
require 'nokogiri'

###############

# # Open a database
db = SQLite3::Database.new "student.db"

rows = db.execute <<-SQL

  create table profiles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    twitter TEXT,
    linkedin TEXT,
    github TEXT,
    blog TEXT,
    quote TEXT
  );
SQL

index = Nokogiri::HTML(open("http://students.flatironschool.com/"))

urls = index.css(".big-comment a").collect { |link| link['href'].downcase}


urls.each do |page|
    
  begin
    doc = Nokogiri::HTML(open("http://students.flatironschool.com/"+page))


    # doc = Nokogiri::HTML(open("http://students.flatironschool.com/students/awaxman.html")).css(".ib_main_header").text

    #Grabs name 
    # doc.css(".ib_main_header").text
    name = doc.search("h4").text

    # Social Links
    social_links = doc.css(".social-icons a").collect { |link| link['href'] }
    twitter = social_links[0]
    linkedin = social_links[1]
    github = social_links[2]
    blog = social_links[3]

    #Quote
    quote = doc.css(".quote-div h3").text

    #########################


    # Execute inserts with parameter markers
    db.execute("INSERT INTO profiles (name, twitter, linkedin, github, blog, quote) 
                VALUES (?, ?, ?, ?, ?, ?)", [name, twitter, linkedin, github, blog, quote])
  rescue OpenURI::HTTPError
  end
end



