//
//  GWMapSource.h
//  GalaxyWar
//
//  Created by Ashwin Kamath on 10/30/12.
//  Copyright (c) 2012 Ashwin Kamath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GWStructs3D.h"

@protocol GWMapSource <NSObject>

- (CGPoint) ccPointForTilePoint:(CGPoint)pt;
- (CGPoint) tilePointForCCPoint:(CGPoint)pt;
- (CGPoint) ccPointForGWPoint3D:(GWPoint3D)pt;

- (BOOL) tileBlockIsOpen:(CGRect)tileBlock;
- (BOOL) tileCoordIsOpen:(CGPoint)tileCoord;

- (CGSize) tileSize;
- (CGSize) mapSize;

@end
