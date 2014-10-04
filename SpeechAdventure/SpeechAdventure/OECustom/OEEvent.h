//
//  OEEvent.h
//  SpeechAdventure
//
//  Created by John Chambers on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OEEvent : NSObject

@property (nonatomic,copy) NSString *text;
@property (nonatomic,copy) NSNumber *recognitionScore;

- (id) initWithText:(NSString*)text andScore:(NSNumber*)score;


@end
