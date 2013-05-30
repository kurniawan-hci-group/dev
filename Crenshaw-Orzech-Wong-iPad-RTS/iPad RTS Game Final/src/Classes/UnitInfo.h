//
//  OffensiveUnit.h
//  AppScaffold
//
//  Created by Scott Orzech on 2/15/11.
//  Copyright 2011 University of California, Santa Cruz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sparrow.h"
#import "OffensiveUnit.h"

@interface UnitInfo : SPSprite{
@private
	SPImage *mImage;
	SPSprite *unitSelected;
	SPTextField *textField;
	NSMutableArray *mTextures;
	SPImage *mUnitImage;
	SPTexture *offensiveTexture;
	SPTexture *workerTexture;
	SPTexture *commandTexture;
	SPTexture *supplyTexture;
	SPTexture *mineralTexture;
	SPImage *offensiveImage;
	SPImage *workerImage;
	SPImage *commandImage; 
	SPImage *supplyImage;
	SPImage *mineralImage;
}

- (void) setTextAndImage: (NSMutableString *)string imgIndex:(int)index;
//- (id)initWithSPImage;
//- (void)updateUnit:(SPSprite *)newUnit;

@end
