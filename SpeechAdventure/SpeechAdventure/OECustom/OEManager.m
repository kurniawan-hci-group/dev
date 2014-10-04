//
//  OEManager.m
//  SpeechAdventure
//
//  Created by John Chambers on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <OpenEars/PocketSphinxController.h>
#import <OpenEars/LanguageModelGenerator.h>
#import <OpenEars/OpenEarsLogging.h>

#import "OEManager.h"

@interface OEManager()

@property (nonatomic, strong) LanguageModelGenerator *languageModelGenerator;
@property (nonatomic, strong) NSMutableArray *notificationRegistrants;
@property (nonatomic, strong) NSMutableDictionary *modelsDictionary;

@end

@implementation OEManager

@synthesize openEarsEventsObserver = _openEarsEventsObserver;
@synthesize pocketsphinxController = _pocketsphinxController;
@synthesize languageModelGenerator = _languageModelGenerator;
@synthesize modelKeyword = _modelKeyword;
@synthesize modelDictionaryPath = _modelDictionaryPath;
@synthesize modelGrammarPath = _modelGrammarPath;
@synthesize notificationRegistrants = _notificationRegistrants;
@synthesize modelsDictionary = _modelsDictionary;
@synthesize debuggingMode = _debuggingMode;



#pragma mark -
#pragma mark Memory Management

// Lazily allocate utility objects

// Lazily allocate PocketsphinxController.
- (PocketsphinxController *)pocketsphinxController { 
	if (_pocketsphinxController == nil) {
		_pocketsphinxController = [[PocketsphinxController alloc] init];
        //great for troubleshooting
        //_pocketsphinxController.verbosePocketSphinx = TRUE;
	}
	return _pocketsphinxController;
}

// Lazily allocate OpenEarsEventsObserver.
- (OpenEarsEventsObserver *)openEarsEventsObserver {
	if (_openEarsEventsObserver == nil) {
		_openEarsEventsObserver = [[OpenEarsEventsObserver alloc] init];
	}
	return _openEarsEventsObserver;
}

//Lazily allocate LanguageModelGenerator
- (LanguageModelGenerator *)languageModelGenerator {
    if (_languageModelGenerator == nil) {
        _languageModelGenerator = [[LanguageModelGenerator alloc] init];
    }
    return _languageModelGenerator;
}

//Lazily allocate notificationRegistrants array
- (NSMutableArray *)notificationRegistrants {
    if (_notificationRegistrants == nil)
    {
        _notificationRegistrants = [[NSMutableArray alloc] initWithCapacity:15];
    }
    return _notificationRegistrants;
}

