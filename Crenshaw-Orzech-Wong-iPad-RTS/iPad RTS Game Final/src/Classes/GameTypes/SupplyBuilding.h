//
//  SupplyBuilding.h
//  AppScaffold
//
//  Created by Scott Orzech on 2/15/11.
//  Copyright 2011 University of California, Santa Cruz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sparrow.h"

@interface SupplyBuilding : SPSprite {
@public
	bool justSelected;
@private	
	SPTexture *builtTexture;
	SPImage *mImage;
	SPTextField *selectionHalo;
	int health;	
	bool selected;
	bool completed; //blueprint complete?
	bool isLocked;
	int buildTimeRemaining; //how long a worker has to work on the building to complete it
	int buildTime;
}

- (id)initBlueprintBuilding;
- (id)initCompleteBuilding;
- (void)advanceBuild; //decrements buildTimeRemaining
- (int)getHealth;
- (void)setHealth:(int) newHealth;
- (void)lock;
- (void)unlock;
- (void)select;
- (void)deselect;
- (void)deJustSelected;
- (bool)isSelected;
- (bool)justSelected;
- (bool)isBlueprint;

@end
