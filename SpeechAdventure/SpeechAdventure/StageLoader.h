//
//  StageLoader.h
//  SpeechAdventure
//
//  Created by John Chambers on 8/13/12.
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

#import "GameModel/GameStage.h"
#import "GameModel/GameActor.h"
#import "GameModel/GameAnimation.h"
#import "GameModel/GameAction.h"
#import "GameModel/GameCue.h"
#import "GameModel/GameMove.h"
#import "GameModel/GameCommand.h"

@interface StageLoader : NSObject

//Parser convenience methods
+ (NSString *)XMLFilePathForPrefix:(NSString*)prefix;
+ (NSString *)singularXMLElementValueFrom:(GDataXMLElement*)encloser inTag:(NSString*)tag;
+ (CGPoint)pointForText:(NSString*)givenText;

//Actual loader methods
+ (GameStage *) loadStageWithXMLFilePrefix: (NSString*) XMLStageDescriptor;
+ (GameCue *) loadCueWithXMLData: (GDataXMLElement *) XMLGameCue withStage: (GameStage*) theStage;
+ (GameCue *) loadMoveWithXMLData: (GDataXMLElement *) XMLMove;
+ (CCScene *) sceneWithXMLPrefix:(NSString*)XMLPrefix;

@end
