//
//  ResourceInfo.h
//  iRTS
//
//  Created by Scott Orzech on 2/28/11.
//  Copyright 2011 University of California, Santa Cruz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sparrow.h"

@interface ResourceInfo : SPSprite{
@private
	SPImage *mImage;
	SPTextField *textField;
}

- (void) setText: (NSMutableString *)string;

@end
