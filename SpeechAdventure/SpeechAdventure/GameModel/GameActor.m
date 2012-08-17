//
//  GameActor.m
//  SpeechAdventure
//
//  Created by John Chambers on 8/10/12.
//
//

#import "GameActor.h"

@implementation GameActor

@synthesize name = _name;
@synthesize location = _location;
@synthesize state = _state;

@synthesize actualSprite = _actualSprite;
@synthesize actionsDictionary = _actionsDictionary;

@synthesize imageSourceType = _imageSourceType;

///////////////////////////////////////////////////////////////////////////////
// SpriteSheet ImageSource Property Members
@synthesize singleImageFileName = _singleImageFileName;

///////////////////////////////////////////////////////////////////////////////
// SpriteSheet ImageSource Property Members

@synthesize spriteSheetImageFile = _spriteSheetImageFile;
@synthesize spriteSheetPListFile = _spriteSheetPListFile;
@synthesize spriteBatchNode = _spriteBatchNode;

@synthesize stillFramesDictionary = _stillFramesDictionary;
@synthesize defaultStillFrameKey = _defaultStillFrameKey;
@synthesize currentStillFrameKey = _currentStillFrameKey;
@synthesize currentStillFrame = _currentStillFrame;

///////////////////////////////////////////////////////////////////////////////
// Initializers


- (id)init {
    //General intializer for both types
    if (self=[super init]) {
        self.actionsDictionary = [[NSMutableDictionary alloc] init];
        self.stillFramesDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) setCurrentStillFrame:(CCSpriteFrame *)currentStillFrame {
    //Special intializer for SpriteSheet types
    //Sets actual sprite on first call
    
    if (_currentStillFrame == nil){
        _currentStillFrame = currentStillFrame;
        //the below line is most likely the problem
        //self.actualSprite = [CCSprite spriteWithSpriteFrame:currentStillFrame];
        //[self.spriteBatchNode addChild:self.actualSprite];
    } else {
        _currentStillFrame = currentStillFrame;
        [self.actualSprite setDisplayFrame:_currentStillFrame];
    }
}

///////////////////////////////////////////////////////////////////////////////
// SingleFrame ImageSource Methods

#pragma mark -
#pragma mark Single frame setup
- (void) setActualSpriteWithLocalParameter {
    [self setActualSpriteWithFile:self.singleImageFileName];
}

- (void) setActualSpriteWithFile:(NSString*)fileName {
    self.actualSprite = [CCSprite spriteWithFile:fileName];
}

/////////////////////////////////////////////////////////////////////////
// SpriteSheet ImageSource Methods

#pragma mark -
#pragma mark Sprite Sheet Processing
- (void) loadSpriteSheetWithLocalParameters {
    [self loadSpriteSheetWithImageFile:self.spriteSheetImageFile PlistFile:self.spriteSheetPListFile];
}

- (void) loadSpriteSheetWithImageFile:(NSString *) imageFile PlistFile:(NSString *) plistFile {
    //cache the plist
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:plistFile];
    
    //create sprite batch
    self.spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:imageFile];
}

- (void) loadSpriteSheetWithFilePrefix:(NSString *) filePrefix {
    [self loadSpriteSheetWithImageFile:[NSString stringWithFormat:@"%@.plist",filePrefix] PlistFile:[NSString stringWithFormat:@"%@.png",filePrefix]];
}

#pragma mark -
#pragma mark Still frame methods
- (void) addStillFrameWithFrameFile:(NSString *) frameFile withKey:(NSString *)key{
    //Must add a still before you can use it
    CCSpriteFrame *newStill = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameFile];
    //Possible error line
    //CCSprite *newStill = [CCSprite spriteWithSpriteFrameName:frameFile];
    [self.stillFramesDictionary setObject:newStill forKey:key];
}

- (void) setCurrentStillFrameWithKey:(NSString *)key {
    //Only set the new still frame if the key has an associated value
    CCSpriteFrame *frameToSet = [self.stillFramesDictionary objectForKey:key];
    if (!(frameToSet == nil)) {
        self.currentStillFrameKey = key;
        self.currentStillFrame = frameToSet;
        [self displayStillFrame];
    }
}

- (void) displayStillFrame {
    //Use this to post a still frame that is already set
    //Often helpful after running an animation)
    [self.actualSprite setDisplayFrame:self.currentStillFrame];
}

#pragma mark -
#pragma mark Old Methods (Reference)
@synthesize walkActions = _walkActions;
@synthesize walkActionKeys = _walkActionKeys;
@synthesize currentWalkAction = _currentWalkAction;
@synthesize currentMoveAction = _currentMoveAction;

