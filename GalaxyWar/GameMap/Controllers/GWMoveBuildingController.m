//
//  GWMoveBuildingController.m
//  GalaxyWar
//
//  Created by Ashwin Kamath on 10/30/12.
//  Copyright (c) 2012 Ashwin Kamath. All rights reserved.
//

#import "GWMoveBuildingController.h"
#import "cocos2d.h"

@implementation GWMoveBuildingController

- (id) init {
  if ((self = [super init])) {
    self.layer = [CCLayer node];
    self.metaLayer = [CCLayer node];
    [_layer addChild:_metaLayer];
  }
  return self;
}

- (void) beginTrackingForBuildingController:(GWBuildingController *)bc {
  self.buildingController = bc;
  _currentBuildingTileCoordinate = self.buildingController.building.groundOffset;
  _startTouchLocation = CGPointZero;
  _isMoving = NO;
}

- (void) endTracking {
  [self clearMeta];
  self.buildingController = nil;
  _isMoving = NO;
}

#pragma mark - MetaLayer methods

- (void) updateMeta {
  [self clearMeta];
  
  CGPoint baseOffset = _currentBuildingTileCoordinate;
  CGSize size = _buildingController.building.groundSize;
  for (int i = 0; i < size.width; i++) {
    for (int j = 0; j < size.height; j++) {
      CGPoint pt = ccpAdd(baseOffset, ccp(i,j));
      
      CGRect picRect;
      picRect.origin.y = 0;
      picRect.size = [_mapSource tileSize];
      if ([_mapSource tileCoordIsOpen:pt]) {
        picRect.origin.x = picRect.size.width;
      } else {
        picRect.origin.x = 0;
      }
      
      CCSprite *tile = [CCSprite spriteWithFile:@"metatiles.png" rect:picRect];
      [_metaLayer addChild:tile];
      tile.anchorPoint = ccp(0.5f, 0);
      tile.position = [_mapSource ccPointForTilePoint:pt];
    }
  }
}

- (void) clearMeta {
  [_metaLayer removeAllChildrenWithCleanup:YES];
}

#pragma mark - Touch events forwarded from map controller

- (void) checkMoveForTouch:(CGPoint)touchLocation isStillTracking:(BOOL)isStillTracking {
  if (CGPointEqualToPoint(_startTouchLocation, CGPointZero)) {
    // This touch just began
    _startTouchLocation = touchLocation;
  }
  
  CGPoint oldLoc = _currentBuildingTileCoordinate;
  CGPoint newLoc = [self locationAfterTouch:touchLocation];
  
  int diffX = newLoc.x - oldLoc.x;
  int diffY = newLoc.y - oldLoc.y;
  if (diffX != 0 || diffY != 0) {
    if (!_isMoving) {
      [_delegate moveBuildingControllerBeganMoving:self];
      _isMoving = YES;
    }
    
    _currentBuildingTileCoordinate = newLoc;
    _buildingController.buildingSprite.position = [_mapSource ccPointForTilePoint:newLoc];
    _startTouchLocation.x += _mapSource.tileSize.width * (diffX-diffY)/2,
    _startTouchLocation.y += _mapSource.tileSize.height * (diffX+diffY)/2;
    
    [self updateMeta];
  }
  
  if (!isStillTracking && _isMoving) {
    // Check if it can be placed down
    CGRect tileBlock;
    tileBlock.origin = _currentBuildingTileCoordinate;
    tileBlock.size = _buildingController.building.groundSize;
    if ([_mapSource tileBlockIsOpen:tileBlock]) {
      [_delegate moveBuildingController:self movedToLocation:newLoc];
      [self clearMeta];
    }
    
    _startTouchLocation = CGPointZero;
  }
}

- (CGPoint) locationAfterTouch:(CGPoint)touchLocation {
  // Subtract the touch location from the start location to find the distance moved
  CGPoint vector = ccpSub(touchLocation, _startTouchLocation);
  CGPoint mapVector = [_mapSource tilePointForCCPoint:ccpAdd(vector, [_mapSource ccPointForTilePoint:ccp(0,0)])];
  return ccpAdd(_currentBuildingTileCoordinate, ccp(floorf(mapVector.x+0.1f), floorf(mapVector.y+0.1f)));
}

@end
