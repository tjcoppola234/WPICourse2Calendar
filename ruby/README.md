# WPICourse2Calendar
A script that takes in WPI course IDs and creates a .ics file for your calendar.

## Requirements
- <a href="https://www.ruby-lang.org/en/downloads/">Ruby 3.1</a> (or greater)
- <a href="https://rubygems.org/gems/bundler/">Bundler</a>

## How to use
 1. Edit the `course_sections.txt` file: For each course you want to add to your calendar, add its course code on a new line in the format "DepartmentID CourseNumber-Term/semester year" (Ex: AB 1533-C01 2023). These course ID sequences can be found on Workday or at https://courselistings.wpi.edu/. Examples can be found in `course_sections.txt`
 2. Run the project: Navigate to the project directory and enter `bundle install` then `ruby WPICourse2Calendar.rb` in a terminal
 3. Your calendar file will be saved as Course_Schedule.ics, where you can open it or import it into any calendar application

This project is not affiliated with Worcester Polytechnic Institute
