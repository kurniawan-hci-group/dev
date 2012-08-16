//
//  GameActorWithSheet.h
//  SpeechAdventure
//
//  Created by John Chambers on 8/15/12.
//
//

#import <Foundation/Foundation.h>

#import "GameActor.h"

@interface GameActorWithSheet : GameActor

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
