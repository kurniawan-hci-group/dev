//
//  GameActionCall.h
//  SpeechAdventure
//
//  Created by John Chambers on 8/16/12.
//
//

#import <Foundation/Foundation.h>

#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

#import "PointConverter.h"

#import "GameActor.h"
#import "GameAction.h"
#import "GameMove.h"

@interface GameCue : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,strong) id<PointConverter> referenceNode;
//The different types: sequence, spawn, single
@property (nonatomic,copy) NSString *cueCollectionType; 

//Properties for a single
@property (nonatomic,strong) NSMutableDictionary *actorsDictionary;
@property (nonatomic,strong) NSMutableDictionary *actorCountsDictionary;
@property (nonatomic,copy) NSString *actorName;
@property (nonatomic,copy) NSString *actorNameExtended;
@property (nonatomic,strong) GameActor *actualActor;
@property (nonatomic,copy) NSString *actorMultiplicityType; //Determines how this call deals with plural actors. Value is either single or pluralOneAtATime
@property (nonatomic,copy) NSString *actionName;
@property (nonatomic,strong) GameAction *actualAction;
@property (nonatomic,strong) NSString *endStillFrame;

@property (nonatomic,assign) double duration;
@property (nonatomic,strong) NSString *soundFile;

@property (nonatomic,strong) GameMove *move;

//Property(s) for sequence & spawn
@property (nonatomic,strong) NSMutableArray *containedCues;

- (id) init;

- (void) runCue; //Use this method to actually run the Cue

///////////////////////////////////////////////////////////////////////////////
//Actor dictionary manipulation
- (GameActor*) getActorByName:(NSString *)actorName;

///////////////////////////////////////////////////////////////////////////////
// Plural Actor Stuff
- (int) getActorCountForActorWithName:(NSString*)actorName;
+ (NSString *) indexedActorNameForActorName:(NSString*)actorName withIndex:(int)index;
- (NSMutableArray*) getNamesForPluralActorPrefix:(NSString*)actorNamePrefix;
- (NSMutableArray*) getObjectsForPluralActorPrefix:(NSString*)actorNamePrefix;

////////////////////////////////////////////////////////////////////////
// Call Block stuff
+ (id) callBlockActionForSoundFile:(NSString *) mySoundFile;
+ (id) callBlockSetStillFrameWithKey:(NSString*)key forActor:(GameActor*)actor;
+ (id) callBlockActorCCAction:(GameAction*)action onActor:(GameActor*)actor forDuration:(double)duration;
+ (id) callBlockFullActorActionForCue:(GameCue*)myCue;
+ (id) callBlockSetStateForActor:(GameActor*)actor withAction:(GameAction*)action;

////////////////////////////////////////////////////////////////////////
// Generating action sequences and spawns of dynamic length

+(CCFiniteTimeAction *) getActionSequence: (NSArray *) actions;
+(CCFiniteTimeAction *) getActionSpawn: (NSArray *) actions;

////////////////////////////////////////////////////////////////////////
// General Convenience Methods

- (void) setActualActorAndActionWithExtendedActorName:(NSString*)extendedActorName;
- (BOOL) actorStateIsAlreadyInPlaceForActorWithExtendedName:(NSString*)actorExtendedName;
+ (void) setupCue:(GameCue*)myCue;

@end
