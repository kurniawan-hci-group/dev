//
//  OEDelegate.h
//  SpeechAdventure
//
//  Created by John Chambers on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OEEvent.h" //turns out imports from within the project need to be in "s

@protocol OEDelegate <NSObject>

- (void)receiveOEEvent:(OEEvent*) speechEvent;

@end
