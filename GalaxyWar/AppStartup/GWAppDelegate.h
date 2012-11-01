//
//  GWAppDelegate.h
//  GalaxyWar
//
//  Created by Ashwin Kamath on 10/26/12.
//  Copyright (c) 2012 Ashwin Kamath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "GWRootViewController.h"

@interface GWAppDelegate : UIResponder <UIApplicationDelegate, CCDirectorDelegate> {
	UIWindow *_window;
	GWRootViewController *_rootViewController;
  
	CCDirectorIOS	*_director;							// weak ref
}

@property (strong, nonatomic) UIWindow *window;
@property (readonly) CCDirectorIOS *director;
@property (readonly) GWRootViewController *rootViewController;

- (void) setupCocos2d;

@end
