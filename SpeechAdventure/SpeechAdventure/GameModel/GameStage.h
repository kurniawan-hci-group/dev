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
@property (nonatomic,strong) NSMutableDictionary *narrationDictionary;
@property (nonatomic,copy) NSString *OEModelKeyword;

- (id) init;

//Add actor to dictionary as well as to the activity layer
- (void) addActor:(GameActor*)newActor withName:(NSString *)actorName;
- (void) removeActorWithName:(NSString *)actorName;
- (GameActor*) getActorByName:(NSString *)actorName;

///////////////////////////////////////////////////////////////////////////////
// Plural Actor Stuff
- (void) setActorCount:(int)count forActorWithName:(NSString*)actorName;
- (int) getActorCountForActorWithName:(NSString*)actorName;
+ (NSString *) getPluralActorNameForActorName:(NSString*)actorName withIndex:(int)index;

@end
