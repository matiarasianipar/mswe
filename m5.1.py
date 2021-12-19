# https://stackoverflow.com/questions/41852393/python-loop-over-sqlite-select-with-fetchmany-until-no-entries-left
import mysql.connector
from mysql.connector import errorcode
import sys

class studentDatabase:

    def __init__(self):
        # initialize database
        try:
            self.cnx = mysql.connector.connect(
                user="root",
                password="Cecm2923",
                host="localhost"
            )
            self.cursor = self.cnx.cursor()
            self.cursor.execute("CREATE DATABASE IF NOT EXISTS studentDatabase")
            
        # database intilization error
        except mysql.connector.Error as err:
            if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
                print("Invalid username/password")
            elif err.errno == errorcode.ER_FAIER_BAD_DB_ERROR:
                print("ERROR: Failed to connect to database")
            else:
                print(err)

        try:
            self.cursor.execute(
                "USE studentDatabase;")
        except mysql.connector.Error as err:
            print(err.msg)

        # student table 
        try:
            self.cursor.execute(
                "CREATE TABLE IF NOT EXISTS students (student_id INT AUTO_INCREMENT PRIMARY KEY, student_last_name VARCHAR(45) NOT NULL, student_first_name VARCHAR(45) NOT NULL);")
        
        # student table error 
        except mysql.connector.Error as err:
            print(err.msg)

        # courses table
        try:
            self.cursor.execute(
                "CREATE TABLE IF NOT EXISTS courses (course_id INT AUTO_INCREMENT PRIMARY KEY, course_name VARCHAR(45) NOT NULL UNIQUE, course_day CHAR(3) NOT NULL, course_time CHAR(8));")
        
        # courses table error
        except mysql.connector.Error as err:
            print(err.msg)

        # student_courses table
        try:
            self.cursor.execute(
                "CREATE TABLE IF NOT EXISTS student_courses (student_id INT NOT NULL, course_id INT NOT NULL, CONSTRAINT students_courses_fk_students FOREIGN KEY (student_id) REFERENCES students (student_id), CONSTRAINT students_courses_fk_courses FOREIGN KEY (course_id) REFERENCES courses (course_id));")
        
        # student_courses table error
        except mysql.connector.Error as err:
            print(err.msg)

    # insert student
    def addStudent(self, student_last_name, student_first_name):

        sql = "INSERT INTO students VALUES (DEFAULT, %s, %s);"
        self.cursor.execute(sql, (student_last_name, student_first_name))
        self.cnx.commit()

    # insert course
    def addCourse(self, course_name, course_day, course_time):

        sql = "INSERT INTO courses VALUES (DEFAULT, %s, %s, TIME(%s));"
        self.cursor.execute(sql, (course_name, course_day, course_time))
        self.cnx.commit()

    # enroll in course
    def enroll(self, student_id, course_id):
        
        # else:
        sql = "INSERT INTO student_courses VALUES (%s, %s);"
        self.cursor.execute(sql, (student_id, course_id))
        self.cnx.commit()

    # find student ID 
    def getStudentID(self, student_id):

        sql = "SELECT * FROM students WHERE student_id = %s;"
        self.cursor.execute(sql, (student_id))
        sid = self.cursor.fetchone()
        return sid

    # find course ID
    def getCourseID(self, course_id):

        sql = "SELECT * FROM courses WHERE course_id = %s;"
        self.cursor.execute(sql, (course_id))
        cid = self.cursor.fetchone()
        return cid

    # boolean to determine whether student is enrolled in course 
    def enrolled(self, student_id, course_id):

        sql = "SELECT * FROM student_courses sc WHERE sc.student_id = %s and sc.course_id = %s;"
        self.cursor.execute(sql, (student_id, course_id))
        enr = self.cursor.fetchall()
        if len(enr) > 0:
            return True
        else:
            return False

    # querying to see which students are in each course 
    def courseEnrollment(self, course_id):

        sql = "SELECT c.course_name, CONCAT(s.student_last_name, ', ', s.student_first_name) AS student_name FROM students s JOIN student_courses sc ON s.student_id = sc.student_id JOIN courses c ON sc.course_id = c.course_id WHERE c.course_id = "+ course_id +" ORDER BY student_name;"
        self.cursor.execute(sql)
        rtrn = self.cursor.fetchall()
        print(rtrn)

    # querying to see which courses each student is in 
    def studentSchedule(self, student_id):

        sql = "SELECT CONCAT(s.student_last_name, ', ', s.student_first_name) AS student_name, c.course_name FROM courses c JOIN student_courses sc ON c.course_id = sc.course_id JOIN students s ON sc.student_id = s.student_id WHERE s.student_id = " + student_id + " ORDER BY c.course_name;"
        self.cursor.execute(sql)
        rtrn = self.cursor.fetchall()
        print(rtrn)


    # querying to see which courses and what times each course is for a given student on a given day of the week
    def studentDaySchedule(self, student_id, day):

        sql = "SELECT c.course_time, c.course_name FROM courses c JOIN student_courses sc ON c.course_id = sc.course_id JOIN students s ON sc.student_id = s.student_id WHERE s.student_id = " + student_id + " AND c.course_day = '" + day + "' ORDER BY c.course_time;"
        self.cursor.execute(sql)
        rtrn = self.cursor.fetchall()
        print(rtrn)

    # view all students
    def allStudents(self):

        sql = "SELECT * FROM students;"
        self.cursor.execute(sql)
        all = self.cursor.fetchall()
        return all

    # view all courses
    def allCourses(self):

        # no courses in database
        if len(self.allCourses() == 0):
            print("No courses in database\n")

        sql = "SELECT * FROM courses;"
        self.cursor.execute(sql)
        self.cursor.fetchall()

    def close(self):
        self.cursor.close()
        self.cnx.close()

