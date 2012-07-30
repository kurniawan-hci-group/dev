//
//  SAGameLayer.m
//  SpeechAdventure
//
//  Created by John Chambers on 7/27/12.
//
//

#import "SAGameLayer.h"

@interface SAGameLayer()

@end


@implementation SAGameLayer

@synthesize backgroundLayer = _backgroundLayer;
@synthesize baseStageLayer = _baseStageLayer;
@synthesize activityLayer = _activityLayer;
@synthesize foregroundLayer = _foregroundLayer;

- (id)init {
    //initialize with white background
    if (self=[super initWithColor:ccc4(255,255,255,255)])
    {
        //Add the sublayers for sprite stratification
        //ORDER MATTERS--first added is farthest back
        [self addChild:self.backgroundLayer];
        [self addChild:self.baseStageLayer];
        [self addChild:self.activityLayer];
        [self addChild:self.foregroundLayer];
    }
    return self;
}

- (CCLayer *)backgroundLayer {
    if (_backgroundLayer == nil)
    {
        _backgroundLayer = [CCLayer node];
    }
    return _backgroundLayer;
}

- (CCLayer *)baseStageLayer {
    if (_baseStageLayer == nil)
    {
        _baseStageLayer = [CCLayer node];
    }
    return _baseStageLayer;
}

- (CCLayer *)activityLayer {
    if (_activityLayer == nil)
    {
        _activityLayer = [CCLayer node];
    }
    return _activityLayer;
}

- (CCLayer *)foregroundLayer {
    if (_foregroundLayer == nil)
    {
        _foregroundLayer = [CCLayer node];
    }
    return _foregroundLayer;
}


- (void)receiveOEEvent:(OEEvent*) speechEvent{
    //abstract method for dealing with speech events
    /*[NSException raise:NSInternalInconsistencyException
                format:@"You must overide %@ in a subclass", NSStringFromSelector(_cmd)];*/
}

// Helper class method that creates a Scene with the current layer as the only child.
+(CCScene *) scene
{
	//abstract method for integration with Cocos2D
    /*[NSException raise:NSInternalInconsistencyException
                format:@"You must overide %@ in a subclass", NSStringFromSelector(_cmd)];*/
    return nil;
}

@end
