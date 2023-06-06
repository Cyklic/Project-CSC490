var video = document.getElementById('video');
var capture = document.getElementById('capture');
var captuedImage = document.getElementById('captured-image');
var captuedImage = document.createElement('img');
var imageHidden = document.getElementById('staff_image');
var stream
var imageData

navigator.mediaDevices.getUserMedia({ video: true})
.then(function(stream) {
    video.srcObject = stream;
    video.play();
    stream = stream
})
.catch(function(error) {
    console.error('Error accessing video stream:', error)
})

capture.addEventListener('click', function() {
    var canvas = document.createElement('canvas');
    var context = canvas.getContext('2d');
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;
    context.drawImage(video, 0, 0, canvas.width, canvas.width);
    imageData = canvas.toDataURL('image/png');
    var imageDataRes = imageData.replace("data:image/png;base64,", "");

    imageHidden.value = imageDataRes;

    video.srcObject = null
    video.remove();
    video.style.display = 'none';
    capture.style.display = 'none';

    captuedImage.src = imageData;
    captuedImage.style.display = 'block';
    document.body.appendChild(captuedImage)
})