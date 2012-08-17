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

- (id) init {
    if (self=[super init]) {
        self.frames = [[NSMutableArray alloc] init];
    }
    return self;
}

/*- (void) setFrames:(NSMutableArray *)frames {
    if (self.frames != frames) {
        [self.frames release];
        self.frames = [frames mutableCopy];
    }
}*/

- (void) setFramesWithFrameNameFormat:(NSString *)frameNameFormat andNumberOfFrames:(int)numberOfFrames {
    for(int i = 1; i<=numberOfFrames; i++){
        [self.frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:frameNameFormat,i]]];
    }
}

- (CCAnimation *) getCCAnimation; {
    return [CCAnimation animationWithSpriteFrames:self.frames delay:self.frameDelay];
}

@end
