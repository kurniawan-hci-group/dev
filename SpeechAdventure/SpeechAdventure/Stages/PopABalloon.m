//
//  PopABalloon.m
//  SpeechAdventure
//
//  Created by John Chambers on 7/27/12.
//
//

#import "PopABalloon.h"

@interface PopABalloon()

//References to the sprites we'll be manipulating
@property (nonatomic, strong) CCSprite *sam;
@property (nonatomic, strong) NSMutableArray *balloons;

@end

@implementation PopABalloon

@synthesize sam = _sam;
@synthesize balloons = _balloons;

#pragma mark -
#pragma mark Initializer & memory management

- (id) init {
    if (self=[super init])
    {
        //ADD SPRITES TO THE PROPER LAYERS
        
        //BASE LAYER
        CCSprite *base = [CCSprite spriteWithFile:@"S1BaseStage.png"];
        base.anchorPoint = ccp(0,0);
        base.position = ccp(0,0);
        [self.baseStageLayer addChild:base];
        
        //ACTIVITY LAYER
        //sam
        self.sam = [CCSprite spriteWithFile:@"SamNormal.png"];
        //put sam slightly offscreen bottom-left
        int x = 0 - (self.sam.contentSize.width/2);
        int y = 0 - (self.sam.contentSize.height/2);
        self.sam.position = ccp(x,y);
        [self.activityLayer addChild:self.sam];
        
        //balloons
        for (int i = 0; i<3; i++) {
            CCSprite *newBalloon = [CCSprite spriteWithFile:@"Balloon2.png"];
            [self.balloons addObject:newBalloon];
        }
        ((CCSprite *)[self.balloons objectAtIndex:0]).position = ccp(240,170);
        ((CCSprite *)[self.balloons objectAtIndex:1]).position = ccp(265,150);
        ((CCSprite *)[self.balloons objectAtIndex:2]).position = ccp(290,180);
        
        for (CCSprite* myBalloon in self.balloons) {
            [self.activityLayer addChild:myBalloon];
        };
        
        //FOREGROUND LAYER
        CCSprite *fore = [CCSprite spriteWithFile:@"S1Foreground.png" rect:CGRectMake(0,0,480,320)];
        fore.anchorPoint = ccp(0,0);
        fore.position = ccp(0,0);
        [self.foregroundLayer addChild:fore];
        
        //SETUP SOUND
        [[OEManager sharedManager] pauseListening]; //don't want events right now
        [[OEManager sharedManager] registerDelegate:self];
        
        //BEGIN ACTIONS
        [self intro];
    }
    return self;
}

//Initializer methods

- (NSMutableArray *)balloons {
    if (_balloons == nil)
    {
        _balloons = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return _balloons;
}

#pragma mark -
#pragma mark Acts within the stage

- (void)intro{
    //create Sam's move
    id moveSamBeforeBridge = [CCMoveTo actionWithDuration:3 position:ccp(202,115)];
    id samBeforeBridgeDone = [CCCallFuncN actionWithTarget:self selector:@selector(prompt)];
    id beforeBridgeSeq = [CCSequence actions:moveSamBeforeBridge, samBeforeBridgeDone, nil];
    [self.sam runAction:beforeBridgeSeq];
}

- (void)prompt{
    [[SimpleAudioEngine sharedEngine] playEffect:@"S1Prompt.wav"];
    //WOULD LIKE INPUT TO BE ENABLED AFTER WAV IS DONE PLAYING
    [[OEManager sharedManager] resumeListening];
}

- (void)performAction{
    //remove a balloon & play a sound
    if (self.balloons.count > 0)
    {
        [((CCSprite*)[self.balloons lastObject]) runAction:[CCHide action]];
         [[SimpleAudioEngine sharedEngine] playEffect:@"PoppingBalloon1.wav"];
        [self.balloons removeLastObject];
    }
    
    //trigger exit if done
    if (self.balloons.count == 0) {
        [[OEManager sharedManager] pauseListening];
        [self rewardAndExit];
    }
}

- (void)rewardAndExit{
    [[OEManager sharedManager] pauseListening];
    int x = 480 + (self.sam.contentSize.width/2);
    int y = 320 + (self.sam.contentSize.height/2);
    id moveSamOffStage = [CCMoveTo actionWithDuration:4 position:ccp(x,y)];
    [self.sam runAction:moveSamOffStage];
    [[SimpleAudioEngine sharedEngine] playEffect:@"S1Reward.wav"];
}

#pragma mark -
#pragma mark Voice input handling

- (void)receiveOEEvent:(OEEvent*) speechEvent{
    NSLog(@"PopABalloon received speechEvent.\ntext:%@\nscore:%@",speechEvent.text,speechEvent.recognitionScore);
    if ([speechEvent.text isEqualToString:@"LEFT"]) {
        [self performAction];
    }

}

#pragma mark -
#pragma mark Cocos2D Methods
// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	// 'layer' is an autorelease object.
	PopABalloon *layer = [PopABalloon node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
    // return the scene
	return scene;
}

@end
