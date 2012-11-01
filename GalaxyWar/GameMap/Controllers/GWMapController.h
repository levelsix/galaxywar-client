//
//  GWMapController.h
//  GalaxyWar
//
//  Created by Ashwin Kamath on 10/30/12.
//  Copyright (c) 2012 Ashwin Kamath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GWMapLayer.h"
#import "GWMap.h"
#import "CCGestureRecognizer.h"
#import "GWBuildingController.h"
#import "GWMapSource.h"

@interface GWMapController : CCScene <GWMapSource> {
  CCGestureRecognizer *_pinchRecognizer;
  CCGestureRecognizer *_tapRecognizer;
  CCGestureRecognizer *_dragRecognizer;
  
  NSMutableArray *_buildingControllers;
}

@property (nonatomic, strong) GWMapLayer *mapLayer;
@property (nonatomic, strong) GWMap *map;

@property (nonatomic, strong) NSArray *buildingControllers;

// Keep a weak ref of the selected building
@property (nonatomic, weak) GWBuildingController *selected;

- (id) initWithMap:(GWMap *)map;
- (void) loadMapLayerIfRequired;

- (void) reorderAllMapObjects;

- (void) tap:(UIGestureRecognizer *)recognizer node:(CCNode *)node;
- (void) drag:(UIGestureRecognizer *)recognizer node:(CCNode *)node;
- (void) scale:(UIGestureRecognizer *)recognizer node:(CCNode *)node;

- (GWBuildingController *) buildingControllerForPoint:(CGPoint)pt;
- (void) selectBuildingController:(GWBuildingController *)bc;

@end
