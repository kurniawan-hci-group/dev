//
//  ControlGroup.h
//  iRTS
//
//  Created by Scott Orzech on 2/28/11.
//  Copyright 2011 University of California, Santa Cruz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sparrow.h"

@interface ControlGroup : SPSprite {
@private
	SPImage *groupImage;
	SPImage *addImage;
	SPTextField *textField;
	SPTextField *textField2;
	NSMutableArray *groupUnits;
}

- (void)setText:(NSMutableString *)string;

@end
