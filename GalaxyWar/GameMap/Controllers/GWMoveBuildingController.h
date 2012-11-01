//
//  GWMoveBuildingController.h
//  GalaxyWar
//
//  Created by Ashwin Kamath on 10/30/12.
//  Copyright (c) 2012 Ashwin Kamath. All rights reserved.
//

#import "CCLayer.h"
#import "GWMapSource.h"
#import "GWBuildingController.h"

@class GWMoveBuildingController;

@protocol GWMoveBuildingDelegate <NSObject>

- (void) moveBuildingControllerBeganMoving:(GWMoveBuildingController *)mbc;
- (void) moveBuildingController:(GWMoveBuildingController *)mbc movedToLocation:(CGPoint)newCoordinate;

@end

@interface GWMoveBuildingController : NSObject {
  CGPoint _startTouchLocation;
  CGPoint _currentBuildingTileCoordinate;
  
  BOOL _isMoving;
}

@property (nonatomic, weak) id<GWMoveBuildingDelegate> delegate;
@property (nonatomic, weak) id<GWMapSource> mapSource;

@property (nonatomic, strong) CCLayer *layer;
@property (nonatomic, strong) CCLayer *metaLayer;

@property (nonatomic, strong) GWBuildingController *buildingController;

- (void) beginTrackingForBuildingController:(GWBuildingController *)bc;
- (void) endTracking;

// This will check whether the touch should move the building
- (void) checkMoveForTouch:(CGPoint)touchLocation isStillTracking:(BOOL)isStillTracking;

@end
