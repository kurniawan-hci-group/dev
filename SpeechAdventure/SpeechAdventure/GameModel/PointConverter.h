//
//  PointConverter.h
//  SpeechAdventure
//
//  Created by John Chambers on 8/20/12.
//
//

#import <Foundation/Foundation.h>

@protocol PointConverter <NSObject>

- (CGPoint) convertToNodeSpace:(CGPoint)worldPoint;
- (CGPoint) convertToWorldSpace:(CGPoint)p;

@end
