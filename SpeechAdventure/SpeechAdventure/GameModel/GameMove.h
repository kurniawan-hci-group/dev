//
//  GameMove.h
//  SpeechAdventure
//
//  Created by John Chambers on 8/18/12.
//
//

#import <Foundation/Foundation.h>

#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

#import "GameActor.h"
#import "PointConverter.h"

@interface GameMove : NSObject

//@property (nonatomic,strong) id<PointConverter> referenceNode;
@property (nonatomic,strong) NSString *destinationType; //Can be "absolute" or "relative"
@property (nonatomic,strong) NSString *moveType; //For now, can be "bezier" or "straight"

@property (nonatomic,assign) CGPoint controlPoint1; //For bezier
@property (nonatomic,assign) CGPoint controlPoint2; //For bezier
@property (nonatomic,assign) CGPoint endPosition;

- (id) getCCActionWithDuration:(int)duration withActor:(GameActor*)myActor;
+ (CGPoint)convertFromRelativeToAbsolute:(CGPoint)targetPoint withStartPoint:(CGPoint)startPoint;
+ (CGPoint)convertFromAbsoluteToRelative:(CGPoint)targetPoint withStartPoint:(CGPoint)startPoint;

@end
