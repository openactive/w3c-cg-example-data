require 'json'
require 'csv'
require 'fileutils'
require 'set'

data = {
  "@context": {
    "dc": "http://purl.org/dc/terms/",
    "skos": "http://www.w3.org/2004/02/skos/core#",
    "inScheme": {
       "@reverse": "skos:inScheme"
    }
  },
  "@type": "skos:ConceptScheme",
  "dc:title": "SportEngland Activity List",
  "dc:description": "Sport England example activity list",
  "inScheme": []
}

def slug(s)
  slug = s.downcase
  slug.gsub! /\s+/, '-'
  slug.gsub! /\(|\)/, ''
  slug.gsub! /\./, ''
  slug  
end

CONCEPTS = {}
TAGS = {}

last_concept = nil
CSV.foreach( ARGV[0] , headers: true ) do |row|
 if row[4] != "Alternate Name"
     concept = {
            "notation": row[0],
            "label": row[1],
            "type": row[4],
            "source": row[5],
            "narrower": [],
            "altLabel": []
     }
     last_concept = concept
     if row[2] != nil
        parent = CONCEPTS[ row[2] ]
        parent[:narrower] << concept   
     else
        CONCEPTS[ row[1] ] = concept
     end
 else
    #alternate name
    last_concept[:altLabel] << row[3]
 end
 
 [6, 7, 8].each do |col|
  break unless row[col] != nil
  if !TAGS.include?(row[col])   
   TAGS[ row[col] ] = Set.new
  end
  TAGS[ row[col] ] << row[1]
 end      
end

CONCEPTS.each do |id, c|
  concept = {
    "@id": "##{slug(c[:label])}",
    "@type": "skos:Concept",
    "skos:prefLabel": c[:label]    
  }
  if c[:notation] != nil
    concept["skos:topConceptOf"] = ""
    concept["skos:notation"] = c[:notation]
  end
  if !c[:altLabel].empty?
    concept["skos:altLabel"] = c[:altLabel]
  end
  if !c[:narrower].empty?
    children = []
    c[:narrower].each do |child|
        children << {
            "@id": "##{slug(child[:label])}",
            "@type": "skos:Concept",
            "skos:prefLabel": child[:label]           
        }
        if !child[:altLabel].empty?
          children.last["skos:altLabel"] = child[:altLabel]
        end
    end
    concept["skos:narrower"] = children
  end  
  data[:inScheme] << concept
end

TAGS.each do |category, children|
 category = {
   "@id": "##{slug(category)}",
   "@type": "skos:Concept",
   "skos:topConceptOf": "",
   "skos:prefLabel": category
 }
 category["skos:narrower"] = []
 children.each do |child|
    category["skos:narrower"] << {
      "@id": "##{slug(child)}"
    }
 end
 data[:inScheme] << category
end

File.open( ARGV[1], "w" ) do |f|
 f.puts JSON.pretty_generate data
end
