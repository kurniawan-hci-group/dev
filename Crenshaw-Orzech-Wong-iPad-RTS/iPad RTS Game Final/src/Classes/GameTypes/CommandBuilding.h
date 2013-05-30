//
//  CommandBuilding.h
//  AppScaffold
//
//  Created by Scott Orzech on 2/15/11.
//  Copyright 2011 University of California, Santa Cruz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sparrow.h"

@interface CommandBuilding : SPSprite {
@public
	bool justSelected;
@private	
	SPTexture *builtTexture;
	SPImage *mImage;
	SPPoint *rallyPoint;
	SPDisplayObject *currentUnit;
	SPTextField *selectionHalo;
	int health;
	bool selected;
	bool completed; //blueprint complete?
	bool isLocked;
	bool producingUnit;
	int buildTimeRemaining; //how long a worker has to work on the building to complete it
	int unitProductionTime;
	int buildTime;
}

- (id)initBlueprintBuilding;
- (id)initCompleteBuilding;
- (void)advanceBuild; //decrements buildTimeRemaining
- (void)setRally:(SPPoint*)dest;
- (int)getHealth;
- (void)buildUnit:(SPDisplayObject*)unit;
- (void)lock;
- (void)unlock;
- (void)setHealth:(int) newHealth;
- (void)select;
- (void)deselect;
- (void)deJustSelected;
- (bool)isSelected;
- (bool)justSelected;
- (bool)isBlueprint;
- (bool)isMakingUnit;
- (float)getX;
- (float)getY;

@end
