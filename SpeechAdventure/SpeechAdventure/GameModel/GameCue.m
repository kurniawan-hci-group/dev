//
//  GameActionCall.m
//  SpeechAdventure
//
//  Created by John Chambers on 8/16/12.
//
//

#import "GameCue.h"

@implementation GameCue

@synthesize name = _name;

//The different types: sequence, spawn, single
@synthesize cueCollectionType = _cueCollectionType;

//Maybe have a CollectionType & a separate type indicating whether the target is plural or not?

//Properties for a single
@synthesize actorsDictionary = _actorsDictionary;
@synthesize actorCountsDictionary = _actorCountsDictionary;
@synthesize actorName = _actorName;
@synthesize actorMultiplicityType = _actorMultiplicityType; //Either single or pluralOneAtATime
@synthesize actionName = _actionName;
@synthesize action = _action;
@synthesize endStillFrame = _endStillFrame;

@synthesize duration = _duration;
@synthesize soundFile = _soundFile;

@synthesize move = _move;


//Property(s) for sequence & spawn
@synthesize containedCues = _containedCues;

- (id) init {
    if (self=[super init]) {
        self.containedCues = [[NSMutableArray alloc] init];
    }
    return  self;
}

- (void) runCue {
    
}

- (id) getCCAction {
    id assembledAction;
    
    if ([self.cueCollectionType isEqualToString:@"single"]) {
        if ([self.actorMultiplicityType isEqualToString:@"single"]) {
            
        }
    }
    
    return assembledAction;
}

///////////////////////////////////////////////////////////////////////////////
//Actor dictionary manipulation

- (GameActor*) getActorByName:(NSString *) actorName {
    return (GameActor*)[self.actorsDictionary objectForKey:actorName];
}

///////////////////////////////////////////////////////////////////////////////
// ActorCount stuff

- (int) getActorCountForActorWithName:(NSString*)actorName {
    return ((NSNumber*)[self.actorCountsDictionary objectForKey:actorName]).intValue;
}

+ (NSString *) indexedActorNameForActorName:(NSString*)actorName withIndex:(int)index {
    return [NSString stringWithFormat:@"%@%d", actorName, index];
}

- (NSMutableArray*) getNamesForPluralActorPrefix:(NSString*)actorNamePrefix {
    int count = [self getActorCountForActorWithName:actorNamePrefix];
    if (count == 1) {
        //This function only works with PLURAL actors
        return nil;
    } else {
        NSMutableArray *actorNames = [[NSMutableArray alloc] init];
        for (int i = 0; i < count; i++) {
            NSString *indexedActorName = [GameCue indexedActorNameForActorName:actorNamePrefix withIndex:i];
            [actorNames addObject:indexedActorName];
        }
        return actorNames;
    }
}

- (NSMutableArray*) getObjectsForPluralActorPrefix:(NSString*)actorNamePrefix {
    NSMutableArray *actorNames = [self getNamesForPluralActorPrefix:actorNamePrefix];
    if (actorNames == nil) {
        //This function only works with PLURAL actors
        return nil;
    } else {
        NSMutableArray *actorObjects = [[NSMutableArray alloc] init];
        for (NSString *indexedActorName in actorNames) {
            GameActor *actorToAdd = [self getActorByName:indexedActorName];
            [actorObjects addObject:actorToAdd];
        }
        return actorObjects;
    }
}

@end
