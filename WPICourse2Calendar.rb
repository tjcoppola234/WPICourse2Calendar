require 'net/http'
require 'json'
require 'icalendar'

courseNames = File.open("course_sections.txt").readlines.map(&:chomp)
p courseNames

courseCal = Icalendar::Calendar.new 

courseInfoRaw = Net::HTTP.get(URI("https://courselistings.wpi.edu/assets/prod-data.json"))
courseInfoParsed = JSON.parse(courseInfoRaw)
courseNames.each { |name|
    currCourse = courseInfoParsed["Report_Entry"].select { |c| c["Course_Section"].start_with?(name) }[0]
    courseCal.event do |e|
        e.description = currCourse["Course_Title"]
        e.dtstart = DateTime.civil(2023, 1, 13, 6, 30)
        e.dtend = DateTime.civil(2023, 1, 13, 7, 30)
        e.location = currCourse["Locations"]
    end
}

courseCal.publish
File.open("Course_Schedule.ics", "w").write(courseCal.to_ical)