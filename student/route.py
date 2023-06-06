from flask import Flask, render_template, url_for, redirect, request, Blueprint, flash
from bluetooth import discover_devices
import pyodbc
from connection.controller import connection
import numpy as np
import base64
import cv2
from deepface import DeepFace
import bluetooth
from datetime import datetime


student = Blueprint('student', __name__, url_prefix='/student', template_folder='templates', static_folder='static')

var = {

}

@student.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        try:
            email = request.form.get('email')
            student_password = request.form.get('student_password')
            student_image = request.form.get('student_image')
            stored_proc = 'Exec spAUTHStudent @email=?, @student_password=?'
            param = email, student_password
            conn = connection()
            cur = conn.cursor()
            cur.execute(stored_proc, param)
            row = cur.fetchone()
            cur.close()
            conn.commit()
            if row:
                student_db_image = row.student_image
                nparr1 = np.frombuffer(base64.b64decode(student_image), np.uint8)
                nparr2 = np.frombuffer(base64.b64decode(student_db_image), np.uint8)
                img1 = cv2.imdecode(nparr1, cv2.COLOR_BGR2GRAY)
                img2 = cv2.imdecode(nparr2, cv2.COLOR_BGR2GRAY)
                img_result = DeepFace.verify(img1, img2, enforce_detection=False)
                print(img_result)
                if img_result['verified'] == True:
                    var['student_id'] = row.student_id
                    return redirect(url_for('student.attendance_page'))
                else:
                    return render_template('student_login.html')
            return render_template('student_login.html')
        except (pyodbc.Error) as e:
            message = e
            return render_template('student_login.html', message=message)
    return render_template('student_login.html')

@student.route('/attendance-page', methods=['GET', 'POST'])
def attendance_page():
    student_id = var['student_id']
    conn = connection()
    cur = conn.cursor()
    stored_proc = 'Exec getClasses4 @student_id=?'
    param = student_id
    cur.execute(stored_proc, param)
    rows = cur.fetchall()
    cur.close()
    conn.close()
    print(rows)
    devices = bluetooth.discover_devices(duration=8, lookup_names=True, flush_cache=True)
    if request.method == 'POST':
        try:
            time_in = request.form.get('time_in')
            time_out = request.form.get('time_out')
            timetable_id = request.form.get('timetable_id')
            conn = connection()
            cur = conn.cursor()
            stored_proc2 = 'spCRUDStudent_Attendance @student_attendance_id=?, @time_in=?, @time_out=?, @student_id=?, @timetable_id=?, @StatementType=?'
            param2 = '1', time_in, time_out, student_id, timetable_id, 'INSERT'
            cur.execute(stored_proc2, param2)
            cur.close()
            conn.commit()
            return redirect(url_for('student.index'))
        except (pyodbc.Error) as e:
            flash(e)
            return render_template("student_attendance_page.html")
    return render_template('student_attendance_page.html', rows=rows, devices=devices)
    
