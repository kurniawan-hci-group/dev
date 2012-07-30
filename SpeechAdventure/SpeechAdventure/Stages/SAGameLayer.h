//
//  SAGameLayer.h
//  SpeechAdventure
//
//  Created by John Chambers on 7/27/12.
//
//

#import <Foundation/Foundation.h>

#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

#import "OEDelegate.h"
#import "OEManager.h"
#import "OEEvent.h"

@interface SAGameLayer : CCLayerColor<OEDelegate>

@property (nonatomic, strong) CCLayer *backgroundLayer;
@property (nonatomic, strong) CCLayer *baseStageLayer;
@property (nonatomic, strong) CCLayer *activityLayer;
@property (nonatomic, strong) CCLayer *foregroundLayer;

- (id) init;
- (void) receiveOEEvent:(OEEvent*) speechEvent;

// returns a CCScene that contains the class's layer as the only child
+(CCScene *) scene;

@end

/* Considered putting the layers into an array and reference them by constants, but I actually believe that will complicate references to them unnecessarily.
 
 typedef enum gameLayers{
    background,
    base,
    activity,
    foreground
} gameLayers;*/