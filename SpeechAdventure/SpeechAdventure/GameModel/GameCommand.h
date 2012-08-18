//
//  GameCommand.h
//  SpeechAdventure
//
//  Created by John Chambers on 8/10/12.
//
//

#import <Foundation/Foundation.h>

#import "GameCue.h"

@interface GameCommand : NSObject

@property (nonatomic,copy) NSString *activatingText;
@property (nonatomic,strong) GameCue *responseActionCall;
@property (nonatomic,copy) NSString *supportSoundFile;

@end
