//
//  TouchSheet.m
//  Sparrow
//
//  Created by Daniel Sperl on 08.05.09.
//  Copyright 2009 Incognitek. All rights reserved.
//

#import "TouchSheet.h"

// --- private interface ---------------------------------------------------------------------------

@interface TouchSheet ()

- (void)onTouchEvent:(SPTouchEvent*)event;

@end

// --- class implementation ------------------------------------------------------------------------

@implementation TouchSheet


- (id)initWithQuad:(SPQuad*)quad
{
    if (self = [super init])
    {
        // move quad to center, so that scaling works like expected
        mQuad = [quad retain];
        mQuad.x = -mQuad.width/2;
        mQuad.y = -mQuad.height/2;        
        [mQuad addEventListener:@selector(onTouchEvent:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        [self addChild:mQuad];
    }
    return self;    
}

- (id)init
{
    // the designated initializer of the base class should always be overridden -- we do that here.
    SPQuad *quad = [[[SPQuad alloc] init] autorelease];
    return [self initWithQuad:quad];
}

- (void)onTouchEvent:(SPTouchEvent*)event
{
    NSArray *touches = [[event touchesWithTarget:self andPhase:SPTouchPhaseMoved] allObjects];
    
	//NSLog(@"Touching the mainscreen");
	
    if (touches.count == 1)
    {                
        // one finger touching -> move
//        SPTouch *touch = [touches objectAtIndex:0];
//		
//        SPPoint *currentPos = [touch locationInSpace:self.parent];
//        SPPoint *previousPos = [touch previousLocationInSpace:self.parent];
//        SPPoint *dist = [currentPos subtractPoint:previousPos];
//        
//        self.x += dist.x;
//        self.y += dist.y;
    }
    else if (touches.count >= 2)
    {
        // two fingers touching -> move
        SPTouch *touch1 = [touches objectAtIndex:0];
		
        SPPoint *currentPos = [touch1 locationInSpace:self.parent];
        SPPoint *previousPos = [touch1 previousLocationInSpace:self.parent];
        SPPoint *dist = [currentPos subtractPoint:previousPos];
       
        self.x += dist.x;
        self.y += dist.y;
    }
    
    touches = [[event touchesWithTarget:self andPhase:SPTouchPhaseEnded] allObjects];
    if (touches.count == 1)
    {
        //SPTouch *touch = [touches objectAtIndex:0];
       // if (touch.tapCount == 2)
//        {
//            // bring self to front            
//            SPDisplayObjectContainer *parent = self.parent;
//			//NSLog("Retain Before: (%f)",[self retainCount]);
//            [self retain];
//			//NSLog("Retain After: (%f)",[self retainCount]);
//            [parent removeChild:self];
//            [parent addChild:self];
//            [self release];
//        }
    }    
}

- (void)dealloc
{
    // event listeners should always be removed to avoid memory leaks!
    [mQuad removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TOUCH];
    [mQuad release];
    [super dealloc];
}

@end
