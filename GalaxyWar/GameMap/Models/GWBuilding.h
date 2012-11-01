//
//  GWBuilding.h
//  GalaxyWar
//
//  Created by Ashwin Kamath on 10/30/12.
//  Copyright (c) 2012 Ashwin Kamath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GWMapObject.h"
#import "cocos2d.h"

@interface GWBuilding : NSObject <GWMapObject>

@property (nonatomic, assign) CGPoint groundOffset;
@property (nonatomic, assign) CGSize groundSize;

@property (nonatomic, assign) CGPoint baseOffset;
@property (nonatomic, assign) CGSize baseSize;

@property (nonatomic, assign) int level;
@property (nonatomic, assign) int hitpoints;

@property (nonatomic, assign) ccTime secondsTillUpdateComplete;
@property (nonatomic, readonly) BOOL isUpdating;

- (CGRect) groundRect;
- (CGRect) relativeBaseRect;
- (CGRect) absoluteBaseRect;

@end
