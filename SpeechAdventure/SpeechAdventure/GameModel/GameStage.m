//
//  GameModel.m
//  SpeechAdventure
//
//  Created by John Chambers on 8/6/12.
//
//

#import "GameStage.h"

@interface GameStage()

@end

@implementation GameStage

@synthesize layersDictionary = _layersDictionary;
@synthesize actorsDictionary = _actorsDictionary;
@synthesize actorCountsDictionary = _actorCountsDictionary;
@synthesize OEModelKeyword = _OEModelKeyword;
@synthesize commandsDictionary = _commandsDictionary;
@synthesize introCueKey = _introCueKey;
@synthesize cuesDictionary = _cuesDictionary;

- (id) init {
    if (self=[super initWithColor:ccc4(255,255,255,255) width:480 height:320])
    {
        //***ALL NSMutableDictionaries must be allocated and initialized before they can actually store anything. This is probably true of all objects, and I just assumed that ObjC was automatically running the intializer method on them anyway since they were properties.
        self.layersDictionary = [[NSMutableDictionary alloc] init];
        self.actorsDictionary = [[NSMutableDictionary alloc] init];
        self.actorCountsDictionary = [[NSMutableDictionary alloc] init];
        self.commandsDictionary = [[NSMutableDictionary alloc] init];
        self.cuesDictionary = [[NSMutableDictionary alloc] init];
    }
    
    //register for OE events
    [[OEManager sharedManager] registerDelegate:self];
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////
//Cue dictionary stuff
- (void) addCue:(GameCue*)newCue withName:(NSString*)cueName {
    [self.cuesDictionary setObject:newCue forKey:cueName];
}

- (void) removeCueWithName:(NSString*)cueName {
    [self.cuesDictionary removeObjectForKey:cueName];
}

- (GameCue*) getCueByName:(NSString*)cueName {
    return [self.cuesDictionary objectForKey:cueName];
}

///////////////////////////////////////////////////////////////////////////////
//Actor dictionary manipulation

- (void) addActor:(GameActor*)newActor withName:(NSString *)actorName {
    //Add the actor itself to the dictionary & its image to the activity layer
    
    [self.actorsDictionary setObject:newActor forKey:actorName];
    
    if ([newActor.imageSourceType isEqualToString:@"singleFrame"]) {
        [((CCLayer*)[self.layersDictionary objectForKey:@"activityLayer"]) addChild:newActor.actualSprite];
    } else if ([newActor.imageSourceType isEqualToString:@"spriteSheet"]) {
        [((CCLayer*)[self.layersDictionary objectForKey:@"activityLayer"]) addChild:newActor.spriteBatchNode];
    }
    
    //set actor count
    [self setActorCount:1 forActorWithName:actorName];
}

- (void) removeActorWithName:(NSString *)actorName {
    //Remove from dictionary and from activity layer
    
    GameActor *actorToRemove = [self getActorByName:actorName];
    if ([actorToRemove.imageSourceType isEqualToString:@"singleFrame"]) {
        [((CCLayer*)[self.layersDictionary objectForKey:@"activityLayer"]) removeChild:actorToRemove.actualSprite cleanup:NO];
    } else if ([actorToRemove.imageSourceType isEqualToString:@"spriteSheet"]) {
        [((CCLayer*)[self.layersDictionary objectForKey:@"activityLayer"]) removeChild:actorToRemove.spriteBatchNode cleanup:NO];
    }
    
    [self.actorsDictionary removeObjectForKey:actorName];
    
}

- (GameActor*) getActorByName:(NSString *) actorName {
    return (GameActor*)[self.actorsDictionary objectForKey:actorName];
}

///////////////////////////////////////////////////////////////////////////////
//Command dictionary stuff

- (void) addCommand:(GameCommand*)newCommand withActivatingText:(NSString *)activatingText {
    [self.commandsDictionary setObject:newCommand forKey:activatingText];
}

- (void) removeCommandWithActivatingText:(NSString *) activatingText {
    [self.commandsDictionary removeObjectForKey:activatingText];
}

- (GameCommand *) getGameCommandWithActivatingText:(NSString *) activatingText {
    return [self.commandsDictionary objectForKey:activatingText];
}

///////////////////////////////////////////////////////////////////////////////
// ActorCount stuff

- (void) setActorCount:(int)count forActorWithName:(NSString*)actorName {
    //ONLY sets the value; does not actually expand actors
    NSNumber *countObject = [[NSNumber alloc] initWithInt:count];
    [self.actorCountsDictionary setObject:countObject forKey:actorName];
}

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
            NSString *indexedActorName = [GameStage indexedActorNameForActorName:actorNamePrefix withIndex:i];
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

///////////////////////////////////////////////////////////////////////////////
// OpenEars processing


- (void)receiveOEEvent:(OEEvent*) speechEvent{
    GameCommand *potentialCommand = [self.commandsDictionary objectForKey:speechEvent.text];
    
    if (potentialCommand != nil) {
        //Tell the command to run itself
        
        //Should also put support system stuff in here
    }
    
    /*//Test to ensure actions are functioning properly -- NOT CODE FOR SHIPPING
    if ([speechEvent.text isEqualToString:@"POP A BALLOON"]) {
        GameActor *actor = [self getActorByName:@"balloon0"];
        GameAction *action = [actor getActionWithName:@"pop"];
        [actor runAction:action];
    }*/
    
}

@end
