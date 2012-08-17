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
@property (nonatomic,copy) NSString *currentStillFrameKey;
@property (nonatomic,strong) CCSpriteFrame *currentStillFrame;

//Still frame methods
- (void) addStillFrameWithFrameFile:(NSString *) frameFile withKey:(NSString *)key;
- (void) setInitialFrameWithKey:(NSString *)key;
- (void) setStillFrameWithKey:(NSString *)key;
- (void) displayStillFrame;

//Sprite sheet loading
- (void) loadSpriteSheetWithLocalParameters;
- (void) loadSpriteSheetWithImageFile:(NSString *) imageFile PlistFile:(NSString *) plistFile;
- (void) loadSpriteSheetWithFilePrefix:(NSString *) filePrefix;

//Old stuff copied from GameCharacter for reference
@property (nonatomic,strong) NSMutableDictionary *walkActions;
@property (nonatomic,strong) NSMutableArray *walkActionKeys;
@property (nonatomic,strong) id currentWalkAction;
@property (nonatomic,strong) id currentMoveAction;
//- (id) initWithFilePrefix:(NSString*)filePrefix withName:(NSString*)characterName withNumberOfAnimationFrames:(int)numberOfAnimationFrames;
//- (void) walkTo:(CGPoint) destinationPoint withDirection:(NSString*)direction;

@end
