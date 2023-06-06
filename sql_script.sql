use Project

--- CREATING ALL THE TABLES INVOLVED IN THE SCHEMA
create table Admins(
	admin_id bigint identity(1,1),
	admin_username varchar(200),
	admin_password varchar(200)
);

insert into Admins(admin_username, admin_password) values ('root_admin', 'root_password')

create procedure spAUTHAdmins (
	@admin_username varchar(200),
	@admin_password varchar(200)
) as
 begin 
	select * from Admins where admin_username = @admin_username and admin_password = @admin_password
end

create table Faculty(
faculty_id int identity(1,1) primary key,
faculty_name varchar(100),
faculty_code varchar(10),
faculty_description text,
update_date date default(getdate()),
update_time time default(getdate())
);

create table Department(
department_id bigint identity(1,1) primary key,
department_name varchar(200),
department_code varchar(20),
department_description text,
update_date date default(getdate()),
update_time time default(getdate())
);

create table Programme(
programme_id bigint identity(1,1) primary key,
programme_name varchar(200),
programme_duration int,
);

create table Courses(
course_id bigint identity(1,1) primary key,
course_name varchar(100)
);

create table Registered_Courses(
registered_courses_id bigint identity(1,1) primary key,
);

create table Staff(
staff_id bigint identity(1,1) primary key,
staff_name varchar(200),
staff_email varchar(200) unique,
staff_tele varchar(11) unique,
);

create table Registered_Staff(
registered_staff_id bigint identity(1,1) primary key,
);

create table Levels(
level_id bigint identity(1,1) primary key,
level_name varchar(10)
);

create table Student(
student_id bigint identity(1,1) primary key,
student_name varchar(200),
matric_number varchar(25) unique,
email varchar(100) unique,
Telephone varchar(11) unique,
);

create table Registered_Student(
registered_student_id bigint identity(1,1) primary key,
);

create table Classes(
class_id bigint identity(1,1) primary key,
class_name varchar(20),
class_venue varchar(20)
);

create table bluetooth_device(
bluetooth_devices_id bigint identity(1,1) primary key,
bluetooth_devices_signal_id varchar(100),
bluetooth_device_name varchar(100)
);

create table Registered_Classes(
registered_classes_id bigint identity(1,1) primary key,
);

create table timetable(
timetable_id bigint identity(1,1) primary key,
timetable_date date default(getdate()),
time_in time,
time_out time,
);

create table Student_Attendance(
student_attendance_id bigint identity(1,1) primary key,
time_in time,
time_out time,
);

create table Sessionss(
session_id bigint identity(1,1) primary key,
session_start date,
session_end date
);

create table Semester(
semester_id bigint identity(1,1) primary key,
semester_start date,
semester_end date
);



--- CONNECTING ALL THE RELATED TABLES

alter table Department
add faculty_id int foreign key(faculty_id) references Faculty(faculty_id)

alter table Programme
add department_id bigint foreign key(department_id) references Department(department_id)

alter table Courses
add department_id bigint foreign key(department_id) references Department(department_id)

alter table Courses
add level_id bigint foreign key(level_id) references Levels(level_id),
semester_id bigint foreign key(semester_id) references Semester(semester_id)

alter table Registered_Courses
add session_id bigint foreign key(session_id) references Sessionss(session_id),
course_id bigint foreign key (course_id) references Courses(course_id)

alter table Staff
add department_id bigint foreign key (department_id) references Department(department_id)

alter table Staff
add staff_password varchar(200) default('welcome')

alter table Staff
add staff_image varchar(max)

alter table Staff
add staff_type varchar(200)

alter table Semester
add session_id bigint foreign key (session_id) references Sessionss(session_id)

alter table timetable
add registered_courses_id bigint foreign key (registered_courses_id) references Registered_Courses(registered_courses_id),
registered_classes_id bigint foreign key (registered_classes_id) references Registered_Classes(registered_classes_id)

alter table Student
add department_id bigint foreign key (department_id) references Department(department_id)

alter table Student
add student_password varchar(200) default('welcome')

alter table Student
add student_image varchar(max)

alter table Registered_Student
add registered_courses_id bigint foreign key (registered_courses_id) references Registered_Courses(registered_courses_id),
student_id bigint foreign key (student_id) references Student(student_id)

alter table Registered_Classes
add class_id bigint foreign key (class_id) references Classes(class_id),
bluetooth_devices_id bigint foreign key (bluetooth_devices_id) references Bluetooth_Device(bluetooth_devices_id)

alter table Registered_Staff
add registered_courses_id bigint foreign key (registered_courses_id) references Registered_Courses(registered_courses_id),
staff_id bigint foreign key (staff_id) references Staff(staff_id)

