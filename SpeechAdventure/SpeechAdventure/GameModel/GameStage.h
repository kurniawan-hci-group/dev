//
//  GameModel.h
//  SpeechAdventure
//
//  Created by John Chambers on 8/6/12.
//
//

#import <Foundation/Foundation.h>

#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

#import "GDataXMLNode.h"

#import "OEDelegate.h"
#import "OEManager.h"
#import "OEModel.h"
#import "OEEvent.h"

#import "GameActor.h"


@interface GameStage : CCLayerColor<OEDelegate>

@property (nonatomic,strong) NSMutableDictionary *layersDictionary;
@property (nonatomic,strong) NSMutableDictionary *actorsDictionary;
@property (nonatomic,strong) NSMutableDictionary *actorCountsDictionary;
@property (nonatomic,copy) NSString *OEModelKeyword;
@property (nonatomic,copy) NSString *introCueKey;

- (id) init;

//Actor manipulation
- (void) addActor:(GameActor*)newActor withName:(NSString *)actorName;
- (void) removeActorWithName:(NSString *)actorName;
- (GameActor*) getActorByName:(NSString *)actorName;

///////////////////////////////////////////////////////////////////////////////
// Plural Actor Stuff
- (void) setActorCount:(int)count forActorWithName:(NSString*)actorName;
- (int) getActorCountForActorWithName:(NSString*)actorName;
+ (NSString *) indexedActorNameForActorName:(NSString*)actorName withIndex:(int)index;
- (NSMutableArray*) getNamesForPluralActorPrefix:(NSString*)actorNamePrefix;
- (NSMutableArray*) getObjectsForPluralActorPrefix:(NSString*)actorNamePrefix;

@end
