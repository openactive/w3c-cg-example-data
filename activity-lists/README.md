# Example Activity Lists

This directory contains a number of sample activity lists that include a variety of sports and physical activities.

Scripts are provided to convert the CSV files provided by the OpenActive Community Group contributors into JSON-LD structured 
according to the recommendations in the [Modelling Opportunity Data](https://www.openactive.io/modelling-opportunity-data/#describing-activity-lists-code-skos-conceptscheme-code-and-physical-activity-code-skos-concept-code-) specification.

Some notes on each of the lists are provided below.

## Example Lists

* The [OpenSessions](http://www.opensessions.io/) list includes unsanitized user generated content, where some activities were added for draft sessions and not published. It's a flat list of activity names, without any hierarchy. It demonstrates a simple activity list without any relationships. [View JSON](converted-data/opensessions-activity-list.json)


* The Sports Suite "mega list" is more complicated. It has a nested hierarchy of activities. At the top level are Physical Activities and Sports, these contain activities some of which have their own children. The list also has a separate set of hierarchies, e.g. "Endurance Sports" or "Health & Wellbeing" that collect together other activities from across the hierarchy. So an activity might have multiple parents. [View JSON](converted-data/sportsuite-activity-list.json). [View simplified hierarchy as PDF](sportsuite.pdf)

* The Sport England list combines data from the list of recognised sports and the Active Lives survey. Again it is a hierarchical list where the activities might have multiple parents. The extra feature demonstrated by this list is that it provides alternative labels for some activities. E.g. Bobsled and Bobsleigh are synonyms.[View JSON](converted-data/sportengland-activity-list.json). [View simplified hierarchy as PDF](sportengland.pdf)

## Notes on Conversion

* An explicit JSON-LD context is included in each. There will be eventually be an OpenActive context that will replace this, so the markup will be a simple `@context` key with a URL to another JSON-LD document.

* Unique identifiers have been generated using relative URLs generated from the activity names, but these could be assigned more methodically

## Other Example

Some other example lists published elsewhere on the web:

* Wikipedia [list of international sports federations and sports](https://en.wikipedia.org/w/index.php?title=Template:International_Sports_Federations&oldid=733950934), used in OpenSessions.io
* [List of sports](http://www.topendsports.com/sport/sport-list.htm) and [list of recognised sports](http://www.topendsports.com/sport/recognized-sports.htm)
* [BBC Sports A-Z](http://www.bbc.co.uk/sport/all-sports)
* [GCSE PE Activity List](https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/447738/GCSE_activity_list_for_PE.pdf) and [A Level Activity List](https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/447744/GCE_AS_and_A_level_activity_list_for_PE.pdf)
* [Compendium of Physical Activities](https://sites.google.com/site/compendiumofphysicalactivities/) see [PDF with full list](https://docs.google.com/viewer?a=v&pid=sites&srcid=ZGVmYXVsdGRvbWFpbnxjb21wZW5kaXVtb2ZwaHlzaWNhbGFjdGl2aXRpZXN8Z3g6MjgyY2EyMzQzNWFlN2Q3OA)
* This [list of activities](http://www.ymcaquebec.org/en/Find-an-Activity/List-of-Activities) mixes up activities and programmes
