//
//  Mineral.m
//  iRTS
//
//  Created by Scott Orzech on 2/28/11.
//  Copyright 2011 University of California, Santa Cruz. All rights reserved.
//

#import "Mineral.h"

// --- private interface ---------------------------------------------------------------------------

@interface Mineral ()

- (void)onTouch:(SPTouchEvent*)event;

@end

// --- class implementation ------------------------------------------------------------------------

@implementation Mineral

- (id)initWithMinerals
{
	if (self = [super init])
    {
		mineralsLeft = 1000;
		
		SPTexture *texture = [SPTexture textureWithContentsOfFile:@"mineral.png"]; //465 by 42
		SPImage *wImage = [SPImage imageWithTexture:texture];
		mImage = wImage;
		mImage.scaleX = mImage.scaleY = 0.65f;
		mImage.x = -mImage.width/2;
		mImage.y = -mImage.height/2;
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

- (id)initWithMinerals:(int)minerals
{
	if (self = [super init])
    {
		mineralsLeft = minerals;
		
		SPTexture *texture = [SPTexture textureWithContentsOfFile:@"mineral.png"]; //465 by 42
		SPImage *wImage = [SPImage imageWithTexture:texture];
		mImage = wImage;
		mImage.scaleX = mImage.scaleY = 0.65f;
		mImage.x = -mImage.width/2;
		mImage.y = -mImage.height/2;		
		[self addChild:mImage];
		
		[mImage addEventListener:@selector(onTouch:) atObject:self
						 forType:SP_EVENT_TYPE_TOUCH];
        [self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
		
		SPEvent *bubblingEvent = [[SPEvent alloc]
								  initWithType:SP_EVENT_TYPE_TOUCH bubbles:YES];
		[self dispatchEvent:bubblingEvent];
		[bubblingEvent release]; //might have to move this to dealloc
	}
	return self;
}

- (id)init
{
    // the designated initializer of the base class should always be overridden -- we do that here.
    return [self initWithMinerals];
}

- (int) mineralsLeft{
	return mineralsLeft;
}

- (void) mineMinerals{
	if (mineralsLeft >= 0 && timeLeftUntilNextMine <= 0) {
		mineralsLeft -= 3;
		timeLeftUntilNextMine = 50;
		[self.parent.parent increaseResources:(3)];
	}
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
	//NSLog(@"Worker Touched");
	if (touches.count == 1)
    {                
        // one finger touching -> move
		//NSLog(@"Selected Unit");
		justSelected = TRUE;
	}
}

- (void)onEnterFrame:(SPEnterFrameEvent *)event
{   
	//if mineralsLeft <= 0, make invisible and dealloc from parent
	if (mineralsLeft <= 0) {
		self.visible = NO;
	}
	if (timeLeftUntilNextMine > 0) {
		timeLeftUntilNextMine--;
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
