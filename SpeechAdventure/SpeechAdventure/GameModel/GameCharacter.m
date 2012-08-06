//
//  GameCharacter.m
//  SpeechAdventure
//
//  Created by John Chambers on 8/2/12.
//
//

#import "GameCharacter.h"

@implementation GameCharacter

@synthesize spriteBatchNode = _spriteBatchNode;
@synthesize walkActions = _walkActions;
@synthesize walkActionKeys = _walkActionKeys;
@synthesize currentWalkAction = _currentWalkAction;
@synthesize currentMoveAction = _currentMoveAction;

- (id) initWithFilePrefix:(NSString*)filePrefix withName:(NSString*)characterName withNumberOfAnimationFrames:(int)numberOfAnimationFrames{
    //This method loads the sprites for the character and sets up associated actions & animations. In order for it to work, the name of your PLIST & sprite sheet PNG must be the same with different extentions--called the "file prefix". The number of animation frames dictates how many frames will be loaded for each animation (e.g. there could be 5 frames in the "walk stage right" series).
    if (self=[super init]) {
        
        //Configuration
        double frameDelay = 0.5f;
        
        //cache the plist
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",filePrefix]];
        
        //create sprite batch
        self.spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.png",filePrefix]];
        
        //SETUP VARIOUS ACTIONS
        //Walk
        self.walkActionKeys = [NSArray arrayWithObjects:
                               @"SL", //Stage left
                               @"SR", //Stage right
                               @"DS", //Down stage
                               @"US", //Up Stage
                               nil];
        self.walkActions = [[NSMutableDictionary alloc] initWithCapacity:[self.walkActionKeys count]];
        for (NSString *key in self.walkActionKeys) {
            NSMutableArray *walkFrames = [NSMutableArray arrayWithCapacity:numberOfAnimationFrames];
            for(int i = 1; i<=numberOfAnimationFrames; i++){
                [walkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@Walk%@%d.png",characterName,key,i]]];
            }
            CCAnimation *walkAnim = [CCAnimation animationWithSpriteFrames:walkFrames delay:frameDelay];
            CCAction *walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim]];
            [self.walkActions setObject:walkAction forKey:key];
        }
    }
    
    return self;
}

- (void) walkTo:(CGPoint) destinationPoint withDirection:(NSString*)direction{
    self.currentMoveAction = [CCMoveTo actionWithDuration:3 position:destinationPoint];
    id endMoveCall = [CCCallFuncN actionWithTarget:self selector:@selector(moveDone)];
    id moveSequence = [CCSequence actions:endMoveCall, nil];
    
    self.currentWalkAction = (CCAction*)[self.walkActions objectForKey:direction];
    
    
    //start moving before animating
    [self.spriteBatchNode runAction:moveSequence];
    [self.spriteBatchNode runAction:self.currentWalkAction];
}

- (void) moveDone {
    [self.spriteBatchNode stopAction:self.currentWalkAction];
}

@end
