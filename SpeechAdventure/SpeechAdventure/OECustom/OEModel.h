//
//  OEModel.h
//  OETestBed
//
//  Created by John Chambers on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OEModel : NSObject

@property (nonatomic, copy) NSString *dictionaryPath;
@property (nonatomic, copy) NSString *grammarPath;

- (id)initWithDicPath:(NSString*)dictionaryPath andGrammarPath:(NSString*)grammarPath;
- (id)initWithDicFile:(NSString*)dictionaryFile andGrammerFile:(NSString*)grammarFile;

+ (NSString*)addResourcePathToFileName:(NSString*)fileName;

@end
