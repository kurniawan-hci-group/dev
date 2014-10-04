//
//  GameMove.m
//  SpeechAdventure
//
//  Created by John Chambers on 8/18/12.
//
//

#import "GameMove.h"

@implementation GameMove

//@synthesize referenceNode = _referenceNode;
@synthesize destinationType = _destinationType;
@synthesize moveType = _moveType;

@synthesize controlPoint1 = _controlPoint1;
@synthesize controlPoint2 = _controlPoint2;
@synthesize endPosition = _endPosition;

- (id) getCCActionWithDuration:(int)duration withActor:(GameActor *)myActor {
    id returnAction;
    
    if ([myActor.imageSourceType isEqualToString:@"spriteSheet"]) {
        //final movement coordinates will need to be relative
        CGPoint startPoint = myActor.spriteBatchNode.position;
        if ([self.moveType isEqualToString:@"straight"]) {
            //process straight actions, either absolutely or relatively
            if ([self.destinationType isEqualToString:@"relative"]) {
                returnAction = [CCMoveTo actionWithDuration:duration position:self.endPosition];
            } else if ([self.destinationType isEqualToString:@"absolute"]) {
                CGPoint actualEndPosition = [GameMove convertFromAbsoluteToRelative:self.endPosition withStartPoint:startPoint];
                returnAction = [CCMoveTo actionWithDuration:duration position:actualEndPosition];
            } else {
                NSLog(@"ERROR: Invalid destinationType %@ in GameMove-getCCAction...", self.destinationType);
            }
            
        } else if ([self.moveType isEqualToString:@"bezier"]) {
            //process bezier actions either absolutely or relatively
            ccBezierConfig myBezier;
            if ([self.destinationType isEqualToString:@"relative"]) {
                myBezier.controlPoint_1 = self.controlPoint1;
                myBezier.controlPoint_2 = self.controlPoint2;
                myBezier.endPosition = self.endPosition;
                returnAction = [CCBezierTo actionWithDuration:duration bezier:myBezier];
            } else if ([self.destinationType isEqualToString:@"absolute"]) {
                myBezier.controlPoint_1 = [GameMove convertFromAbsoluteToRelative:self.controlPoint1 withStartPoint:startPoint];
                myBezier.controlPoint_2 = [GameMove convertFromAbsoluteToRelative:self.controlPoint2 withStartPoint:startPoint];
                myBezier.endPosition = [GameMove convertFromAbsoluteToRelative:self.endPosition withStartPoint:startPoint];
                returnAction = [CCBezierTo actionWithDuration:duration bezier:myBezier];
            } else {
                NSLog(@"ERROR: Invalid destinationType %@ in GameMove-getCCAction...", self.destinationType);
            }
        } else {
            NSLog(@"ERROR: Invalid moveType %@ in GameMove-getCCAction...", self.moveType);
        }
    } else if ([myActor.imageSourceType isEqualToString:@"singleFrame"]) {
        //final movement coordinates will be absolute
        CGPoint startPoint = myActor.actualSprite.position;
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
    } else {
        NSLog(@"ERROR: Invalid imageSourceType %@ in GameMove-getCCAction", myActor.imageSourceType);
    }
    
    return returnAction;
}

- (id) getCCActionWithDuration:(int)duration withStartPoint:(CGPoint)startPoint {
    id returnAction;
    
    NSLog(@"Received starting point: %f,%f", startPoint.x, startPoint.y);
    
    //movements are performed on the actual sprite sheet, so the 
    
    if ([self.moveType isEqualToString:@"straight"]) {
        //process straight actions, either absolutely or relatively
        if ([self.destinationType isEqualToString:@"relative"]) {
            returnAction = [CCMoveTo actionWithDuration:duration position:self.endPosition];
        } else if ([self.destinationType isEqualToString:@"absolute"]) {
            CGPoint actualEndPosition = [GameMove convertFromRelativeToAbsolute:self.endPosition withStartPoint:startPoint];
            returnAction = [CCMoveTo actionWithDuration:duration position:actualEndPosition];
        } else {
            NSLog(@"ERROR: Invalid destinationType %@ in GameMove-getCCAction...", self.destinationType);
        }
        
    } else if ([self.moveType isEqualToString:@"bezier"]) {
        //process bezier actions either absolutely or relatively
        ccBezierConfig myBezier;
        if ([self.destinationType isEqualToString:@"relative"]) {
            myBezier.controlPoint_1 = self.controlPoint1;
            myBezier.controlPoint_2 = self.controlPoint2;
            myBezier.endPosition = self.endPosition;
            returnAction = [CCBezierTo actionWithDuration:duration bezier:myBezier];
        } else if ([self.destinationType isEqualToString:@"absolute"]) {
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

+ (CGPoint)convertFromAbsoluteToRelative:(CGPoint)targetPoint withStartPoint:(CGPoint)startPoint {
    return ccp(targetPoint.x - startPoint.x, targetPoint.y - startPoint.y);
}

@end
