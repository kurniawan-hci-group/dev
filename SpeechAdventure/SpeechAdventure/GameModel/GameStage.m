//
//  GameModel.m
//  SpeechAdventure
//
//  Created by John Chambers on 8/6/12.
//
//

#import "GameStage.h"

@interface GameStage()

@end

@implementation GameStage

@synthesize layers = _layers;

+ (NSString *)XMLFilePathForPrefix:(NSString*)prefix{
    return [[NSBundle mainBundle] pathForResource:prefix ofType:@"xml"];
}

- (id) initWithXMLFilePrefix: (NSString*) XMLFilePrefix{
    if (self = [super init]) {
        NSString *path = [GameStage XMLFilePathForPrefix:XMLFilePrefix];
        NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:path];
        NSError *error;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
                                                               options:0 error:&error];
        if (doc == nil) {
            NSLog(@"XML file %@ not found", path);
            return nil;
        }
        
        NSLog(@"XML Root Element: %@", doc.rootElement);
        
        //-scenery
        NSArray *scenerySectionArray = [doc.rootElement elementsForName:@"scenery"];
        GDataXMLElement *sceneryElement = (GDataXMLElement*)[scenerySectionArray objectAtIndex:0];
        
        //--layer
        NSArray *layersArray = [sceneryElement elementsForName:@"layer"];
        GDataXMLElement *firstLayer = (GDataXMLElement*)[layersArray objectAtIndex:0];
        
        //---name
        NSArray *nameArray = [firstLayer elementsForName:@"name"];
        GDataXMLElement *layerName = (GDataXMLElement*)[nameArray objectAtIndex:0];
        
        NSLog(@"The name of the first layer is: %@", layerName.stringValue);
        
    }
    return self;
}

#pragma mark -
#pragma mark Voice input handling

- (void) receiveOEEvent:(OEEvent*) speechEvent{
    
}

#pragma mark -
#pragma mark Cocos2D Methods
// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	// 'layer' is an autorelease object.
	GameStage *layer = [GameStage node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
    // return the scene
	return scene;
}

@end
