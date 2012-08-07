//
//  GameCharacter.h
//  SpeechAdventure
//
//  Created by John Chambers on 8/2/12.
//
//

#import <Foundation/Foundation.h>

#import <GameKit/GameKit.h>
#import "cocos2d.h"

@interface GameCharacter : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) CCSpriteBatchNode *spriteBatchNode;
@property (nonatomic,strong) CCSprite *actualSprite;
@property (nonatomic,strong) NSMutableDictionary *walkActions;
@property (nonatomic,strong) NSMutableArray *walkActionKeys;
@property (nonatomic,strong) id currentWalkAction;
@property (nonatomic,strong) id currentMoveAction;

- (id) initWithFilePrefix:(NSString*)filePrefix withName:(NSString*)characterName withNumberOfAnimationFrames:(int)numberOfAnimationFrames;
- (void) walkTo:(CGPoint) destinationPoint withDirection:(NSString*)direction;

@end
