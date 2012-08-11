//
//  GameAnimation.h
//  SpeechAdventure
//
//  Created by John Chambers on 8/10/12.
//
//

#import <Foundation/Foundation.h>

@interface GameAnimation : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,strong) NSMutableArray *frames;
@property (nonatomic,strong) NSNumber *lengthInTime;

@end
