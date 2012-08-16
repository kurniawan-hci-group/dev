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

@interface GameActor : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) CGPoint location;

@property (nonatomic,strong) CCSprite *actualSprite;
@property (nonatomic,strong) NSMutableDictionary *actionsDictionary;

@property (nonatomic,copy) NSString *imageSourceType;

///////////////////////////////////////////////////////////////////////////////
// SingleFrame Image Source Stuff

- (void) setActualSpriteWithFile:(NSString*)fileName;

///////////////////////////////////////////////////////////////////////////////
// Sprite Sheet Image Source Stuff

@property (nonatomic,strong) CCSpriteBatchNode *spriteBatchNode;
@property (nonatomic,strong) NSMutableDictionary *stillFramesDictionary;
@property (nonatomic,strong) CCSpriteFrame *currentStillFrame;
@property (nonatomic,assign) double frameDelay;

@property (nonatomic,strong) NSMutableDictionary *walkActions;
@property (nonatomic,strong) NSMutableArray *walkActionKeys;
@property (nonatomic,strong) id currentWalkAction;
@property (nonatomic,strong) id currentMoveAction;

//Still frame methods
- (void) setStillFrameWithKey:(NSString *)key;
- (void) displayStillFrame;

//Sprite sheet loading
- (void) loadSpriteSheetWithImageFile:(NSString *) imageFile PlistFile:(NSString *) plistFile;
- (void) loadSpriteSheetWithFilePrefix:(NSString *) filePrefix;

//Old methods
- (id) initWithFilePrefix:(NSString*)filePrefix withName:(NSString*)characterName withNumberOfAnimationFrames:(int)numberOfAnimationFrames;
- (void) walkTo:(CGPoint) destinationPoint withDirection:(NSString*)direction;

@end
