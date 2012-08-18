//
//  GameActionCall.m
//  SpeechAdventure
//
//  Created by John Chambers on 8/16/12.
//
//

#import "GameCue.h"

@implementation GameCue

//The different types: sequence, spawn, single
@synthesize actionCollectionType = _actionCollectionType;

//Maybe have a CollectionType & a separate type indicating whether the target is plural or not?

//Properties for a single
@synthesize targetActor = _targetActor;
@synthesize actorMultiplicityType = _actionMultiplicityType; //Either single, pluralAllAtOnce, or pluralOneAtATime
@synthesize actionToPerform = _actionToPerform;

//Property(s) for sequence & spawn
@synthesize containedActions = _containedActions;

- (id)init {
    if (self=[super init]) {
        self.containedActions = [[NSMutableArray alloc] init];
    }
    return  self;
}

//recursive method to build CCAction from
- (id) getCCAction {
    
}

@end
