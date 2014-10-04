//
//  GameAnimation.h
//  SpeechAdventure
//
//  Created by John Chambers on 8/10/12.
//
//

#import <Foundation/Foundation.h>

#import <GameKit/GameKit.h>
#import "cocos2d.h"

@interface GameAnimation : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,strong) NSMutableArray *frames;
@property (nonatomic,assign) double frameDelay;


- (id) init;
- (void) setFramesWithFrameNameFormat:(NSString *)frameNameFormat andNumberOfFrames:(int)numberOfFrames;
- (CCAnimation *) getCCAnimation;

@end
