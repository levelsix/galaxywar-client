//
//  GWBuildingController.m
//  GalaxyWar
//
//  Created by Ashwin Kamath on 10/30/12.
//  Copyright (c) 2012 Ashwin Kamath. All rights reserved.
//

#import "GWBuildingController.h"
#import "cocos2d.h"

#define ARROW_LAYER_TAG 821
#define ARROW_FADE_DURATION 0.2f

@implementation CCNode (OpacityAddition)

- (void) setOpacity:(GLubyte)opacity {
  for(CCNode *node in [self children]) {
    if([node conformsToProtocol:@protocol(CCRGBAProtocol)]) {
      [(id<CCRGBAProtocol>) node setOpacity: opacity];
    }
  }
}

@end

@implementation GWBuildingController

#pragma mark - Initialization and Setup

- (id) initWithBuilding:(GWBuilding *)building {
  if ((self = [self init])) {
    self.building = building;
  }
  return self;
}

- (void) loadBuildingSpriteIfRequired {
  NSAssert(self.building != nil, @"GWBuildingController expects building on load.");
  
  if (!_buildingSprite) {
    _buildingSprite = [GWBuildingSprite spriteWithFile:@"Slaughterhouse.png"];
    
    [self synchronizePosition];
  }
}

- (void) buildingWillAppear {
  [self loadBuildingSpriteIfRequired];
}

- (void) synchronizePosition {
  CGPoint tilePoint = [_building absoluteBaseRect].origin;
  CGPoint ccPoint = [self.mapSource ccPointForTilePoint:tilePoint];
  self.buildingSprite.position = ccPoint;
}

#pragma mark - Selection of building

- (void) buildingWasSelected {
  if (!_isSelected) {
    [self.buildingSprite displaySelected];
    self.isSelected = YES;
  }
}

- (void) buildingWasUnselected {
  if (_isSelected) {
    self.isSelected = NO;
    [self.buildingSprite displayUnselected];
  }
}

- (void) displayMoveArrows {
  [self removeMoveArrows];
  
  CCNode *node = [CCNode node];
  
  CCSprite *nr = [CCSprite spriteWithFile:@"expanddownarrow.png"];
  CCSprite *nl = [CCSprite spriteWithFile:@"expanddownarrow.png"];
  CCSprite *fr = [CCSprite spriteWithFile:@"expanduparrow.png"];
  CCSprite *fl = [CCSprite spriteWithFile:@"expanduparrow.png"];
  nl.flipX = YES;
  fl.flipX = YES;
  
  // Set anchor points so adjusting to tiles will be easy
  nr.anchorPoint = ccp(0,1);
  nl.anchorPoint = ccp(1,1);
  fr.anchorPoint = ccp(0,0);
  fl.anchorPoint = ccp(1,0);
  
  CGRect r = [_building groundRect];
  CGPoint relativeTo = [_mapSource ccPointForTilePoint:r.origin];
  nr.position = ccpSub([_mapSource ccPointForTilePoint:ccp(CGRectGetMidX(r), CGRectGetMinY(r))], relativeTo);
  nl.position = ccpSub([_mapSource ccPointForTilePoint:ccp(CGRectGetMinX(r), CGRectGetMidY(r))], relativeTo);
  fr.position = ccpSub([_mapSource ccPointForTilePoint:ccp(CGRectGetMaxX(r), CGRectGetMidY(r))], relativeTo);
  fl.position = ccpSub([_mapSource ccPointForTilePoint:ccp(CGRectGetMidX(r), CGRectGetMaxY(r))], relativeTo);
  
  [node addChild:nr];
  [node addChild:nl];
  [node addChild:fr];
  [node addChild:fl];
  node.position = ccp(_buildingSprite.contentSize.width/2, 0);
  
  [node runAction:[CCFadeIn actionWithDuration:ARROW_FADE_DURATION]];
  
  [self.buildingSprite addChild:node z:-1 tag:ARROW_LAYER_TAG];
}

- (void) removeMoveArrows {
  CCNode *node = [self.buildingSprite getChildByTag:ARROW_LAYER_TAG];
  [node stopAllActions];
  [node runAction:[CCSequence actions:[CCFadeOut actionWithDuration:ARROW_FADE_DURATION],
                   [CCCallBlock actionWithBlock:^{[node removeFromParentAndCleanup:YES];}], nil]];
}

#pragma mark - GWMapObjectController methods

- (id<GWMapObject>) mapObject {
  return self.building;
}

- (CCNode *) mapSprite {
  return self.buildingSprite;
}

@end
