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

- (void)receiveOEEvent:(OEEvent*) speechEvent{
    
}

@end
