//
//  GWMap.h
//  GalaxyWar
//
//  Created by Ashwin Kamath on 10/29/12.
//  Copyright (c) 2012 Ashwin Kamath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GWBuilding.h"
#import "GWResourceGatherer.h"

@interface GWMap : NSObject

@property (nonatomic, assign) CGSize mapSize;
@property (nonatomic, assign) CGSize tileSize;

@property (nonatomic, strong) NSArray *oreRefineries;
@property (nonatomic, strong) NSArray *etherGatherers;

- (NSArray *) allBuildings;
- (NSArray *) allMapObjects;

- (void) homeUpdate:(ccTime)dt;
- (void) visitUpdate:(ccTime)dt;
- (void) battleUpdate:(ccTime)dt;

@end