alter table Student_Attendance
add student_id bigint foreign key (student_id) references Student(student_id),
timetable_id bigint foreign key (timetable_id) references timetable(timetable_id)



---- CREATING THE INSERT AND UPDATE PROCEDURES FOR THE TABLES
create procedure spCRUDFaculty(
@faculty_id varchar(200),
@faculty_name varchar(200),
@faculty_code varchar(200),
@faculty_description varchar(max),
@StatementType varchar(200)
) as 
begin
	if @StatementType = 'INSERT'
	begin
		insert into Faculty(faculty_name, faculty_code, faculty_description) values
		(@faculty_name, @faculty_code, @faculty_description)
	end
	if @StatementType = 'UPDATE'
	begin
		update Faculty set faculty_name=@faculty_name, faculty_code=@faculty_code,faculty_description=@faculty_description
		where faculty_id=@faculty_id
	end
end

create procedure spCRUDDepartment(
@department_id varchar(200),
@department_name varchar(200),
@department_code varchar(200),
@department_description varchar(max),
@faculty_id varchar(200),
@StatementType varchar(200)
) as 
begin
	if @StatementType = 'INSERT'
	begin
		insert into Department(department_name, department_code, department_description, faculty_id) values
		(@department_name, @department_code, @department_description, @faculty_id)
	end
	if @StatementType = 'UPDATE'
	begin
		update Department set department_name=@department_name, department_code=@department_code, department_description=@department_description, faculty_id=@faculty_id
		where department_id = @department_id
	end
end

create procedure spCRUDProgramme(
@programme_id varchar(200),
@programme_name varchar(200),
@programme_duration varchar(200),
@department_id varchar(200),
@StatementType varchar(200)
) as
begin
	if @StatementType = 'INSERT'
	begin
		insert into Programme(programme_name, programme_duration, department_id) values
		(@programme_name, @programme_duration, @department_id)
	end
	if @StatementType = 'UPDATE'
	begin
		update Programme set programme_name=@programme_name, programme_duration=@programme_duration, department_id=@department_id
		where programme_id =@programme_id
	end
end

create procedure spCRUDCourses(
@course_id varchar(200),
@course_name varchar(200),
@department_id varchar(200),
@level_id varchar(200),
@semester_id varchar(200),
@StatementType  varchar(200)
) as
begin
	if @StatementType = 'INSERT'
	begin
		insert into Courses(course_name, department_id, level_id, semester_id) values
		(@course_name, @department_id, @level_id, @semester_id)
	end
	if @StatementType = 'UPDATE'
	begin
		update Courses set course_name=@course_name, department_id=@department_id, level_id=@level_id, semester_id=@semester_id
		where course_id=@course_id
	end
end

create procedure spCRUDRegistered_Courses(
@registered_courses_id varchar(200),
@session_id varchar(200),
@course_id varchar(200),
@StatementType varchar(200)
) as
begin
	if @StatementType = 'INSERT'
	begin
		insert into Registered_Courses(session_id, course_id) values
		(@session_id, @course_id)
	end
	if @StatementType = 'UPDATE'
	begin
		update Registered_Courses set session_id=@session_id, course_id=@course_id
		where registered_courses_id=@registered_courses_id
	end
end

create procedure spCRUDStaff(
@staff_id varchar(200),
@staff_name varchar(200),
@staff_email varchar(200),
@staff_tele varchar(200),
@department_id varchar(200),
@staff_image varchar(max),
@staff_type varchar(200),
@StatementType varchar(200)
) as
begin
	if @StatementType = 'INSERT'
	begin
		insert into Staff(staff_name, staff_email, staff_tele, department_id, staff_image, staff_type) values
		(@staff_name, @staff_email, @staff_tele,@department_id, @staff_image, @staff_type)
	end
	if @StatementType = 'UPDATE'
	begin
		update Staff set staff_name=@staff_name, staff_email=@staff_email, staff_tele=@staff_tele, department_id=@department_id, staff_image=@staff_image, staff_type=@staff_type
		where staff_id=@staff_id
	end
end

create procedure spCRUDRegistered_Staff(
@registered_staff_id varchar(200),
@registered_courses_id varchar(200),
@staff_id varchar(200),
@StatementType varchar(200)
) as
begin
	if @StatementType = 'INSERT'
	begin
		insert into Registered_Staff(registered_courses_id, staff_id) values
		(@registered_courses_id, @staff_id)
	end
	if @StatementType = 'UPDATE'
	begin
		update Registered_Staff set registered_courses_id=@registered_courses_id, staff_id=@staff_id
		where registered_staff_id=@registered_staff_id
	end
end

