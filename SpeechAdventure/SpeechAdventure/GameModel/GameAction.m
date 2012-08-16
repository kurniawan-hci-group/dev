//
//  GameAction.m
//  SpeechAdventure
//
//  Created by John Chambers on 8/10/12.
//
//

#import "GameAction.h"

@implementation GameAction

@synthesize name = _name;
@synthesize type = _type;
@synthesize animation = _animation;
@synthesize sound = _sound;

- (CCAction *) getCCAction {
    return [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:[self.animation getCCAnimation]]];
}

@end
