//
//  IntroLayer.h
//  SpeechAdventure
//
//  Created by John Chambers on 7/21/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "OEDelegate.h"
#import "OEEvent.h"

// HelloWorldLayer
@interface IntroLayer : CCLayer<OEDelegate>
{
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
