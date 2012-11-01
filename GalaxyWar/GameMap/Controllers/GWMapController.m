//
//  GWMapController.m
//  GalaxyWar
//
//  Created by Ashwin Kamath on 10/30/12.
//  Copyright (c) 2012 Ashwin Kamath. All rights reserved.
//

#import "GWMapController.h"

#define MAX_ZOOM 1.8f
#define MIN_ZOOM 0.5f
#define DEFAULT_ZOOM 0.8f

#define REORDER_START_Z 150

@implementation GWMapController

@synthesize map = _map, mapLayer = _mapLayer;
@synthesize buildingControllers = _buildingControllers;
@synthesize selected = _selected;

#pragma mark - Initialization

- (id) init {
  if ((self = [super init])) {
    UIPanGestureRecognizer *uig = [[UIPanGestureRecognizer alloc] init];
    _dragRecognizer = [CCGestureRecognizer recognizerWithRecognizer:uig target:self action:@selector(drag:node:)];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] init];
    _pinchRecognizer = [CCGestureRecognizer recognizerWithRecognizer:pinch target:self action:@selector(scale:node:)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    _tapRecognizer = [CCGestureRecognizer recognizerWithRecognizer:tap target:self action:@selector(tap:node:)];
    
    _buildingControllers = [NSMutableArray array];
  }
  return self;
}

- (id) initWithMap:(GWMap *)map {
  if ((self = [self init])) {
    self.map = map;
  }
  return self;
}

- (void) loadMapLayerIfRequired {
  if (!self.mapLayer) {
    self.mapLayer = [GWMapLayer node];
    [self addChild:self.mapLayer];
    
    for (GWBuilding *building in [_map allBuildings]) {
      GWBuildingController *bc = [[GWBuildingController alloc] initWithBuilding:building];
      bc.mapSource = self;
      [self addBuildingController:bc];
    }
    
    [self reorderAllMapObjects];
  }
}

#pragma mark - Adding/removing child controllers

- (void) addBuildingController:(GWBuildingController *)bc {
  [_buildingControllers addObject:bc];
  [bc buildingWillAppear];
  [self.mapLayer addChild:bc.buildingSprite];
}

- (void) removeBuildingController:(GWBuildingController *)bc {
  [bc.buildingSprite removeFromParentAndCleanup:YES];
  [_buildingControllers removeObject:bc];
}

#pragma mark - Gesture Recognizer Actions

// pt has only been converted to GL, not to the node space
- (GWBuildingController *) buildingControllerForPoint:(CGPoint)pt {
  if ([_selected.buildingSprite isPointInArea:pt]) {
    return _selected;
  }
  
  GWBuildingController *toRet = nil;
  float distToCenter = 320.f; // Arbitrarily high number
  CGPoint mapPoint = [_mapLayer convertToNodeSpace:pt];
  CGPoint tilePoint = [self tilePointForCCPoint:mapPoint];
  for (GWBuildingController *bc in _buildingControllers) {
    GWBuildingSprite *child = bc.buildingSprite;
    // Two conditions: a) pt is in building's sprite area or b) tile for pt is in building's ground rect
    CGRect box = CGRectInset(child.boundingBox, -5.f, -5.f);
    if (CGRectContainsPoint(box, mapPoint) ||
        CGRectContainsPoint([bc.building groundRect], tilePoint)) {
      CGPoint center = ccp(child.contentSize.width/2, child.contentSize.height/2);
      float thisDistToCenter = ccpDistance(center, [child convertToNodeSpace:pt]);
      
      if (thisDistToCenter < distToCenter) {
        distToCenter = thisDistToCenter;
        toRet = bc;
      }
    }
  }
  return toRet;
}

- (void) selectBuildingController:(GWBuildingController *)bc {
  // Unselect currently selected controller
  if (bc != self.selected) {
    [self.selected buildingWasUnselected];
    self.selected = bc;
    [bc buildingWasSelected];
  }
}

