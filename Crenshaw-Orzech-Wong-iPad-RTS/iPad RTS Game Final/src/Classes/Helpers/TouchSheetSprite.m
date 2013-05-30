//
//  TouchSheetCSprite.m
//  AppScaffold
//
//  Created by Scott Orzech on 2/14/11.
//  Copyright 2011 University of California, Santa Cruz. All rights reserved.
//

#import "TouchSheetSprite.h"

// --- private interface ---------------------------------------------------------------------------

@interface TouchSheetSprite ()

- (void)onTouchEvent:(SPTouchEvent*)event;

@end

// --- class implementation ------------------------------------------------------------------------

@implementation TouchSheetSprite


- (id)initWithGrid:(SPSprite*)grid width:(float)width height:(float)height
{
    if (self = [super init])
    {		
		mgrid = grid;
		mwidth = width;
		mheight = height;
		
        [self addEventListener:@selector(onTouchEvent:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
    }
    return self;
}

- (id)init
{
    // the designated initializer of the base class should always be overridden -- we do that here.
	SPSprite *tempSprite = [SPSprite sprite];
	return [self initWithGrid:tempSprite width:50.0f height:50.0f];
}

- (void)onTouchEvent:(SPTouchEvent*)event
{
    NSArray *touches = [[event touchesWithTarget:self andPhase:SPTouchPhaseMoved] allObjects];
	//NSLog(@"Touching the mainscreen");

    if (touches.count == 1)
    {                
        // one finger touching -> move
        SPTouch *touch = [touches objectAtIndex:0];
		
        SPPoint *currentPos = [touch locationInSpace:self.parent];
        SPPoint *previousPos = [touch previousLocationInSpace:self.parent];
        SPPoint *dist = [currentPos subtractPoint:previousPos];
        
		if (abs(self.x + dist.x) <= (mgrid.width)/2) { //if mgrid.width or height are lower than 768, 
			self.x += dist.x;								 //there may be artifacts
		}
		if (abs(self.y + dist.y) <= (mgrid.height)/2) {
			self.y += dist.y;				
		}
    }
    else 
	if (touches.count >= 2)
    {
        // two fingers touching -> move
        SPTouch *touch1 = [touches objectAtIndex:0];
		
        SPPoint *currentPos = [touch1 locationInSpace:self.parent];
        SPPoint *previousPos = [touch1 previousLocationInSpace:self.parent];
        SPPoint *dist = [currentPos subtractPoint:previousPos];
		
        if (abs(self.x + dist.x) <= (mgrid.width - 768)/2) { //if mgrid.width or height are lower than 768, 
			self.x += dist.x;								 //there may be artifacts
		}
		if (abs(self.y + dist.y) <= (mgrid.height - 768)/2) {
			self.y += dist.y;				
		}
    }
    
    touches = [[event touchesWithTarget:self andPhase:SPTouchPhaseEnded] allObjects];
    if (touches.count == 1)
    {
        SPTouch *touch = [touches objectAtIndex:0];
        if (touch.tapCount == 2)
        {
            // bring self to front            
            SPDisplayObjectContainer *parent = self.parent;
            [self retain];
            [parent removeChild:self];
            [parent addChild:self];
            [self release];
        }
    }    
}

- (void)dealloc
{
    // event listeners should always be removed to avoid memory leaks!
	[mgrid release];
    [super dealloc];
}

@end
