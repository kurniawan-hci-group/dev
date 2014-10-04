//
//  OEModel.m
//  OETestBed
//
//  Created by John Chambers on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OEModel.h"

@implementation OEModel

@synthesize dictionaryPath = _dictionaryPath;
@synthesize grammarPath = _grammarPath;

- (id)initWithDicPath:(NSString*)dictionaryPath andGrammarPath:(NSString*)grammarPath {
    if (self == [super init])
    {
        self.dictionaryPath = dictionaryPath;
        self.grammarPath = grammarPath;
    }
    return self;
}

- (id)initWithDicFile:(NSString*)dictionaryFile andGrammerFile:(NSString*)grammarFile {
    return [self initWithDicPath:[OEModel addResourcePathToFileName:dictionaryFile] andGrammarPath:[OEModel addResourcePathToFileName:grammarFile]];
}

+ (NSString *)addResourcePathToFileName:(NSString *)fileName {
        return [NSString stringWithFormat:@"%@/%@", [[NSBundle  mainBundle] resourcePath], fileName];
}

@end
