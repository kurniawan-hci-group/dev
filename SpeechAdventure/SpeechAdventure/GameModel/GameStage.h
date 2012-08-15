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
#import "OEEvent.h"


@interface GameStage : CCLayerColor<OEDelegate>

@property (nonatomic,strong) NSMutableDictionary *layersDictionary;

- (id) init;

@end
