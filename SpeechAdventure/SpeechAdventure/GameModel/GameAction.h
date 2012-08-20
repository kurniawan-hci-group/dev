//
//  GameAction.h
//  SpeechAdventure
//
//  Created by John Chambers on 8/10/12.
//
//

#import <Foundation/Foundation.h>

#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

#import "GameAnimation.h"

@interface GameAction : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,strong) GameAnimation *animation;
@property (nonatomic,copy) NSString *stateEffect;
@property (nonatomic,copy) NSString *soundFile;

- (id) getCCActionRepeatForever;
- (id) getCCActionWithDuration:(int)duration;


@end
