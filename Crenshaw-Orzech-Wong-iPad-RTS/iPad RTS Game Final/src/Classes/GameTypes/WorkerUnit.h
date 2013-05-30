//
//  WorkerUnit.h
//  AppScaffold
//
//  Created by Scott Orzech on 2/15/11.
//  Copyright 2011 University of California, Santa Cruz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sparrow.h"

@interface WorkerUnit : SPSprite {
@public
	bool justSelected;
@private	
	SPImage *mImage;
	SPTextField *selectionHalo;
	int health;	
	int destX, destY;
	int moveX, moveY;
	bool selected;
	bool justSet;
	SPDisplayObject *myBuilding;
	SPDisplayObject *myMineral;
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
- (void)setBuilding:(SPDisplayObject*)building;
- (void)setMineral:(SPDisplayObject*)mineral;

@end
