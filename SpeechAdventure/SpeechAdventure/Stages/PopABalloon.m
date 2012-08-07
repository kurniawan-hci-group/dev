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
@property (nonatomic, strong) GameCharacter *samCharacter;
@property (nonatomic, strong) NSMutableArray *balloons;

@end

@implementation PopABalloon

@synthesize sam = _sam;
@synthesize samCharacter = _samCharacter;
@synthesize balloons = _balloons;

#pragma mark -
#pragma mark Initializer & memory management

- (id) init {
    if (self=[super init])
    {
        //SETUP CHARACTER(S)
        self.samCharacter = [[GameCharacter alloc] initWithFilePrefix:@"SamSheet_default" withName:@"Sam" withNumberOfAnimationFrames:2];
        
        //******************ADD SPRITES TO THE PROPER LAYERS******************
        
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
        int y = (self.sam.contentSize.height/2);
        self.sam.position = ccp(x,y);
        [self.activityLayer addChild:self.sam];
        
        //sam2
        self.samCharacter.spriteBatchNode.position = ccp(100,250);
        [self.activityLayer addChild:self.samCharacter.spriteBatchNode];
        
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
        
        //SETUP RECOGNITION
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

/* It is helpful to divide each stage into 4 discrete sections of events or "acts":
    Intro -- Moves the player into position
    Prompt -- Describe the problem to the player and enlist his/her help; start listening
    PerformAction -- Perform an action in response to voice input
    RewardAndExit -- After the task has been completed, play exit narration & move player offscreen
 */

- (void)intro{
    //animate sam2
    [self.samCharacter walkTo:ccp(300,250) withDirection:@"SL"];
    
    //create Sam's move
    ccBezierConfig beforeBridgeBezier;
    beforeBridgeBezier.controlPoint_1 = ccp(77,30);
    beforeBridgeBezier.controlPoint_2 = ccp(146,78);
    beforeBridgeBezier.endPosition = ccp(202,115);
    id moveSamBeforeBridge = [CCBezierTo actionWithDuration:3 bezier:beforeBridgeBezier];
    id samBeforeBridgeDone = [CCCallFuncN actionWithTarget:self selector:@selector(prompt)];
    //alternate action for testing
    //id samBeforeBridgeDone = [CCCallFuncN actionWithTarget:self selector:@selector(rewardAndExit)];
    
    id beforeBridgeSequence = [CCSequence actions:moveSamBeforeBridge, samBeforeBridgeDone, nil];
    [self.sam runAction:beforeBridgeSequence];
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

- (void)performAction2{
    id secondaryAction = [CCRotateBy actionWithDuration:2 angle:360];
    [self.sam runAction:secondaryAction];
}

- (void)rewardAndExit{
    [[OEManager sharedManager] pauseListening];
    
    //offscreen destination point
    //int x = 480 + (self.sam.contentSize.width/2);
    //int y = 320 + (self.sam.contentSize.height/2);
    
    //actions list
    ccBezierConfig bridgeBezier;
    bridgeBezier.controlPoint_1 = ccp(227,161);
    bridgeBezier.controlPoint_2 = ccp(280,214);
    bridgeBezier.endPosition = ccp(327,244);
    id samCrossBridge = [CCBezierTo actionWithDuration:3 bezier:bridgeBezier];
    id samFarRoad = [CCMoveTo actionWithDuration:3 position:ccp(527,370)];
    id exitAction = [CCSequence actions:samCrossBridge, samFarRoad, nil];
    [self.sam runAction:exitAction];
    [[SimpleAudioEngine sharedEngine] playEffect:@"S1Reward.wav"];
}

#pragma mark -
#pragma mark Voice input handling

/* There are a couple of considerations in this area:
    1) equal vs. contains
        There is a possibility that the listener will pick up more in a recording than just the correct command. If the correct command was said, but the listener picked up other noise, the command would be ignored if we used strict equality. If, instead, we check that the oration simply CONTAINS the correct command, such noise wouldn't be problem.
 
    2) how to handle the accuracy rating
        PocketSphinx's accuracy ratings for each oration are somewhat unpredictable. In fact, so are the text transcriptions it produces when the oration is not in its dictionary. Though there's little we can do for the latter problem, we can try to address the former with pragmatic testing. So far, I've found that even when I produce a correct oration, my ratings range from -250 to 0. To be fair, I'm still unsure exactly how to interpret these values. Closer to 0 means closer to correct, but I don't know how "correct" -250 is. I've seen values as far out as -20,000, so -250 may be a normal threshold for correct.
        
        In short, we just need to find the threshold values that mean 'correct' or 'not correct at all'.
 
        To evaluate the correctness of orations with respect to known mispronounciations, we could get the 'n best' array from OpenEars that gives you the n most probable reponses along with their accuracy ratings. We could then compare the accuracy ratings of mispronounciations & correct pronounciations to determine the oration's placement along a continuum with the correct on one end & and the incorrect ones on the other. Any probable responses with accuracy ratings below the 'not correct at all' threshold should be filtered before performing this process.
 */
- (void)receiveOEEvent:(OEEvent*) speechEvent{
    NSLog(@"PopABalloon received speechEvent.\ntext:%@\nscore:%@",speechEvent.text,speechEvent.recognitionScore);
    
    //if ([speechEvent.text isEqualToString:@"LEFT"]) {
    if ([speechEvent.text rangeOfString:@"LEFT"].location != NSNotFound) {
        [self performAction];
    } else if ([speechEvent.text rangeOfString:@"RIGHT"].location != NSNotFound) {
        [self performAction2];
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
