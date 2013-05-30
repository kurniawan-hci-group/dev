//
//  GameScene.h
//  AppScaffold
//
//  Created by Scott Orzech on 2/13/11.
//  Copyright 2011 University of California, Santa Cruz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchSheet.h"
#import "TouchSheetSprite.h"
#import "CSpriteGrid.h"
#import "OffensiveUnit.h"
#import "WorkerUnit.h"
#import "CommandBuilding.h"
#import "SupplyBuilding.h"
#import "UnitInfo.h"
#import "ResourceInfo.h"
#import "BubbleBuildMenu.h"
#import "Mineral.h"
#import	"Minimap.h"
#import "ControlGroup.h"
#define EVENT_TYPE_UNIT_TRIGGERED @"UnitTriggered"


@interface GameScene : SPStage {
@public
	
@private	
    SPJuggler *m_Juggler;
	int holdLocX, holdLocY;
    int mFrameCount;
    double mElapsed; 
    BOOL mStarted;
    int mWaitFrames;
	int resources;
	int offensiveCost;
	int workerCost;
	int commandCost;
	int supplyCost;
}

- (void)trashCanVisible:(bool)vis;
- (int)getResources;
- (void)increaseResources:(int)numResources;
- (void)spendResources:(int)numResources;
- (void)addSupply;
- (void)subSupply;
- (bool)isSupplyCapped;
- (void)raiseSupplyCap:(int)numSupply;
- (void)lowerSupplyCap:(int)numSupply;
- (int) offensiveCost;
- (int) workerCost;
- (int) commandCost;
- (int) supplyCost;
- (NSArray*) getSelected;
- (void) setSelected:(NSMutableArray*)newSelected;
- (int) insidePolygon:(NSMutableArray*) polygon withPoint:(SPPoint*) p;
- (double) angle2D:(double)x1 :(double)y1 :(double)x2 :(double)y2;

@end
