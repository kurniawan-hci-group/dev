//
//  StageLoader.m
//  SpeechAdventure
//
//  Created by John Chambers on 8/13/12.
//
//

#import "StageLoader.h"

@implementation StageLoader

#pragma mark -
#pragma mark Parser Convenience Methods

+ (NSString *)XMLFilePathForPrefix:(NSString*)prefix{
    return [[NSBundle mainBundle] pathForResource:prefix ofType:@"xml"];
}

+ (NSArray *)bypassSingularXMLTag:(NSString *) singularTag toGroupTag:(NSString *) groupTag inNode:(GDataXMLElement *)enclosingNode {
    return [[[enclosingNode elementsForName:singularTag] objectAtIndex:0] elementsForName:groupTag];
}

+ (NSString *)singularXMLElementValueFrom:(GDataXMLElement*)encloser inTag:(NSString*)tag {
    //Returns the value contained in a singular XML element
    
    //Helpful because accessing these types of element values in GData is a bit cumbersome. GData returns an ARRAY of the nodes containing a certain name. That's great when you have an indefinite number of nodes, but when you are in a known structure where you have only ONE instance of a tag, this lets you querry its value without having to go through a lot of crap.
    return ((GDataXMLElement*)[[encloser elementsForName:tag] objectAtIndex:0]).stringValue;
}

