//
//  GWRootViewController.m
//  GalaxyWar
//
//  Created by Ashwin Kamath on 10/26/12.
//  Copyright (c) 2012 Ashwin Kamath. All rights reserved.
//

#import "GWRootViewController.h"
#import "cocos2d.h"
#import "GWMapLayer.h"
#import "GWAppDelegate.h"

@implementation GWRootViewController

- (void) viewDidAppear:(BOOL)animated {
  GWAppDelegate *appDelegate = (GWAppDelegate *)([UIApplication sharedApplication].delegate);
  [appDelegate setupCocos2d];
  [self displayContentController:[CCDirector sharedDirector]];
}

- (void) displayContentController:(UIViewController *)content {
  [self addChildViewController:content];
  content.view.frame = self.view.bounds;
  [self.view addSubview:content.view];
  [content didMoveToParentViewController:self];
}

- (void) hideContentController:(UIViewController *)content {
  [content willMoveToParentViewController:nil];
  [content.view removeFromSuperview];
  [content removeFromParentViewController];
}

- (void) loadView {
  CGRect rect = [[UIScreen mainScreen] bounds];
  rect.size = CGSizeMake(rect.size.height, rect.size.width);
  UIView *v = [[UIView alloc] initWithFrame:rect];
  v.backgroundColor = [UIColor blackColor];
  
  self.view = v;
}

#pragma mark iOS5 requirements

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
  [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
  
  CCDirector *dir = [CCDirector sharedDirector];
  if (!CGRectEqualToRect(self.view.bounds, dir.view.frame)) {
    dir.view.frame = self.view.bounds;
    dir.runningScene.contentSize = self.view.bounds.size;
  }
}

@end