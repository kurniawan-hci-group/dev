//
//  DebuggingOutput.m
//  OpenEars
//
//  Created by Halle Winkler on 6/10/12.
//  Copyright (c) 2012 Politepix. All rights reserved.
//

#import "OpenEarsLogging.h"
#import "RuntimeVerbosity.h"

extern int openears_logging;

@implementation OpenEarsLogging

+ (id)startOpenEarsLogging
{
    static dispatch_once_t once;
    static id startOpenEarsLogging;
    dispatch_once(&once, ^{
        startOpenEarsLogging = [[self alloc] init];
    });
    openears_logging = 1;
    return startOpenEarsLogging;
}

@end
