//
//  GWHomeMapController.h
//  GalaxyWar
//
//  Created by Ashwin Kamath on 10/31/12.
//  Copyright (c) 2012 Ashwin Kamath. All rights reserved.
//

#import "GWMapController.h"
#import "GWMoveBuildingController.h"

@interface GWHomeMapController : GWMapController <GWMoveBuildingDelegate> {
  BOOL _isMovingBuilding;
}

@property (nonatomic, strong) GWMoveBuildingController *moveBuildingController;

@end
