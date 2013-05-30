//
//  Minimap.m
//  iRTS
//
//  Created by Scott Orzech on 2/28/11.
//  Copyright 2011 University of California, Santa Cruz. All rights reserved.
//

#import "Minimap.h"

float minimapScale = 0.21;

// --- private interface ---------------------------------------------------------------------------

@interface Minimap ()

- (void)onTouch:(SPTouchEvent*)event;

@end

// --- class implementation ------------------------------------------------------------------------

@implementation Minimap
- (id)initWithSPImage
{
	if (self = [super init])
    {
		self.y = 808;
		
		SPTexture *texture = [SPTexture textureWithContentsOfFile:@"minimap.png"]; //214 by 215
		SPImage *oImage = [SPImage imageWithTexture:texture];
		mImage = oImage;
		
		[self addChild:mImage];
		
		texture = [SPTexture textureWithContentsOfFile:@"starfield.png"];
		oImage = [SPImage imageWithTexture:texture];
		mImage2 = oImage;
		mImage2.scaleX = mImage2.scaleY = minimapScale;
		mImage2.y = -mImage2.height/2 + mImage.height/2.0f;
		
		[self addChild:mImage2];
		
		mSprite = [[SPSprite alloc] init];
		//[self addChild:mSprite]; //cannot be left empty by the time of rendering so it crashes
		
		gTexture = [SPTexture textureWithContentsOfFile:@"green_dot.png"];
		oImage = [SPImage imageWithTexture:gTexture]; //this sprite makes it so that it isn't empty
		oImage.x = -oImage.width/2 - 50;
		oImage.y = -oImage.height/2;
		oImage.scaleX = 0.1;
		oImage.scaleY = 0.1;
		[mSprite addChild:oImage];
		rTexture = [SPTexture textureWithContentsOfFile:@"red_dot.png"];
		oImage = [SPImage imageWithTexture:rTexture]; //this sprite makes it so that it isn't empty
		oImage.x = -oImage.width/2 - 50;
		oImage.y = -oImage.height/2;
		oImage.scaleX = 0.1;
		oImage.scaleY = 0.1;
		[mSprite addChild:oImage];
		
		[self addChild:mSprite];
		
		[mImage addEventListener:@selector(onTouch:) atObject:self
						  forType:SP_EVENT_TYPE_TOUCH];
		[mImage2 addEventListener:@selector(onTouch:) atObject:self
						  forType:SP_EVENT_TYPE_TOUCH];
		[mSprite addEventListener:@selector(onTouch:) atObject:self
						  forType:SP_EVENT_TYPE_TOUCH];
        [self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
		
		textField = [SPTextField textFieldWithWidth:768 * minimapScale / 5.0 height:768 * minimapScale / 5.0
											   text:@"" 
										   fontName:@"Helvetica" fontSize:16.0f color:0xcccccc];
		textField.width += 2;
		textField.height += 2;
		//textField.x = 108;
		//textField.y = 110;
		textField.hAlign = SPHAlignCenter; // horizontal alignment
		textField.vAlign = SPVAlignCenter; // vertical alignment
		textField.touchable = NO;
		textField.border = YES;
		
		[self addChild:textField];
	}
	return self;
}

- (id)init
{
    // the designated initializer of the base class should always be overridden -- we do that here.
    return [self initWithSPImage];
}

- (void)onTouch:(SPTouchEvent*)event{
	SPSprite *touchSheet = [self.parent childAtIndex:0];
	
	//depending on loc, move by loc multiply by 5.0 / minimapScale
	mImage2.y = -mImage2.height/2 + mImage.height/2.0f;
	
	NSArray *touches = [[event touchesWithTarget:self
										andPhase:SPTouchPhaseBegan] allObjects];
	
	if (touches.count == 1) {
		
		SPTouch *touch = [touches objectAtIndex:0];
		SPPoint *myMini = [touch locationInSpace:mImage2];
		if (myMini.x <= 1024 && myMini.x >= 0 && myMini.y <= 768 && myMini.y >= 0) {
			touchSheet.x = -(myMini.x - 512) / minimapScale + 384;
			touchSheet.y = -(myMini.y - 384) / minimapScale + 384;
			textField.x = myMini.x * minimapScale - textField.width/2 + 1;
			textField.y = myMini.y * minimapScale + textField.height/2 - 6;			
		}
	}
	
	touches = [[event touchesWithTarget:self
										andPhase:SPTouchPhaseMoved] allObjects];
	
	if (touches.count == 1) {
		SPTouch *touch = [touches objectAtIndex:0];
		SPPoint *myMini = [touch locationInSpace:mImage2];
		if (myMini.x <= 1024 && myMini.x >= 0 && myMini.y <= 768 && myMini.y >= 0) {
			touchSheet.x = -(myMini.x - 512) / minimapScale + 384;
			touchSheet.y = -(myMini.y - 384) / minimapScale + 384;
			textField.x = myMini.x * minimapScale - textField.width/2 + 1;
			textField.y = myMini.y * minimapScale + textField.height/2 - 6;			
		}
	}
}

- (void)onEnterFrame:(SPEnterFrameEvent *)event
{
	while (2 < [mSprite numChildren])
	{
		[mSprite removeChildAtIndex:1];
	}
	//update info	
	SPSprite *touchSheet = [self.parent childAtIndex:0];
	int numChildren = [touchSheet numChildren]; //For each child of parent
	
	for (int loop = 1; loop < numChildren; ++loop)
	{
		SPDisplayObject *obj = [touchSheet childAtIndex:loop];
		SPImage *oImage = [SPImage imageWithTexture:rTexture];
		if ([obj isKindOfClass:[Mineral class]]) {
			oImage = [SPImage imageWithTexture:gTexture];
		}
		oImage.x = (obj.x ) * minimapScale / 5.0 + mImage.width/2.0f;
		oImage.y = (obj.y ) * minimapScale / 5.0 + mImage.height/2.0f;
		[mSprite addChild:oImage];
	}
	
	textField.x = -touchSheet.x * minimapScale / 5.0 + mImage.width/2.0f;
	textField.y = -touchSheet.y * minimapScale / 5.0 + mImage.height/2.0f;
}

- (void)dealloc
{
    // event listeners should always be removed to avoid memory leaks!
	[mImage release];
    [super dealloc];
}

@end
