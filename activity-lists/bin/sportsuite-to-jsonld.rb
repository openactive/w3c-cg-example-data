require 'json'
require 'csv'
require 'fileutils'

physical_activity = {
  "@id": "#physical-activity",
  "@type": "skos:Concept",
  "skos:prefLabel": "Physical Activity",
  "skos:topConceptOf": ""
}

sport = {
  "@id": "#sport",
  "@type": "skos:Concept",
  "skos:prefLabel": "Sport",
  "skos:topConceptOf": ""
}

data = {
  "@context": {
    "dc": "http://purl.org/dc/terms/",
    "skos": "http://www.w3.org/2004/02/skos/core#",
    "inScheme": {
       "@reverse": "skos:inScheme"
    }
  },
  "@type": "skos:ConceptScheme",
  "dc:title": "SportSuite Activity List",
  "dc:description": "SportSuite Mega List converted to JSONLD",
  "inScheme": [ physical_activity, sport ]
}

def slug(s)
  slug = s.downcase
  slug.gsub! /\s+/, '-'
  slug.gsub! /\(|\)/, ''
  slug.gsub! /\./, ''
  slug  
end

PHYSICAL_ACTIVITIES = Hash.new([])
SPORTS = Hash.new([])
CATEGORIES = Hash.new([])

CSV.foreach( ARGV[0] , headers: true ) do |row|
 list = (row[0] == "Sport" ? SPORTS : PHYSICAL_ACTIVITIES)
 if row[1] != nil
   if list.include?( row[1] )
    list[ row[1] ] << row[2] 
   else
    list[ row[1] ] = [ row[2] ]
   end
 else
  if !list.include?( row[2] )
    list[ row[2] ] = []
  end
 end
 
 #Categories 
 if row[4] != "-"
   categories = CSV.parse( row[4] )[0]
   categories.map do |c| c.lstrip! end
   categories.each do |c|
     if CATEGORIES.include?(c)
       CATEGORIES[c] << row[2]
     else
       CATEGORIES[c] = [ row[2] ]
     end
   end
 end
  
end

def to_skos(concepts, parent)
  parent["skos:narrower"] = []
  concepts.each do |k,v|
     concept = {
       "@id": "##{slug(k)}",
       "@type": "skos:Concept",
       "skos:prefLabel": k
     }
     if !v.empty?
       concept["skos:narrower"] = []
       v.each do |child|
        concept["skos:narrower"] << {
           "@id": "##{slug(child)}",
           "@type": "skos:Concept",
           "skos:prefLabel": child
        }
       end
     end
    parent["skos:narrower"] << concept
  end
end

to_skos(PHYSICAL_ACTIVITIES, physical_activity)
to_skos(SPORTS, sport)

CATEGORIES.each do |category, children|
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
