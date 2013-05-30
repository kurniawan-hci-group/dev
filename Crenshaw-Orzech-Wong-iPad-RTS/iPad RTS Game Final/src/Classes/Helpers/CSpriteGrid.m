//
//  CSpriteGrid.m
//  AppScaffold
//
//  Created by Scott Orzech on 2/14/11.
//  Copyright 2011 University of California, Santa Cruz. All rights reserved.
//

#import "CSpriteGrid.h"

// --- private interface ---------------------------------------------------------------------------

@interface CSpriteGrid ()

@end


@implementation CSpriteGrid


- (id)initWithGameBoard:(SPTexture*)texture
{
    if (self = [super init])
    {
        mTexture = [texture retain];
		mImage = [SPImage imageWithTexture:mTexture]; //unselected grid texture
		
		int texture_width = mTexture.width;
		int texture_height = mTexture.height;
		
		rows = 50, cols = 50;
		
		for (int i = 0; i < cols; ++i) { //Num Columns
			for (int j = 0; j < rows; ++j) { //Num Rows
				SPImage *tempImage = [SPImage imageWithTexture:mTexture];
				tempImage.x = i * tempImage.width;
				tempImage.y = j * tempImage.height;
				[self addChild:tempImage];
			}
		}
		
		SPImage *tempImage = [SPImage imageWithContentsOfFile:@"selectedbox.png"];
		tempImage.x = rows*texture_height/2 - tempImage.width/2;
		tempImage.y = cols*texture_width/2 - tempImage.height/2;
		[self addChild:tempImage];
		
		width = texture_width * (int)cols;
		height = texture_height * (int)rows;
				
		self.x -= (width-768)/2;  //center grid
		self.y -= (height-768)/2;
		
		[self compile];
    }
    return self;    
}

- (id)init
{
    // the designated initializer of the base class should always be overridden -- we do that here.
    SPTexture *texture = [[[SPTexture alloc] init] autorelease];
	return [self initWithGameBoard:texture texture2:texture];
}


- (void)dealloc
{
    // event listeners should always be removed to avoid memory leaks!
    [mTexture release];
    [mImage release];
    [super dealloc];
}

@end
