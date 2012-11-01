//
//  GWStructs3D.h
//  GalaxyWar
//
//  Created by Ashwin Kamath on 10/31/12.
//  Copyright (c) 2012 Ashwin Kamath. All rights reserved.
//

typedef struct {CGFloat x, y, z;} GWPoint3D;
typedef struct {CGFloat width, length, height;} GWSize3D;

static inline GWPoint3D
gwp3(CGFloat x, CGFloat y, CGFloat z) {
  GWPoint3D pt;
  pt.x = x;
  pt.y = y;
  pt.z = z;
  return pt;
}

static inline GWSize3D
gws3(CGFloat w, CGFloat l, CGFloat h) {
  GWSize3D s;
  s.width = w;
  s.length = l;
  s.height = h;
  return s;
}