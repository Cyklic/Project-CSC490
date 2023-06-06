from datetime import datetime
from flask import Flask, render_template, Blueprint
from bluetooth import discover_devices
import bluetooth
# from pybluez import bluetooth
from student.route import student
from staff.routes import staff
from admin.routes import admin

app = Flask(__name__)
app.secret_key="gsvahbdnsadhvsgvhasbjnkxsajdhsgvdhbasjnxsa"

app.config["TEMPLATES_AUTO_RELOAD"]=True


@app.route('/')
def scan():
    return render_template('devices.html')

app.register_blueprint(student)
app.register_blueprint(staff)
app.register_blueprint(admin)

if __name__ == '__main__':
    app.run(debug=True)


# def algorithm():
#     username = input("Input username: ")
#     password = input("Input your password: ")
#     #Take image
#     if username == dbstudentregisteredusername:
#         get mypassword from database
#         get myimage from database
#         if mypassword == password:
#             Apply OpenCV Library
#             Convert  image-photo to grayscale
#             Convert myimage to grayscale
#             Apply CNN 
#             if CNN image-photo ==myimage:
#                 for b in bluetooth_active_devices:
#                     if b.signalstrength == 0.5:
#                         for d in distance_bluetooth_devices:
#                             if b.Mac_ID == d.Mac_ID:
#                                 get servertime
#                                 get course assigned within server time 
#                                 if myunique_ID is registered to course:
#                                     ("Take attendance")
#                                 else:
#                                     ("Not registered for the course assigned to active bluetooth device")
#                             else:
#                                 ("No active class")
#                     else:
#                         ("No active class")
#             else:
#                 ("retake image")
#         else:
#             ("reenter password")
#     else:
#         ("reenter username")