create procedure spCRUDLevels(
@level_id varchar(200),
@level_name varchar(200),
@StatementType varchar(200)
) as
begin
	if @StatementType = 'INSERT'
	begin
		insert into Levels(level_name) values
		(@level_name)
	end
	if @StatementType = 'UPDATE'
	begin
		update Levels set level_name=@level_name
		where level_id=@level_id
	end
end

select * from Student
create procedure spCRUDStudent(
@student_id varchar(200),
@student_name varchar(200),
@matric_number varchar(200),
@email varchar(200),
@Telephone varchar(200),
@department_id varchar(200),
@student_image varchar(200),
@StatementType varchar(200)
) as
begin
	if @StatementType = 'INSERT'
	begin
		insert into Student(student_name, matric_number, email, Telephone, department_id, student_image) values
		(@student_name, @matric_number,	@email, @Telephone, @department_id, @student_image)
	end
	if @StatementType = 'UPDATE'
	begin
		update Student set student_name=@student_name, matric_number=@matric_number, email=@email, Telephone=@Telephone, department_id=@department_id, student_image=@student_image
		where student_id=@student_id 
	end
end

create procedure spCRUDRegistered_Student(
@registered_student_id varchar(200),
@registered_courses_id varchar(200),
@student_id varchar(200),
@StatementType varchar(200)
) as 
begin
	if @StatementType = 'INSERT'
	begin
		insert into Registered_Student(registered_courses_id, student_id) values
		(@registered_courses_id, @student_id)
	end
	if @StatementType = 'UPDATE'
	begin
		update Registered_Student set registered_courses_id=@registered_courses_id, student_id=@student_id
		where registered_student_id=@registered_student_id
	end
end

create procedure spCRUDClasses(
@class_id varchar(200),
@class_name varchar(200),
@class_venue varchar(200),
@StatementType varchar(200)
) as
begin
	if @StatementType = 'INSERT'
	begin
		insert into Classes(class_name, class_venue) values
		(@class_name, @class_venue)
	end
	if @StatementType = 'UPDATE'
	begin
		update Classes set class_name=@class_name, class_venue=@class_venue
		where class_id=@class_id
	end
end

create procedure spCRUDbluetooth_device(
@bluetooth_devices_id varchar(200),
@bluetooth_devices_signal_id varchar(200),
@bluetooth_device_name varchar(200),
@StatementType varchar(200)
) as
begin
	if @StatementType = 'INSERT'
	begin
		insert into bluetooth_device(bluetooth_devices_signal_id, bluetooth_device_name) values
		(@bluetooth_devices_signal_id, @bluetooth_device_name)
	end
	if @StatementType = 'UPDATE'
	begin
		update bluetooth_device set bluetooth_devices_signal_id=@bluetooth_devices_signal_id, bluetooth_device_name=@bluetooth_device_name
		where bluetooth_devices_id=@bluetooth_devices_id
	end
end

create procedure spCRUDRegistered_Classes(
@registered_classes_id varchar(200),
@class_id varchar(200),
@bluetooth_devices_id varchar(200),
@StatementType varchar(200)
) as
begin
	if @StatementType = 'INSERT'
	begin
		insert into Registered_Classes(class_id, bluetooth_devices_id) values
		(@class_id, @bluetooth_devices_id)
	end
	if @StatementType = 'UPDATE'
	begin
		update Registered_Classes set class_id=@class_id, bluetooth_devices_id=@bluetooth_devices_id
		where registered_classes_id=@registered_classes_id
	end
end

create procedure spCRUDtimetable(
@timetable_id varchar(200),
@timetable_date varchar(200),
@time_in varchar(200),
@time_out varchar(200),
@registered_courses_id varchar(200),
@registered_classes_id varchar(200),
@StatementType varchar(200)
) as 
begin
	if @StatementType = 'INSERT'
	begin
		insert into timetable(timetable_date, time_in, time_out, registered_courses_id, registered_classes_id) values
		(@timetable_date, @time_in, @time_out, @registered_courses_id, @registered_classes_id)
	end
	if @StatementType = 'UPDATE'
	begin
		update timetable set timetable_date=@timetable_date, time_in=@time_in, time_out=@time_out, registered_courses_id=@registered_courses_id, registered_classes_id=@registered_classes_id
		where timetable_id=@timetable_id
	end
end

select * from Student_Attendance
create procedure spCRUDStudent_Attendance(
@student_attendance_id varchar(200),
@time_in varchar(200),
@time_out varchar(200),
@student_id varchar(200),
@timetable_id varchar(200),
@StatementType varchar(200)
) as
begin 
	if @StatementType = 'INSERT'
	begin
		insert into Student_Attendance(time_in, time_out, student_id, timetable_id) values
		(@time_in, @time_out, @student_id, @timetable_id)
	end
	if @StatementType = 'UPDATE'
	begin
		update Student_Attendance set time_in=@time_in, time_out=@time_out, timetable_id=@timetable_id
		where student_attendance_id=@student_attendance_id
	end
