//
//  GameRewardCondition.m
//  SpeechAdventure
//
//  Created by John Chambers on 8/16/12.
//
//

#import "GameRewardCondition.h"

@implementation GameRewardCondition

@synthesize actorStateDictionary = _actorStateDictionary;
@synthesize parentStage = _parentStage;

- (id) init {
    if (self=[super init]) {
        self.actorStateDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id) initWithStage:(GameStage*) parentStage {
    if (self=[self init]) {
        self.parentStage = parentStage;
    }
    return self;
}

- (void) addRequiredState:(NSString*)state forActorName:(NSString*)actorName {
    [self.actorStateDictionary setObject:state forKey:actorName];
}

- (BOOL) isConditionSatisfiedWithStage:(GameStage*)myGameStage {
    //For now, this only checks whether the required actor states match the current ones
    for (NSString *actorName in self.actorStateDictionary) {
        NSString *currentActorState = [myGameStage getActorByName:actorName].state;
        NSString *requiredState = [self.actorStateDictionary objectForKey:actorName];
        
        if (![requiredState isEqualToString:currentActorState]) {
            return NO;
        }
    }
    
    return YES;
}

@end
