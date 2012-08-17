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
