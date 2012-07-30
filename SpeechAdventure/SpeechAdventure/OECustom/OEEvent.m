//
//  OEEvent.m
//  SpeechAdventure
//
//  Created by John Chambers on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OEEvent.h"

@implementation OEEvent

@synthesize text = _text;
@synthesize recognitionScore = _recognitionScore;

- (id)initWithText:(NSString *)text andScore:(NSNumber *)score {
    if (self = [super init])
    {
        self.text = text;
        self.RecognitionScore = score;
    }
    return self;
}

@end
