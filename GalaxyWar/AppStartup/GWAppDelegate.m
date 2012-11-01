//
//  GWAppDelegate.m
//  GalaxyWar
//
//  Created by Ashwin Kamath on 10/26/12.
//  Copyright (c) 2012 Ashwin Kamath. All rights reserved.
//

#import "GWAppDelegate.h"
#import "GWHomeMapController.h"
#import "GWMap.h"

@implementation GWAppDelegate

@synthesize window=_window, director=_director, rootViewController=_rootViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Create the main window
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
	// Create a Navigation Controller with the Director
  _rootViewController = [[GWRootViewController alloc] init];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:_rootViewController];
	navController.navigationBarHidden = YES;
	
	// set the Navigation Controller as the root view controller
	[_window setRootViewController:navController];
	
	// make main window visible
	[_window makeKeyAndVisible];
	
	return YES;
}

- (void) setupCocos2d {
	// Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
	CCGLView *glView = [CCGLView viewWithFrame:[_window bounds]
                                 pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
                                 depthFormat:0	//GL_DEPTH_COMPONENT24_OES
                          preserveBackbuffer:NO
                                  sharegroup:nil
                               multiSampling:NO
                             numberOfSamples:0];
  
	_director = (CCDirectorIOS*) [CCDirector sharedDirector];
  
	_director.wantsFullScreenLayout = YES;
  
	// Display FSP and SPF
	[_director setDisplayStats:YES];
  
	// set FPS at 60
	[_director setAnimationInterval:1.0/60];
  
	// attach the openglView to the director
	[_director setView:glView];
  
	// for rotation and other messages
  [_director setDelegate:self];
  
	// 2D projection
	[_director setProjection:kCCDirectorProjection2D];
  //	[director setProjection:kCCDirectorProjection3D];
  
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ![_director enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
  
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
  
	// If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
	// On iPad HD  : "-ipadhd", "-ipad",  "-hd"
	// On iPad     : "-ipad", "-hd"
	// On iPhone HD: "-hd"
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];				// Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@""];					// Default on iPad is "ipad"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"@2x"];	// Default on iPad RetinaDisplay is "-ipadhd"
  
	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
}

// This is needed for iOS4 and iOS5 in order to ensure
// that the 1st scene has the correct dimensions
// This is not needed on iOS6 and could be added to the application:didFinish...
- (void) directorDidReshapeProjection:(CCDirector*)director
{
	if(director.runningScene == nil) {
		// Add the first scene to the stack. The director will draw it immediately into the framebuffer. (Animation is started automatically when the view is displayed.)
		// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
    
    GWMap *map = [[GWMap alloc] init];
    map.mapSize = CGSizeMake(36, 36);
    
		[director runWithScene:[[GWHomeMapController alloc] initWithMap:map]];
	}
}

// Supported orientations: Landscape. Customize it for your own needs
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


// getting a call, pause the game
- (void) applicationWillResignActive:(UIApplication *)application
{
		[_director pause];
}

// call got rejected
- (void) applicationDidBecomeActive:(UIApplication *)application
{
		[_director resume];
}

- (void) applicationDidEnterBackground:(UIApplication*)application
{
		[_director stopAnimation];
}

- (void) applicationWillEnterForeground:(UIApplication*)application
{
		[_director startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
- (void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

@end