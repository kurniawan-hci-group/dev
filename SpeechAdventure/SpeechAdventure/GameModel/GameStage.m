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
@synthesize narrationDictionary = _narrationDictionary;
@synthesize OEModelKeyword = _OEModelKeyword;

- (id) init {
    if (self=[super initWithColor:ccc4(255,255,255,255) width:480 height:320])
    {
        //***ALL NSMutableDictionaries must be allocated and initialized before they can actually store anything. This is probably true of all objects, and I just assumed that ObjC was automatically running the intializer method on them anyway since they were properties.
        self.layersDictionary = [[NSMutableDictionary alloc] init];
        self.actorsDictionary = [[NSMutableDictionary alloc] init];
        self.actorCountsDictionary = [[NSMutableDictionary alloc] init];
        self.narrationDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

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

///////////////////////////////////////////////////////////////////////////////
// OpenEars processing


- (void)receiveOEEvent:(OEEvent*) speechEvent{
    
}

@end
