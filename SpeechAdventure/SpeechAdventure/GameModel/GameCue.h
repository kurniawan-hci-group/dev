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

#import "GameActor.h"
#import "GameAction.h"

@interface GameCue : NSObject

//The different types: sequence, spawn, single
@property (nonatomic,copy) NSString *actionCollectionType; 

//Properties for a single
@property (nonatomic,strong) GameActor *targetActor;
@property (nonatomic,copy) NSString *actorMultiplicityType; //Determines how this call deals with plural actors. Value is either single, pluralAllAtOnce, or pluralOneAtATime
@property (nonatomic,strong) GameAction *actionToPerform;

//Property(s) for sequence & spawn
@property (nonatomic,strong) NSMutableArray *containedActions;

@end
