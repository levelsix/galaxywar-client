//
//  GWMap.m
//  GalaxyWar
//
//  Created by Ashwin Kamath on 10/29/12.
//  Copyright (c) 2012 Ashwin Kamath. All rights reserved.
//

#import "GWMap.h"

@implementation GWMap

- (id) init {
  if ((self = [super init])) {
    self.tileSize = CGSizeMake(64, 32);
  }
  return self;
}

- (NSArray *) allBuildings {
  return [_oreRefineries arrayByAddingObjectsFromArray:_etherGatherers];
}

- (NSArray *) allMapObjects {
  return [self allBuildings];
}

#pragma mark - Update methods for different states of a map

- (void) homeUpdate:(ccTime)dt {
  NSArray *mapObjects = [self allMapObjects];
  for (id<GWMapObject> obj in mapObjects) {
    if ([obj respondsToSelector:@selector(homeUpdate:)]) {
      [obj performSelector:@selector(homeUpdate:)];
    }
  }
}

- (void) visitUpdate:(ccTime)dt {
  NSArray *mapObjects = [self allMapObjects];
  for (id<GWMapObject> obj in mapObjects) {
    if ([obj respondsToSelector:@selector(visitUpdate:)]) {
      [obj performSelector:@selector(visitUpdate:)];
    }
  }
}

- (void) battleUpdate:(ccTime)dt {
  NSArray *mapObjects = [self allMapObjects];
  for (id<GWMapObject> obj in mapObjects) {
    if ([obj respondsToSelector:@selector(battleUpdate:)]) {
      [obj performSelector:@selector(battleUpdate:)];
    }
  }
}

@end
