//
//  GWBuilding.m
//  GalaxyWar
//
//  Created by Ashwin Kamath on 10/30/12.
//  Copyright (c) 2012 Ashwin Kamath. All rights reserved.
//

#import "GWBuilding.h"
#import "CGPointExtension.h"

@implementation GWBuilding

- (CGRect) groundRect {
  CGRect rect;
  rect.origin = self.groundOffset;
  rect.size = self.groundSize;
  return rect;
}

- (CGRect) relativeBaseRect {
  CGRect rect;
  rect.origin = self.baseOffset;
  rect.size = self.baseSize;
  return rect;
}

- (CGRect) absoluteBaseRect {
  CGRect rect;
  rect.origin = ccpAdd(self.groundOffset, self.baseOffset);
  rect.size = self.baseSize;
  return rect;
}

- (GWPoint3D) location3D {
  GWPoint3D pt;
  pt.x = [self absoluteBaseRect].origin.x;
  pt.y = [self absoluteBaseRect].origin.y;
  pt.z = 0;
  return pt;
}

- (GWSize3D) size3D {
  GWSize3D s;
  s.width = [self absoluteBaseRect].size.width;
  s.length = [self absoluteBaseRect].size.height;
  s.height = 2;
  return s;
}

- (BOOL) isAirObject {
  return NO;
}

- (void) homeUpdate:(ccTime)dt {
  if (_secondsTillUpdateComplete > 0) {
    _secondsTillUpdateComplete -= dt;
    if (_secondsTillUpdateComplete > 0) {
      _isUpdating = YES;
    } else {
      _isUpdating = NO;
    }
  }
}

@end
