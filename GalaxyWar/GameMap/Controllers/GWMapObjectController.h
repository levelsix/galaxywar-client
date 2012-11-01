//
//  GWMapObjectController.h
//  GalaxyWar
//
//  Created by Ashwin Kamath on 10/30/12.
//  Copyright (c) 2012 Ashwin Kamath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GWMapObject.h"

@protocol GWMapObjectController <NSObject>

- (id<GWMapObject>) mapObject;
- (CCNode *) mapSprite;

@end
