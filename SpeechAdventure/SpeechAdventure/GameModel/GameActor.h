//
//  GameActor.h
//  SpeechAdventure
//
//  Created by John Chambers on 8/10/12.
//
//

#import <Foundation/Foundation.h>

#import <GameKit/GameKit.h>
#import "cocos2d.h"

#import "GameAction.h"

@interface GameActor : NSObject<NSCopying>

@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) CGPoint location;
@property (nonatomic,copy) NSString *state;

@property (nonatomic,strong) CCSprite *actualSprite;
@property (nonatomic,strong) NSMutableDictionary *actionsDictionary;

@property (nonatomic,copy) NSString *imageSourceType;

- (id) init;

//(somewhat) Deep copy method for plural actors
- (id) copyWithZone:(NSZone *)zone;

//ActionsDictionary methods
- (GameAction *) getActionWithName:(NSString *)actionName;
- (void) addAction:(GameAction*)newAction withName:(NSString *)actionName;
- (void) removeActionWithName:(NSString *)actionName;

//Running Actions
- (void) runAction:(GameAction *)myAction withDuration:(double)duration;

///////////////////////////////////////////////////////////////////////////////
// SingleFrame Image Source Stuff

@property (nonatomic,copy) NSString *singleImageFileName;

- (void) setActualSpriteWithLocalParameter;
- (void) setActualSpriteWithFile:(NSString*)fileName;

///////////////////////////////////////////////////////////////////////////////
// Sprite Sheet Image Source Stuff

@property (nonatomic,copy) NSString *spriteSheetImageFile;
@property (nonatomic,copy) NSString *spriteSheetPListFile;
@property (nonatomic,strong) CCSpriteBatchNode *spriteBatchNode;

@property (nonatomic,strong) NSMutableDictionary *stillFramesDictionary;
@property (nonatomic,copy) NSString *defaultStillFrameKey;
@property (nonatomic,copy) NSString *currentStillFrameKey;
@property (nonatomic,strong) CCSpriteFrame *currentStillFrame;

//Still frame methods
- (void) addStillFrameWithFrameFile:(NSString *) frameFile withKey:(NSString *)key;
- (void) setCurrentStillFrameWithKey:(NSString *)key;
- (void) displayStillFrame;

//Sprite sheet loading
- (void) loadSpriteSheetWithLocalParameters;
- (void) loadSpriteSheetWithImageFile:(NSString *) imageFile PlistFile:(NSString *) plistFile;
- (void) loadSpriteSheetWithFilePrefix:(NSString *) filePrefix;

@end
