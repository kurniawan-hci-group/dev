//
//  GameMove.m
//  SpeechAdventure
//
//  Created by John Chambers on 8/18/12.
//
//

#import "GameMove.h"

@implementation GameMove

@synthesize destinationType = _destinationType;
@synthesize moveType = _moveType;

@synthesize controlPoint1 = _controlPoint1;
@synthesize controlPoint2 = _controlPoint2;
@synthesize endPosition = _endPosition;

- (id) getCCActionWithDuration:(int)duration withStartPoint:(CGPoint)startPoint {
    id returnAction;
    
    if ([self.moveType isEqualToString:@"straight"]) {
        //process straight actions, either absolutely or relatively
        if ([self.destinationType isEqualToString:@"absolute"]) {
            returnAction = [CCMoveTo actionWithDuration:duration position:self.endPosition];
        } else if ([self.destinationType isEqualToString:@"relative"]) {
            CGPoint actualEndPosition = [GameMove convertFromRelativeToAbsolute:self.endPosition withStartPoint:startPoint];
            returnAction = [CCMoveTo actionWithDuration:duration position:actualEndPosition];
        } else {
            NSLog(@"ERROR: Invalid destinationType %@ in GameMove-getCCAction...", self.destinationType);
        }
        
    } else if ([self.moveType isEqualToString:@"bezier"]) {
        //process bezier actions either absolutely or relatively
        ccBezierConfig myBezier;
        if ([self.destinationType isEqualToString:@"absolute"]) {
            myBezier.controlPoint_1 = self.controlPoint1;
            myBezier.controlPoint_2 = self.controlPoint2;
            myBezier.endPosition = self.endPosition;
            returnAction = [CCBezierTo actionWithDuration:duration bezier:myBezier];
        } else if ([self.destinationType isEqualToString:@"relative"]) {
            myBezier.controlPoint_1 = [GameMove convertFromRelativeToAbsolute:self.controlPoint1 withStartPoint:startPoint];
            myBezier.controlPoint_2 = [GameMove convertFromRelativeToAbsolute:self.controlPoint2 withStartPoint:startPoint];
            myBezier.endPosition = [GameMove convertFromRelativeToAbsolute:self.endPosition withStartPoint:startPoint];
            returnAction = [CCBezierTo actionWithDuration:duration bezier:myBezier];
        } else {
            NSLog(@"ERROR: Invalid destinationType %@ in GameMove-getCCAction...", self.destinationType);
        }
    } else {
        NSLog(@"ERROR: Invalid moveType %@ in GameMove-getCCAction...", self.moveType);
    }
    
    return returnAction;
}

+ (CGPoint)convertFromRelativeToAbsolute:(CGPoint)targetPoint withStartPoint:(CGPoint)startPoint {
    return ccp(startPoint.x + targetPoint.x, startPoint.y + targetPoint.y);
}

@end
