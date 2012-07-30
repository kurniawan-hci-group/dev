//
//  AppDelegate.h
//  SpeechAdventure
//
//  Created by John Chambers on 7/21/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

#import "OEManager.h"
#import "OEEvent.h"
#import "OEDelegate.h"

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate, OEDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;

	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;
//@property (nonatomic, strong) OEManager *voiceInputManager;

- (void)receiveOEEvent:(OEEvent*) speechEvent;

@end
