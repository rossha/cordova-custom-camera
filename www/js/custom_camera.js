var CustomCamera = {
	getVideo: function(success, failure){
		cordova.exec(success, failure, "CustomCamera", "openCamera", []);
	}
};
module.exports = CustomCamera;