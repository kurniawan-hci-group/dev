//
//  GameAnimation.m
//  SpeechAdventure
//
//  Created by John Chambers on 8/10/12.
//
//

#import "GameAnimation.h"

@implementation GameAnimation

@synthesize name = _name;
@synthesize frames = _frames;
@synthesize frameDelay = _frameDelay;

- (CCAnimation *) getCCAnimation; {
    return [CCAnimation animationWithSpriteFrames:self.frames delay:self.frameDelay];
}

@end
