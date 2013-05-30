//
//  GameScene.m
//  AppScaffold
//
//  Created by Scott Orzech on 2/13/11.
//  Copyright 2011 University of California, Santa Cruz. All rights reserved.
//

#import "GameScene.h"

NSTimeInterval touchBeganTime;
SPPoint *startPos, *endPos;
TouchSheet *sheet1;
NSMutableArray *allSelectableUnits;
NSMutableArray *currentSelectedArray;
NSMutableArray *pastSelectedArray;
SPDisplayObject *lastUnit;
UnitInfo *unitinfo;
ResourceInfo *resourceInfo;
Minimap *minimapInfo;
bool holding;
int heldFor = 0;
BubbleBuildMenu *bMenu;
NSMutableString *lastString;
SPImage *trashCan;
NSMutableArray *allCommandBuildings;
SPSound *music;
SPSoundChannel *mainTheme;

//Variables Used for Lasso
bool dragWithOneFinger; //lasso selection must be one finger
SPPoint * initHold;
NSMutableArray * myLasso;

bool justTwoTouch;
int twoCount;

int supply;
int supplyCap;
SPTextField *textField;

@implementation GameScene


- (id)init
{
    if (self = [super init])
    { 		
		lastString = @"Please Select A Unit!";
		
		myLasso = [[NSMutableArray alloc] init];
		
		offensiveCost = 50;
		workerCost = 25;
		commandCost = 75;
		supplyCost = 50;
				
		supply = supplyCap = 0;
		resources = 25;
		currentSelectedArray = [[NSMutableArray alloc] init];	
		pastSelectedArray = [[NSMutableArray alloc] init];	
		allCommandBuildings = [[NSMutableArray alloc] init];
		
        m_Juggler = [[SPJuggler alloc] init];
        mStarted = NO;
		
		SPTexture *texture = [SPTexture textureWithContentsOfFile:@"starfield.png"]; //768 by 767
		SPImage *mainscreen = [SPImage imageWithTexture:texture];
		mainscreen.scaleX = 5;
		mainscreen.scaleY = 5;
		
		sheet1 = [[TouchSheet alloc] initWithQuad:mainscreen];    
		sheet1.x = 0;
		sheet1.y = 0;  
		//NSLog(@"Crash?");
		bMenu = [[BubbleBuildMenu alloc] initWithSPImages];
		[self addChild:bMenu];
		//NSLog(@"Crash?");
		texture = [SPTexture textureWithContentsOfFile:@"trash_can.png"];
		trashCan = [SPImage imageWithTexture:texture];
		trashCan.scaleX = trashCan.scaleY = 0.75f;
		trashCan.x = 650;
		trashCan.y = 0;
		[self addChild:trashCan];
		trashCan.visible = NO;
		
		allSelectableUnits = [[NSMutableArray alloc] init];			
				
		for (int i = 0; i < 6; ++i) {
			Mineral *mineral;
			mineral = [[Mineral	alloc] initWithMinerals];
			mineral.x += 100 * i + 114;
			mineral.y += 180;
			[sheet1 addChild:mineral];
			[allSelectableUnits addObject:mineral];
		}
		for (int i = 0; i < 3; ++i) {
			Mineral *mineral;
			mineral = [[Mineral	alloc] initWithMinerals];
			mineral.x = 1000 - sheet1.x;
			mineral.y = 1500 - sheet1.y;
			mineral.x += 85 * i + 164;
			mineral.y += 180;
			[sheet1 addChild:mineral];
			[allSelectableUnits addObject:mineral];
		}
		for (int i = 0; i < 3; ++i) {
			Mineral *mineral;
			mineral = [[Mineral	alloc] initWithMinerals];
			mineral.x = -750 - sheet1.x;
			mineral.y = -750 - sheet1.y;
			mineral.x += 85 * i + 164;
			mineral.y += 180;
			[sheet1 addChild:mineral];
			[allSelectableUnits addObject:mineral];
		}
		for (int i = 0; i < 1; ++i) {
			CommandBuilding *cBuilding;
			cBuilding = [[CommandBuilding alloc] initCompleteBuilding];
			cBuilding.x += 325 * i + 384;
			cBuilding.y += 580;
			[sheet1 addChild:cBuilding];
			[allSelectableUnits addObject:cBuilding];
			[allCommandBuildings addObject:cBuilding];
			[self raiseSupplyCap:(5)];
		}
		for (int i = 0; i < 1; ++i) {
			WorkerUnit *wUnit;
			wUnit = [[WorkerUnit alloc] initWithSPImage];
			wUnit.x += 384;
			wUnit.y += 360;
			[sheet1 addChild:wUnit];
			[allSelectableUnits addObject:wUnit];
			[self addSupply];
		}
		music = [SPSound soundWithContentsOfFile:@"Space 2055.aifc"];
		mainTheme = [[music createChannel] retain];
		[music release];
		[mainTheme setLoop:TRUE];
		[mainTheme play];
		
		[self addChild:sheet1 atIndex:0];	
	
        [self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
		[self addEventListener:@selector(onTouch:) atObject:self
					   forType:SP_EVENT_TYPE_TOUCH];
		[self addEventListener:@selector(onBubblingEvent:)
					  atObject:self forType:SP_EVENT_TYPE_TOUCH];
		
		//texture = [SPTexture textureWithContentsOfFile:@"controlgroup.png"]; //768 by 41
//		SPImage	*controlgroup = [SPImage imageWithTexture:texture];
//		[controlgroup addEventListener:@selector(onControlGroupTriggered:) atObject:self
//							   forType:SP_EVENT_TYPE_TOUCH];
//		controlgroup.y = 767;
		for (int i = 0; i < 6; ++i) {	
			ControlGroup *controlgroup = [[ControlGroup alloc] initWithX1:(i * 128) X2:(214 - i * 50) index: i + 1];
			[self addChild:controlgroup];
		}
		//texture = [SPTexture textureWithContentsOfFile:@"minimap.png"]; //214 by 215
		minimapInfo = [[Minimap alloc] initWithSPImage];
		//[minimapInfo addEventListener:@selector(onMinimapTriggered:) atObject:self
//						  forType:SP_EVENT_TYPE_TOUCH];
		//minimap.y = 808;
		
		//texture = [SPTexture textureWithContentsOfFile:@"resources.png"]; //85 by 215
		resourceInfo = [[ResourceInfo alloc] initWithSPImage];
		[resourceInfo addEventListener:@selector(onResourcesTriggered:) atObject:self
							forType:SP_EVENT_TYPE_TOUCH];
		//resourcesUI.x = 683;
		//resourcesUI.y = 808;
		
		//texture = [SPTexture textureWithContentsOfFile:@"unitInfo.png"]; //464 by 172
		unitinfo = [[UnitInfo alloc] initWithSPImage];
		[unitinfo addEventListener:@selector(onUnitInfoTriggered:) atObject:self
						   forType:SP_EVENT_TYPE_TOUCH];
		//unitinfo.x = 215;
		//unitinfo.y = 808;
		
		//texture = [SPTexture textureWithContentsOfFile:@"addsetbar.png"]; //465 by 42
//		SPButton *addsetbar = [SPButton buttonWithUpState:texture];
//		[addsetbar addEventListener:@selector(onAddSetBarTriggered:) atObject:self
//							forType:SP_EVENT_TYPE_TRIGGERED];
//		addsetbar.x = 215;
//		addsetbar.y = 980;
		
		mWaitFrames = 3;
		
		//[self addChild:controlgroup];
		[self addChild:minimapInfo];
		[self addChild:resourceInfo];
		[self addChild:unitinfo];
		//[self addChild:addsetbar];
				
		textField = [SPTextField textFieldWithWidth:200 height:60 
											   text:@"YOU'VE BEEN\nSUPPLY CAPPED! (Try building a supply depot)" 
										   fontName:@"Helvetica" fontSize:16.0f color:0xcc0000];
		textField.x = 284;
		textField.hAlign = SPHAlignCenter; // horizontal alignment
		textField.vAlign = SPVAlignCenter; // vertical alignment
		textField.border = YES;
		textField.visible = NO;
		
		[self addChild:textField];
	}
    return self;    
}

- (void)onControlGroupTriggered:(SPEvent *)event
{
    NSLog(@"The Control Group was triggered!");
}
//- (void)onMinimapTriggered:(SPTouchEvent *)event
//{
//    NSLog(@"The Minimap was triggered!");
//}
- (void)onResourcesTriggered:(SPEvent *)event
{
    NSLog(@"The Resources was triggered!");
}
- (void)onUnitInfoTriggered:(SPEvent *)event
{
    NSLog(@"The Unit Info was triggered!");
}
- (void)onAddSetBarTriggered:(SPEvent *)event
{
    NSLog(@"The Add Set Bar was triggered!");
}

- (void)onEnterFrame:(SPEnterFrameEvent *)event
{    
	if ([self isSupplyCapped]) {
		textField.visible = YES;
	}
	else {
		textField.visible = NO;
	}

	
    [m_Juggler advanceTime:event.passedTime];    
    if (holding == TRUE) {
		heldFor++;
		//NSLog(@"Held For: %d", heldFor);
	}
	else {
		heldFor = 0;
	}
	if (heldFor >= 13 && holdLocY < 767) {
		[self setSelected:[[NSMutableArray alloc] init]];
		[bMenu setVisible:(TRUE)];
		[bMenu displayAtX:holdLocX Y:holdLocY];
		//NSLog(@"Held at: %f, %f",holdLocX,holdLocY);
	}
		
	
    if (mStarted)
    {
        mElapsed += event.passedTime;
        ++mFrameCount;
		
        if (mFrameCount % mWaitFrames == 0)
        {
            float targetFPS = self.stage.frameRate;
            float realFPS = mWaitFrames / mElapsed;
            
            if (ceilf(realFPS) >= targetFPS)
            {
                //mFailCount = 0;        
            }
            else 
            {
                //++mFailCount;                
                
                //if (mFailCount > 10){
				//mWaitFrames = 15; // slow down creation process to be more exact 
				NSLog(@"SLOWING DOWN");
				//}
                //if (mFailCount == 14)
                //    [self benchmarkComplete]; // target fps not reached for a while
            }
			
            mElapsed = mFrameCount = 0;
        }
    }
    //NSLog(@"currently selected %f", [currentSelectedArray count]);
	//update pastSelectedArray
	for (int i = 0; i < [currentSelectedArray count] && [currentSelectedArray count] > 0; ++i) {
		NSString *unitType = NSStringFromClass([[currentSelectedArray objectAtIndex:i] class]);
		NSMutableString *string2; int index;
		if (![[currentSelectedArray objectAtIndex:i] isKindOfClass:[Mineral class]]) {
			if (([[currentSelectedArray objectAtIndex:i] isKindOfClass:[SupplyBuilding class]] || [[currentSelectedArray objectAtIndex:i] isKindOfClass:[CommandBuilding class]])&& [[currentSelectedArray objectAtIndex:i] isBlueprint]) {
				string2 = [NSMutableString stringWithFormat:@"Blueprint: \n %@", unitType];
			}
			else{
				string2 = [NSMutableString stringWithFormat:@"%@ \n Health: \n %d", unitType, [[currentSelectedArray objectAtIndex:i] getHealth]];
			}
			index = 4;
		}
		else{
			string2 = [NSMutableString stringWithFormat:@"%@: \n%d", unitType, [[currentSelectedArray objectAtIndex:i] mineralsLeft]];
			if (![[currentSelectedArray objectAtIndex:i] isKindOfClass:[OffensiveUnit class]]) {
				index = 0;
			}
			if (![[currentSelectedArray objectAtIndex:i] isKindOfClass:[WorkerUnit class]]) {
				index = 1;
			}
			if (![[currentSelectedArray objectAtIndex:i] isKindOfClass:[CommandBuilding class]]) {
				index = 2;
			}
			if (![[currentSelectedArray objectAtIndex:i] isKindOfClass:[SupplyBuilding class]]) {
				index = 3;
			}
		}
			  
		[unitinfo setText:string2 imgIndex:index];
	}
	
	NSMutableString *string = [NSMutableString stringWithFormat:@"Minerals: \n%d\nSupply: \n%d/%d", resources, supply, supplyCap];
	[resourceInfo setText:string];
	
	//mContainer.x += 0.5f;
	
  //  for (SPDisplayObject *child in mContainer)    
   //     child.rotation += 0.05f;    
}

- (void)onBubblingEvent:(SPTouchEvent*)event
{
	
	//NSLog(@"Bubbling event detected!");
	
	int numChildren = [[self childAtIndex:0] numChildren];
	//NSLog(@"A!");
	BOOL somethingJustSelected = FALSE;
	//check which children have been justSelected
	for (int loop = 1; loop < numChildren; ++loop)
	{
		//NSLog(@"B!");
		SPDisplayObject *obj = [[self childAtIndex:0] childAtIndex:loop];
		//NSLog(@"C!");
		
		//NSLog(@"%s just selected: %s", obj == oUnit ? "oUnit" : "wUnit", [obj justSelected]?"true":"false");
		if ([obj justSelected]) {
			//NSLog(@"D!");
			somethingJustSelected = TRUE;
		}
	}
	if (somethingJustSelected) {
		//NSLog(@"Something just selected");
		if ([pastSelectedArray count] >= 1) {
			//NSLog(@"One unit in past %@",NSStringFromClass([[pastSelectedArray objectAtIndex:0] class]));
			lastUnit = [pastSelectedArray objectAtIndex:0];
		}
		
		while(0 < [pastSelectedArray count]) {
			[[pastSelectedArray objectAtIndex:0] deselect];
			[pastSelectedArray removeObjectAtIndex:0];
		}
		while(0 < [currentSelectedArray count]) {
			[currentSelectedArray removeObjectAtIndex:0];
		}
		//check which children have been justSelected
		for (int loop = 1; loop < numChildren; ++loop)
		{
			SPDisplayObject *obj = [[self childAtIndex:0] childAtIndex:loop];
			
			//NSLog(@"%s just selected: %s", obj == oUnit ? "oUnit" : "wUnit", [obj justSelected]?"true":"false");
			if ([obj justSelected]) {
				
				while(0 < [pastSelectedArray count]) {
					[[pastSelectedArray objectAtIndex:0] deselect];
					[pastSelectedArray removeObjectAtIndex:0];
				}
				while(0 < [currentSelectedArray count]) {
					[currentSelectedArray removeObjectAtIndex:0];
				}
				[currentSelectedArray addObject:obj];
				if ([currentSelectedArray count] == 1) {
					//NSLog(@"One unit in current");
					if([[currentSelectedArray objectAtIndex:0] isKindOfClass:[CommandBuilding class]] || 
					   [[currentSelectedArray objectAtIndex:0] isKindOfClass:[SupplyBuilding class]])
					{
						//NSLog(@"Current is command or supply");
						if([[currentSelectedArray objectAtIndex:0] isBlueprint] && [lastUnit isKindOfClass:[WorkerUnit class]]){
							//NSLog(@"Building is a blueprint");
							[lastUnit setBuilding:[currentSelectedArray objectAtIndex:0]];
							[currentSelectedArray removeObjectAtIndex:0];
							[currentSelectedArray addObject:lastUnit];
							lastUnit = NULL;
						}
					}
					else if([[currentSelectedArray objectAtIndex:0] isKindOfClass:[Mineral class]])
					{
						//NSLog(@"Current is mineral");
						if([[currentSelectedArray objectAtIndex:0] mineralsLeft] >= 0 && [lastUnit isKindOfClass:[WorkerUnit class]]){
							//NSLog(@"Mineral to be mined");
							[lastUnit setMineral:[currentSelectedArray objectAtIndex:0]];
							[currentSelectedArray removeObjectAtIndex:0];
							[currentSelectedArray addObject:lastUnit];
							lastUnit = NULL;
						}
					}
				}
				[obj deJustSelected];
			}
			
			//NSLog(@"The X position is: %f",obj.x);
		}
		
		
	}
	
	//update pastSelectedArray
	for (int i = 0; i < [currentSelectedArray count]; ++i) {
		[[currentSelectedArray objectAtIndex:i] select];
		[pastSelectedArray addObject:[currentSelectedArray objectAtIndex:i]];
		
		//[unitinfo updateUnit:[currentSelectedArray objectAtIndex:i]];
		//[unitinfo updateUnit:oUnit];
	}	
}	


//http://paulbourke.net/geometry/insidepoly/

/*
 Return the angle between two vectors on a plane
 The angle is from vector 1 to vector 2, positive anticlockwise
 The result is between -pi -> pi
 */
- (double) angle2D:(double) x1 :(double) y1 :(double) x2 :(double) y2
{
	double dtheta,theta1,theta2;
	
	theta1 = atan2(y1,x1);
	theta2 = atan2(y2,x2);
	dtheta = theta2 - theta1;
	while (dtheta > M_PI)
		dtheta -= M_PI * 2;
	while (dtheta < -M_PI)
		dtheta += M_PI * 2;
	
	return(dtheta);
}

//vector<vector3> polygon - the vertices of the tile in question
//int n - the number of vertices
//vector3 p - the location of the ball(or point on the plane)
- (int) insidePolygon:(NSMutableArray*) polygon withPoint:(SPPoint*) p
{
	//if the height of the tile at the balls x,z coord is too low/high, return false
	//INTERPOLATION - at the ball's (x,z) location for the y coordinate of the plane
	
	int i;
	double angle=0;
	SPPoint *p1,*p2;
	p1 = [SPPoint pointWithX:0 y:0];
	p2 = [SPPoint pointWithX:0 y:0];
	
	for (i=0;i<[polygon count];i++) { //missing check of height		
		p1.x = ((SPPoint *)[polygon objectAtIndex:i]).x - p.x;
		p1.y = ((SPPoint *)[polygon objectAtIndex:i]).y - p.y;
		p2.x = ((SPPoint *)[polygon objectAtIndex:((i+1)%[polygon count])]).x - p.x;
		p2.y = ((SPPoint *)[polygon objectAtIndex:((i+1)%[polygon count])]).y - p.y;
		angle += [self angle2D: p1.x: p1.y: p2.x: p2.y];
	}
	
	if (abs(angle) < M_PI)
		return(FALSE);
	else
		return(TRUE);
}


- (void)onTouch:(SPTouchEvent*)event
{
	//NSLog(@"GameScene onTouch Event detected!");
	//Began Phase
	NSArray *touches = [[event touchesWithTarget:self
										andPhase:SPTouchPhaseBegan] allObjects];
	
	if (touches.count == 1) {
		dragWithOneFinger = FALSE;
		holding = TRUE;
		SPTouch *touch = [touches objectAtIndex:0];
		SPPoint *holdLoc = [touch locationInSpace:self];
		holdLocX = holdLoc.x;
		holdLocY = holdLoc.y;
		initHold = holdLoc;
		
		SPDisplayObject *newObject = [bMenu getNewObject];
		if (newObject != NULL && ([newObject isKindOfClass:[CommandBuilding class]] || [newObject isKindOfClass:[SupplyBuilding class]])) {
			//NSLog(@"build this new building at: %f, %f",touch.globalX,touch.globalY);
			newObject.x = touch.globalX - sheet1.x;
			newObject.y = touch.globalY - sheet1.y;
			[sheet1 addChild:newObject atIndex:1];
			[allSelectableUnits addObject:newObject];
			if ([newObject isKindOfClass:[CommandBuilding class]]) {
				[allCommandBuildings addObject:newObject];
			}
		}
		else if (newObject != NULL && ([newObject isKindOfClass:[OffensiveUnit class]] || [newObject isKindOfClass:[WorkerUnit class]])) {
			CommandBuilding *tarBuilding = NULL;
			int closestDist;
			for (int i = 0; i < [allCommandBuildings count]; ++i) {
				if (![[allCommandBuildings objectAtIndex:i] isMakingUnit] && ![[allCommandBuildings objectAtIndex:i] isBlueprint]) {
					//if (tarBuilding == NULL) {
//						tarBuilding = [allCommandBuildings objectAtIndex:i];
//						closestDist = abs(bMenu.x - [[allCommandBuildings objectAtIndex:i] getX]) + abs(bMenu.y - [[allCommandBuildings objectAtIndex:i] getY]);
//					}
//					else if (closestDist < abs(bMenu.x - [[allCommandBuildings objectAtIndex:i] getX]) + abs(bMenu.y - [[allCommandBuildings objectAtIndex:i] getY])){
//						tarBuilding = [allCommandBuildings objectAtIndex:i];
//						closestDist = abs(bMenu.x - [[allCommandBuildings objectAtIndex:i] getX]) + abs(bMenu.y - [[allCommandBuildings objectAtIndex:i] getY]);
//					}
					[self addSupply];
					[sheet1 addChild:newObject];
					[allSelectableUnits addObject:newObject];
					newObject.visible = NO;
					[[allCommandBuildings objectAtIndex:i] buildUnit:newObject];
					i = [allCommandBuildings count];
				}
			}
			//[self addSupply];
//			[sheet1 addChild:newObject];
//			[allSelectableUnits addObject:newObject];
//			newObject.visible = NO;
//			[tarBuilding buildUnit:newObject];
			
		}
	}
	
	//Move Phase
	touches = [[event touchesWithTarget:self
							   andPhase:SPTouchPhaseMoved] allObjects];
	if (touches.count >= 2) {
		justTwoTouch = TRUE;
		twoCount = touches.count;
		heldFor = 0;
		holding = FALSE;
		[bMenu setVisible:(FALSE)];
		
		if (touches.count == 1) {
					}
	}
	if (touches.count == 1) {
		SPTouch *touch = [touches objectAtIndex:0];
		//NSLog(@"Hold location: %f, %f",holdLoc.x, holdLoc.y);
		//NSLog(@"Menu holding move amount: %d, %d",abs(touch.globalX - holdLoc.x),abs(touch.globalY - holdLoc.y));
		if (abs(touch.globalX - holdLocX) > 20 || abs(touch.globalY - holdLocY) > 20){
			heldFor = 0;
			holding = FALSE;
			[bMenu setVisible:(FALSE)];
			
			if (!dragWithOneFinger) { //If false, set one finger drag to true
				dragWithOneFinger = !dragWithOneFinger;
			}
			
			//Grabbing the points, moved to
			SPTouch *touch = [touches objectAtIndex:0];
			SPPoint *holdLoc = [touch locationInSpace:self];
			
			//Saving the points in the lasso
			[myLasso addObject:(holdLoc)];
			
			//For Visualization of the lasso (if enabled the squares don't dissappear yet)
			//To make dissappearing quads: Need to create a list of them (the quads) so that they can be freed with lasso
			//in TouchPhaseEnded
			/*SPQuad *quad = [SPQuad quadWithWidth:20 height:20];
			quad.color = 0x0fff00;
			quad.x = [holdLoc x] - [quad width]/2;
			quad.y = [holdLoc y] - [quad height]/2;
			[self addChild:quad];*/
		}
	}
	
	{
	//if (touches.count == 1 && heldFor < 25) {
//		
//		NSLog(@"Array of Units %d", [allSelectableUnits count]);
//		for (int i = 0; i < [allSelectableUnits count]; ++i) {
//			//if offensive or worker was selected
//			//move to position
//						
//			//if barrack was selected
//			if([[allSelectableUnits objectAtIndex:i] isKindOfClass:[CommandBuilding class]])
//			{
//				CommandBuilding *cBuilding = (CommandBuilding *)[allSelectableUnits objectAtIndex:i];
//				if ((cBuilding != NULL && [cBuilding isSelected]) && ![cBuilding justSelected]) {
//					SPTouch *touch = [touches objectAtIndex:0];
//					SPPoint *currentPos = [touch locationInSpace:self.parent];
//					currentPos.x -= sheet1.x;
//					currentPos.y -= sheet1.y;
//					if(abs([cBuilding x] - currentPos.x) >= 75 || abs([cBuilding y] - currentPos.y) >= 75){
//						[cBuilding moveTo:currentPos];
//					}
//				}
//			}
//			
//			//if supply was selected
//			if([[allSelectableUnits objectAtIndex:i] isKindOfClass:[SupplyBuilding class]])
//			{
//				SupplyBuilding *sBuilding = (SupplyBuilding *)[allSelectableUnits objectAtIndex:i];
//				if ((sBuilding != NULL && [sBuilding isSelected]) && ![sBuilding justSelected]) {
//					SPTouch *touch = [touches objectAtIndex:0];
//					SPPoint *currentPos = [touch locationInSpace:self.parent];
//					currentPos.x -= sheet1.x;
//					currentPos.y -= sheet1.y;
//					if(abs([sBuilding x] - currentPos.x) >= 75 || abs([sBuilding y] - currentPos.y) >= 75){
//						[sBuilding moveTo:currentPos];
//					}
//				}
//			}
//		}
//	}
	}
	
    //End Phase
	touches = [[event touchesWithTarget:self
										andPhase:SPTouchPhaseEnded] allObjects];
	
	//for each object in allSelectableUnits array, check is selected/justselected and that touch == 1
	//then call move to
	
	if (touches.count == 1) {
		holding = FALSE;
		
		//Lasso clearing
		if (dragWithOneFinger) {
			// one way
			//NSLog(@"myLasso: %@", myLasso);
			
			//Deselect what was previously selected
			while(0 < [currentSelectedArray count]) {
				[[currentSelectedArray objectAtIndex:0] deselect];
				[currentSelectedArray removeObjectAtIndex:0];
			}			
			
			//Check for and select objects that were in lasso			
			for (SPDisplayObject * SPDObj in allSelectableUnits){
				SPPoint * myUnitLoc = [[[SPPoint alloc] initWithX:SPDObj.x y: SPDObj.y] autorelease];
				
				bool inside = [self insidePolygon:myLasso withPoint:myUnitLoc];
				
				NSLog(@"Polygon inside Lasso?: %@", inside?@"YES":@"NO");
				
				if (inside) {					
					//Select 
					[currentSelectedArray addObject:SPDObj];
				}
			}
			
			
			//Clear the lasso array to prepare it for another one
			for (int i = 0; i < [myLasso count] - 1; ++i) {
				SPDisplayObject * SPDObj = [myLasso objectAtIndex:i];
				
				//NSLog(@"SPDObj: %@", SPDObj);
				//SPDObj.visible = false;
				[self removeChild:SPDObj];
			}
			[myLasso removeAllObjects];
		}
	}
	if (touches.count == 1 && heldFor < 13 && !justTwoTouch) {
		
		//NSLog(@"Array of Units %d", [allSelectableUnits count]);
		for (int i = 0; i < [currentSelectedArray count]; ++i) {
			//if offensive or worker was selected
			//move to position
			if([[currentSelectedArray objectAtIndex:i] isKindOfClass:[OffensiveUnit class]])
			{
				//NSLog(@"Offensive Unit");
				OffensiveUnit *oUnit = (OffensiveUnit *)[currentSelectedArray objectAtIndex:i];
				if ((oUnit != NULL && [oUnit isSelected]) && ![oUnit justSelected]) {
					//NSLog(@"Just Moved!");
					SPTouch *touch = [touches objectAtIndex:0];
					SPPoint *currentPos = [touch locationInSpace:self.parent];
					currentPos.x -= sheet1.x;
					currentPos.y -= sheet1.y;
					if((abs([oUnit x] - currentPos.x) >= 75 || abs([oUnit y] - currentPos.y) >= 75) && touch.globalY < 767){
						[oUnit moveTo:currentPos];
					}
				}
			}
			if([[currentSelectedArray objectAtIndex:i] isKindOfClass:[WorkerUnit class]])
			{
				//NSLog(@"Worker Unit");
				WorkerUnit *wUnit = (WorkerUnit *)[currentSelectedArray objectAtIndex:i];
				if ((wUnit != NULL && [wUnit isSelected]) && ![wUnit justSelected]) {
					//NSLog(@"Just Moved!");
					SPTouch *touch = [touches objectAtIndex:0];
					SPPoint *currentPos = [touch locationInSpace:self.parent];
					currentPos.x -= sheet1.x;
					currentPos.y -= sheet1.y;
					if((abs([wUnit x] - currentPos.x) >= 75 || abs([wUnit y] - currentPos.y) >= 75) && touch.globalY < 767){
						[wUnit moveTo:currentPos];
					}
				}
			}
			
			//if barrack was selected
			//set rallypoint
			if([[currentSelectedArray objectAtIndex:i] isKindOfClass:[CommandBuilding class]])
			{
				CommandBuilding *cBuilding = (CommandBuilding *)[currentSelectedArray objectAtIndex:i];
				if ((cBuilding != NULL && [cBuilding isSelected]) && ![cBuilding justSelected]) {
					SPTouch *touch = [touches objectAtIndex:0];
					SPPoint *currentPos = [touch locationInSpace:self.parent];
					currentPos.x -= sheet1.x;
					currentPos.y -= sheet1.y;
					if((abs([cBuilding x] - currentPos.x) >= 75 || abs([cBuilding y] - currentPos.y) >= 75) && touch.globalY < 767){
						[cBuilding setRally:currentPos]; //cBuilding internally checks which to perform
						//[cBuilding moveTo:currentPos];
					}
				}
			}
		}
	}
	else if(touches.count == 1){
		if (twoCount == 1) {
			twoCount = 0;
			justTwoTouch = FALSE;
		}
		twoCount --;		
	}

	
	
	/*
	if (touches.count != 0) { //only care where first finger starts
		touchBeganTime = [event timestamp];
		SPTouch *touch = [touches objectAtIndex:0];
		startPos = [touch locationInSpace:self];
		
		NSLog(@"\n\nStart position (%f, %f)",
			  startPos.x, startPos.y);
		NSLog(@"Start Time (%f)", touchBeganTime);
		NSTimeInterval currTime = [event timestamp];
		NSLog(@"Current time: (%f)",currTime);
	}
	
	//Stationary Phase
	touches = [[event touchesWithTarget:self andPhase:SPTouchPhaseStationary] allObjects];
	if (touches.count == 1) {
		SPTouch *touch = [touches objectAtIndex:0];
		
		SPPoint *currentPos = [touch locationInSpace:self];
		SPPoint *previousPos = [touch previousLocationInSpace:self];
		
		NSLog(@"Current position (%f, %f)",
			  currentPos.x, currentPos.y);
		NSLog(@"Previous position (%f, %f)",
			  previousPos.x, previousPos.y);
		
		NSTimeInterval currTime = [event timestamp];
		if (touchBeganTime != 0 && currTime - touchBeganTime >= 1) {
			NSLog(@"\nHold Event Triggered!");
		}
	}
	
	//Moved Phase
	touches = [[event touchesWithTarget:self andPhase:SPTouchPhaseMoved] allObjects];	
	if (touches.count == 1)
	{
		// one finger touching
		SPTouch *touch = [touches objectAtIndex:0];
		
		SPPoint *currentPos = [touch locationInSpace:self];
		SPPoint *previousPos = [touch previousLocationInSpace:self];
		
		NSLog(@"Current position (%f, %f)",
			  currentPos.x, currentPos.y);
		NSLog(@"Previous position (%f, %f)",
			  previousPos.x, previousPos.y);
		
		float distance = sqrt(pow(currentPos.x - startPos.x, 2) + pow(currentPos.y - startPos.y, 2));
		
		//Hold
		NSTimeInterval currTime = [event timestamp];
		if (touchBeganTime != 0 && currTime - touchBeganTime >= 1) {
			NSLog(@"\nHold Event Triggered!");
		}
		//Drag
		if (distance > 3) { //if moved more than 3 pixels initiate drag
			NSLog(@"\nDrag Event - diff(%f, %f)",
				  currentPos.x - previousPos.x, currentPos.y - previousPos.y);
		}
		//Double Tap
		if (touch.tapCount == 2) {
			NSLog(@"\nDouble Tap Triggered!");
		}
		
	}
	else if (touches.count >= 2)
	{
		// at least two fingers touching
		SPTouch *touch1 = [touches objectAtIndex:0];
		SPTouch *touch2 = [touches objectAtIndex:1];
		
		SPPoint *currentPos = [touch1 locationInSpace:self];
		SPPoint *previousPos = [touch1 previousLocationInSpace:self];
		// ...
		NSLog(@"Current position (%f, %f)",
			  currentPos.x, currentPos.y);
		NSLog(@"Previous position (%f, %f)",
			  previousPos.x, previousPos.y);
		
		SPPoint *currentPos2 = [touch2 locationInSpace:self];
		SPPoint *previousPos2 = [touch2 previousLocationInSpace:self];
		// ...
		NSLog(@"Current position 2 (%f, %f)",
			  currentPos2.x, currentPos2.y);
		NSLog(@"Previous position 2 (%f, %f)",
			  previousPos2.x, previousPos2.y);
		
		//Two Finger Drag
		if (currentPos.x != previousPos.x || currentPos.y != previousPos.y) {
			NSLog(@"Drag Event - diff(%f, %f)",
				  currentPos.x - previousPos.x, currentPos.y - previousPos.y);
		}
		if (currentPos2.x != previousPos2.x || currentPos2.y != previousPos2.y) {
			NSLog(@"Drag Event 2 - diff(%f, %f)",
				  currentPos2.x - previousPos2.x, currentPos2.y - previousPos2.y);
		}
	}
	
	//End Phase
	touches = [[event touchesWithTarget:self
							   andPhase:SPTouchPhaseEnded] allObjects];
	
	if (touches.count != 0) { //only care where first finger starts
		NSTimeInterval touchEndedTime = [event timestamp];
		SPTouch *touch = [touches objectAtIndex:0];
		SPPoint *endPos = [touch locationInSpace:self];
		
		startPos = nil;
		touchBeganTime = 0;
		
		NSLog(@"End position (%f, %f)",
			  endPos.x, endPos.y);
		NSLog(@"End Time (%f)", touchEndedTime);
	}
	 */
}

- (void)trashCanVisible:(bool)vis
{
	trashCan.visible = vis;
}

- (int)getResources{
	return resources;
}

- (void)increaseResources:(int)numResources{
	//NSLog(@"numResources: %d",resources);
	resources = resources + numResources;
}

- (void)spendResources:(int)numResources{
	resources = resources - numResources;
} 

- (void)addSupply{
	++supply;
}

- (void)subSupply{
	--supply;
}

- (bool)isSupplyCapped{
	return (supply >= supplyCap);
}

- (void)raiseSupplyCap:(int)numSupply{
	supplyCap += numSupply;
}

- (void)lowerSupplyCap:(int)numSupply{
	supplyCap -= numSupply;
}

- (int) offensiveCost { return offensiveCost; } 
- (int) workerCost { return workerCost; }
- (int) commandCost { return commandCost; }
- (int) supplyCost { return supplyCost; }

- (NSArray *)getSelected
{
	return currentSelectedArray;
}

- (void)setSelected:(NSMutableArray *)newSelection
{
	while(0 < [pastSelectedArray count]) {
		[[pastSelectedArray objectAtIndex:0] deselect];
		[pastSelectedArray removeObjectAtIndex:0];
	}
	for (int i = 0; i < [currentSelectedArray count]; ++i) {
		[pastSelectedArray addObject:[currentSelectedArray objectAtIndex:i]];
	}
	while(0 < [currentSelectedArray count]) {		
		[[currentSelectedArray objectAtIndex:0] deselect];
		[currentSelectedArray removeObjectAtIndex:0];
	}
	for (int i = 0; i < [newSelection count]; ++i) {
		[currentSelectedArray addObject:[newSelection objectAtIndex:i]];
	}
}

- (void)dealloc
{
    [self removeEventListenersAtObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
	
    [m_Juggler release];
    [super dealloc];
}


@end



