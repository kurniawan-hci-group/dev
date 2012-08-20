//
//  GameActionCall.m
//  SpeechAdventure
//
//  Created by John Chambers on 8/16/12.
//
//

#import "GameCue.h"

@interface GameCue()

- (id) getCCAction;

@end

@implementation GameCue

@synthesize name = _name;

//The different types: sequence, spawn, single
@synthesize cueCollectionType = _cueCollectionType;

//Maybe have a CollectionType & a separate type indicating whether the target is plural or not?

//Properties for a single
@synthesize actorsDictionary = _actorsDictionary;
@synthesize actorCountsDictionary = _actorCountsDictionary;
@synthesize actorName = _actorName;
@synthesize actorNameExtended = _actorNameExtended;
@synthesize actualActor = _actualActor;
@synthesize actorMultiplicityType = _actorMultiplicityType; //Either single or pluralOneAtATime
@synthesize actionName = _actionName;
@synthesize actualAction = _actualAction;
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
    //Simply run the cue
    
    //The outer if handles single cues and sequences and spawns thereof.
    //The inner if handles plural vs. singular actors
    if ([self.cueCollectionType isEqualToString:@"single"]) {
        //get the target, but only set it if it's state is not already in effect
        self.actorNameExtended = @"";
        if ([self.actorMultiplicityType isEqualToString:@"single"]) {
            if (![self actorStateIsAlreadyInPlaceForActorWithExtendedName:self.actorName]){
                self.actorNameExtended = self.actorName;
            }
        } else if ([self.actorMultiplicityType isEqualToString:@"pluralOneAtATime"]) {
            NSMutableArray *possibleActorExtendedNames = [self getNamesForPluralActorPrefix:self.actorName];
            for (NSString *possibleName in possibleActorExtendedNames) {
                if (![self actorStateIsAlreadyInPlaceForActorWithExtendedName:possibleName]) {
                    self.actorNameExtended = possibleName;
                    break;
                }
            }
        } else {
            NSLog(@"ERROR: Invalid actorMultiplicityType %@ in GameCue-runCue", self.actorMultiplicityType);
        }
        
        if (![self.actorNameExtended isEqualToString:@""]){
            [self setActualActorAndActionWithExtendedActorName:self.actorNameExtended];
            [self.actualActor.actualSprite runAction:[self getCCAction]];
        }
        
        //check its state and only run the cue if there is an actor who has not yet had that state put on it
    } else if ([self.cueCollectionType isEqualToString:@"sequence"]) {
        //Assemble MULTI-ACTOR action sequence
    } else if ([self.cueCollectionType isEqualToString:@"spawn"]) {
        //Assemble MULTI-ACTOR action spawn
    } else {
        NSLog(@"ERROR: Invalid cueCollectionType %@ in GameCue-runCue",self.cueCollectionType);
    }
}

//HAVEN'T YET DECIDED whether to test the STATE in the getCCAction method or elsewhere

- (id) getCCAction {
    //Returns the described action regardless of whether the target actor has already been affected
    //assumes the target actor has been established beforehand and stored in self.actualActor
    id assembledAction;
    
    /*GameActor *targetActor = self.actualActor;
    
    assembledAction = [[targetActor getActionWithName:self.actionName] getCCActionWithDuration:self.duration];*/
    
    NSMutableArray *actionsToAdd = [[NSMutableArray alloc] init];
    
    //get target name
    if (self.actualActor == nil) {
        NSLog(@"ERROR: actualActor not established in GameCue-getCCAction");
    }
    GameActor *targetActor = self.actualActor;
    
    //only add non-nil, non-empty actions
     
    //GameAction
    id myActionCCAction = [[targetActor getActionWithName:self.actionName] getCCActionWithDuration:self.duration];
    if (!(myActionCCAction == nil)) {
        [actionsToAdd addObject:myActionCCAction];
    }
    
    //Actor state change
    id myActorStateChange = [GameCue callBlockSetStateForActor:targetActor withAction:self.actualAction];
    if (!(myActorStateChange == nil)) {
        [actionsToAdd addObject:myActorStateChange];
    }
    
    //move
    id myMoveCCAction = [self.move getCCActionWithDuration:self.duration withStartPoint:targetActor.actualSprite.position];
    if (!(myMoveCCAction == nil)) {
        [actionsToAdd addObject:myMoveCCAction];
    }
    
    //endStillFrame
    if (![self.endStillFrame isEqualToString:@""] && !(self.endStillFrame == nil)) {
        id setStillFrameCCAction = [GameCue callBlockSetStillFrameWithKey:self.endStillFrame forActor:targetActor];
        [actionsToAdd addObject:setStillFrameCCAction];
    }
    
    //assemble the action as a spawn
    assembledAction = [GameCue getActionSpawn:actionsToAdd];
    
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

////////////////////////////////////////////////////////////////////////
// Call Block stuff

+ (id) callBlockActionForSoundFile:(NSString *) mySoundFile {
    return [CCCallBlock actionWithBlock:^{
        [[SimpleAudioEngine sharedEngine] playEffect:mySoundFile];
    }];
}

+ (id) callBlockSetStillFrameWithKey:(NSString*)key forActor:(GameActor*)actor {
    return [CCCallBlock actionWithBlock:^{
        [actor setCurrentStillFrameWithKey:key];
    }];
}

+ (id) callBlockActorAction:(GameAction*)action onActor:(GameActor*)actor forDuration:(double)duration {
    return [CCCallBlock actionWithBlock:^{
        [actor.actualSprite runAction:[action getCCActionWithDuration:duration]];
    }];
}

+ (id) callBlockSetStateForActor:(GameActor*)actor withAction:(GameAction*)action {
    //only return an actual change if the value is non-nil, non-empty
    if (![action.stateEffect isEqualToString:@""] && !(action.stateEffect == nil)){
        return [CCCallBlock actionWithBlock:^{
            actor.state = action.stateEffect;
        }];
    } else {
        return nil;
    }
    
}

//extra method not yet implemented
+ (id) callBlockMultiActorSequenceComponent {
    return nil;
}

////////////////////////////////////////////////////////////////////////
// Generating action sequences and spawns of dynamic length
// (taken from http://www.cocos2d-iphone.org/forum/topic/7414)

+(CCFiniteTimeAction *) getActionSequence: (NSArray *) actions
{
	CCFiniteTimeAction *seq = nil;
	for (CCFiniteTimeAction *anAction in actions)
	{
		if (!seq)
		{
			seq = anAction;
		}
		else
		{
			seq = [CCSequence actionOne:seq two:anAction];
		}
	}
	return seq;
}

+(CCFiniteTimeAction *) getActionSpawn: (NSArray *) actions
{
	CCFiniteTimeAction *result = nil;
	for (CCFiniteTimeAction *anAction in actions)
	{
		if (!result)
		{
			result = anAction;
		}
		else
		{
			result = [CCSpawn actionOne:result two:anAction];
		}
	}
	return result;
}

////////////////////////////////////////////////////////////////////////
// General Convenience Methods

- (void) setActualActorAndActionWithExtendedActorName:(NSString*)extendedActorName {
    self.actorNameExtended = extendedActorName;
    self.actualActor = [self getActorByName:self.actorNameExtended];
    self.actualAction = [self.actualActor getActionWithName:self.actionName];
}

- (BOOL) actorStateIsAlreadyInPlaceForActorWithExtendedName:(NSString*)actorExtendedName {
    GameActor *myActor = [self getActorByName:actorExtendedName];
    GameAction *myAction = [myActor getActionWithName:self.actionName];
    return [myActor.state isEqualToString:myAction.stateEffect];
}

@end
