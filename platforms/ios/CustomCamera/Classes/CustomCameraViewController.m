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
#import <AVFoundation/AVFoundation.h>
@implementation CustomCameraViewController;
@synthesize startButton;
UIView *overlayView;
UILabel *lyrics;
AVAudioPlayer *_audioPlayer;
int cameraHeight;

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
        self.picker.wantsFullScreenLayout = normal;

		// Make us the delegate for the UIImagePickerController
		self.picker.delegate = self;

		// Set the frames to be full screen
		CGRect screenFrame = [[UIScreen mainScreen] bounds];
        self.view.frame = screenFrame;
		//self.picker.view.frame = screenFrame;

		// Set this VC's view as the overlay view for the UIImagePickerController
		self.picker.cameraOverlayView = self.view;
        
        // Adding Overlay View
        int cameraHeight = screenFrame.size.height - 150;
        CGRect lyricsRect = CGRectMake(0,cameraHeight,screenFrame.size.width,150);
        UIView* overlayView = [[UIView alloc] initWithFrame:lyricsRect];
        overlayView.backgroundColor = [UIColor blackColor];
        [overlayView.layer setOpaque:NO];
        overlayView.opaque = NO;
        [self.picker.cameraOverlayView addSubview:overlayView];
        
        // Add Label for Overlay View to Display Lyrics
        UILabel *lyrics = [[UILabel alloc] initWithFrame:lyricsRect];
        [lyrics setTextColor:[UIColor whiteColor]];
        [lyrics setTextAlignment:NSTextAlignmentCenter];
        //[lyrics setTextColor:[UIColor whiteColor]];
        [lyrics setFont:[UIFont fontWithName:@"Trebuchet MS" size:20.0f]];
        [self.picker.cameraOverlayView addSubview:lyrics];
        NSString *lyricOne = @"Here are the lyrics, sing along y'all!";
        lyrics.text = lyricOne;
	}
	return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"View Loaded");
    [startButton addTarget:self action:@selector(beginRecording) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
    
    // Find Song
    NSString *path = [NSString stringWithFormat:@"%@/brandenburg.mp3", [[NSBundle mainBundle]resourcePath]];
    NSURL *soundURL = [NSURL fileURLWithPath:path];
    
    // Create Audio Player Object and Initialize with URL to Sound
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
    [_audioPlayer play];
    
    // Being Recording Video
    [self performSelector:@selector(clickButton) withObject:nil afterDelay:3.0];
}

// Action method.  This is like an event callback in JavaScript.
-(IBAction) takePhotoButtonPressed:(id)sender forEvent:(UIEvent*)event {
    // Call the takePicture method on the UIImagePickerController to capture the image.
    [self.picker startVideoCapture];
}

-(void)clickButton {
    [startButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

-(void)beginRecording {
    NSLog(@"Running this function");
    [self.picker startVideoCapture];
    [self.picker performSelector:@selector(stopVideoCapture) withObject:nil afterDelay:16];
    [_audioPlayer performSelector:@selector(stop) withObject:nil afterDelay:16];
}

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
