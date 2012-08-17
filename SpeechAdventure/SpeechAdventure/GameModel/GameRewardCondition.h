//
//  GameRewardCondition.h
//  SpeechAdventure
//
//  Created by John Chambers on 8/16/12.
//
//

#import <Foundation/Foundation.h>

#import "GameStage.h"

@interface GameRewardCondition : NSObject

@property (nonatomic,strong) NSMutableDictionary *actorStateDictionary;
@property (nonatomic,strong) GameStage *parentStage;

- (id) initWithStage:(GameStage*)parentStage;
- (void) addRequiredState:(NSString*)state forActorName:(NSString*)actorName;
- (BOOL) isConditionSatisfiedWithStage:(GameStage*)myGameStage;

@end
