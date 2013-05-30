//
//  CSpriteGrid.h
//  AppScaffold
//
//  Created by Scott Orzech on 2/14/11.
//  Copyright 2011 University of California, Santa Cruz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sparrow.h"
#import "SPCompiledSprite.h"

@interface CSpriteGrid : SPCompiledSprite {
@private
	SPTexture *mTexture;
	SPImage *mImage;
@public
	float width;
	float height;
	int rows;
	int cols;
	
}

- (id)initWithGameBoard:(SPTexture*)texture texture2:(SPTexture*)texture2; // designated initializer
	
@end
