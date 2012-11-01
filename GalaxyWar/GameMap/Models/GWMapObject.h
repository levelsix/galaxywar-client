//
//  GWMapObject.h
//  GalaxyWar
//
//  Created by Ashwin Kamath on 10/30/12.
//  Copyright (c) 2012 Ashwin Kamath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GWStructs3D.h"

@protocol GWMapObject <NSObject>

- (CGRect) groundRect;
- (GWPoint3D) location3D;
- (GWSize3D) size3D;
- (BOOL) isAirObject;

@optional
// Called periodically in a home map setting
- (void) homeUpdate:(ccTime)dt;
// Called periodically in a visit map setting
- (void) visitUpdate:(ccTime)dt;
// Called periodically in an attack map setting
- (void) attackUpdate:(ccTime)dt;

@end
