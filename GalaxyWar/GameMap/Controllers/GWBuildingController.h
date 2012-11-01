//
//  GWBuildingController.h
//  GalaxyWar
//
//  Created by Ashwin Kamath on 10/30/12.
//  Copyright (c) 2012 Ashwin Kamath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GWBuilding.h"
#import "GWBuildingSprite.h"
#import "GWMapSource.h"
#import "GWMapObjectController.h"

@interface GWBuildingController : NSObject <GWMapObjectController>

@property (nonatomic, strong) GWBuilding *building;
@property (nonatomic, strong) GWBuildingSprite *buildingSprite;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, weak) id<GWMapSource> mapSource;

- (id) initWithBuilding:(GWBuilding *)building;

- (void) buildingWillAppear;
- (void) synchronizePosition;

- (void) buildingWasSelected;
- (void) buildingWasUnselected;

- (void) displayMoveArrows;
- (void) removeMoveArrows;

@end
