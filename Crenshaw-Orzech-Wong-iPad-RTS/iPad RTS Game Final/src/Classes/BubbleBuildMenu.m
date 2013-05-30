//
//  BuildMenu.m
//  iRTS
//
//  Created by Scott Orzech on 2/27/11.
//  Copyright 2011 University of California, Santa Cruz. All rights reserved.
//

#import "BubbleBuildMenu.h"



// --- private interface ---------------------------------------------------------------------------

@interface BubbleBuildMenu ()

- (void)onTouch:(SPTouchEvent*)event; //Select Unit

@end


@implementation BubbleBuildMenu
- (id)initWithSPImages
{
	if (self = [super init])
    {
		self.x = 0;
		self.y = 0;
		
		SPTexture *texture = [SPTexture textureWithContentsOfFile:@"button2_barrack.png"]; //465 by 42
		buildCommand = [SPImage imageWithTexture:texture];
		buildCommand.x = -buildCommand.width/2;
		buildCommand.y = -buildCommand.height/2;
		buildCommand.x -= 100;
		[self addChild:buildCommand];
		texture = [SPTexture textureWithContentsOfFile:@"button2_supply.png"]; //465 by 42
		buildSupply = [SPImage imageWithTexture:texture];
		buildSupply.x = -buildSupply.width/2;
		buildSupply.y = -buildSupply.height/2;
		buildSupply.x -= 55;
		buildSupply.y -= 100;
		[self addChild:buildSupply];
		texture = [SPTexture textureWithContentsOfFile:@"button2_worker.png"]; //465 by 42
		buildWorker = [SPImage imageWithTexture:texture];
		buildWorker.x = -buildWorker.width/2;
		buildWorker.y = -buildWorker.height/2;
		buildWorker.x += 55;
		buildWorker.y -= 100;
		[self addChild:buildWorker];
		texture = [SPTexture textureWithContentsOfFile:@"button2_offensive.png"]; //465 by 42
		buildOffensive = [SPImage imageWithTexture:texture];
		buildOffensive.x = -buildOffensive.width/2;
		buildOffensive.y = -buildOffensive.height/2;
		buildOffensive.x += 100;
		[self addChild:buildOffensive];
		texture = [SPTexture textureWithContentsOfFile:@"button_template.png"]; //465 by 42
		closeMenu = [SPImage imageWithTexture:texture];
		closeMenu.scaleX = .8;
		closeMenu.scaleY = .8;
		closeMenu.x = -closeMenu.width/2;
		closeMenu.y = -closeMenu.height/2;
		[self addChild:closeMenu];
		
		buildCommand.visible = NO;
		buildSupply.visible = NO;
		buildWorker.visible = NO;
		buildOffensive.visible = NO;
		closeMenu.visible = NO;
		
		[buildCommand addEventListener:@selector(onTouch:) atObject:self
						 forType:SP_EVENT_TYPE_TOUCH];
		[buildSupply addEventListener:@selector(onTouch:) atObject:self
							   forType:SP_EVENT_TYPE_TOUCH];
		[buildWorker addEventListener:@selector(onTouch:) atObject:self
							   forType:SP_EVENT_TYPE_TOUCH];
		[buildOffensive addEventListener:@selector(onTouch:) atObject:self
							   forType:SP_EVENT_TYPE_TOUCH];
		[closeMenu addEventListener:@selector(onTouch:) atObject:self
							   forType:SP_EVENT_TYPE_TOUCH];
		
		
		textField1 = [SPTextField textFieldWithWidth:200
											 height:80 text:@"$75" fontName:@"Helvetica" fontSize:20.0f color:0xff3333];
		textField1.hAlign = SPHAlignCenter; // horizontal alignment
		textField1.vAlign = SPVAlignCenter; // vertical alignment
		textField1.x = -buildCommand.width/2;
		textField1.y = -buildCommand.height/2;
		textField1.x -=150;
		textField1.y += 45; //Use this index to alter the height: the others are to get it in place
		textField1.border = NO;
		textField1.touchable = NO;
		
		[self addChild:textField1];
		
		textField2 = [SPTextField textFieldWithWidth:200
											 height:80 text:@"$50" fontName:@"Helvetica" fontSize:20.0f color:0xff3333];
		textField2.hAlign = SPHAlignCenter; // horizontal alignment
		textField2.vAlign = SPVAlignCenter; // vertical alignment
		textField2.x = -buildSupply.width/2;
		textField2.y = -buildSupply.height/2;
		textField2.x -= 105;
		textField2.y -= 100;
		textField2.y += 45;
		textField2.border = NO;
		textField2.touchable = NO;
		
		[self addChild:textField2];
		
		textField3 = [SPTextField textFieldWithWidth:200
											 height:80 text:@"$25" fontName:@"Helvetica" fontSize:20.0f color:0xff3333];
		textField3.hAlign = SPHAlignCenter; // horizontal alignment
		textField3.vAlign = SPVAlignCenter; // vertical alignment
		textField3.x = -buildWorker.width/2;
		textField3.y = -buildWorker.height/2;
		textField3.x += 5;
		textField3.y -= 100;
		textField3.y += 45;
		textField3.border = NO;
		textField3.touchable = NO;
		
		[self addChild:textField3];
		
		textField4 = [SPTextField textFieldWithWidth:200
											 height:80 text:@"$50" fontName:@"Helvetica" fontSize:20.0f color:0xff3333];
		textField4.hAlign = SPHAlignCenter; // horizontal alignment
		textField4.vAlign = SPVAlignCenter; // vertical alignment
		textField4.x = -buildOffensive.width/2;
		textField4.y = -buildOffensive.height/2;
		textField4.x += 50;
		textField4.y += 45;
		textField4.border = NO;
		textField4.touchable = NO;
		
		[self addChild:textField4];
		
		textField1.visible = NO;
		textField2.visible = NO;
		textField3.visible = NO;
		textField4.visible = NO;
		
	}
	return self;
}

