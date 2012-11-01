//
//  GWMapLayer.m
//  GalaxyWar
//
//  Created by Ashwin Kamath on 10/28/12.
//  Copyright 2012 Ashwin Kamath. All rights reserved.
//

#import "GWMapLayer.h"
#import "CCGestureRecognizer.h"

@implementation GWMapLayer

- (id) init {
  if ((self = [super init])) {
    CCSprite *bgd = [CCSprite spriteWithFile:@"magic_bgr_left.png"];
    [self addChild:bgd];
    bgd.anchorPoint = ccp(0, 0);
    
    CCSprite *bgdRight = [CCSprite spriteWithFile:@"magic_bgr_right.png"];
    [self addChild:bgdRight];
    bgdRight.anchorPoint = ccp(0, 0);
    bgdRight.position = ccp(bgd.contentSize.width, 0);
    
    self.contentSize = CGSizeMake(bgd.contentSize.width+bgdRight.contentSize.width, bgd.contentSize.height);
    
    self.anchorPoint = ccp(0,0);
    
    self.baseOffset = CGPointMake(636, 190);
  }
  return self;
}

#pragma mark - Map Movement

- (void) moveToCenter {
  int x = -self.contentSize.width/2*self.scaleX+self.parent.contentSize.width/2;
  int y = -self.contentSize.height/2*self.scaleY+self.parent.contentSize.height/2;
  [self setPosition:ccp(x, y)];
}

- (void) setPosition:(CGPoint)position {
  float minX = 0;
  float minY = 0;
  float maxX = self.contentSize.width;
  float maxY = self.contentSize.height;
  
  float x = MAX(MIN(-minX*self.scaleX, position.x), -maxX*self.scaleX + self.parent.contentSize.width);
  float y = MAX(MIN(-minY*self.scaleY, position.y), -maxY*self.scaleY + self.parent.contentSize.height);
  
  [super setPosition:ccp(x,y)];
}

- (void) setScale:(float)scale {
  int newWidth = self.contentSize.width*scale;
  int newHeight = self.contentSize.height*scale;
  
  if (newWidth >= self.parent.contentSize.width && newHeight >= self.parent.contentSize.height) {
    [super setScale:scale];
  }
}

@end
