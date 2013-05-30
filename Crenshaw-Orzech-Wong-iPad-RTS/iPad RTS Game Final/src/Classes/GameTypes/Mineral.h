//
//  Mineral.h
//  iRTS
//
//  Created by Scott Orzech on 2/28/11.
//  Copyright 2011 University of California, Santa Cruz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sparrow.h"

@interface Mineral : SPSprite {
@private
	SPImage *mImage;
	SPTextField *selectionHalo;
	int mineralsLeft;
	bool selected;
	bool justSelected;
	int timeLeftUntilNextMine;
}

- (id) initWithMinerals;
- (id) initWithMinerals:(int)numMinerals;
- (int) mineralsLeft;
- (void)mineMinerals;
- (void)select;
- (void)deselect;
- (bool)isSelected;
- (bool)justSelected;
- (void)deJustSelected;

@end