- (id) initWithFilePrefix:(NSString*)filePrefix withName:(NSString*)characterName withNumberOfAnimationFrames:(int)numberOfAnimationFrames{
    //This method loads the sprites for the character and sets up associated actions & animations. In order for it to work, the name of your PLIST & sprite sheet PNG must be the same with different extentions--called the "file prefix". The number of animation frames dictates how many frames will be loaded for each animation (e.g. there could be 5 frames in the "walk stage right" series).
    if (self=[super init]) {
        
        self.name = characterName;
        
        //Configuration
        double frameDelay = 0.5f;
        
        //cache the plist
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",filePrefix]];
        
        //create sprite batch
        self.spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.png",filePrefix]];
        
        //SETUP STILL FRAMES
        self.actualSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@Normal.png",characterName]];
        [self.spriteBatchNode addChild:self.actualSprite];
        
        //SETUP VARIOUS ACTIONS
        //Walk
        self.walkActionKeys = [NSArray arrayWithObjects:
                               @"Left",
                               @"Right",
                               @"Up",
                               @"Down",
                               nil];
        self.walkActions = [[NSMutableDictionary alloc] initWithCapacity:[self.walkActionKeys count]];
        for (NSString *key in self.walkActionKeys) {
            NSMutableArray *walkFrames = [NSMutableArray arrayWithCapacity:numberOfAnimationFrames];
            for(int i = 1; i<=numberOfAnimationFrames; i++){
                [walkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@Walk%@%d.png",characterName,key,i]]];
            }
            CCAnimation *walkAnimation = [CCAnimation animationWithSpriteFrames:walkFrames delay:frameDelay];
            walkAnimation.restoreOriginalFrame = YES;
            id walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnimation]];
            [self.walkActions setObject:walkAction forKey:key];
        }
    }
    
    return self;
}

- (void) walkTo:(CGPoint) destinationPoint withDirection:(NSString*)direction{
    /*//Diagnostic code for inter-object point conversion
     NSLog(@"WalkTo\nOriginal Point\nx:%f y:%f\n", destinationPoint.x, destinationPoint.y);
     CGPoint convertedPoint = [self.spriteBatchNode convertToNodeSpace:destinationPoint];
     NSLog(@"New Point\nx:%f y:%f", convertedPoint.x, convertedPoint.y);*/
    
    self.currentMoveAction = [CCMoveTo actionWithDuration:3 position:[self.spriteBatchNode convertToNodeSpace:destinationPoint]];
    id endMoveCall = [CCCallFuncN actionWithTarget:self selector:@selector(moveDone)];
    id moveSequence = [CCSequence actions:self.currentMoveAction, endMoveCall, nil];
    
    self.currentWalkAction = (id)[self.walkActions objectForKey:direction];
    
    
    //start moving before animating
    [self.actualSprite runAction:moveSequence];
    [self.actualSprite runAction:self.currentWalkAction];
}

- (void) moveDone {
    [self.actualSprite stopAction:self.currentWalkAction];
    CCSpriteFrame *stillFrameToRestore = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@Normal.png",self.name]];
    [self.actualSprite setDisplayFrame:stillFrameToRestore];
}

#pragma mark -
#pragma mark Plural Actor Expansion

//(somewhat) Deep copy method for plural actors
- (id) copyWithZone:(NSZone *)zone {
    GameActor *actorCopy = [super copy];
    actorCopy.name = [self.name copy];
    actorCopy.location = CGPointMake(self.location.x, self.location.y);
    actorCopy.state = [self.state copy];
    actorCopy.actionsDictionary = self.actionsDictionary;
    actorCopy.imageSourceType = [self.imageSourceType copy];
    
    if ([self.imageSourceType isEqualToString:@"singleFrame"]) {
        actorCopy.singleImageFileName = [self.singleImageFileName copy];
        [actorCopy setActualSpriteWithLocalParameter];
    } else if ([self.imageSourceType isEqualToString:@"spriteSheet"]){
        
        actorCopy.spriteSheetImageFile = [self.spriteSheetImageFile copy];
        actorCopy.spriteSheetPListFile = [self.spriteSheetPListFile copy];
        [actorCopy loadSpriteSheetWithLocalParameters]; //sets spriteBatchNode new w/o relying on copy
        
        actorCopy.stillFramesDictionary = self.stillFramesDictionary;

    } else {
        NSLog(@"ERROR WHILE DEEP COPYING ACTORS: Image source type invalid");
    }
    
    return actorCopy;
}

@end
