//
//  GWHomeMapController.m
//  GalaxyWar
//
//  Created by Ashwin Kamath on 10/31/12.
//  Copyright (c) 2012 Ashwin Kamath. All rights reserved.
//

#import "GWHomeMapController.h"

#define MOVE_BUILDING_LAYER_Z 1000

@implementation GWHomeMapController

- (id) init {
  if ((self = [super init])) {
    _moveBuildingController = [[GWMoveBuildingController alloc] init];
    _moveBuildingController.mapSource = self;
    _moveBuildingController.delegate = self;
  }
  return self;
}

- (void) loadMapLayerIfRequired {
  [super loadMapLayerIfRequired];
  [self.mapLayer addChild:_moveBuildingController.layer z:MOVE_BUILDING_LAYER_Z];
}

#pragma mark - Gesture recognizer methods

- (void) drag:(UIGestureRecognizer *)recognizer node:(CCNode *)node {
  CGPoint pt = [recognizer locationInView:recognizer.view];
  pt = [[CCDirector sharedDirector] convertToGL:pt];
  CGPoint mapPoint = [self.mapLayer convertToNodeSpace:pt];
  
  BOOL shouldPan = YES;
  if (self.selected) {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
      if ([self buildingControllerForPoint:pt] == self.selected) {
        if (!_isMovingBuilding) {
          [_moveBuildingController beginTrackingForBuildingController:self.selected];
          _isMovingBuilding = YES;
        }
        [_moveBuildingController checkMoveForTouch:mapPoint isStillTracking:YES];
        shouldPan = NO;
      }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
      if (_isMovingBuilding) {
        [_moveBuildingController checkMoveForTouch:mapPoint isStillTracking:YES];
        shouldPan = NO;
      }
    } else {
      if (_isMovingBuilding) {
        [_moveBuildingController checkMoveForTouch:mapPoint isStillTracking:NO];
        shouldPan = NO;
      }
    }
  }
  
  if (shouldPan) {
    [super drag:recognizer node:node];
  }
}

#pragma mark - GWMapSource methods (Overwritten)

- (BOOL) tileCoordIsOpen:(CGPoint)tileCoord {
  CGSize mapSize = [self mapSize];
  if (!CGRectContainsPoint(CGRectMake(0, 0, mapSize.width, mapSize.height), tileCoord)) {
    return NO;
  }
  
  for (GWBuildingController *bc in _buildingControllers) {
    if (!_isMovingBuilding || bc != self.selected) {
      if (CGRectContainsPoint([bc.building groundRect], tileCoord)) {
        return NO;
      }
    }
  }
  return YES;
}

#pragma mark - GWMoveBuildingDelegate methods

- (void) selectBuildingController:(GWBuildingController *)bc {
  if (self.selected) {
    [self stopMovingBuilding];
    [_moveBuildingController endTracking];
    [self.selected removeMoveArrows];
  }
  
  [super selectBuildingController:bc];
  
  if (bc) {
    [_moveBuildingController beginTrackingForBuildingController:bc];
    [bc displayMoveArrows];
  }
}

- (void) moveBuildingControllerBeganMoving:(GWMoveBuildingController *)mbc {
  // mbc uses same coordinate system so no need to reposition
  GWBuildingController *bc = mbc.buildingController;
  [bc.buildingSprite removeFromParentAndCleanup:NO];
  [mbc.layer addChild:bc.buildingSprite];
  bc.buildingSprite.opacity = 100;
}

- (void) moveBuildingController:(GWMoveBuildingController *)mbc movedToLocation:(CGPoint)newCoordinate {
  GWBuildingController *bc = mbc.buildingController;
  bc.building.groundOffset = newCoordinate;
  [self stopMovingBuilding];
}

- (void) stopMovingBuilding {
  GWBuildingController *bc = _moveBuildingController.buildingController;
  [bc.buildingSprite removeFromParentAndCleanup:NO];
  [self.mapLayer addChild:bc.buildingSprite];
  
  [bc synchronizePosition];
  bc.buildingSprite.opacity = 255;
  
  [self reorderAllMapObjects];
  
  _isMovingBuilding = NO;
}

@end