+ (GDataXMLElement *)singularXMLElementFrom:(GDataXMLElement*)encloser inTag:(NSString*)tag {
    //Returns a singular XML node
    
    //Identical to the above method except that it returns the node itself instead of the string value
    return ((GDataXMLElement*)[[encloser elementsForName:tag] objectAtIndex:0]);
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

+ (GameStage *) loadStageWithXMLFilePrefix: (NSString*) XMLFilePrefix{
    GameStage *newStage = [GameStage node];

    @try {
        
        //****************************************************************************
        //
        // Process XML Stage File
        //
        //****************************************************************************
        
        NSString *path = [StageLoader XMLFilePathForPrefix:XMLFilePrefix];
        NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:path];
        NSError *error;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
                                                               options:0 error:&error];
        /*Old troubleshooting code for when file is not found
         if (doc == nil) {
         NSLog(@"XML file %@ not found", path);
         return nil;
         }*/
        
        //NSLog(@"XML Root Element: %@", doc.rootElement);
        
        //PROCESS SCENERY*************************************************************
        NSArray *layersArray = [StageLoader bypassSingularXMLTag:@"scenery" toGroupTag:@"layer" inNode:doc.rootElement];
        
        //Process XML layer elements
        for (GDataXMLElement *myXMLLayer in layersArray) {
            CCLayer *myCCLayer = [CCLayer node];
            
            //get XML layer name
            NSString *layerName = [StageLoader singularXMLElementValueFrom:myXMLLayer inTag:@"name"];
            
            //add layer
            [newStage.layersDictionary setObject:myCCLayer forKey:layerName];
            [newStage addChild:myCCLayer];
            
            //get and add layer sprites ('items')
            NSArray *itemsArray = [myXMLLayer elementsForName:@"item"];
            for (GDataXMLElement *myItemXML in itemsArray) {
                //NSString *itemName = [GameStage singularXMLElementValueFrom:myItemXML inTag:@"name"];
                NSString *anchorPointString = [StageLoader singularXMLElementValueFrom:myItemXML inTag:@"anchorPoint"];
                NSString *positionString = [StageLoader singularXMLElementValueFrom:myItemXML inTag:@"position"];
                NSString *fileString = [StageLoader singularXMLElementValueFrom:myItemXML inTag:@"file"];
                CGPoint anchorPoint = [StageLoader pointForText:anchorPointString];
                CGPoint position = [StageLoader pointForText:positionString];
                
                CCSprite *mySprite = [CCSprite spriteWithFile:fileString];
                mySprite.anchorPoint = anchorPoint;
                mySprite.position = position;
                [myCCLayer addChild:mySprite];
            }
            
        }
        
        //PROCESS ACTORS*************************************************************
        NSArray *actorsArray = [StageLoader bypassSingularXMLTag:@"actorList" toGroupTag:@"actor" inNode:doc.rootElement];

        for (GDataXMLElement *myXMLActor in actorsArray) {
            NSString *actorName = [StageLoader singularXMLElementValueFrom:myXMLActor inTag:@"name"];
            //NSLog(@"Actor name %@", actorName);
            
            GameActor *newActor = [[GameActor alloc] init];
            
            //Load images from ImageSource
            //Process differently depending on whether is fixed image or sprite sheet style
            GDataXMLElement *imageSource = [StageLoader singularXMLElementFrom:myXMLActor inTag:@"imageSource"];
            NSString *sourceType = [StageLoader singularXMLElementValueFrom:imageSource inTag:@"type"];
            newActor.imageSourceType = sourceType;
            //NSLog(@"Image source type: %@", sourceType);
            
            if ([sourceType isEqualToString:@"spriteSheet"]) {
                //PROCESS AN ACTOR WITH SHEET
                
                //enter spriteSheet node
                GDataXMLElement *spriteSheetNode = [StageLoader singularXMLElementFrom:imageSource inTag:@"spriteSheet"];
                NSString *imageFile = [StageLoader singularXMLElementValueFrom:spriteSheetNode inTag:@"imageFile"];
                NSString *plistFile = [StageLoader singularXMLElementValueFrom:spriteSheetNode inTag:@"plistFile"];
                
                newActor.spriteSheetImageFile = imageFile;
                newActor.spriteSheetPListFile = plistFile;
                //NSLog(@"PListFile value: %@", plistFile);
                [newActor loadSpriteSheetWithImageFile:imageFile PlistFile:plistFile];
                
                //Add stillFrames (which are unique to sprite sheet actors)
                NSArray *myXMLStillFramesArray = [myXMLActor elementsForName:@"stillFrame"];
                for (GDataXMLElement *myXMLStillFrame in myXMLStillFramesArray) {
                    NSString *stillName = [StageLoader singularXMLElementValueFrom:myXMLStillFrame inTag:@"name"];
                    NSString *frameFile = [StageLoader singularXMLElementValueFrom:myXMLStillFrame inTag:@"frameFile"];
                    BOOL isDefaultStill = [[StageLoader singularXMLElementValueFrom:myXMLStillFrame inTag:@"isDefaultStill"] isEqualToString:@"YES"];
                    
                    CCSprite *newStill = [CCSprite spriteWithSpriteFrameName:frameFile];
                     [newActor.stillFramesDictionary setObject:newStill forKey:stillName];
                    /*[newActor addStillFrameWithFrameFile:frameFile withKey:stillName];*/
                    NSLog(@"Name used for reference: %@", stillName);
                    
                    //Retrieval Test
                    CCSprite *gottenBack = [newActor.stillFramesDictionary objectForKey:stillName];
                    NSLog(@"Retrieve test value: %@", gottenBack);
                    
                    
                    //set initial sprite for actor
                    if (isDefaultStill) {
                        //[newActor setInitialFrameWithKey:stillName];
                        /*newActor.actualSprite = newStill;
                        [newActor.spriteBatchNode addChild:newActor.actualSprite];*/
                    }
                }
                
            } else if ([sourceType isEqualToString:@"singleFrame"]) {
                //PROCESS AN ACTOR WITH NO SHEET
                
                NSString *imageFile = [StageLoader singularXMLElementValueFrom:imageSource inTag:@"imageFile"];
                [newActor setActualSpriteWithFile:imageFile];
                newActor.singleImageFileName = imageFile;
            } else {
                NSLog(@"ERROR: Image source type description for actor %@ invalid in the XML file", actorName);
                return nil;
            }
            
            //Add actions with & without sound
            NSArray *actionsArray = [myXMLActor elementsForName:@"action"];
            for (GDataXMLElement *myXMLAction in actionsArray) {
                NSString *actionName = [StageLoader singularXMLElementValueFrom:myXMLAction inTag:@"name"];
                NSString *actionType = [StageLoader singularXMLElementValueFrom:myXMLAction inTag:@"type"];
                
                GameAction *newAction = [[GameAction alloc] init];
                newAction.type = actionType;
                
                if ([actionType isEqualToString:@"animation"]) {
                    newAction.animation = [[GameAnimation alloc] init];
                    
                    GDataXMLElement *animationNode = [StageLoader singularXMLElementFrom:myXMLAction inTag:@"animation"];
                    
                    NSString *frameNameFormat = [StageLoader singularXMLElementValueFrom:animationNode inTag:@"frameNameFormat"];
                    int numberOfFrames = [StageLoader singularXMLElementValueFrom:animationNode inTag:@"numberOfFrames"].intValue;
                    [newAction.animation setFramesWithFrameNameFormat:frameNameFormat andNumberOfFrames:numberOfFrames];
                    
                    newAction.animation.frameDelay = [StageLoader singularXMLElementValueFrom:animationNode inTag:@"frameDelay"].doubleValue;
                }
                
                newAction.soundFile = [StageLoader singularXMLElementValueFrom:myXMLAction inTag:@"soundFile"];
                
                [newActor.actionsDictionary setObject:newAction forKey:actionName];
            }
            
            //Add actor to list
            [newStage.actorsDictionary setObject:newActor forKey:actorName];
        }
        
        //ADD NARRATION*************************************************************
        NSArray *narrationSounds = [StageLoader bypassSingularXMLTag:@"narration" toGroupTag:@"sound" inNode:doc.rootElement];
        for (GDataXMLElement *myXMLSound in narrationSounds) {
            NSString *soundName = [StageLoader singularXMLElementValueFrom:myXMLSound inTag:@"name"];
            NSString *file = [StageLoader singularXMLElementValueFrom:myXMLSound inTag:@"file"];
            
            [newStage.narrationDictionary setObject:soundName forKey:file];
        }
        
        //INIALIZE ACTORS******************************************************
        //Generate full set of actors (i.e. expand plural actors), and add their
        //spriteBatchNodes to the activityLayer
        
        //OPEN EARS & COMMANDS******************************************************
        GDataXMLElement *voiceToTextNode = [StageLoader singularXMLElementFrom:doc.rootElement inTag:@"voiceToText"];
        
        //Load & set OEModel----------------
        GDataXMLElement *myXMLOEModel = [StageLoader singularXMLElementFrom:voiceToTextNode inTag:@"model"];
        NSString *OEModelKeyword = [StageLoader singularXMLElementValueFrom:myXMLOEModel inTag:@"keyword"];
        NSString *OEModelDictionaryFile = [StageLoader singularXMLElementValueFrom:myXMLOEModel inTag:@"dictionaryFile"];
        NSString *OEModelLanguageModelFile = [StageLoader singularXMLElementValueFrom:myXMLOEModel inTag:@"languageModelFile"];
        
        OEModel *newOEModel = [[OEModel alloc] initWithDicFile:OEModelDictionaryFile andGrammerFile:OEModelLanguageModelFile];
        
        //add it to the manager list
        [[OEManager sharedManager] addModel:newOEModel withKeyword:OEModelKeyword];
        //set its keyword value in the stage
        newStage.OEModelKeyword = OEModelKeyword;
        
        //Process commands specifically--------
        
        
        //***The stage should learn to switch to its model independently of the StageLoader,
        //but we'll keep the model change here for now since the StageLoader is the only way
        //that I currently expect these stages to be switched to.
        [[OEManager sharedManager] changeToModelWithKeyword:OEModelKeyword];
        /////////////////////////////////////////////////////////////////////////////
        
    }
    @catch (NSException *e) {
        NSLog(@"ERROR LOADING XML STAGE: %@", e);
    }
    
    return newStage;
}

#pragma mark -
#pragma mark Cocos2D Methods
// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) sceneWithXMLPrefix:(NSString*)XMLPrefix
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	// 'layer' is an autorelease object.
	GameStage *layer = [StageLoader loadStageWithXMLFilePrefix:XMLPrefix];
    
	// add layer as a child to scene
	[scene addChild: layer];
	
    // return the scene
	return scene;
}

@end
