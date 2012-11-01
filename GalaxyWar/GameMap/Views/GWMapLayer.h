//
//  GWMapLayer.h
//  GalaxyWar
//
//  Created by Ashwin Kamath on 10/28/12.
//  Copyright 2012 Ashwin Kamath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GWMapLayer : CCLayer

@property (nonatomic, assign) CGPoint baseOffset;

- (void) moveToCenter;

@end
