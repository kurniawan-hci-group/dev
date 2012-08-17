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
@synthesize stateEffect = _stateEffect;
@synthesize soundFile = _soundFile;

- (id) init {
    if (self=[super init]) {
        self.animation = [[GameAnimation alloc] init];
    }
    return self;
}

- (id) getCCAction {
    id returnAction;
    id actionWithoutSound;
    id soundAction;
    
    if ([self.type isEqualToString:@"animation"]) {
        actionWithoutSound = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:[self.animation getCCAnimation]]];
    } else if ([self.type isEqualToString:@"hide"]) {
        actionWithoutSound = [CCHide action];
    }
    
    //Sound is not required for a GameAction. Therefore, only include it if it is set.
    if (![self.soundFile isEqualToString:@""]){
        soundAction = [GameAction callBlockActionForSoundFile:self.soundFile];
        returnAction = [CCSpawn actions:
                        actionWithoutSound,
                        soundAction,
                        nil];
    } else {
        returnAction = actionWithoutSound;
    }
    
    return returnAction;
}

+ (id) callBlockActionForSoundFile:(NSString *) mySoundFile {
    return [CCCallBlock actionWithBlock:^{
        [[SimpleAudioEngine sharedEngine] playEffect:mySoundFile];
        }];
}
;


@end
