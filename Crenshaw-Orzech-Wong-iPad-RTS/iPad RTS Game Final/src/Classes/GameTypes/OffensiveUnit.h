//
//  OffensiveUnit.h
//  AppScaffold
//
//  Created by Scott Orzech on 2/15/11.
//  Copyright 2011 University of California, Santa Cruz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sparrow.h"
#define EVENT_TYPE_UNIT_TRIGGERED @"UnitTriggered"

@interface OffensiveUnit : SPSprite{
@public
	bool justSelected;
	int health;
@private	
	SPImage *mImage;
	SPTextField *selectionHalo;
	int attackPower;
	int destX, destY;
	int moveX, moveY;
	bool selected;
}

- (id)initWithSPImage;
- (void)moveTo:(SPPoint*)dest;
- (int)getHealth;
- (void)setHealth:(int) newHealth;
- (void)select;
- (void)deselect;
- (bool)isSelected;
- (bool)justSelected;
- (void)deJustSelected;

@end
