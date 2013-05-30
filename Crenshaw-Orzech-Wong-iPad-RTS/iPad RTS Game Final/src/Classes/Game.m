//
//  Game.m
//  AppScaffold
//
//  Created by Daniel Sperl on 14.01.10.
//  Copyright 2010 Incognitek. All rights reserved.
//

#import "Game.h" 
#import "GameScene.h"

@implementation Game

- (id)initWithWidth:(float)width height:(float)height
{
    if (self = [super initWithWidth:width height:height])
    {
        // this is where the code of your game will start. 
        // in this sample, we add just a simple quad to see if it works.
        //
//        SPQuad *quad = [SPQuad quadWithWidth:100 height:100];
//        quad.color = 0xff0000;
//        quad.x = 50;
//        quad.y = 50;
//        [self addChild:quad];		
		
		SPTexture *gameStartButtonTexture = [SPTexture textureWithContentsOfFile:@"button_big.png"]; //127 by 42
		SPButton *gameStartButton = [SPButton buttonWithUpState:gameStartButtonTexture text:@"Game Start!"];
        [gameStartButton addEventListener:@selector(onGameSceneButtonTriggered:) atObject:self
                                  forType:SP_EVENT_TYPE_TRIGGERED];
		gameStartButton.x = (768 - 127)/2;
		gameStartButton.y = (1024 - 42)/2;
        [self addChild:gameStartButton];		
	}
    return self;
}


- (void)onGameSceneButtonTriggered:(SPEvent *)event
{
    SPSprite *scene = [[GameScene alloc] init];
    [self showScene:scene];
    [scene release];
}

- (void)showScene:(SPSprite *)scene
{
    mCurrentScene = scene;
    [self addChild:scene];
	
    mMainMenu.visible = NO;
}


@end




