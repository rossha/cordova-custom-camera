//
//  CustomCameraViewController.m
//  CustomCamera
//
//  Created by Shane Carr on 1/3/14.
//
//

#import "CustomCamera.h"
#import "CustomCameraViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
@implementation CustomCameraViewController;
@synthesize startButton;

// Entry point method
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Instantiate the UIImagePickerController instance
		self.picker = [[UIImagePickerController alloc] init];
        
		// Configure the UIImagePickerController instance
		self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
        self.picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
		self.picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        self.picker.videoMaximumDuration = 5.0;
		self.picker.showsCameraControls = NO;

		// Make us the delegate for the UIImagePickerController
		self.picker.delegate = self;

		// Set the frames to be full screen
		CGRect screenFrame = [[UIScreen mainScreen] bounds];
		self.view.frame = screenFrame;
		self.picker.view.frame = screenFrame;

		// Set this VC's view as the overlay view for the UIImagePickerController
		self.picker.cameraOverlayView = self.view;
	}
	return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"View Loaded");
    [startButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

// Action method.  This is like an event callback in JavaScript.
-(IBAction) takePhotoButtonPressed:(id)sender forEvent:(UIEvent*)event {
    // Call the takePicture method on the UIImagePickerController to capture the image.
    [self.picker startVideoCapture];
}

//-(void) beginRecording {
//    [sendActionsForControlEvents: UIControlEventTouchUpInside];
//}

// Delegate method.  UIImagePickerController will call this method as soon as the image captured above is ready to be processed.  This is also like an event callback in JavaScript.
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // Get a reference to the captured video
    //NSString* video_path = [[info objectForKey:UIImagePickerControllerMediaType] path];
    NSURL* video = [info objectForKey:UIImagePickerControllerMediaURL];
    NSData* videoData = [NSData dataWithContentsOfURL:video];
    
    // Get a file path to save the MP4
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* filename = @"test.mp4";
    NSString* videoPath = [documentsDirectory stringByAppendingPathComponent:filename];
    UISaveVideoAtPathToSavedPhotosAlbum(videoPath, self, nil, nil);
    
    // Write the data to the file
    [videoData writeToFile:videoPath atomically:NO];
    
    // Tell the plugin class that we're finished processing the image
    [self.plugin capturedVideoWithPath:videoPath];
}

@end
