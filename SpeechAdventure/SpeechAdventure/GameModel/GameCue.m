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
@synthesize cueCollectionType = _cueCollectionType;

//Maybe have a CollectionType & a separate type indicating whether the target is plural or not?

//Properties for a single
@synthesize targetActor = _targetActor;
@synthesize actorMultiplicityType = _actorMultiplicityType; //Either single, pluralAllAtOnce, or pluralOneAtATime
@synthesize actionToPerform = _actionToPerform;
@synthesize endStillFrame = _endStillFrame;

@synthesize duration = _duration;
@synthesize soundFile = _soundFile;

@synthesize move = _move;


//Property(s) for sequence & spawn
@synthesize containedCues = _containedCues;

- (id)init {
    if (self=[super init]) {
        self.containedCues = [[NSMutableArray alloc] init];
    }
    return  self;
}

//recursive method to build CCAction from cue
- (id) getCCAction {
    
}

@end