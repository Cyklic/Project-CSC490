# if request.method == 'POST':
#         if rows:
#             for row in rows:
#                 class_device = row.bluetooth_devices_signal_id
#                 today=row.Today
#                 todaytime=row.TodayTime
#                 devices = bluetooth.discover_devices(duration=8, lookup_names=True, flush_cache=True)
#                 #loop through the bluetooth scanned devices
#                 for r in devices:
#                     print('This is the class device', class_device)
#                     print('This is the Date Query', today)
#                     print('This is the time query', todaytime)
#                     deviceid=r[0]
#                     if class_device==deviceid:
#                         if today==0:
#                             if todaytime==1:
#                                 con=connection()
#                                 cur=con.cursor()
#                                 stored_proc=""
#                                 param=""
#                                 cur.execute(stored_proc, param)
#                                 cur.close()
#                                 con.commit()
#                                 con.close()
#                                 flash("Attendance taken successully.")
#                                 return render_template('student_attendance_page.html')
#                             else:
#                                 flash("No Class for this available time")
#                                 return render_template('student_attendance_page.html')
#                         else:
#                             flash("No Course available for today.")
#                             return render_template('student_attendance_page.html')
#                     else:
#                         flash('Bluetooth No Detected')
#                         return render_template('student_attendance_page.html')
#         else:
#             flash("You are not registered.")
#             return render_template('student_attendance_page.html')
#     return render_template('student_attendance_page.html')