- (void) tap:(UIGestureRecognizer *)recognizer node:(CCNode *)node {
  CGPoint pt = [recognizer locationInView:recognizer.view];
  pt = [[CCDirector sharedDirector] convertToGL:pt];
  
  GWBuildingController *bc = [self buildingControllerForPoint:pt];
  
  if (bc == self.selected) {
    [self selectBuildingController:nil];
  } else {
    [self selectBuildingController:bc];
  }
}

- (void) drag:(UIGestureRecognizer *)recognizer node:(CCNode *)node {
  UIPanGestureRecognizer* pan = (UIPanGestureRecognizer *)recognizer;
  
  if([recognizer state] == UIGestureRecognizerStateBegan ||
     [recognizer state] == UIGestureRecognizerStateChanged )
  {
    [node stopActionByTag:190];
    CGPoint translation = [pan translationInView:pan.view.superview];
    
    CGPoint delta = [self convertVectorToGL: translation];
    [node setPosition:ccpAdd(node.position, delta)];
    
    // Reset to 0 so we only worry about delta
    [pan setTranslation:CGPointZero inView:pan.view.superview];
  } else if ([recognizer state] == UIGestureRecognizerStateEnded) {
    CGPoint vel = [pan velocityInView:pan.view.superview];
    vel = [self convertVectorToGL: vel];
    
    float dist = ccpDistance(ccp(0,0), vel);
    if (dist < 500) {
      return;
    }
    
    vel.x /= 3;
    vel.y /= 3;
    id actionID = [CCMoveBy actionWithDuration:dist/1500 position:vel];
    CCEaseOut *action = [CCEaseSineOut actionWithAction:actionID];
    action.tag = 190;
    [node runAction:action];
  }
}

- (void) scale:(UIGestureRecognizer *)recognizer node:(CCNode *)node {
  UIPinchGestureRecognizer* pinch = (UIPinchGestureRecognizer *)recognizer;
  
  // See if zoom should even be allowed
  float newScale = node.scale * pinch.scale;
  pinch.scale = 1.0f; // we just reset the scaling so we only wory about the delta
  
  if (newScale > MAX_ZOOM || newScale < MIN_ZOOM) {
    return;
  }
  
  CCDirector* director = [CCDirector sharedDirector];
  CGPoint pt = [recognizer locationInView:recognizer.view.superview];
  pt = [director convertToGL:pt];
  CGPoint beforeScale = [node convertToNodeSpace:pt];
  
  node.scale = newScale;
  CGPoint afterScale = [node convertToNodeSpace:pt];
  CGPoint diff = ccpSub(afterScale, beforeScale);
  
  node.position = ccpAdd(node.position, ccpMult(diff, node.scale));
}

- (CGPoint) convertVectorToGL:(CGPoint)uiPoint
{
  float newY = -uiPoint.y;
  return ccp( uiPoint.x, newY );
}

#pragma mark - Building Ordering

- (BOOL) mapObject:(id<GWMapObject>)front isInFrontOfMapObject:(id<GWMapObject>)back {
  if (front == back) {
    return YES;
  }
  
  CGRect frontLoc = front.groundRect;
  CGRect backLoc = back.groundRect;
  
  // Determine if we want to look at x
  BOOL leftX = frontLoc.origin.x < backLoc.origin.x && frontLoc.origin.x+frontLoc.size.width <= backLoc.origin.x;
  BOOL rightX = frontLoc.origin.x >= backLoc.origin.x+backLoc.size.width && frontLoc.origin.x+frontLoc.size.width > backLoc.origin.x+backLoc.size.width;
  
  if (leftX || rightX) {
    return frontLoc.origin.x <= backLoc.origin.x;
  }
  
  BOOL leftY = frontLoc.origin.y < backLoc.origin.y && frontLoc.origin.y+frontLoc.size.height <= backLoc.origin.y;
  BOOL rightY = frontLoc.origin.y >= backLoc.origin.y+backLoc.size.height && frontLoc.origin.y+frontLoc.size.height > backLoc.origin.y+backLoc.size.height;
  
  if (leftY || rightY) {
    return frontLoc.origin.y <= backLoc.origin.y;
  }
  
  // This means the rects are overlapping:
  // Only solution is to find out who's actual y is lower.
  int frontY = [self ccPointForTilePoint:frontLoc.origin].y;
  int backY = [self ccPointForTilePoint:backLoc.origin].y;
  return frontY <= backY;
}

