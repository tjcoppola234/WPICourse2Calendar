require 'net/http'
require 'json'
require 'icalendar-rrule'

using Icalendar::Scannable

# Maps day letters to icalendar rrule format
rruleDays = {"M" => "MO", "T" => "TU", "W" => "WE", "R" => "TH", "F" => "FR"}

courseNames = File.open("course_sections.txt").readlines.map(&:chomp)
p courseNames

courseCal = Icalendar::Calendar.new 

courseInfoRaw = Net::HTTP.get(URI("https://courselistings.wpi.edu/assets/prod-data.json"))
courseInfoParsed = JSON.parse(courseInfoRaw)
courseNames.each { |name|
    currCourse = courseInfoParsed["Report_Entry"].select { |c| c["Course_Section"].start_with?(name) }[0]
    courseDetails = currCourse["Section_Details"].split("; ").each { |det|
        # The location, days of the week, and class times of the course
        detSplit = det.split(" | ")
        detLoc = detSplit[0]
        # Get the days of the week where there is class (Ex: "MO,TU,TH,FR")
        detDays = []
        detSplit[1].split("-").each_with_index do |d, i|
            detDays[i] = rruleDays[d]
        end
        detDays = detDays.join(",")
        # Get the start time and end time for each class day (Ex: [["9","00"], ["9","50"]])
        detTimes = detSplit[2].split(" ")
        pmStart = false
        pmEnd = false
        # Adjust hour number if class is at P.M. time
        if detTimes[1] == "PM"
            pmStart = true
        end
        if detTimes[-1] == "PM"
            pmEnd = true
        end
        detTimes = [detTimes[0].split(":"), detTimes[-2].split(":")]
        if pmStart == true
            detTimes[0][0] = (detTimes[0][0].to_i + 12).to_s
        end
        if pmEnd == true
            detTimes[1][0] = (detTimes[1][0].to_i + 12).to_s
        end
        # The first and last day of the course
        startDate = currCourse["Course_Section_Start_Date"].split("-")
        endDate = currCourse["Course_Section_End_Date"].split("-")

        courseCal.event do |e|
            e.summary = currCourse["Course_Title"]
            e.dtstart = DateTime.civil(startDate[0].to_i, startDate[1].to_i, startDate[2].to_i, detTimes[0][0].to_i, detTimes[0][1].to_i)
            e.dtend = DateTime.civil(startDate[0].to_i, startDate[1].to_i, startDate[2].to_i, detTimes[1][0].to_i, detTimes[1][1].to_i)
            e.location = detLoc;
            e.rrule = "FREQ=WEEKLY;BYDAY=#{detDays};UNTIL=#{DateTime.civil(endDate[0].to_i, endDate[1].to_i, endDate[2].to_i)};"
        end
    }
}

courseCal.publish
File.open("Course_Schedule.ics", "w").write(courseCal.to_ical)