def main():
    database = studentDatabase()

    print("\n" +
            "Student Schedule Database\n" +
            "Select an action\n" +
            "1. Add a new student\n" +
            "2. Add a new course\n" +
            "3. Enroll a student in a course\n" +
            "4. View an enrollment list for a course\n" +
            "5. View a full schedule for a student\n" +
            "6. View a day's schedule for a student\n")
            # "7. View all students in database\n" +
            # "8. View all courses in database\n" +
            # "7. Exit system\n")

    command = input()

    # add student to database
    if command == '1':
        lastname = input('Last name: ')
        firstname = input('First name: ')
        database.addStudent(lastname, firstname)
        print(firstname, ' ', lastname, 'added successfully\n')

    # add course to database
    if command == '2':

        # name of course
        coursename = input('Course name: \n')

        # day of course
        validDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri']
        courseday = input('Day (ex: Mon, Tue, Wed, Thu, Fri): \n')

        # invalid day
        if courseday not in validDays:
            print("ERROR: Invalid input for 'Day' ")

        # time of course
        coursetime = input('Time (ex: 09:00, 12:30, 15:00): \n')
        
        database.addCourse(coursename, courseday, coursetime)

        print(coursename, ' ', 'added successfully\n')

    # enroll a student in a course
    if command == '3':

        studentID = input('Student ID: \n')
        courseID = input('Course ID: \n')

        database.enroll(studentID, courseID)

        print('Student enrolled successfully')

    # view course enrollment list
    if command == '4':

        courseID = input('Course ID: \n')

        database.courseEnrollment(courseID)

    # view full student schedule
    if command == '5':

        studentID = input('Student ID: \n')

        database.studentSchedule(studentID)

    # view student's day schedule
    if command == '6':

        studentID = input('Student ID: \n')
        # day of course
        validDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri']
        courseday = input('Day (ex: Mon, Tue, Wed, Thu, Fri): \n')

        # invalid day
        if courseday not in validDays:
            print("ERROR: Invalid input for 'Day' ")

        else:
            database.studentDaySchedule(studentID, courseday)

if __name__ == "__main__":
    main()
