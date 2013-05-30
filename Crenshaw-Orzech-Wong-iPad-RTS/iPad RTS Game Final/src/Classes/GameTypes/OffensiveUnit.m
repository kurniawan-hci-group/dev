//
//  OffensiveUnit.m
//  AppScaffold
//
//  Created by Scott Orzech on 2/15/11.
//  Copyright 2011 University of California, Santa Cruz. All rights reserved.
//

#import "OffensiveUnit.h"

// --- private interface ---------------------------------------------------------------------------

@interface OffensiveUnit ()

- (void)onTouch:(SPTouchEvent*)event; //Select Unit

@end

// --- class implementation ------------------------------------------------------------------------

@implementation OffensiveUnit
- (id)initWithSPImage
{
	if (self = [super init])
    {
		health = 50;
		moveX = moveY = 0;
		destX = destY = 0;
		SPTexture *texture = [SPTexture textureWithContentsOfFile:@"unit2_offensive.png"]; //465 by 42
		SPImage *oImage = [SPImage imageWithTexture:texture];
		mImage = oImage;
		mImage.scaleX = mImage.scaleY = 0.7f;
		mImage.x = -mImage.width/2;
		mImage.y = -mImage.height/2;
		selected = FALSE;
		justSelected = FALSE;
	
		[self addChild:mImage];
		
		[mImage addEventListener:@selector(onTouch:) atObject:self
							   forType:SP_EVENT_TYPE_TOUCH];
        [self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
		
		SPEvent *bubblingEvent = [[SPEvent alloc]
								  initWithType:SP_EVENT_TYPE_TOUCH bubbles:YES];
		[self dispatchEvent:bubblingEvent];
		[bubblingEvent release]; //might have to move this to dealloc
		
		selectionHalo = [SPTextField textFieldWithWidth:mImage.width
											 height:mImage.height text:@"" fontName:@"Helvetica" fontSize:16.0f color:0xffcccc];
		selectionHalo.hAlign = SPHAlignCenter; // horizontal alignment
		selectionHalo.vAlign = SPVAlignCenter; // vertical alignment
		selectionHalo.x = -mImage.width/2;
		selectionHalo.y = -mImage.height/2;
		selectionHalo.border = YES;
		selectionHalo.visible = NO;
		
		[self addChild:selectionHalo];
	}
	return self;
}

- (id)init
{
    // the designated initializer of the base class should always be overridden -- we do that here.
    return [self initWithSPImage];
}

- (void)moveTo:(SPPoint*)dest
{
	destX = dest.x;
	destY = dest.y;
	float angle = atan2(destY-self.y, destX-self.x);
	moveX = cos(angle) * (10.0f);
	moveY = sin(angle) * (10.0f);
	//self.x = dest.x;
	//self.y = dest.y;
	
	//NSLog(@"moveTo targetX: %f targetY: %f", destX, destY);
//	NSLog(@"x: %f y: %f", self.x, self.y);
}

- (int)getHealth{
	return health;
}

- (void)setHealth:(int) newHealth{
	health = newHealth;
}

- (void)select
{
	//NSLog(@"Unit Selected");
	selected = TRUE;
}

- (void)deselect
{
	//NSLog(@"Unit Unselected");
	selected = FALSE;
	[self deJustSelected];
}

- (bool)isSelected
{
	return selected;
}

- (bool)justSelected
{
	return justSelected;
}

- (void)deJustSelected
{
	justSelected = FALSE;
}

- (void)onTouch:(SPTouchEvent*)event
{
    NSArray *touches = [[event touchesWithTarget:self andPhase:SPTouchPhaseBegan] allObjects];
	if (touches.count == 1)
    {
        // one finger touching -> move
		//NSLog(@"Selected Unit");
		justSelected = TRUE;
	}
}

- (void)onEnterFrame:(SPEnterFrameEvent *)event
{   
	self.x += moveX;
	self.y += moveY;
	
	if (abs(self.x - destX) < 30){
		moveX = 0;
	}
	if (abs(self.y - destY) < 30) {
		moveY = 0;
	}
	
	if (selected) {
		selectionHalo.visible = YES;
	}
	else {
		selectionHalo.visible = NO;
	}

}


- (void)dealloc
{
    // event listeners should always be removed to avoid memory leaks!
	[mImage release];
    [super dealloc];
}

@end
