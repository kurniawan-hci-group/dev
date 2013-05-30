//
//  ResourceInfo.m
//  iRTS
//
//  Created by Scott Orzech on 2/15/11.
//  Copyright 2011 University of California, Santa Cruz. All rights reserved.
//

#import "ResourceInfo.h"


// --- class implementation ------------------------------------------------------------------------

@implementation ResourceInfo
- (id)initWithSPImage
{
	if (self = [super init])
    {
		self.x = 681;
		self.y = 808;
		
		SPTexture *texture = [SPTexture textureWithContentsOfFile:@"resources.png"]; //465 by 42
		SPImage *oImage = [SPImage imageWithTexture:texture];
		mImage = oImage;
		
		[self addChild:mImage];
		
        //[self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
		
		textField = [SPTextField textFieldWithWidth:85 height:215 
											   text:@"Minerals: 0\nSupply: 0/0" 
										   fontName:@"Helvetica" fontSize:16.0f color:0x000000];
		textField.hAlign = SPHAlignCenter; // horizontal alignment
		textField.vAlign = SPVAlignCenter; // vertical alignment
		textField.border = NO;
		
		[self addChild:textField];
		
	}
	return self;
}

- (id)init
{
    // the designated initializer of the base class should always be overridden -- we do that here.
    return [self initWithSPImage];
}

- (void)setText:(NSMutableString *)string
{
	textField.text = string;
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