end

create procedure spCRUDSessions(
@session_id varchar(200),
@session_start varchar(200),
@session_end varchar(200),
@StatementType varchar(200)
) as
begin
	if @StatementType = 'INSERT'
	begin
		insert into Sessionss(session_start, session_end) values
		(@session_start, @session_end)
	end
	if @StatementType = 'UPDATE'
	begin
		update Sessionss set session_start=@session_start, session_end=@session_end
		where session_id=@session_id
	end
end

create procedure spCRUDSemester(
@semester_id varchar(200),
@semester_start varchar(200),
@semester_end varchar(200),
@session_id varchar(200),
@StatementType varchar(200)
) as 
begin 
	if @StatementType = 'INSERT'
	begin 
		insert into Semester(semester_start, semester_end, session_id) values
		(@semester_start, @semester_end, @session_id)
	end
	if @StatementType = 'UPDATE'
	begin
		update Semester set semester_start=@semester_start, semester_end=@semester_end, session_id=@session_id
		where semester_id=@semester_id
	end
end

select * from Faculty

insert into Faculty(faculty_name, faculty_code, faculty_description) values ('Education', 'EDU', 'Something about Educating') 

select * from Department

insert into Department(department_name, department_code, department_description, faculty_id) values ('Pure & Applied Sciences', 'CHM', 'Something Chemistrying', '1')

select * from Student

insert into Student(student_name, matric_number, email, Telephone, department_id) values ('Barry Allen', 'VUG/CHM/19/3266', 'barryallen@gmail.com', '07022223344', '5')

select * from Sessionss

insert into Sessionss(session_start, session_end) values ('2022', '2023') 

select * from Semester

insert into Semester(semester_start, semester_end, session_id) values ('2022-07-01', '2022-11-01', '1')

select * from Levels

insert into Levels(level_name) values ('400')

select * from Courses

insert into Courses(course_name, department_id, level_id, semester_id) values ('Cyber Security', '1', '1', '2')

select * from Registered_Courses

insert into Registered_Courses(session_id, course_id) values ('1', '1')

select * from bluetooth_device

insert into bluetooth_device(bluetooth_devices_signal_id, bluetooth_device_name) values ('94:54:CE:D0:54:CE', 'Block A')

select * from Classes

insert into Classes(class_name, class_venue) values ('Hardware Lab', 'Block A top floor')

select * from Registered_Classes

insert into Registered_Classes(class_id, bluetooth_devices_id) values ('1', '1')

select * from timetable

insert into timetable(timetable_date, time_in, time_out, registered_courses_id, registered_classes_id) values ('2023-05-22', '13:00', '15:00', '1', '1')

select * from Staff

insert into Staff(staff_name, staff_email, staff_tele, department_id) values ('Uloko Felix', 'ulokofelix@gmail.com', '08042423311', '1')

select * from Registered_Student

insert into Registered_Student(registered_courses_id, student_id) values ('1', '1')

select * from Registered_Staff

insert into Registered_Staff(registered_courses_id, staff_id) values ('1', '1')



create procedure spAUTHStudent(
	@email varchar(200),
	@student_password varchar(200)
)
as
begin
	select email, student_password from Student where email=@email and student_password=@student_Password
end

create procedure selectAllStudents (
	@student_email varchar(200),
	@old_password varchar(200)
) as
begin
	select * from Student where @student_email=email and student_password = @old_password
end


create procedure changePassword(
	@email varchar(200),
	@old_password varchar(200),
	@new_password varchar(200),
	@accountType varchar(200),
	@statement varchar(200)
) as
begin
	if @statement = 'Change Password'
	begin
		if @accountType = 'Student'
		begin
			update StudentQry set student_password = @new_password from 
			(select * from Student where email = @email and student_password = @old_password ) as StudentQry
		end 
		if @accountType = 'Staff'
		begin
			update StaffQry set staff_password = @new_password from 
			(select * from Staff where staff_email = @email and staff_password = @old_password ) as StaffQry
		end 
	end
end


Exec selectAllStudents @student_email = 'barryallen@gmail.com', @old_password = 'something_new'

select * from Student

select * from Staff

Exec changePassword @email = 'umoruleonard@gmail.com', @old_password = 'leo7', @new_password = 'leo77', @accountType = 'Student', @statement = 'Change Password'


Exec changePassword @email = 'ulokofelix@gmail.com', @old_password = 'welcome', @new_password = 'Something New', @accountType = 'Staff', @statement = 'Change Password'