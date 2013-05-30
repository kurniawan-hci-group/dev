//
//  ControlGroup.m
//  iRTS
//
//  Created by Scott Orzech on 2/28/11.
//  Copyright 2011 University of California, Santa Cruz. All rights reserved.
//

#import "ControlGroup.h"

// --- private interface ---------------------------------------------------------------------------

@interface ControlGroup ()

- (void)onTouch:(SPTouchEvent*)event;

@end

// --- class implementation ------------------------------------------------------------------------

@implementation ControlGroup
- (id)initWithX1:(int)x1 X2:(int)x2 index:(int)index
{
	if (self = [super init])
    {
		self.x = x1;
		self.y = 768;
		groupUnits = [[NSMutableArray alloc] init];
		SPTexture *texture = [SPTexture textureWithContentsOfFile:@"control_group.png"];
		SPImage *oImage = [SPImage imageWithTexture:texture];
		groupImage = oImage;

		[self addChild:groupImage];
		
		SPTexture *texture1 = [SPTexture textureWithContentsOfFile:@"addto_group.png"];
		oImage = [SPImage imageWithTexture:texture1];
		addImage = oImage;
		addImage.x = x2;
		addImage.y = 216;
		[self addChild:addImage];
		
        //[self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
		NSString *unitCount = [NSString stringWithFormat:@"#: %d",[groupUnits count]];
		textField = [SPTextField textFieldWithWidth:50 height:40 
											   text:unitCount
										   fontName:@"Helvetica" fontSize:16.0f color:0x000000];
		textField.hAlign = SPHAlignCenter; // horizontal alignment
		textField.vAlign = SPVAlignCenter; // vertical alignment
		textField.border = NO;
		textField.touchable = NO;
		
		[self addChild:textField];
	
		NSString *groupCount = [NSString stringWithFormat:@"Add to %d",index];
		textField2 = [SPTextField textFieldWithWidth:80 height:40 
											   text:groupCount
										   fontName:@"Helvetica" fontSize:16.0f color:0x000000];
		textField2.hAlign = SPHAlignCenter; // horizontal alignment
		textField2.vAlign = SPVAlignCenter; // vertical alignment
		textField2.x = x2;
		textField2.y = 216;
		textField2.border = NO;
		textField2.touchable = NO;
		
		[self addChild:textField2];
		
		[groupImage addEventListener:@selector(onTouch:) atObject:self
							   forType:SP_EVENT_TYPE_TOUCH];
		[addImage addEventListener:@selector(onTouchAdd:) atObject:self
							  forType:SP_EVENT_TYPE_TOUCH];
		[self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
		
	}
	return self;
}

- (id)init
{
    // the designated initializer of the base class should always be overridden -- we do that here.
    return [self initWithX1:0 X2:0];
}

- (void)setText:(NSMutableString *)string
{
	textField.text = string;
}

- (void)onTouch:(SPTouchEvent *)event
{
	NSArray *touches = [[event touchesWithTarget:self andPhase:SPTouchPhaseBegan] allObjects];
	if (touches.count == 1) {
		SPTouch *touch = [touches objectAtIndex:0];
		[self.parent setSelected:groupUnits];
	}
	
	touches = [[event touchesWithTarget:self andPhase:SPTouchPhaseMoved] allObjects];
	if (touches.count == 1) {
		SPTouch *touch = [touches objectAtIndex:0];
		[self.parent trashCanVisible:(YES)];
	}
	
	touches = [[event touchesWithTarget:self andPhase:SPTouchPhaseEnded] allObjects];
	if (touches.count == 1) {
		SPTouch *touch = [touches objectAtIndex:0];
		if (touch.globalX > 650 && touch.globalX < 750 && touch.globalY > 0 && touch.globalY < 100) {
			while(0 < [groupUnits count]) {
				[groupUnits removeObjectAtIndex:0];
			}			
		}
		[self.parent trashCanVisible:(NO)];
	}
}

- (void)onTouchAdd:(SPTouchEvent *)event
{
	NSArray *touches = [[event touchesWithTarget:self andPhase:SPTouchPhaseBegan] allObjects];
	if (touches.count == 1) {
		SPTouch *touch = [touches objectAtIndex:0];
		for (int i=0; i < [[self.parent getSelected] count]; ++i) {
			if ([groupUnits count] == 0) {
				[groupUnits addObject:[[self.parent getSelected] objectAtIndex:i]];
			}
			else if (![groupUnits containsObject:[[self.parent getSelected] objectAtIndex:i]]) {
				[groupUnits addObject:[[self.parent getSelected] objectAtIndex:i]];
			}
		}	
	}
}

- (void)onEnterFrame:(SPEnterFrameEvent *)event
{
	NSMutableString *unitCount = [NSMutableString stringWithFormat:@"#: %d",[groupUnits count]];
	[self setText:unitCount];
}


- (void)dealloc
{
    // event listeners should always be removed to avoid memory leaks!
	[groupImage release];
	[addImage release];
    [super dealloc];
}

@end
