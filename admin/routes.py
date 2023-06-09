from flask import Blueprint, blueprints, render_template, redirect, url_for, request
import pyodbc
from connection.controller import connection

admin = Blueprint('admin', __name__, url_prefix='/admin', template_folder='templates', static_folder='static')

@admin.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        try:
            username = request.form.get('username')
            password = request.form.get('password')
            conn = connection()
            cur = conn.cursor()
            stored_proc = 'Exec spAUTHAdmins @admin_username=?, @admin_password=?'
            param = username, password
            cur.execute(stored_proc, param)
            rows = cur.fetchone()
            cur.close()
            conn.commit()
            if rows:
                return redirect(url_for('admin.dashboard'))
            return render_template('admin_index.html')
        except (pyodbc.Error) as e:
            message = e
            return render_template('admin_index.html', message=e)

    return render_template('admin_index.html')

@admin.route('/dashboard', methods=['GET', 'POST'])
def dashboard():
    return render_template('admin_dashboard.html')

@admin.route('/add-student', methods=['GET', 'POST'])
def add_students():
    if request.method == 'POST':
        try:
            student_name = request.form.get('student_name')
            matric_num = request.form.get('matric_number')
            email = request.form.get('email')
            tel_num = request.form.get('tel_num')
            dept_id = request.form.get('department_id')
            student_image = request.form.get('student_image')
            
            conn = connection()
            cur = conn.cursor()
            stored_proc = 'Exec spCRUDStudent @student_id=?, @student_name=?, @matric_number=?, @email=?, @Telephone=?, @department_id=?, @student_image=?, @StatementType=?'
            param = '1',student_name,matric_num,email,tel_num,dept_id,student_image,'INSERT'
            cur.execute(stored_proc, param)
            cur.close()
            conn.commit()
            return redirect(url_for('admin.dashboard'))
        except (pyodbc.Error) as e:
            message = e
            return render_template('add_student.html', message=message)
    return render_template('add_student.html')

@admin.route('/add-staff', methods=['GET', 'POST'])
def add_staff():
    if request.method == 'POST':
        try:
            staff_name = request.form.get('staff_name')
            email = request.form.get('email')
            tel_num = request.form.get('tel_num')
            dept_id = request.form.get('department_id')
            staff_image = request.form.get('staff_image')
            staff_type = request.form.get('staff_type')
            # print(staff_image)
            
            conn = connection()
            cur = conn.cursor()
            stored_proc = 'Exec spCRUDStaff @staff_id=?, @staff_name=?, @staff_email=?, @staff_tele=?, @department_id=?, @staff_image=?, @staff_type=?, @StatementType=?'
            param = '1',staff_name,email,tel_num,dept_id,staff_image, staff_type,'INSERT'
            cur.execute(stored_proc, param)
            cur.close()
            conn.commit()
            return redirect(url_for('admin.dashboard'))
        except (pyodbc.Error) as e:
            message = e
            return render_template('add_staff.html', message=message)
    return render_template('add_staff.html')