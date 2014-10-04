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
@property (nonatomic,assign) BOOL actorIsPlural; //Only with regard to the name given. If yes, the actorName is expanded to all members of the plural actor. If no, the actor, whether singular or plural initially, is referenced directly.
@property (nonatomic,copy) NSString *requiredState;

@end
