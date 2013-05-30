//
//  BuildMenu.h
//  iRTS
//
//  Created by Scott Orzech on 2/27/11.
//  Copyright 2011 University of California, Santa Cruz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sparrow.h"
#import "SupplyBuilding.h"
#import "CommandBuilding.h"
#import "OffensiveUnit.h"
#import "WorkerUnit.h"


@interface BubbleBuildMenu : SPSprite{
@private
	SPDisplayObject *buildThis;
	SPImage *buildCommand;
	SPImage *buildSupply;
	SPImage *buildWorker;
	SPImage *buildOffensive;
	SPImage *closeMenu;
	SPTextField *textField1;
	SPTextField *textField2;
	SPTextField *textField3;
	SPTextField *textField4;
	bool isVisible;
	bool newObject;
}
- (id)initWithSPImages;
- (bool)isVisible;
- (void)setVisible:(BOOL)vis;
- (void)displayAt:(SPPoint *)center;
- (void)displayAtX:(int)centerX Y:(int)centerY;

@end