- (id)init
{
    // the designated initializer of the base class should always be overridden -- we do that here.
    return [self initWithSPImages];
}

- (bool)isVisible
{
	return isVisible;
}

- (void)setVisible:(BOOL)vis
{
	isVisible = vis;
	buildCommand.visible = vis;
	buildSupply.visible = vis;
	buildWorker.visible = vis;
	buildOffensive.visible = vis;
	closeMenu.visible = vis;
	textField1.visible = vis;
	textField2.visible = vis;
	textField3.visible = vis;
	textField4.visible = vis;
}

- (void)displayAt:(SPPoint *)center
{
	self.x = center.x;
	self.y = center.y;
}

- (void)displayAtX:(int)centerX Y:(int)centerY
{
	self.x = centerX;
	self.y = centerY;
}
- (SPDisplayObject*)getNewObject
{
	if (newObject == FALSE) {
		return NULL;
	}
	else {
		newObject = FALSE;
		return buildThis;
	}
}

- (void)onTouch:(SPTouchEvent*)event
{
	[self.parent setSelected:[[NSMutableArray alloc] init]];
	
    NSArray *touches = [[event touchesWithTarget:self andPhase:SPTouchPhaseBegan] allObjects];
	//NSLog(@"BubbleBuildMenu touches %d",touches.count);
	if (touches.count == 1 && isVisible == TRUE)
    {
		SPTouch *touch = [touches objectAtIndex:0];
		//NSLog(@"touch located at: %f, %f",touch.globalX, touch.globalY);
//		NSLog(@"Supply Capped?: %d", ![self.parent isSupplyCapped]);
		//NSLog(@"buildCommand boundaries: X: %f,%f. Y: %f, %f",(self.x + buildWorker.x),(self.x + buildWorker.x + buildWorker.width),(self.y + buildWorker.y),(self.y + buildWorker.y + buildWorker.height));
		if (touch.globalX < (self.x + closeMenu.width/2) && touch.globalX > (self.x - closeMenu.width/2) &&
			touch.globalY < (self.y + closeMenu.height/2) && touch.globalY > (self.y - closeMenu.height/2)) {
			[self setVisible:(FALSE)];
		}
		else if (touch.globalX > (self.x + buildCommand.x) && touch.globalX < (self.x + buildCommand.x + buildCommand.width) &&
				 touch.globalY > (self.y - buildCommand.y - buildCommand.height) && touch.globalY < (self.y - buildCommand.y)) {
			CommandBuilding *cBuilding;
			cBuilding = [[CommandBuilding alloc] initBlueprintBuilding];
			buildThis = cBuilding;
			newObject = TRUE;
			[self setVisible:(FALSE)];
		}
		else if (touch.globalX > (self.x + buildSupply.x) && touch.globalX < (self.x + buildSupply.x + buildSupply.width) &&
				 touch.globalY < (self.y + buildSupply.y + buildSupply.height) && touch.globalY > (self.y + buildSupply.y)) {
			SupplyBuilding *sBuilding;
			sBuilding = [[SupplyBuilding alloc] initBlueprintBuilding];
			buildThis = sBuilding;
			newObject = TRUE;
			[self setVisible:(FALSE)];
		}
		else if (touch.globalX > (self.x + buildWorker.x) && touch.globalX < (self.x + buildWorker.x + buildWorker.width) &&
				 touch.globalY < (self.y + buildWorker.y + buildWorker.height) && touch.globalY > (self.y + buildWorker.y) &&
				 [self.parent getResources] >= [self.parent workerCost]) {
			if (![self.parent isSupplyCapped]) {
				WorkerUnit *oUnit;
				oUnit = [[WorkerUnit alloc] initWithSPImage];
				buildThis = oUnit;
				[self.parent spendResources:[self.parent workerCost]];
				newObject = TRUE;
			}

			[self setVisible:(FALSE)];
		}
		else if (touch.globalX > (self.x + buildOffensive.x) && touch.globalX < (self.x + buildOffensive.x + buildOffensive.width) &&
				 touch.globalY > (self.y - buildOffensive.y - buildOffensive.height) && touch.globalY < (self.y - buildOffensive.y) &&
				 [self.parent getResources] >= [self.parent offensiveCost]) {
			if (![self.parent isSupplyCapped]) {
				OffensiveUnit *oUnit;
				oUnit = [[OffensiveUnit alloc] initWithSPImage];
				buildThis = oUnit;
				[self.parent spendResources:[self.parent offensiveCost]];
				newObject = TRUE;
			}
			[self setVisible:(FALSE)];
		}

	}
}

- (void)dealloc
{
    // event listeners should always be removed to avoid memory leaks!
	[buildCommand release];
	[buildSupply release];
	[buildWorker release];
	[buildOffensive release];
    [super dealloc];
}
@end
