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

@synthesize layersDictionary = _layersDictionary;

- (id) init {
    if (self=[super initWithColor:ccc4(255,255,255,255) width:480 height:320])
    {
        
    }
    return self;
}

+ (NSString *)XMLFilePathForPrefix:(NSString*)prefix{
    return [[NSBundle mainBundle] pathForResource:prefix ofType:@"xml"];
}

#pragma mark -
#pragma mark XML Stage Loading

+ (NSString *)singularXMLElementValueFrom:(GDataXMLElement*)encloser inTag:(NSString*)tag {
    //Returns the value contained in a singular XML element
    
    //Helpful because accessing these types of element values in GData is a bit cumbersome. GData returns an ARRAY of the nodes containing a certain name. That's great when you have an indefinite number of nodes, but when you are in a known structure where you have only ONE instance of a tag, this lets you querry its value without having to go through a lot of crap.
    return ((GDataXMLElement*)[[encloser elementsForName:tag] objectAtIndex:0]).stringValue;
}

+ (CGPoint)pointForText:(NSString*)givenText {
    //Converts text of the form (x,y) to a CGPoint
    
    int indexOfOpenParenthesis = [givenText rangeOfString:@"("].location;
    int indexOfComma = [givenText rangeOfString:@","].location;
    int indexOfCloseParenthesis = [givenText rangeOfString:@")"].location;
    
    NSRange xRange = NSMakeRange(indexOfOpenParenthesis + 1, indexOfComma - (indexOfOpenParenthesis + 1));
    NSRange yRange = NSMakeRange(indexOfComma + 1, indexOfCloseParenthesis - (indexOfComma + 1));
    double x = [[givenText substringWithRange:xRange] doubleValue];
    double y = [[givenText substringWithRange:yRange] doubleValue];
    return CGPointMake(x, y);
}

- (void) loadStageWithXMLFilePrefix: (NSString*) XMLFilePrefix{
    
    //****************************************************************************
    //
    // Process XML Stage File
    //
    //****************************************************************************
    
    NSString *path = [GameStage XMLFilePathForPrefix:XMLFilePrefix];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:path];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
                                                           options:0 error:&error];
    /*Old troubleshooting code for when code is not found
     if (doc == nil) {
        NSLog(@"XML file %@ not found", path);
        return nil;
    }*/
    
    NSLog(@"XML Root Element: %@", doc.rootElement);
    
    //PROCESS SCENERY*************************************************************
    //Open Scenery Section
    NSArray *scenerySectionArray = [doc.rootElement elementsForName:@"scenery"];
    GDataXMLElement *sceneryElement = (GDataXMLElement*)[scenerySectionArray objectAtIndex:0];
    
    //Get XML layers
    NSArray *layersArray = [sceneryElement elementsForName:@"layer"];
    //GDataXMLElement *firstLayer = (GDataXMLElement*)[layersArray objectAtIndex:0];
    
    //Process XML layer elements
    for (GDataXMLElement *myXMLLayer in layersArray) {
        CCLayer *myCCLayer = [CCLayer node];
        
        //get XML layer name
        NSString *layerName = [GameStage singularXMLElementValueFrom:myXMLLayer inTag:@"name"];
        
        //add layer
        [self.layersDictionary setObject:myCCLayer forKey:layerName];
        [self addChild:myCCLayer];
        
        //get and add layer sprites ('items')
        NSArray *itemsArray = [myXMLLayer elementsForName:@"item"];
        for (GDataXMLElement *myItemXML in itemsArray) {
            //NSString *itemName = [GameStage singularXMLElementValueFrom:myItemXML inTag:@"name"];
            NSString *anchorPointString = [GameStage singularXMLElementValueFrom:myItemXML inTag:@"anchorPoint"];
            NSString *positionString = [GameStage singularXMLElementValueFrom:myItemXML inTag:@"position"];
            NSString *fileString = [GameStage singularXMLElementValueFrom:myItemXML inTag:@"file"];
            CGPoint anchorPoint = [GameStage pointForText:anchorPointString];
            CGPoint position = [GameStage pointForText:positionString];
            
            CCSprite *mySprite = [CCSprite spriteWithFile:fileString];
            mySprite.anchorPoint = anchorPoint;
            mySprite.position = position;
            [myCCLayer addChild:mySprite];
        }
        
    }
    
    //PROCESS ACTORS*************************************************************
}

#pragma mark -
#pragma mark Voice input handling

- (void) receiveOEEvent:(OEEvent*) speechEvent{
    
}

#pragma mark -
#pragma mark Cocos2D Methods
// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) sceneWithXMLPrefix:(NSString*)XMLPrefix
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	// 'layer' is an autorelease object.
	GameStage *layer = [GameStage node];
    [layer loadStageWithXMLFilePrefix:XMLPrefix];
    
	// add layer as a child to scene
	[scene addChild: layer];
	
    // return the scene
	return scene;
}

@end
