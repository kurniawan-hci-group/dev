//
//  IntroLayer.m
//  SpeechAdventure
//
//  Created by John Chambers on 7/21/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "HelloWorldLayer.h"
#import "PopABalloon.h"


#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// 
-(void) onEnter
{
	[super onEnter];

	// ask director for the window size
	CGSize size = [[CCDirector sharedDirector] winSize];

	CCSprite *background;
	
	if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
		background = [CCSprite spriteWithFile:@"Default.png"];
		background.rotation = 90;
	} else {
		background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
	}
	background.position = ccp(size.width/2, size.height/2);

	// add the label as a child to this Layer
	[self addChild: background];
	
	// In one second transition to the new scene
	//[self scheduleOnce:@selector(makeTransition:) delay:1];
    //CGSize winSize = [[CCDirector sharedDirector] winSize];
    //NSLog(@"Width %g Height %g", winSize.width, winSize.height);
    [[OEManager sharedManager] registerDelegate:self];
}

-(void) makeTransition:(ccTime)dt
{
    [[OEManager sharedManager] removeDelegate:self];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[PopABalloon scene] withColor:ccWHITE]];
}

- (void)receiveOEEvent:(OEEvent*) speechEvent{
    NSLog(@"IntroLayer received speechEvent.\ntext:%@\nscore:%@",speechEvent.text,speechEvent.recognitionScore);
}

@end
