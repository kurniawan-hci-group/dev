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

@property (nonatomic,strong) CCSprite *spriteBatchNode;
@property (nonatomic,strong) NSMutableDictionary *walkActions;
@property (nonatomic,strong) NSMutableArray *walkActionKeys;
@property (nonatomic,strong) CCAction *currentWalkAction;
@property (nonatomic,strong) CCAction *currentMoveAction;

- (id) initWithFilePrefix:(NSString*)filePrefix withName:(NSString*)characterName withNumberOfAnimationFrames:(int)numberOfAnimationFrames;

@end
