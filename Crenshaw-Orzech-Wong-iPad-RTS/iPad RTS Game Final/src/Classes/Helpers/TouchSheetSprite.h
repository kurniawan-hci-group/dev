//
//  TouchSheetCSprite.h
//  AppScaffold
//
//  Created by Scott Orzech on 2/14/11.
//  Copyright 2011 University of California, Santa Cruz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sparrow.h"
#import "SPSprite.h"

@interface TouchSheetSprite : SPSprite 
{
	SPSprite *mgrid;
	float mwidth;
	float mheight;
}

- (id)initWithGrid:(SPSprite*)grid width:(float)width height:(float)height; // designated initializer

@end
