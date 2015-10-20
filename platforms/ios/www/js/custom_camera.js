var CustomCamera = {
<<<<<<< HEAD
    startVideoCapture: function(success, failure){
=======
	getVideo: function(success, failure){
>>>>>>> 728006c0e8113181a5a18aa5bfeac64c8cd5c9da
		cordova.exec(success, failure, "CustomCamera", "openCamera", []);
	}
};
module.exports = CustomCamera;