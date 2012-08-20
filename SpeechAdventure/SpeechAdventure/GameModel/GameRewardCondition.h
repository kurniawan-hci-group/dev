//
//  GameRewardCondition.h
//  SpeechAdventure
//
//  Created by John Chambers on 8/16/12.
//
//

#import <Foundation/Foundation.h>

#import "GameRewardConditionItem.h"

@interface GameRewardCondition : NSObject

@property (nonatomic,strong) NSMutableArray *conditionItemsArray;
@property (nonatomic,copy) NSString *rewardCue;

//Considering modifying this to better support plural state requirements

- (id) init;
- (void) addRequiredState:(NSString*)state forActorName:(NSString*)actorName actorIsPlural:(BOOL) actorIsPlural;

@end
