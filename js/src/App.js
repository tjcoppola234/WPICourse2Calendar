import './App.css';
import { useState } from 'react';

function App() {
  const [courses, setCourses] = useState(["course1"])

  return (
    <div className="App">
      <header className="App-header">
        <p>Enter your course id</p>
        <div>
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

function makeical(courses) {

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