- (void) reorderAllMapObjects {
  NSMutableArray *mapObjectControllers = [self.buildingControllers mutableCopy];
  for (int i = 1; i < [mapObjectControllers count]; i++) {
    id<GWMapObjectController> toSort = [mapObjectControllers objectAtIndex:i];
    id<GWMapObjectController> sorted = [mapObjectControllers objectAtIndex:i-1];
    if (![self mapObject:[toSort mapObject] isInFrontOfMapObject:[sorted mapObject]]) {
      int j;
      for (j = i-2; j >= 0; j--) {
        sorted = [mapObjectControllers objectAtIndex:j];
        if ([self mapObject:[toSort mapObject] isInFrontOfMapObject:[sorted mapObject]]) {
          break;
        }
      }
      
      [mapObjectControllers removeObjectAtIndex:i];
      [mapObjectControllers insertObject:toSort atIndex:j+1];
    }
  }
  
  for (int i = 0; i < [mapObjectControllers count]; i++) {
    CCNode *child = [[mapObjectControllers objectAtIndex:i] mapSprite];
    [self reorderChild:child z:i+REORDER_START_Z];
  }
}

#pragma mark - GWMapSource protocol methods

- (CGPoint) tilePointForCCPoint:(CGPoint)pt {
  CGSize ts = self.tileSize;
  
  // Remove base offset first
  pt = ccpSub(pt, _mapLayer.baseOffset);
  
  float a = (pt.x)/ts.width;
  float b = pt.y/ts.height;
  float x = a+b;
  float y = b-a;
  return ccp(x,y);
}

- (CGPoint) ccPointForTilePoint:(CGPoint)pt {
  CGSize ts = self.tileSize;
  CGPoint tp = ccp(ts.width * (pt.x-pt.y)/2.f, ts.height * (pt.y+pt.x)/2.f);
  
  // Add on base offset
  tp = ccpAdd(tp , _mapLayer.baseOffset);
  return tp;
}

- (CGPoint) ccPointForGWPoint3D:(GWPoint3D)pt {
  CGPoint tilePoint = ccp(pt.x+pt.z, pt.y+pt.z);
  return [self ccPointForTilePoint:tilePoint];
}

- (BOOL) tileCoordIsOpen:(CGPoint)tileCoord {
  CGSize mapSize = [self mapSize];
  if (!CGRectContainsPoint(CGRectMake(0, 0, mapSize.width, mapSize.height), tileCoord)) {
    return NO;
  }
  
  for (GWBuildingController *bc in _buildingControllers) {
    if (CGRectContainsPoint([bc.building groundRect], tileCoord)) {
      return NO;
    }
  }
  return YES;
}

- (BOOL) tileBlockIsOpen:(CGRect)tileBlock {
  for (int i = 0; i < tileBlock.size.width; i++) {
    for (int j = 0; j < tileBlock.size.height; j++) {
      CGPoint pt = ccpAdd(tileBlock.origin, ccp(i,j));
      if (![self tileCoordIsOpen:pt]) {
        return NO;
      }
    }
  }
  return YES;
}

- (CGSize) tileSize {
  return _map.tileSize;
}

- (CGSize) mapSize {
  return _map.mapSize;
}

#pragma mark -

- (void) onEnter {
  NSAssert(_map != nil, @"GWMapController expects a map upon being presented.");
  
  [super onEnter];
  
  [self loadMapLayerIfRequired];
  
  [self.mapLayer addGestureRecognizer:_dragRecognizer];
  [self.mapLayer addGestureRecognizer:_pinchRecognizer];
  [self.mapLayer addGestureRecognizer:_tapRecognizer];
  
  self.mapLayer.scale = DEFAULT_ZOOM;
  [self.mapLayer moveToCenter];
}

- (void) onExit {
  [self selectBuildingController:nil];
  
  [self.mapLayer removeGestureRecognizer:_dragRecognizer];
  [self.mapLayer removeGestureRecognizer:_pinchRecognizer];
  [self.mapLayer removeGestureRecognizer:_tapRecognizer];
  
  [super onExit];
}

@end
