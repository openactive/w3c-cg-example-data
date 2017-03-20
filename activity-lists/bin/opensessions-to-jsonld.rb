require 'json'
require 'csv'
require 'fileutils'

data = {
  "@context": {
    "dc": "http://purl.org/dc/terms/",
    "skos": "http://www.w3.org/2004/02/skos/core#",
    "inScheme": {
       "@reverse": "skos:inScheme"
    }
  },
  "@type": "skos:ConceptScheme",
  "dc:title": "OpenSessions Activity List",
  "dc:description": "Sample activity list from Open Sessions. Note this includes unsanitized user generated content, where some activities were added for draft sessions and not published",
  "inScheme": []
}

def slug(s)
  slug = s.downcase
  slug.gsub! /\s+/, '-'
  slug.gsub! /\(|\)/, ''
  slug.gsub! /\./, ''
  slug  
end

CSV.foreach( ARGV[0] , "r" ) do |row|
    data[:inScheme] << {
      "@id": "##{slug(row[0])}",
      "@type": "skos:Concept",
      "skos:prefLabel": row[0]
    }
end

File.open( ARGV[1], "w" ) do |f|
 f.puts JSON.pretty_generate data
end