//Lazily allocate modelsDictionary
- (NSMutableDictionary *)modelsDictionary {
    if (_modelsDictionary == nil)
    {
        _modelsDictionary = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    return _modelsDictionary;
}

#pragma mark -
#pragma mark Initializers

- (id) initWithModelKeyword:(NSString *)keyword {
    if (self = [super init])
    {
        //add stock models
        OEModel *defaultModel = [[OEModel alloc] initWithDicFile:@"OpenEars1.dic" andGrammerFile:@"OpenEars1.languagemodel"];
        //OEModel *defaultModel = [[OEModel alloc] initWithDicFile:@"PopABalloonOEModel.dic" andGrammerFile:@"PopABalloonOEModel.languagemodel"];
        [self addModel:defaultModel withKeyword:@"Default"];
         
        //register for OpenEars events
        [self.openEarsEventsObserver setDelegate:self];
        
        //apply any parameters
        [self setModelWithKeyword:keyword];
    }
    
    self.debuggingMode? NSLog(@"Successfully initialized"): nil;
    
    return self;
}

- (id) initWithDefaults {
    return [self initWithModelKeyword:@"Default"];
}

- (id) init {
    return [self initWithDefaults];
}

#pragma mark -
#pragma mark PocketSphinx Control

- (void) startListening {
    self.debuggingMode? NSLog(@"OpenEars: About to start listening"): nil;
    
    [self.pocketsphinxController startListeningWithLanguageModelAtPath:self.modelGrammarPath dictionaryAtPath:self.modelDictionaryPath languageModelIsJSGF:FALSE];
    
    self.debuggingMode? NSLog(@"OpenEars: Started listening"): nil;
}

- (void) stopListening {
    [self.pocketsphinxController stopListening];
    self.debuggingMode? NSLog(@"OpenEars: Stopped listening"): nil;
}

- (void) pauseListening {
    [self.pocketsphinxController suspendRecognition];
    self.debuggingMode? NSLog(@"OpenEars: Paused listening"): nil;
}

- (void) resumeListening {
    [self.pocketsphinxController resumeRecognition];
    self.debuggingMode? NSLog(@"OpenEars: Resumed listening"): nil;
}

- (void) addModel:(OEModel *)newModel withKeyword:(NSString *)keyword {
    if ([self.modelsDictionary objectForKey:keyword] == nil)
    {
        [self.modelsDictionary setObject:newModel forKey:keyword];
    }
}

- (void) setModelWithKeyword:(NSString *) keyword {
    //Set the paths for the model without actually enforcing the change
    //Stopping & starting would enact the new model
    
    OEModel *currentModel = [self.modelsDictionary objectForKey:keyword];
    //verify such a model exists before installing paths
    if (currentModel != nil)
    {
        self.modelKeyword = keyword;
        self.modelGrammarPath = currentModel.grammarPath;
        self.modelDictionaryPath = currentModel.dictionaryPath;
    }
                                
    //As it appears that the problem is in the model generation,
    //I am removing the autocreating part in favor of precreated files.
    //I suspect the audio model may be missing.
    
    //The model creation code doesn't cause any problems, but installing the newly
    //created model absolutely does. Because dynamic model creation is not
    //an absolute necessity for the game, I will keep it removed so we can
    //make further progress on the project.
    
    //ADDITION!!! (16 August 2012)
    //XCode seems not to like the "lm" extension used by default by the
    //online model creator & (probably) by the dynamic creator. Therefore,
    //it's worth reopening this code area with a CUSTOM extension different
    //than "lm" to see if that makes a difference.
    
    /*
    NSArray *defaultWords = [[NSArray alloc] initWithObjects:@"TEST", @"ONE", @"TWO", @"THREE", @"STOP", nil]; //be sure words are UPPER-CASE
    NSError *error = [self.languageModelGenerator generateLanguageModelFromArray:defaultWords withFilesNamed:@"Default"];
    NSDictionary *generationResultsDictionary = nil;
    if([error code] != noErr) {
        NSLog(@"Dynamic language generator reported error %@", [error description]);	
    } else {
        generationResultsDictionary = [error userInfo];
        
        NSString *lmFile = [generationResultsDictionary objectForKey:@"LMFile"];
        NSString *dictionaryFile = [generationResultsDictionary objectForKey:@"DictionaryFile"];
        NSString *lmPath = [generationResultsDictionary objectForKey:@"LMPath"];
        NSString *dictionaryPath = [generationResultsDictionary objectForKey:@"DictionaryPath"];
        
        NSLog(@"Dynamic language generator completed successfully, you can find your new files %@\n and \n%@\n at the paths \n%@ \nand \n%@", lmFile,dictionaryFile,lmPath,dictionaryPath);
        
        if (generationResultsDictionary)
        {
            self.modelDictionaryPath = lmPath;
            self.modelGrammarPath = dictionaryPath;
            [self startListening];
        }
        }*/
}

- (void) changeToModelWithKeyword:(NSString *) keyword {
    //IMMEDIATELY changes to the new model (unlike setModelWithKeyword)
    //Cycles a stop/start, so should work even if OE isn't listening at call time
    [self setModelWithKeyword:keyword];
    [self stopListening];
    [self startListening];
    
}

#pragma mark -
#pragma mark Notification Registration
- (void) registerDelegate:(id<OEDelegate>)delegate {
    [self.notificationRegistrants addObject:delegate];
    self.debuggingMode? NSLog(@"OpenEars Delegate registered"): nil;
}

- (void) removeDelegate:(id<OEDelegate>)delegate {
    [self.notificationRegistrants removeObject:delegate];
}

#pragma mark -
#pragma mark Singleton Stuff
static OEManager *theManager = nil;

+ (OEManager *) sharedManager {
    if (theManager == nil) {
        theManager = [[super allocWithZone:NULL] init];
    }
    return theManager;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedManager] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

- (oneway void)release {
    
}

- (id)autorelease {
    return self;
}

#pragma mark -
#pragma mark OpenEarsEventsObserver delegate methods

- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
	self.debuggingMode? NSLog(@"OpenEars received hypothesis %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID): nil; // Log it.
    /*if ([hypothesis isEqualToString:@"STOP"])
    {
        [self stopListening];
    }*/
    
    //NOTIFY THE REGISTRANTS
    //generate the event
    OEEvent *voiceEvent = [[OEEvent alloc] initWithText:hypothesis andScore:[[NSNumber alloc] initWithDouble:[recognitionScore doubleValue]]];
    
    //actually deliver the event
    NSEnumerator *registrantArrayTraverser = [self.notificationRegistrants objectEnumerator];
    id<OEDelegate> currentRegistrant;
    
    while (currentRegistrant = [registrantArrayTraverser nextObject])
    {
        if ([currentRegistrant conformsToProtocol:@protocol(OEDelegate)])
        {
            [currentRegistrant receiveOEEvent:voiceEvent];
        }
    }
}

- (void) pocketSphinxContinuousSetupDidFail {
    NSLog(@"OpenEars setup failed");
}

- (void) pocketsphinxDidCompleteCalibration {
    self.debuggingMode? NSLog(@"OpenEars calibration complete"): nil;
}

- (void) pocketsphinxDidResumeRecognition {
    self.debuggingMode? NSLog(@"OpenEars resume complete"): nil;
}

- (void) pocketsphinxDidDetectSpeech {
    self.debuggingMode? NSLog(@"OpenEars detected speech"): nil;
}
    
@end
