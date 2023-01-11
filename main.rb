require 'net/http'
require 'json'
require 'icalendar'

courseNames = File.open("course_sections.txt").readlines.map(&:chomp)
p courseNames

courseInfoRaw = Net::HTTP.get(URI("https://courselistings.wpi.edu/assets/prod-data.json"))
courseInfoParsed = JSON.parse(courseInfoRaw)
p courseInfoParsed["Report_Entry"].select { |c| c["Course_Section"].start_with?(courseNames[0]) }