//
//  GameRewardConditionItem.h
//  SpeechAdventure
//
//  Created by John Chambers on 8/18/12.
//
//

#import <Foundation/Foundation.h>

@interface GameRewardConditionItem : NSObject

@property (nonatomic,copy) NSString *actorName;
@property (nonatomic,assign) BOOL actorIsPlural;
@property (nonatomic,copy) NSString *requiredState;

@end
