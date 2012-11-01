//
//  GWResourceGatherer.m
//  GalaxyWar
//
//  Created by Ashwin Kamath on 10/31/12.
//  Copyright (c) 2012 Ashwin Kamath. All rights reserved.
//

#import "GWResourceGatherer.h"

@implementation GWResourceGatherer

- (void) homeUpdate:(ccTime)dt {
  _accumulatedTime += dt;
  
  CGFloat rateInSecs = _productionRate/3600;
  int amtResGained = (int)(rateInSecs*_accumulatedTime);
  _accumulatedTime -= amtResGained/rateInSecs;
  _currentStock = MIN(_capacity, _currentStock+amtResGained);
}

@end
