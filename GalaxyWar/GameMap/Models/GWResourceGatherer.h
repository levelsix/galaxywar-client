//
//  GWResourceGatherer.h
//  GalaxyWar
//
//  Created by Ashwin Kamath on 10/31/12.
//  Copyright (c) 2012 Ashwin Kamath. All rights reserved.
//

#import "GWBuilding.h"

@interface GWResourceGatherer : GWBuilding

@property (nonatomic, assign) CGFloat accumulatedTime;
@property (nonatomic, assign) CGFloat productionRate; // in units per hr
@property (nonatomic, assign) int capacity;
@property (nonatomic, assign) int currentStock;

@end
