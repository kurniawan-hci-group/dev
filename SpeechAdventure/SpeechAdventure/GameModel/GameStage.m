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

- (id) init {
    if (self=[super initWithColor:ccc4(255,255,255,255) width:480 height:320])
    {
        
    }
    return self;
}

- (void)receiveOEEvent:(OEEvent*) speechEvent{
    
}

@end
