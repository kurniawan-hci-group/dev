//
//  Minimap.h
//  iRTS
//
//  Created by Scott Orzech on 2/28/11.
//  Copyright 2011 University of California, Santa Cruz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sparrow.h"
#import "Mineral.h"

@interface Minimap : SPSprite{
@private
	SPTexture *rTexture; //red unit on minimap
	SPTexture *gTexture; //green mineral on minimap
	SPImage *mImage; //minimap backdrop
	SPImage *mImage2; //minimap photo background
	SPSprite *mSprite; //holds all the red dots
	SPTextField *textField;
}

- (void) setText: (NSMutableString *)string;

@end
