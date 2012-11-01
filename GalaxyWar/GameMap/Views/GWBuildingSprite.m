//
//  GWBuildingSprite.m
//  GalaxyWar
//
//  Created by Ashwin Kamath on 10/30/12.
//  Copyright (c) 2012 Ashwin Kamath. All rights reserved.
//

#import "GWBuildingSprite.h"
#import "cocos2d.h"

#define GLOW_ACTION_TAG 3021
#define GLOW_DURATION 0.6f
#define GLOW_AMOUNT 80

#define BOUNCE_ACTION_TAG 3022
#define BOUNCE_DURATION 0.1f // 1-way
#define BOUNCE_SCALE 1.1

@implementation GWBuildingSprite

- (id) initWithFile:(NSString *)filename {
  if ((self = [super initWithFile:filename])) {
    self.anchorPoint = ccp(0.5, 0);
  }
  return self;
}

- (void) displaySelected {
  [self stopActionByTag:GLOW_ACTION_TAG];
  [self stopActionByTag:BOUNCE_ACTION_TAG];
  self.scale = 1.f;
  
  int amt = GLOW_AMOUNT;
  CCTintBy *tint = [CCTintTo actionWithDuration:GLOW_DURATION red:255-amt green:255-amt blue:255-amt];
  CCTintBy *tintBack = [CCTintTo actionWithDuration:GLOW_DURATION red:255 green:255 blue:255];
  CCAction *action = [CCRepeatForever actionWithAction:[CCSequence actions:tint, tintBack, nil]];
  action.tag = GLOW_ACTION_TAG;
  [self runAction:action];
  
  CCScaleTo *scaleBig = [CCScaleTo actionWithDuration:BOUNCE_DURATION scale:BOUNCE_SCALE];
  CCScaleTo *scaleBack = [CCScaleTo actionWithDuration:BOUNCE_DURATION scale:1.f];
  CCAction *bounce = [CCEaseSineInOut actionWithAction:[CCSequence actions:scaleBig, scaleBack, nil]];
  action.tag = BOUNCE_ACTION_TAG;
  [self runAction:bounce];
}

- (void) displayUnselected {
  [self stopActionByTag:GLOW_ACTION_TAG];
  [self stopActionByTag:BOUNCE_ACTION_TAG];
  self.scale = 1.f;
  
  CCAction *action = [CCTintTo actionWithDuration:0.1f red:255 green:255 blue:255];
  action.tag = GLOW_ACTION_TAG;
  [self runAction:action];
}

@end
