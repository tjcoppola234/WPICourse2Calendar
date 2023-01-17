require 'net/http'
require 'json'
require 'icalendar-rrule'

using Icalendar::Scannable

courseNames = File.open("course_sections.txt").readlines.map(&:chomp)
p courseNames

courseCal = Icalendar::Calendar.new 

courseInfoRaw = Net::HTTP.get(URI("https://courselistings.wpi.edu/assets/prod-data.json"))
courseInfoParsed = JSON.parse(courseInfoRaw)
courseNames.each { |name|
    currCourse = courseInfoParsed["Report_Entry"].select { |c| c["Course_Section"].start_with?(name) }[0]
    courseDetails = currCourse["Section_Details"].split("; ").each { |det|
        detSplit = det.split(" | ")
        detLoc = det[0]
        detDays = det[1]
        detTimes = det[2]

        courseCal.event do |e|
            e.description = currCourse["Course_Title"]
            e.dtstart = DateTime.civil(2023, 1, 13, 6, 30)
            e.dtend = DateTime.civil(2023, 1, 13, 7, 30)
            e.location = loc[0];
            if detSplit.size() > 3
                e.rrule = "FREQ=WEEKLY;BYDAY=MO,WE;" # UNTIL=sometime
            end
            e.rrule = "FREQ=WEEKLY;BYDAY=MO,WE;"
        end 
    }
}

courseCal.publish
File.open("Course_Schedule.ics", "w").write(courseCal.to_ical)