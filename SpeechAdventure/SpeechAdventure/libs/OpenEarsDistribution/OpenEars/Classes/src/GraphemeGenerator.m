//  OpenEars _version 1.1_
//  http://www.politepix.com/openears
//
//  GraphemeGenerator.m
//  OpenEars
// 
//  GraphemeGenerator is a class which creates pronunciations for words which aren't in the dictionary
//
//  Copyright Politepix UG (haftungsbeschränkt) 2012. All rights reserved.
//  http://www.politepix.com
//  Contact at http://www.politepix.com/contact
//
//  This file is licensed under the Politepix Shared Source license found in the root of the source distribution.

#import "GraphemeGenerator.h"
#import "flite.h"

#import "RuntimeVerbosity.h"
extern int openears_logging;

cst_voice *v;
@implementation GraphemeGenerator

void unregister_cmu_us_kal(cst_voice *vox);
cst_voice *register_cmu_us_kal(const char *voxdir);

- (void)dealloc {
	unregister_cmu_us_kal(v);

    [super dealloc];
}

- (id) init 
{
    self = [super init];
    if (self)
    {
		flite_init();
		
		cst_voice *desired_voice = 0;
		
		cst_features *extra_feats;
		
		extra_feats = new_features();
		
		flite_voice_list = cons_val(voice_val(register_cmu_us_kal(NULL)),flite_voice_list);
		
		feat_set_string(extra_feats,"print_info_relation","Segment");
		
		if (desired_voice == 0) desired_voice = flite_voice_select(NULL);
		
		v = desired_voice;
		feat_copy_into(extra_feats,v->features);
		
		delete_features(extra_feats);
        free(flite_voice_list); // HLW
        
		//flite_voice_list=0;
    }
    return self;
}


- (NSString *) convertGraphemes:(NSString *)phrase {
	
	if(openears_logging == 1) NSLog(@"Using convertGraphemes for the word or phrase %@ which doesn't appear in the dictionary", phrase);
    cst_utterance *u = flite_synth_text((char *)[phrase UTF8String],v);
	NSMutableString *phonesMutableString = [[NSMutableString alloc] init];
	cst_item *item;
	const char *relname = utt_feat_string(u,"print_info_relation");
    for (item=relation_head(utt_relation(u,relname)); item; item=item_next(item)) {
		NSString *bufferString = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%s", item_feat_string(item,"name")]];
		[phonesMutableString appendString:[NSString stringWithFormat:@"%@ ",bufferString]];
		[bufferString release];
    }
	const char *destinationString = [(NSString *)phonesMutableString UTF8String];
	[phonesMutableString release];
    delete_utterance(u);
	NSString *stringToReturn = [[[NSString alloc] initWithString:[NSString stringWithFormat:@"%s", destinationString]]autorelease];
	return stringToReturn;
}

@end

