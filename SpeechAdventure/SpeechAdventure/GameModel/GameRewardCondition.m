//
//  GameRewardCondition.m
//  SpeechAdventure
//
//  Created by John Chambers on 8/16/12.
//
//

#import "GameRewardCondition.h"

@interface GameRewardCondition()

//Methods copied from GameStage for plural actors; maybe should move these to GameActor
- (NSMutableArray*) getNamesForPluralActorPrefix:(NSString*)actorNamePrefix;
- (NSMutableArray*) getObjectsForPluralActorPrefix:(NSString*)actorNamePrefix;
- (GameActor*) getActorByName:(NSString *) actorName;


@end

@implementation GameRewardCondition

@synthesize conditionItemsArray = _conditionItemsArray;

- (id) init {
    if (self=[super init]) {
        self.conditionItemsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addRequiredState:(NSString*)state forActorName:(NSString*)actorName actorIsPlural:(BOOL)actorIsPlural {
    GameRewardConditionItem *newItem = [[GameRewardConditionItem alloc] init];
    newItem.requiredState = state;
    newItem.actorName = actorName;
    newItem.actorIsPlural = actorIsPlural;
    
    [self.conditionItemsArray addObject:newItem];
}

@end
