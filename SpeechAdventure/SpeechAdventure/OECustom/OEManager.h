//
//  OEManager.h
//  SpeechAdventure
//
//  Created by John Chambers on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PocketsphinxController;

#import <OpenEars/OpenEarsEventsObserver.h>

#import "OEDelegate.h"
#import "OEModel.h"

@interface OEManager : NSObject<OpenEarsEventsObserverDelegate>

- (id) initWithModelKeyword:(NSString *) keyword;
- (id) initWithDefaults;
- (id) init;

- (void) startListening;
- (void) stopListening;
- (void) pauseListening;
- (void) resumeListening;

- (void) addModel:(OEModel *)newModel withKeyword:(NSString *)keyword;
- (void) setModelWithKeyword:(NSString *) keyword;

- (void) registerDelegate:(id <OEDelegate>) delegate;
- (void) removeDelegate:(id <OEDelegate>) delegate;

//have a shared manager for the whole program
+ (OEManager *) sharedManager;

@property (nonatomic, strong) OpenEarsEventsObserver *openEarsEventsObserver;
@property (nonatomic, strong) PocketsphinxController *pocketsphinxController;
@property (nonatomic, copy) NSString *modelKeyword;
@property (nonatomic, copy) NSString *modelDictionaryPath;
@property (nonatomic, copy) NSString *modelGrammarPath;
@property (nonatomic, assign) BOOL debuggingMode;

@end


