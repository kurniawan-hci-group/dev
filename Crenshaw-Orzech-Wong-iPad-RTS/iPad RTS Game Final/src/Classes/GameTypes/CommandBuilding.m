//
//  CommandBuilding.m
//  AppScaffold
//
//  Created by Scott Orzech on 2/15/11.
//  Copyright 2011 University of California, Santa Cruz. All rights reserved.
//

#import "CommandBuilding.h"

// --- private interface ---------------------------------------------------------------------------

@interface CommandBuilding ()

- (void)onTouch:(SPTouchEvent*)event;

@end

// --- class implementation ------------------------------------------------------------------------

@implementation CommandBuilding

- (id)initBlueprintBuilding
{
	if (self = [super init])
    {
		health = 250;
		buildTime = 200;
		
		completed = FALSE;
		buildTimeRemaining = buildTime;
		
		SPTexture *texture = [SPTexture textureWithContentsOfFile:@"unit2_barrack_blueprint_85_170.png"]; //465 by 42
		builtTexture = [SPTexture textureWithContentsOfFile:@"unit2_barrack.png"];
		SPImage *cImage = [SPImage imageWithTexture:texture];
		mImage = cImage;
		mImage.scaleX = mImage.scaleY = 0.5f;
		mImage.x = -mImage.width/2;
		mImage.y = -mImage.height/2;
		
				
		//delete mImage and then swap it with blueprint
		
		[self addChild:mImage];
		
		[mImage addEventListener:@selector(onTouch:) atObject:self
						 forType:SP_EVENT_TYPE_TOUCH];
		
		SPEvent *bubblingEvent = [[SPEvent alloc]
								  initWithType:SP_EVENT_TYPE_TOUCH bubbles:YES];
		[self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
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

- (id)initCompleteBuilding
{
	if (self = [super init])
    {
		health = 250;
		
		completed = TRUE;
		buildTimeRemaining = 0;
		
		builtTexture = [SPTexture textureWithContentsOfFile:@"unit2_barrack.png"]; //465 by 42
		SPImage *cImage = [SPImage imageWithTexture:builtTexture];
		mImage = cImage;
		mImage.scaleX = mImage.scaleY = 0.5f;
		mImage.x = -mImage.width/2;
		mImage.y = -mImage.height/2;
		
		//delete mImage and then swap it with blueprint
		
		[self addChild:mImage];
		
		[mImage addEventListener:@selector(onTouch:) atObject:self
						 forType:SP_EVENT_TYPE_TOUCH];
		
		SPEvent *bubblingEvent = [[SPEvent alloc]
								  initWithType:SP_EVENT_TYPE_TOUCH bubbles:YES];
		[self dispatchEvent:bubblingEvent];
		[self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
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
    return [self initWithCompleteBuilding];
}

- (void)advanceBuild
{ //decrements buildTimeRemaining
	
	if (buildTimeRemaining > 0) {
		if (buildTime == buildTimeRemaining) {
			if ([self.parent.parent getResources] < [self.parent.parent commandCost]) {
				return;
			}
			[self.parent.parent spendResources:[self.parent.parent commandCost]];
		}
		//NSLog(@"Build advanced %d", buildTimeRemaining);
		buildTimeRemaining--;
	}
	else {
		//NSLog(@"Build Complete");
		//mImage = [SPImage imageWithTexture:builtTexture];
		[self removeChildAtIndex:0];
		builtTexture = [SPTexture textureWithContentsOfFile:@"unit2_barrack.png"]; //465 by 42
		SPImage *sImage = [SPImage imageWithTexture:builtTexture];
		mImage = sImage;
		mImage.scaleX = mImage.scaleY = 0.5f;
		mImage.x = -mImage.width/2;
		mImage.y = -mImage.height/2;
		
		[self addChild:mImage];
		[mImage addEventListener:@selector(onTouch:) atObject:self
						 forType:SP_EVENT_TYPE_TOUCH];
		
		[self.parent.parent raiseSupplyCap:(5)];
		
		completed = TRUE;
	}
}

- (void)setRally:(SPPoint*)dest{
	if (completed) {
		//NSLog(@"Rally Point Selected %f, %f", dest.x, dest.y);
		rallyPoint = dest;
	}
}

- (int)getHealth{
	return health;
}

- (void)buildUnit:(SPDisplayObject *)unit
{
	currentUnit = unit;
	currentUnit.x = self.x;
	currentUnit.y = self.y;
	producingUnit = YES;
	
}

- (void)setHealth:(int) newHealth{
	health = newHealth;
}

- (void)lock
{
	isLocked = TRUE;
}

- (void)unlock
{
	isLocked = FALSE;
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

- (bool)isBlueprint
{
	return !completed;
}

- (bool)isMakingUnit
{
	return producingUnit;
}

- (float)getX
{
	return self.x;
}

- (float)getY
{
	return self.y;
}

- (void)onTouch:(SPTouchEvent*)event
{
    NSArray *touches = [[event touchesWithTarget:self andPhase:SPTouchPhaseBegan] allObjects];
	if (touches.count == 1)
    {                
		justSelected = TRUE;
	}
	
	touches = [[event touchesWithTarget:self andPhase:SPTouchPhaseMoved] allObjects];
	if (touches.count == 1 && !completed && !isLocked)
    {                
        SPTouch *touch = [touches objectAtIndex:0];
		self.x = touch.globalX - self.parent.x;
		self.y = touch.globalY - self.parent.y;	
		[self.parent.parent trashCanVisible:(YES)];
		
	}
	touches = [[event touchesWithTarget:self andPhase:SPTouchPhaseEnded] allObjects];
	if (touches.count == 1 && !completed && !isLocked) {
		[self deselect];
		[[self.parent.parent getSelected] removeObject:self];
		[self.parent.parent trashCanVisible:(NO)];
		SPTouch *touch = [touches objectAtIndex:0];
		if (touch.globalX > 650 && touch.globalX < 750 && touch.globalY > 0 && touch.globalY < 100) {
			[self.parent removeChild:self];
			
		}
	}
	
}

- (void)onEnterFrame:(SPEnterFrameEvent *)event
{   
	if (producingUnit == YES) {
		unitProductionTime++;
	}
	if (unitProductionTime >= 100) {
		producingUnit = NO;
		currentUnit.visible = YES;
		unitProductionTime = 0;
		currentUnit = NULL;
	}
	
	if (selected && completed) {
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
	[rallyPoint release];
    [super dealloc];
}

@end
