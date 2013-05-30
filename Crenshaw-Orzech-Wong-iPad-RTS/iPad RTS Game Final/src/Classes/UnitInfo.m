//
//  OffensiveUnit.m
//  AppScaffold
//
//  Created by Scott Orzech on 2/15/11.
//  Copyright 2011 University of California, Santa Cruz. All rights reserved.
//

#import "UnitInfo.h"


// --- class implementation ------------------------------------------------------------------------

@implementation UnitInfo
- (id)initWithSPImage
{
	if (self = [super init])
    {
		self.x = 213;
		self.y = 808;
		
		SPTexture *texture = [SPTexture textureWithContentsOfFile:@"unitInfo.png"]; //465 by 42
		SPImage *oImage = [SPImage imageWithTexture:texture];
		mImage = oImage;
		
		[self addChild:mImage];
		
        //[self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
		
		textField = [SPTextField textFieldWithWidth:200
								 height:80 text:@"Please Select A Unit!" fontName:@"Helvetica" fontSize:16.0f color:0x000000];
		textField.hAlign = SPHAlignCenter; // horizontal alignment
		textField.vAlign = SPVAlignCenter; // vertical alignment
		textField.x = 140;
		textField.y = 40;
		textField.border = NO;
		
		[self addChild:textField];
		
		texture = [SPTexture textureWithContentsOfFile:@"red_dot.png"];
		oImage = [SPImage imageWithTexture:texture];
		mUnitImage = oImage;
		mUnitImage.x = 20;
		mUnitImage.y = 20;
		mUnitImage.visible = NO;
		
		[self addChild:mUnitImage];
		
		mTextures = [NSMutableArray arrayWithObjects:[SPTexture textureWithContentsOfFile:@"unit2_offensive.png"], 
					 [SPTexture textureWithContentsOfFile:@"unit2_worker.png"],
					 [SPTexture textureWithContentsOfFile:@"unit2_barrack.png"], 
					 [SPTexture textureWithContentsOfFile:@"unit2_supply.png"], 
					 [SPTexture textureWithContentsOfFile:@"mineral.png"], nil];
		
		offensiveTexture = [SPTexture textureWithContentsOfFile:@"unit2_offensive.png"];
		workerTexture = [SPTexture textureWithContentsOfFile:@"unit2_worker.png"];
		commandTexture = [SPTexture textureWithContentsOfFile:@"unit2_barrack.png"]; 
		supplyTexture = [SPTexture textureWithContentsOfFile:@"unit2_supply.png"];
		mineralTexture = [SPTexture textureWithContentsOfFile:@"mineral.png"];
		
		offensiveImage = [SPImage imageWithTexture:offensiveTexture];
		workerImage = [SPImage imageWithTexture:workerTexture];
		commandImage = [SPImage imageWithTexture:commandTexture]; 
		supplyImage = [SPImage imageWithTexture:supplyTexture];
		mineralImage = [SPImage imageWithTexture:mineralTexture];
	}
	return self;
}

- (id)init
{
    // the designated initializer of the base class should always be overridden -- we do that here.
    return [self initWithSPImage];
}

- (void)setText:(NSMutableString *)string imgIndex:(int)index
{
	textField.text = string;
	//mUnitImage.visible = YES;
	//NSLog(@"index %d", index);
	//SPTexture *texture = [mTextures objectAtIndex:index];
	//mUnitImage = [SPImage imageWithTexture:[mTextures objectAtIndex:index]];
//	SPImage *oImage;
//	if (index == 0) {
//		oImage = offensiveImage;
//	}
//	else if (index == 1) {
//		oImage = workerImage;
//	}
//	else if (index == 2) {
//		oImage = commandImage;
//	}
//	else if (index == 3) {
//		oImage = supplyImage;
//	}
//	else if (index == 4) {
//		oImage = mineralImage;
//	}
//	NSLog(@"%@", NSStringFromClass([[self childAtIndex:2] class]));
	//[self removeChildAtIndex:2];
	//mUnitImage = oImage;
	//mUnitImage.x = 20;
	//mUnitImage.y = 20;
	//[self addChild:mUnitImage];
}

//- (void)updateUnit:(SPSprite *)newUnit
//{
//	unitSelected = newUnit;
//}
//
//- (void)onEnterFrame:(SPEnterFrameEvent *)event
//{
//	//update info
//	if (unitSelected != NULL) {
//		//add textfield of health
//		//(OffensiveUnit)unitSelected;
//		textField.text = @"You've Selected a unit!";
//	}
//}


- (void)dealloc
{
    // event listeners should always be removed to avoid memory leaks!
	[mImage release];
    [super dealloc];
}

@end
