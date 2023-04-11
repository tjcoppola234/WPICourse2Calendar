import './App.css';
import { useState } from 'react';
import { createEvent } from 'ics';

function App() {
  const [courses, setCourses] = useState(["course1"])

  return (
    <div className="App">
      <header className="App-header">
        <p>Enter your course id</p>
        <div id='courseList'>
          {courses.map(i => <input id={i} type="text"/>)}
        </div>
        <div style={{display:"flex", flexDirection: "row"}}>
          <button type="button" onClick={() => setCourses([...addCourseInput(courses)])}>Add course</button>
          <button type="button" onClick={() => setCourses([...removeCourseInput(courses)])}>Remove course</button>
        </div>
        <button type="button" onClick={makeical}>Create calendar</button>
      </header>
    </div>
  );
}

async function makeical(courses) {
  // Maps day letters to icalendar rrule format
  const rruleDays = {"M" : "MO", "T" : "TU", "W" : "WE", "R" : "TH", "F" : "FR"}
  
  // Read the courses from input
  const docCourseList = document.getElementById("courseList").children;
  let courseList = []
  for(let i = 0; i < docCourseList.length; i++) {
    const courseName = docCourseList[i].value.split(" ")
    courseList[i] = [courseName[0] + " " + courseName[1], courseName[2]];
  }
  
  // Load raw course data
  fetch("https://courselistings.wpi.edu/assets/prod-data-raw.json", {
    headers: {'mode': 'no-cors'}
  })
  .then(res => res.json())
  .then(json => {
    for(let course of courseList) {
      let currCourse = json.Report_Entry.find(c => c.Course_Section.startsWith(course[0]) && c.Offering_Period.startsWith(course[1]))
      console.log(currCourse)
    }
  })

  const event = {
    start: [2018, 10, 15],
    end: [2018, 10, 16],
    recurrenceRule: "FREQ=WEEKLY;UNTIL=20230503T000000;BYDAY=MO,TH"
  }
  
  // Implementation from https://github.com/adamgibbons/ics#using-esmodules--in-the-browser
  // const filename = 'Course_Schedule.ics'
  // const file = await new Promise((resolve, reject) => {
  //   createEvent(event, (error, value) => {
  //     if (error) {
  //       reject(error)
  //     }
  //     resolve(new File([value], filename, { type: 'plain/text' }))
  //   })
  // })
  // const url = URL.createObjectURL(file);
  // const anchor = document.createElement('a');
  // anchor.href = url;
  // anchor.download = filename;
  // document.body.appendChild(anchor);
  // anchor.click();
  // document.body.removeChild(anchor);
  
  // URL.revokeObjectURL(url);
}

function addCourseInput(courses) {
  let newInput = `course${courses.length + 1}`;
  courses.push(newInput);
  return courses;
}
function removeCourseInput(courses) {
  courses.pop()
  return courses;
}

export default App;
