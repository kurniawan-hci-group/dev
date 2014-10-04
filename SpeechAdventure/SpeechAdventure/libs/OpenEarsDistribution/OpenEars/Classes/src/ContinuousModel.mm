//  OpenEars _version 1.1_
//  http://www.politepix.com/openears
//
//  ContinuousModel.mm
//  OpenEars
//
//  ContinuousModel is a class which consists of the continuous listening loop used by Pocketsphinx.
//
//  This is a Pocketsphinx continuous listening loop based on modifications to the Pocketsphinx file continuous.c.
//
//  Copyright Politepix UG (hatfungsbeschränkt) 2012 excepting that which falls under the copyright of Carnegie Mellon University as part
//  of their file continuous.c.
//  http://www.politepix.com
//  Contact at http://www.politepix.com/contact
//
//  Excepting that which falls under the license of Carnegie Mellon University as part of their file continuous.c, 
//  this file is licensed under the Politepix Shared Source license found in the root of the source distribution.
//
//  Header for original source file continuous.c which I modified to create this file is as follows:
//
/* -*- c-basic-offset: 4; indent-tabs-mode: nil -*- */
/* ====================================================================
 * Copyright (c) 1999-2001 Carnegie Mellon University.  All rights
 * reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer. 
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * This work was supported in part by funding from the Defense Advanced 
 * Research Projects Agency and the National Science Foundation of the 
 * United States of America, and the CMU Sphinx Speech Consortium.
 *
 * THIS SOFTWARE IS PROVIDED BY CARNEGIE MELLON UNIVERSITY ``AS IS'' AND 
 * ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL CARNEGIE MELLON UNIVERSITY
 * NOR ITS EMPLOYEES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ====================================================================
 *
 */
/*
 * demo.c -- An example SphinxII program using continuous listening/silence filtering
 * 		to segment speech into utterances that are then decoded.
 * 
 * HISTORY
 *
 * 15-Jun-99    Kevin A. Lenzo (lenzo@cs.cmu.edu) at Carnegie Mellon University
 *              Added i386_linux and used ad_open_sps instead of ad_open
 * 
 * 14-Jun-96	M K Ravishankar (rkm@cs.cmu.edu) at Carnegie Mellon University.
 * 		Created.
 */

/*
 * This is a simple, tty-based example of a SphinxII client that uses continuous listening
 * with silence filtering to automatically segment a continuous stream of audio input
 * into utterances that are then decoded.
 * 
 * Remarks:
 *   - Each utterance is ended when a silence segment of at least 1 sec is recognized.
 *   - Single-threaded implementation for portability.
 *   - Uses fbs8 audio library; can be replaced with an equivalent custom library.
 */
#import "AudioConstants.h"


#import "ContinuousAudioUnit.h"

#import "ContinuousModel.h"
#import "pocketsphinx.h"
#import "ContinuousADModule.h"
#import "unistd.h"

#import "PocketsphinxRunConfig.h"
#import "fsg_search_internal.h"

#import "RuntimeVerbosity.h"


#define kJSGFLanguageWeight 3

@implementation ContinuousModel

@synthesize inMainRecognitionLoop; // Have we entered the main part of the loop yet?
@synthesize exitListeningLoop; // Should we be breaking out of the loop at the nearest opportunity?
@synthesize thereIsALanguageModelChangeRequest;
@synthesize languageModelFileToChangeTo;
@synthesize dictionaryFileToChangeTo;
@synthesize secondsOfSilenceToDetect;
@synthesize returnNbest;
@synthesize nBestNumber;
@synthesize calibrationTime;

extern int openears_logging;
extern int verbose_pocketsphinx;

- (void)dealloc {
	[languageModelFileToChangeTo release];
	[dictionaryFileToChangeTo release];
    [super dealloc];
}



- (NSArray *)commandArrayForlanguageModel:(NSString *)languageModelPath andDictionaryPath:(NSString *)dictionaryPath isJSGF:(BOOL)languageModelIsJSGF {
	
    
    NSString *languageModelToUse = nil;
    float languageWeight;
    if(languageModelIsJSGF == TRUE) {
        languageModelToUse = @"-jsgf";
        languageWeight = kJSGFLanguageWeight; // I think that the language weight for JSGF was the source of a lot of issues
    } else {
        languageModelToUse = @"-lm";
        languageWeight = 6.5;
    }
    
    NSArray *commandArray = [NSArray arrayWithObjects: // This is an array that is used to set up the run arguments for Pocketsphinx. 
                             // Never change any of the values here directly.  They can be changed using the file PocketsphinxRunConfig.h (although you shouldn't 
                             // change anything there unless you are absolutely 100% clear on why you'd want to and what the outcome will be).
                             // See PocketsphinxRunConfig.h for explanations of these constants and the run arguments they correspond to.
                             languageModelToUse, languageModelPath,		 
#ifdef kADCDEV
                             @"-adcdev", kADCDEV,
#endif
                             
#ifdef kAGC
                             @"-agc", kAGC,
#endif
                             
#ifdef kAGCTHRESH
                             @"-agcthresh", kAGCTHRESH,
#endif
                             
#ifdef kALPHA
                             @"-alpha", kALPHA,
#endif
                             
#ifdef kARGFILE
                             @"-argfile", kARGFILE,
#endif
                             
#ifdef kASCALE
                             @"-ascale", kASCALE,
#endif
                             
#ifdef kBACKTRACE
                             @"-backtrace", kBACKTRACE,
#endif
                             
#ifdef kBEAM
                             @"-beam", kBEAM,
#endif
                             
#ifdef kBESTPATH
                             @"-bestpath", kBESTPATH,
#endif
                             
#ifdef kBESTPATHLW
                             @"-bestpathlw", kBESTPATHLW,
#endif
                             
#ifdef kBGHIST
                             @"-bghist", kBGHIST,
#endif
                             
#ifdef kCEPLEN
                             @"-ceplen", kCEPLEN,
#endif
                             
#ifdef kCMN
                             @"-cmn", kCMN,
#endif
                             
#ifdef kCMNINIT
                             @"-cmninit", kCMNINIT,
#endif
                             
#ifdef kCOMPALLSEN
                             @"-compallsen", kCOMPALLSEN,
#endif
                             
#ifdef kDEBUG
                             @"-debug", kDEBUG,
#endif
                             
#ifdef kDICT
                             @"-dict", dictionaryPath,
#endif
                             
#ifdef kDICTCASE
                             @"-dictcase", kDICTCASE,
#endif
                             
#ifdef kDITHER
                             @"-dither", kDITHER,
#endif
                             
#ifdef kDOUBLEBW
                             @"-doublebw", kDOUBLEBW,
#endif
                             
#ifdef kDS
                             @"-ds", kDS,
#endif
                             
#ifdef kFDICT
                             @"-fdict",  [NSString stringWithFormat:@"%@/noisedict",[[NSBundle mainBundle] resourcePath]],
#endif
                             
#ifdef kFEAT
                             @"-feat", kFEAT,
#endif
                             
#ifdef kFEATPARAMS
                             @"-featparams", kFEATPARAMS,
#endif
                             
#ifdef kFILLPROB
                             @"-fillprob", kFILLPROB,
#endif
                             
#ifdef kFRATE
                             @"-frate", kFRATE,
#endif
                             
#ifdef kFSG
                             @"-fsg", kFSG,
#endif
                             
#ifdef kFSGUSEALTPRON
                             @"-fsgusealtpron", kFSGUSEALTPRON,
#endif
                             
#ifdef kFSGUSEFILLER
                             @"-fsgusefiller", kFSGUSEFILLER,
#endif
                             
#ifdef kFWDFLAT
                             @"-fwdflat", kFWDFLAT,
#endif
                             
#ifdef kFWDFLATBEAM
                             @"-fwdflatbeam", kFWDFLATBEAM,
#endif
                             
#ifdef kFWDFLATWID
                             @"-fwdflatefwid", kFWDFLATWID,
#endif
                             
#ifdef kFWDFLATLW
                             @"-fwdflatlw", kFWDFLATLW,
#endif
                             
#ifdef kFWDFLATSFWIN
                             @"-fwdflatsfwin", kFWDFLATSFWIN,
#endif
                             
#ifdef kFWDFLATWBEAM
                             @"-fwdflatwbeam", kFWDFLATWBEAM,
#endif
                             
#ifdef kFWDTREE
                             @"-fwdtree", kFWDTREE,
#endif
                             
#ifdef kHMM
                             @"-hmm", [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] resourcePath]],
#endif
                             
#ifdef kINPUT_ENDIAN
                             @"-input_endian", kINPUT_ENDIAN,
#endif
                             
#ifdef kKDMAXBBI
                             @"-kdmaxbbi", kKDMAXBBI,
#endif
                             
#ifdef kKDMAXDEPTH
                             @"-kdmaxdepth", kKDMAXDEPTH,
#endif
                             
#ifdef kKDTREE
                             @"-kdtree", kKDTREE,
#endif
                             
#ifdef kLATSIZE
                             @"-latsize", kLATSIZE,
#endif
                             
#ifdef kLDA
                             @"-lda", kLDA,
#endif
                             
#ifdef kLDADIM
                             @"-ldadim", kLDADIM,
#endif
                             
#ifdef kLEXTREEDUMP
                             @"-lextreedump", kLEXTREEDUMP,
#endif
                             
#ifdef kLIFTER
                             @"-lifter",	kLIFTER,
#endif
                             
#ifdef kLMCTL
                             @"-lmctl",	kLMCTL,
#endif
                             
#ifdef kLMNAME
                             @"-lmname",	kLMNAME,
#endif
                             
#ifdef kLOGBASE
                             @"-logbase", kLOGBASE,
#endif
                             
#ifdef kLOGFN
                             @"-logfn", kLOGFN,
#endif
                             
#ifdef kLOGSPEC
                             @"-logspec", kLOGSPEC,
#endif
                             
#ifdef kLOWERF
                             @"-lowerf", kLOWERF,
#endif
                             
#ifdef kLPBEAM
                             @"-lpbeam", kLPBEAM,
#endif
                             
#ifdef kLPONLYBEAM
                             @"-lponlybeam", kLPONLYBEAM,
#endif
                             
                             
                             @"-lw",	[NSString stringWithFormat:@"%f", languageWeight],
                             
                             
#ifdef kMAXHMMPF
                             @"-maxhmmpf", kMAXHMMPF,
#endif
                             
#ifdef kMAXNEWOOV
                             @"-maxnewoov", kMAXNEWOOV,
#endif
                             
#ifdef kMAXWPF
                             @"-maxwpf", kMAXWPF,
#endif
                             
#ifdef kMDEF
                             @"-mdef", kMDEF,
#endif
                             
#ifdef kMEAN
                             @"-mean", kMEAN,
#endif
                             
#ifdef kMFCLOGDIR
                             @"-mfclogdir", kMFCLOGDIR,
#endif
                             
#ifdef kMIXW
                             @"-mixw", kMIXW,
#endif
                             
#ifdef kMIXWFLOOR
                             @"-mixwfloor", kMIXWFLOOR,
#endif
                             
#ifdef kMLLR
                             @"-mllr", kMLLR,
#endif
                             
#ifdef kMMAP
                             @"-mmap", kMMAP,
#endif
                             
#ifdef kNCEP
                             @"-ncep", kNCEP,
#endif
                             
#ifdef kNFFT
                             @"-nfft", kNFFT,
#endif
                             
#ifdef kNFILT
                             @"-nfilt", kNFILT,
#endif
                             
#ifdef kNWPEN
                             @"-nwpen", kNWPEN,
#endif
                             
#ifdef kPBEAM
                             @"-pbeam", kPBEAM,
#endif
                             
#ifdef kPIP
                             @"-pip", kPIP,
#endif
                             
#ifdef kPL_BEAM
                             @"-pl_beam", kPL_BEAM,
#endif
                             
#ifdef kPL_PBEAM
                             @"-pl_pbeam", kPL_PBEAM,
#endif
                             
#ifdef kPL_WINDOW
                             @"-pl_window", kPL_WINDOW,
#endif
                             
#ifdef kRAWLOGDIR
                             @"-rawlogdir", kRAWLOGDIR,
#endif
                             
#ifdef kREMOVE_DC
                             @"-remove_dc", kREMOVE_DC,
#endif
                             
#ifdef kROUND_FILTERS
                             @"-round_filters", kROUND_FILTERS,
#endif
                             
#ifdef kSAMPRATE
                             @"-samprate", kSAMPRATE,
#endif
                             
#ifdef kSEED
                             @"-seed",kSEED,
#endif
                             
#ifdef kSENDUMP
                             @"-sendump", kSENDUMP,
#endif
                             
#ifdef kSENMGAU
                             @"-senmgau", kSENMGAU,
#endif
                             
#ifdef kSILPROB
                             @"-silprob", kSILPROB,
#endif
                             
#ifdef kSMOOTHSPEC
                             @"-smoothspec", kSMOOTHSPEC,
#endif
                             
#ifdef kSVSPEC
                             @"-svspec", kSVSPEC,
#endif
                             
#ifdef kTMAT
                             @"-tmat", kTMAT,
#endif
                             
#ifdef kTMATFLOOR
                             @"-tmatfloor", kTMATFLOOR,
#endif
                             
#ifdef kTOPN
                             @"-topn", kTOPN,
#endif
                             
#ifdef kTOPN_BEAM
                             @"-topn_beam", kTOPN_BEAM,
#endif
                             
#ifdef kTOPRULE
                             @"-toprule", kTOPRULE,
#endif
                             
#ifdef kTRANSFORM
                             @"-transform", kTRANSFORM,
#endif
                             
#ifdef kUNIT_AREA
                             @"-unit_area", kUNIT_AREA,
#endif
                             
#ifdef kUPPERF
                             @"-upperf", kUPPERF,
#endif
                             
#ifdef kUSEWDPHONES
                             @"-usewdphones", kUSEWDPHONES,
#endif
                             
#ifdef kUW
                             @"-uw", kUW,
#endif
                             
#ifdef kVAR
                             @"-var", kVAR,
#endif
                             
#ifdef kVARFLOOR
                             @"-varfloor", kVARFLOOR,
#endif
                             
#ifdef kVARNORM
                             @"-varnorm", kVARNORM,
#endif
                             
#ifdef kVERBOSE
                             @"-verbose", kVERBOSE,
#endif
                             
#ifdef kWARP_PARAMS
                             @"-warp_params", kWARP_PARAMS,
#endif
                             
#ifdef kWARP_TYPE
                             @"-warp_type", kWARP_TYPE,
#endif
                             
#ifdef kWBEAM
                             @"-wbeam", kWBEAM,
#endif
                             
#ifdef kWIP
                             @"-wip", kWIP,
#endif
                             
#ifdef kWLEN
                             @"-wlen", kWLEN,
#endif
                             nil];
	
	return commandArray;
}


- (NSString *)languageModelFileToChangeTo {
	if (languageModelFileToChangeTo == nil) {
		languageModelFileToChangeTo = [[NSString alloc] init];
	}
	return languageModelFileToChangeTo;
}

- (NSString *) compileKnownWordsFromFileAtPath:(NSString *)filePath {
	NSArray *dictionaryArray = [[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	NSMutableString *allWords = [[[NSMutableString alloc] init]autorelease];
	for(NSString *string in dictionaryArray) {
		NSArray *lineArray = [string componentsSeparatedByString:@"\t"];
		[allWords appendString:[NSString stringWithFormat:@"%@\n",[lineArray objectAtIndex:0]]];
	}
	return allWords;
}

- (void) changeLanguageModelForDecoder:(ps_decoder_t *)pocketsphinxDecoder languageModelIsJSGF:(BOOL)languageModelIsJSGF {

    int fatalErrors = 0;
    
    if(languageModelIsJSGF == TRUE) {
        
		NSArray *dictionaryArray = [[NSString stringWithContentsOfFile:self.dictionaryFileToChangeTo encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
		int updateValue = 0;
		int count = 1;
		int add_word_result = 0;
        
        NSCharacterSet *nonWhitespaceCharacterSet = [[NSCharacterSet whitespaceAndNewlineCharacterSet] invertedSet];
        
        NSMutableArray *mutableCleaningArray = [[NSMutableArray alloc] init];

        for(NSString *string in dictionaryArray) {
            
            if(([string length] > 0) && [string rangeOfCharacterFromSet:nonWhitespaceCharacterSet].location != NSNotFound) { // This string has a length of at least one and it doesn't exclusively consist of whitespace or newlines, so it can be parsed by what follows.
                [mutableCleaningArray addObject:string];
            }
            
        }
        
        NSArray *dictionaryProcessingArray = [[NSArray alloc] initWithArray:(NSArray *)mutableCleaningArray];
        [mutableCleaningArray release];
        
		for(NSString *string in dictionaryProcessingArray) {
           
            NSArray *lineArray = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            NSMutableString *mutablePhonesString = [[NSMutableString alloc] init];
            int i;
            for ( i = 0; i < [lineArray count]; i++ ) {
                if(i > 0) [mutablePhonesString appendString:[NSString stringWithFormat:@"%@ ",[lineArray objectAtIndex:i]]];
            }
            
            NSRange deletionRange = {[mutablePhonesString length]-1,1};
            [mutablePhonesString deleteCharactersInRange:deletionRange];
            
            if(count < [dictionaryProcessingArray count]) {
                updateValue = 0;
            } else {
                updateValue = 1;
            }
 
            add_word_result = ps_add_word(pocketsphinxDecoder,(char *)[[lineArray objectAtIndex:0] UTF8String], (char *)[[lineArray objectAtIndex:1] UTF8String],updateValue);
            [mutablePhonesString release];
            
            if(add_word_result > -1) {
                if(openears_logging == 1) NSLog(@"%@ was added to dictionary",[lineArray objectAtIndex:0]);
            } else {
                if(openears_logging == 1) NSLog(@"%@ was not added to dictionary, perhaps because it is already in the dictionary",[lineArray objectAtIndex:0]);
            }
            
            count++;
            
		}
        
        [dictionaryProcessingArray release];
        
        
		if(openears_logging == 1) NSLog(@"A request has been made to change a JSGF grammar on the fly.");
		fsg_set_t *fsgs = ps_get_fsgset(pocketsphinxDecoder);
        
         fsg_set_remove_byname(fsgs, fsg_model_name(fsgs->fsg));
        
        //NSLog(@"The name of the current FSG is %s", fsgs->fsg->name);
        
//        POCKETSPHINX_EXPORT
//        fsg_model_t *fsg_set_remove(fsg_set_t *fsgs, fsg_model_t *wfsg);

        
		jsgf_t *jsgf;
		fsg_model_t *fsg;
        jsgf_rule_t *rule;
		char const *path = (char *)[self.languageModelFileToChangeTo UTF8String];
        
        if ((jsgf = jsgf_parse_file(path, NULL)) == NULL) {
			if(openears_logging == 1) NSLog(@"Error: no JSGF file at path.");
            fatalErrors++;
		}
        rule = NULL;
        
		jsgf_rule_iter_t *itor;
        
		for (itor = jsgf_rule_iter(jsgf); itor;
			 itor = jsgf_rule_iter_next(itor)) {
			rule = jsgf_rule_iter_rule(itor);
			if (jsgf_rule_public(rule))
				break;
            
            if (rule == NULL) {
                if(openears_logging == 1) NSLog(@"Error: No public rules found in %s", path);
                fatalErrors++;
            }
        }
        
        NSLog(@"current language weight is %d",fsgs->lw);
        
        int languageWeight = kJSGFLanguageWeight; // For some reason this value is a) lost and b) now an int instead of a float. Resetting it manually at this time helps a lot with recognition quality.
        
		fsg = jsgf_build_fsg(jsgf, rule, pocketsphinxDecoder->lmath, languageWeight);
      
        if (fsg_set_add(fsgs, fsg_model_name(fsg), fsg) != fsg) {
			if(openears_logging == 1) NSLog(@"Error: could not add finite state grammar to set.");
            fatalErrors++;
        } else {
            
		}
        
        if (fsg_set_select(fsgs, fsg_model_name(fsg)) == NULL) {
			if(openears_logging == 1) NSLog(@"Error: could not select new grammar.");
            fatalErrors++;
		}
        
		ps_update_fsgset(pocketsphinxDecoder);
        
	} else {
        
		if(openears_logging == 1) NSLog(@"A request has been made to change an ARPA grammar on the fly. The language model to change to is %@", self.languageModelFileToChangeTo);
		NSNumber *languageModelID = [NSNumber numberWithInt:999];
		NSFileManager *fileManager = [[NSFileManager alloc] init];
		NSError *error = nil;
		NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:self.languageModelFileToChangeTo error:&error];
		if(error) {
			if(openears_logging == 1) NSLog(@"Error: couldn't get attributes of language model file.");
            fatalErrors++;
		} else {
			if(openears_logging == 1) NSLog(@"In this session, the requested language model will be known to Pocketsphinx as id %@.",[fileAttributes valueForKey:NSFileSystemFileNumber]);
			languageModelID = [fileAttributes valueForKey:NSFileSystemFileNumber];
		}
        
		[fileManager release];
        
		ngram_model_t *baseLanguageModel, *newLanguageModelToAdd;
        
		newLanguageModelToAdd = ngram_model_read(pocketsphinxDecoder->config, (char *)[self.languageModelFileToChangeTo UTF8String], NGRAM_AUTO, pocketsphinxDecoder->lmath);
        
		baseLanguageModel = ps_get_lmset(pocketsphinxDecoder);
        
		if(openears_logging == 1) NSLog(@"languageModelID is %s",(char *)[[languageModelID stringValue] UTF8String]);
		ngram_model_set_add(baseLanguageModel, newLanguageModelToAdd, (char *)[[languageModelID stringValue] UTF8String], 1.0, TRUE);
		ngram_model_set_select(baseLanguageModel, (char *)[[languageModelID stringValue] UTF8String]);
        
		ps_update_lmset(pocketsphinxDecoder, baseLanguageModel);
        
		int loadingDictionaryResult = ps_load_dict(pocketsphinxDecoder, (char *)[self.dictionaryFileToChangeTo UTF8String],NULL, NULL);
        
		if(loadingDictionaryResult > -1) {
			if(openears_logging == 1) NSLog(@"Success loading the dictionary file %@.",self.dictionaryFileToChangeTo);
		} else {
			if(openears_logging == 1) NSLog(@"Error: could not load the specified dictionary file.");
            fatalErrors++;
		}
        
	}
    
    if(fatalErrors > 0) { // Language model or grammar switch wasn't successful, report the failure and reset the variables.

        if(openears_logging == 1) NSLog(@"There were too many errors to switch the language model or grammar, please search the console for the word 'error' to investigate the issues.");
        
        self.languageModelFileToChangeTo = nil;
		self.thereIsALanguageModelChangeRequest = FALSE;
        
    } else { // Language model or grammar switch appears to have been successful.

        NSDictionary *userInfoDictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"PocketsphinxDidChangeLanguageModel",self.languageModelFileToChangeTo, self.dictionaryFileToChangeTo,nil] forKeys:[NSArray arrayWithObjects:@"OpenEarsNotificationType",@"LanguageModelFilePath",@"DictionaryFilePath",nil]];
		NSNotification *notification = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionary];
		[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
        
		self.languageModelFileToChangeTo = nil;
		self.thereIsALanguageModelChangeRequest = FALSE;
        
		if(openears_logging == 1) NSLog(@"Changed language model. Project has these words in its dictionary:\n%@", [self compileKnownWordsFromFileAtPath:self.dictionaryFileToChangeTo]);
    }
}

- (PocketsphinxAudioDevice *) continuousAudioDevice { // Return the device to an Objective-C class.
	return audioDevice;	
}

- (CFStringRef) getCurrentRoute {
	if(audioDevice != NULL) {
		return audioDevice->currentRoute;
	}
	return NULL;
}


- (void) setCurrentRouteTo:(NSString *)newRoute {
	if(audioDevice != NULL && audioDevice->currentRoute != NULL) {
		audioDevice->currentRoute = (CFStringRef)newRoute;
	}
}

- (int) getRecognitionIsInProgress {
	if(audioDevice != NULL) {
		return audioDevice->recognitionIsInProgress;
	}
	return 0;
}

- (void) setRecognitionIsInProgressTo:(int)recognitionIsInProgress {
	if(audioDevice != NULL) {
		audioDevice->recognitionIsInProgress = recognitionIsInProgress;
	}
}


- (int) getRecordData {
	if(audioDevice != NULL) {
		return audioDevice->recordData;
	}
	return 0;
}

- (void) setRecordDataTo:(int)recordData {
	if(audioDevice != NULL) {
		audioDevice->recordData = recordData;
	}
}

- (Float32) getMeteringLevel {
	if(audioDevice != NULL) {	
		return pocketsphinxAudioDeviceMeteringLevel(audioDevice);
	}
	return 0.0;
}



#pragma mark -
#pragma mark Pocketsphinx Listening Loop


- (void) setupCalibrationBuffer {
	
	int numberOfRounds = 25; // This is the minimum number of rounds that appear to be required to be available under normal usage;
	int numberOfSamples = kPredictedSizeOfRenderFramesPerCallbackRound; // This is the current number of samples that is called in a single callback buffer round but this could change based on hardware, etc so keep an eye on it
	int safetyMultiplier = audioDevice->bps * 3; // this is the safety multiplier so that under normal usage we don't overrun this buffer, bps * 3 for device independence.

	if(audioDevice->calibrationBuffer == NULL) {
		audioDevice->calibrationBuffer = (SInt16*) malloc(audioDevice->bps * numberOfSamples * numberOfRounds * safetyMultiplier); // this only needs to be the size of the amount of data used to calibrate, and then some		
	} else {
		audioDevice->calibrationBuffer = (SInt16*) realloc(audioDevice->calibrationBuffer, audioDevice->bps * numberOfSamples * numberOfRounds * safetyMultiplier); // this only needs to be the size of the amount of data used to calibrate, and then some				
	}
	
	audioDevice->availableSamplesDuringCalibration = 0;
	audioDevice->samplesReadDuringCalibration = 0;
}


- (void) putAwayCalibrationBuffer {
	if(audioDevice->calibrationBuffer != NULL) {
		free(audioDevice->calibrationBuffer);
		audioDevice->calibrationBuffer = NULL;
	}
	audioDevice->availableSamplesDuringCalibration = 0;
	audioDevice->samplesReadDuringCalibration = 0;
}

- (void) changeLanguageModelToFile:(NSString *)languageModelPathAsString withDictionary:(NSString *)dictionaryPathAsString {
	self.thereIsALanguageModelChangeRequest = TRUE;
	self.languageModelFileToChangeTo = languageModelPathAsString;
	self.dictionaryFileToChangeTo = dictionaryPathAsString;
}

- (void) checkWhetherJSGFSettingOf:(BOOL)languageModelIsJSGF LooksCorrectForThisFilename:(NSString *)languageModelPath {
    
    if([languageModelPath hasSuffix:@".gram"] || [languageModelPath hasSuffix:@".GRAM"] || [languageModelPath hasSuffix:@".grammar"] || [languageModelPath hasSuffix:@".GRAMMAR"] || [languageModelPath hasSuffix:@".jsgf"] || [languageModelPath hasSuffix:@".JSGF"]) {
        
        // This is probably a JSGF file. Let's see if the languageModelIsJSGF seems correct for that case.
        if(!languageModelIsJSGF) { // Probable JSGF file with the ARPA bit set
            if(openears_logging == 1) NSLog(@"The file you've sent to the decoder appears to be a JSGF grammar based on its naming, but you have not set languageModelIsJSGF: to TRUE. If you are experiencing recognition issues, there is a good chance that this is the reason for it.");
        }
        
    } else if([languageModelPath hasSuffix:@".lm"] || [languageModelPath hasSuffix:@".LM"] || [languageModelPath hasSuffix:@".languagemodel"] || [languageModelPath hasSuffix:@".LANGUAGEMODEL"] || [languageModelPath hasSuffix:@".arpa"] || [languageModelPath hasSuffix:@".ARPA"] || [languageModelPath hasSuffix:@".dmp"] || [languageModelPath hasSuffix:@".DMP"]) {
        
        // This is probably an ARPA file. Let's see if the languageModelIsJSGF seems correct for that case.        
        if(languageModelIsJSGF) { // Probable ARPA file with the JSGF bit set
            if(openears_logging == 1) NSLog(@"The file you've sent to the decoder appears to be an ARPA-style language model based on its naming, but you have set languageModelIsJSGF: to TRUE. If you are experiencing recognition issues, there is a good chance that this is the reason for it.");
        }
        
    } else { // It isn't clear from the suffix what kind of file this is, which could easily be a bad sign so let's mention it.
        if(openears_logging == 1) NSLog(@"The LanguageModelAtPath filename that was submitted to listeningLoopWithLanguageModelAtPath: doesn't have a suffix that is usually seen on an ARPA model or a JSGF model, which are the only two kinds of models that OpenEars supports. If you are having difficulty with your project, you should probably take a look at the language model or grammar file you are trying to submit to the decoder and/or its naming.");
    }
}

- (void) listeningLoopWithLanguageModelAtPath:(NSString *)languageModelPath dictionaryAtPath:(NSString *)dictionaryPath languageModelIsJSGF:(BOOL)languageModelIsJSGF { // The big recognition loop.
	
    [self checkWhetherJSGFSettingOf:languageModelIsJSGF LooksCorrectForThisFilename:languageModelPath];
    
    
    static ps_decoder_t *pocketSphinxDecoder; // The Pocketsphinx decoder which will perform the actual speech recognition on recorded speech.
    FILE *err_set_logfp(FILE *logfp); // This function will allow us to make Pocketsphinx run quietly.
    
    
	NSDictionary *userInfoDictionaryForStartup = [NSDictionary dictionaryWithObject:@"PocketsphinxRecognitionLoopDidStart" forKey:@"OpenEarsNotificationType"]; // Forward the info that we're starting to OpenEarsEventsObserver.
	NSNotification *notificationForStartup = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForStartup];
	[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForStartup waitUntilDone:NO];

	if(openears_logging == 1) NSLog(@"Recognition loop has started");
	
	UInt32 maximumAndBufferIndices = 32368;
	int16 audioDeviceBuffer[maximumAndBufferIndices]; // The following are all used by Pocketsphinx.
    int32 speechData;
	int32 timestamp;
	int32 remainingSpeechData;
	int32 recognitionScore;
    char const *hypothesis;
    char const *utteranceID;
    cont_ad_t *continuousListener;
	ps_nbest_t *nbest;
    
    if(verbose_pocketsphinx == 0) {

        err_set_logfp(NULL); // If verbose_pocketsphinx isn't defined, this will quiet the output from Pocketsphinx.
    }
	
    NSArray *commandArray = [self commandArrayForlanguageModel:languageModelPath andDictionaryPath:dictionaryPath isJSGF:languageModelIsJSGF];

	
	char* argv[[commandArray count]]; // We're simulating the command-line run arguments for Pocketsphinx.
	
	for (int i = 0; i < [commandArray count]; i++ ) { // Grab all the set arguments.

		char *argument = const_cast<char*> ([[commandArray objectAtIndex:i]UTF8String]);
		argv[i] = argument;
	}
	
	arg_t cont_args_def[] = { // Grab any extra arguments.
		POCKETSPHINX_OPTIONS,
		{ "-argfile", ARG_STRING, NULL, "Argument file giving extra arguments." },
		CMDLN_EMPTY_OPTION
	};
	
	cmd_ln_t *configuration; // The Pocketsphinx run configuration.
	
    if ([commandArray count] == 2) { // Fail if there aren't really any arguments.
		if(openears_logging == 1) NSLog(@"Initial Pocketsphinx command failed because there aren't any arguments in the command");
		NSDictionary *userInfoDictionaryForContinuousSetupFailure = [NSDictionary dictionaryWithObject:@"PocketsphinxContinuousSetupDidFail" forKey:@"OpenEarsNotificationType"];
		NSNotification *notificationForContinuousSetupFailure = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForContinuousSetupFailure];
		[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForContinuousSetupFailure waitUntilDone:NO];			
        configuration = cmd_ln_parse_file_r(NULL, cont_args_def, argv[1], TRUE);
    }  else { // Set the Pocketsphinx run configuration to the selected arguments and values.
        configuration = cmd_ln_parse_r(NULL, cont_args_def, [commandArray count], argv, FALSE);
    }
	

    pocketSphinxDecoder = ps_init(configuration); // Initialize the decoder.
	
    cmd_ln_free_r(configuration);

    if ((audioDevice = openAudioDevice("device",kSamplesPerSecond)) == NULL) { // Open the audio device (actually the struct containing the Audio Unit).
		if(openears_logging == 1) NSLog(@"openAudioDevice failed");
		NSDictionary *userInfoDictionaryForContinuousSetupFailure = [NSDictionary dictionaryWithObject:@"PocketsphinxContinuousSetupDidFail" forKey:@"OpenEarsNotificationType"];
		NSNotification *notificationForContinuousSetupFailure = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForContinuousSetupFailure];
		[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForContinuousSetupFailure waitUntilDone:NO];		
	}
	
    if ((continuousListener = cont_ad_init(audioDevice, readBufferContents)) == NULL) { // Initialize the continuous recognition module.
        if(openears_logging == 1) NSLog(@"cont_ad_init failed");
		NSDictionary *userInfoDictionaryForContinuousSetupFailure = [NSDictionary dictionaryWithObject:@"PocketsphinxContinuousSetupDidFail" forKey:@"OpenEarsNotificationType"];
		NSNotification *notificationForContinuousSetupFailure = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForContinuousSetupFailure];
		[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForContinuousSetupFailure waitUntilDone:NO];
	}
	
	audioDevice->recordData = 1; // Set the device to record data rather than ignoring it (it will ignore data when PocketsphinxController receives the suspendRecognition method).
	audioDevice->recognitionIsInProgress = 1;
	
    if (startRecording(audioDevice) < 0) { // Start recording.
        if(openears_logging == 1) NSLog(@"startRecording failed");
		NSDictionary *userInfoDictionaryForContinuousSetupFailure = [NSDictionary dictionaryWithObject:@"PocketsphinxContinuousSetupDidFail" forKey:@"OpenEarsNotificationType"];
		NSNotification *notificationForContinuousSetupFailure = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForContinuousSetupFailure];
		[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForContinuousSetupFailure waitUntilDone:NO];
	}
	
	[self setupCalibrationBuffer];
	audioDevice->roundsOfCalibration = 0;
	audioDevice->calibrating = TRUE;
	
	NSDictionary *userInfoDictionaryForCalibrationStarted = [NSDictionary dictionaryWithObject:@"PocketsphinxDidStartCalibration" forKey:@"OpenEarsNotificationType"];
	NSNotification *notificationForCalibrationStarted = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForCalibrationStarted];
	[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForCalibrationStarted waitUntilDone:NO];
	// Forward notification that calibration is starting to OpenEarsEventsObserver.
	if(openears_logging == 1) NSLog(@"Calibration has started");
	
    if(self.calibrationTime != 1 && self.calibrationTime != 2 && self.calibrationTime != 3) {
        self.calibrationTime = 1;
    }
    
	[NSThread sleepForTimeInterval:self.calibrationTime + 1.2]; // Getting some samples in the buffer is necessary before we start calibrating.
    
    continuousListener->calibration_time = self.calibrationTime;
    
    if (cont_ad_calib(continuousListener) < 0) { // Start calibration.
		if(openears_logging == 1) NSLog(@"cont_ad_calib failed");
		NSDictionary *userInfoDictionaryForContinuousSetupFailure = [NSDictionary dictionaryWithObject:@"PocketsphinxContinuousSetupDidFail" forKey:@"OpenEarsNotificationType"];
		NSNotification *notificationForContinuousSetupFailure = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForContinuousSetupFailure];
		[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForContinuousSetupFailure waitUntilDone:NO];
	}
	
	NSDictionary *userInfoDictionaryForCalibrationComplete = [NSDictionary dictionaryWithObject:@"PocketsphinxDidCompleteCalibration" forKey:@"OpenEarsNotificationType"];
	NSNotification *notificationForCalibrationComplete = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForCalibrationComplete];
	[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForCalibrationComplete waitUntilDone:NO];
	// Forward notification that calibration finished to OpenEarsEventsObserver.
	if(openears_logging == 1) NSLog(@"Calibration has completed");
	
	audioDevice->calibrating = FALSE;
	audioDevice->roundsOfCalibration = 0;
	[self putAwayCalibrationBuffer];
	

	
	if(openears_logging == 1) NSLog(@"Project has these words in its dictionary:\n%@", [self compileKnownWordsFromFileAtPath:dictionaryPath]);
	
    for (;;) { // This is the main loop.
				
		self.inMainRecognitionLoop = TRUE; // Note that we're in the main loop.
		
		if(exitListeningLoop == 1) {
			break; // Break if we're trying to exit the loop.
		}
		
		// We're now listening for speech.
		if(openears_logging == 1) NSLog(@"Listening.");
		
		NSArray *objectsArray = [[NSArray alloc] initWithObjects:@"PocketsphinxDidStartListening",nil];
		NSArray *keysArray = [[NSArray alloc] initWithObjects:@"OpenEarsNotificationType",nil];
		NSDictionary *userInfoDictionaryForListening = [[NSDictionary alloc] initWithObjects:objectsArray forKeys:keysArray];
		NSNotification *notificationForListening = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForListening];
		[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForListening waitUntilDone:NO];
		[userInfoDictionaryForListening release];
		[objectsArray release];
		[keysArray release];
		
		// Forward notification that we're now listening for speech to OpenEarsEventsObserver.
		
		// If there is a request to change the lm let's do it here:
		
		if(thereIsALanguageModelChangeRequest == TRUE) {
			
			if(openears_logging == 1) NSLog(@"there is a request to change to the language model file %@", self.languageModelFileToChangeTo);
			
			[self changeLanguageModelForDecoder:pocketSphinxDecoder languageModelIsJSGF:languageModelIsJSGF];
			
		}
        // Wait for speech and sleep when we don't have any yet.
        
        while ((speechData = cont_ad_read(continuousListener, audioDeviceBuffer, maximumAndBufferIndices)) == 0) {
            
            usleep(30000);
            
            if(exitListeningLoop == 1) { 
                break; // Break if we're trying to exit the loop.
            }
            
            if(thereIsALanguageModelChangeRequest == TRUE) {
                break; // Or break if we have a current request for a language model change
            }
        }
        
        if(thereIsALanguageModelChangeRequest == TRUE) { // Loop around to deal with the language model change right now
            continue;
        }
        
        if(exitListeningLoop == 1) {
            break; // Break if we're trying to exit the loop.
        }
        
        if (speechData < 0) { // This is an error.
			if(openears_logging == 1) NSLog(@"cont_ad_read failed");
			NSDictionary *userInfoDictionaryForContinuousSetupFailure = [NSDictionary dictionaryWithObject:@"PocketsphinxContinuousSetupDidFail" forKey:@"OpenEarsNotificationType"];
			NSNotification *notificationForContinuousSetupFailure = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForContinuousSetupFailure];
			[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForContinuousSetupFailure waitUntilDone:NO];			
		}
		
        if (ps_start_utt(pocketSphinxDecoder, NULL) < 0) { // Data has been received and recognition is starting.
			if(openears_logging == 1) NSLog(@"ps_start_utt() failed");
			NSDictionary *userInfoDictionaryForContinuousSetupFailure = [NSDictionary dictionaryWithObject:@"PocketsphinxContinuousSetupDidFail" forKey:@"OpenEarsNotificationType"];
			NSNotification *notificationForContinuousSetupFailure = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForContinuousSetupFailure];
			[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForContinuousSetupFailure waitUntilDone:NO];			
		}
		
        BOOL no_search_false = FALSE; // The crashing bug from this in 0.6.1 appears to be fixed now.
        BOOL full_utt_process_raw_false = FALSE;
        
		ps_process_raw(pocketSphinxDecoder, audioDeviceBuffer, speechData, no_search_false, full_utt_process_raw_false); // Process the data.
		
		if(openears_logging == 1) NSLog(@"Speech detected...");
		
		NSArray *speechNotificationObjectsArray = [[NSArray alloc] initWithObjects:@"PocketsphinxDidDetectSpeech",nil];
		NSArray *speechNotificationKeysArray = [[NSArray alloc] initWithObjects:@"OpenEarsNotificationType",nil];
		NSDictionary *userInfoDictionaryForSpeechDetection = [[NSDictionary alloc] initWithObjects:speechNotificationObjectsArray forKeys:speechNotificationKeysArray];
		NSNotification *notificationForSpeechDetection = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForSpeechDetection];
		[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForSpeechDetection waitUntilDone:NO];
		[userInfoDictionaryForSpeechDetection release];
		[speechNotificationObjectsArray release];
		[speechNotificationKeysArray release];
		// Forward to OpenEarsEventsObserver than speech has been detected.
		
		timestamp = continuousListener->read_ts;
		
		if(exitListeningLoop == 1) {
			break; // Break if we're trying to exit the loop.
		}
		
        for (;;) { // An inner loop in which the received speech will be decoded up to the point of a silence longer than a second.
			
			
			if(exitListeningLoop == 1) {
				break; // Break if we're trying to exit the loop.
			}
            if ((speechData = cont_ad_read(continuousListener, audioDeviceBuffer, maximumAndBufferIndices)) < 0) { // Read the available data.
				
				if(openears_logging == 1) NSLog(@"cont_ad_read failed");
				NSDictionary *userInfoDictionaryForContinuousSetupFailure = [NSDictionary dictionaryWithObject:@"PocketsphinxContinuousSetupDidFail" forKey:@"OpenEarsNotificationType"];
				NSNotification *notificationForContinuousSetupFailure = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForContinuousSetupFailure];
				[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForContinuousSetupFailure waitUntilDone:NO];				
			}
			
			if(exitListeningLoop == 1)  {
				break; // Break if we're trying to exit the loop.
			}
			
            if (speechData == 0) { // No speech data, could be the end of a statement if it's been more than a second since the last received speech.
				
                if ((continuousListener->read_ts - timestamp) > (kSamplesPerSecond * self.secondsOfSilenceToDetect)) {
					
					NSArray *speechFinishedNotificationObjectsArray = [[NSArray alloc] initWithObjects:@"PocketsphinxDidDetectFinishedSpeech",nil];
					NSArray *speechFinishedNotificationKeysArray = [[NSArray alloc] initWithObjects:@"OpenEarsNotificationType",nil];
					NSDictionary *userInfoDictionaryForSpeechFinished = [[NSDictionary alloc] initWithObjects:speechFinishedNotificationObjectsArray forKeys:speechFinishedNotificationKeysArray];
					NSNotification *notificationForSpeechFinished = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForSpeechFinished];
					[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForSpeechFinished waitUntilDone:NO];
					[userInfoDictionaryForSpeechFinished release];
					[speechFinishedNotificationObjectsArray release];
					[speechFinishedNotificationKeysArray release];
                    break;
				}
            } else { // New speech data.
				
				timestamp = continuousListener->read_ts;
            }
			
			if(exitListeningLoop == 1) {
				break; // Break if we're trying to exit the loop.
			}
			// Decode the data.
                        
			remainingSpeechData = ps_process_raw(pocketSphinxDecoder, audioDeviceBuffer, speechData, no_search_false, full_utt_process_raw_false);
			
            if ((remainingSpeechData == 0) && (speechData == 0)) { // If nothing more to be done for now, sleep.
				usleep(5000);
				if(exitListeningLoop == 1) {
					break; // Break if we're trying to exit the loop.
				}
			}
			
			if(exitListeningLoop == 1) {
				break; // Break if we're trying to exit the loop.
			}
        }
		
		if(exitListeningLoop == 1) {
			break; // Break if we're trying to exit the loop.
		}
		audioDevice->endingLoop = TRUE;
		int i;
		for ( i = 0; i < 10; i++ ) {
			readBufferContents(audioDevice, audioDeviceBuffer, maximumAndBufferIndices); // Make several attempts to read anything remaining in the buffer.
		}
		
        stopRecording(audioDevice); // Stop recording.
        audioDevice->endingLoop = FALSE;

        cont_ad_reset(continuousListener); // Reset the continuous module.
		
		if(exitListeningLoop == 1) {
			break; // Break if we're trying to exit the loop.
		}
		if(openears_logging == 1) NSLog(@"Processing speech, please wait...");
		
		ps_end_utt(pocketSphinxDecoder); // The utterance is ended,
		hypothesis = ps_get_hyp(pocketSphinxDecoder, &recognitionScore, &utteranceID); // Return the hypothesis.
		int32 probability = ps_get_prob(pocketSphinxDecoder, &utteranceID);
		
		if(openears_logging == 1) NSLog(@"Pocketsphinx heard \"%s\" with a score of (%d) and an utterance ID of %s.", hypothesis, probability, utteranceID);
		
		NSString *hypothesisString = [[NSString alloc] initWithFormat:@"%s",hypothesis];
		NSString *probabilityString = [[NSString alloc] initWithFormat:@"%d",probability];
		NSString *uttidString = [[NSString alloc] initWithFormat:@"%s",utteranceID];
		NSArray *hypothesisObjectsArray = [[NSArray alloc] initWithObjects:@"PocketsphinxDidReceiveHypothesis",hypothesisString,probabilityString,uttidString,nil];
		NSArray *hypothesisKeysArray = [[NSArray alloc] initWithObjects:@"OpenEarsNotificationType",@"Hypothesis",@"RecognitionScore",@"UtteranceID",nil];
		NSDictionary *userInfoDictionary = [[NSDictionary alloc] initWithObjects:hypothesisObjectsArray forKeys:hypothesisKeysArray];
		NSNotification *notification = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionary];
		[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
		[userInfoDictionary release];
		[hypothesisObjectsArray release];
		[hypothesisKeysArray release];
		[hypothesisString release];
		[probabilityString release];
		[uttidString release];

        if(self.returnNbest == TRUE) { // Let's get n-best if needed
            
            NSMutableArray *nbestMutableArray = [[NSMutableArray alloc] init];

            int32 n;
            nbest = ps_nbest(pocketSphinxDecoder, 0, -1, NULL, NULL);
            n = 1;
            
            while (ps_nbest_next(nbest)) {
                //ps_seg_t *seg;
                hypothesis = ps_nbest_hyp(nbest, &recognitionScore);
                printf("NBEST %d: %s (%d)\n", n, hypothesis, recognitionScore);
                [nbestMutableArray addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%s",hypothesis],[NSNumber numberWithInt:recognitionScore],nil] forKeys:[NSArray arrayWithObjects:@"Hypothesis",@"Score",nil]]];
//                
//                for (seg = ps_nbest_seg(nbest, &recognitionScore); seg; seg = ps_seg_next(seg)) { // Probably not needed by most developers.
//
//                    char const *word;
//                    int sf, ef;
//
//                    word = ps_seg_word(seg);
//                    ps_seg_frames(seg, &sf, &ef);
//                    printf("%s %d %d\n", word, sf, ef);
//                }

                if (n == self.nBestNumber) break;

                ++n;
            }
            
            ps_nbest_free(nbest);
            
            NSArray *nBesthypothesisObjectsArray = [[NSArray alloc] initWithObjects:@"PocketsphinxDidReceiveNbestHypothesisArray",nbestMutableArray,nil];
            NSArray *nBesthypothesisKeysArray = [[NSArray alloc] initWithObjects:@"OpenEarsNotificationType",@"NbestHypothesisArray",nil];
            NSDictionary *userInfoDictionary = [[NSDictionary alloc] initWithObjects:nBesthypothesisObjectsArray forKeys:nBesthypothesisKeysArray];
            NSNotification *notification = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionary];
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
            [userInfoDictionary release];
            [nBesthypothesisObjectsArray release];
            [nBesthypothesisKeysArray release];

            [nbestMutableArray release];
            
        }
        
		if(exitListeningLoop == 1) {
			break; // Break if we're trying to exit the loop.
		}
		
        if (startRecording(audioDevice) < 0) { // Start over.
			if(openears_logging == 1) NSLog(@"startRecording failed");
			NSDictionary *userInfoDictionaryForContinuousSetupFailure = [NSDictionary dictionaryWithObject:@"PocketsphinxContinuousSetupDidFail" forKey:@"OpenEarsNotificationType"];
			NSNotification *notificationForContinuousSetupFailure = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForContinuousSetupFailure];
			[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForContinuousSetupFailure waitUntilDone:NO];			
		}
		
		if(exitListeningLoop == 1) {
			break; // Break if we're trying to exit the loop.
		}
    }
	
	self.inMainRecognitionLoop = FALSE; // We broke out of the loop.
	exitListeningLoop = 0; // We don't want to prompt further exiting attempts since we're out.
	stopRecording(audioDevice); // Stop recording if necessary.
    cont_ad_close(continuousListener); // Close the continuous module.
    ps_free(pocketSphinxDecoder); // Free the decoder.
	
    closeAudioDevice(audioDevice); // Close the device, i.e. stop and dispose of the Audio Unit.

	if(openears_logging == 1) NSLog(@"No longer listening.");	
	
	NSArray *stopListeningObjectsArray = [[NSArray alloc] initWithObjects:@"PocketsphinxDidStopListening",nil];
	NSArray *stopListeningKeysArray = [[NSArray alloc] initWithObjects:@"OpenEarsNotificationType",nil];
	NSDictionary *userInfoDictionaryForStop = [[NSDictionary alloc] initWithObjects:stopListeningObjectsArray forKeys:stopListeningKeysArray];
	NSNotification *stopNotification = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForStop];
	[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:stopNotification waitUntilDone:NO];
	[userInfoDictionaryForStop release];
	[stopListeningObjectsArray release];
	[stopListeningKeysArray release];

}


- (void) runRecognitionOnWavFileAtPath:(NSString *)wavPath usingLanguageModelAtPath:(NSString *)languageModelPath dictionaryAtPath:(NSString *)dictionaryPath languageModelIsJSGF:(BOOL)languageModelIsJSGF { // Listen to a single recording which already exists.
	
    [self checkWhetherJSGFSettingOf:languageModelIsJSGF LooksCorrectForThisFilename:languageModelPath];
    
    static ps_decoder_t *pocketSphinxDecoder; // The Pocketsphinx decoder which will perform the actual speech recognition on recorded speech.
    FILE *err_set_logfp(FILE *logfp); // This function will allow us to make Pocketsphinx run quietly.

	int32 recognitionScore;
    char const *hypothesis;
    char const *utteranceID;
	ps_nbest_t *nbest;
    
if(verbose_pocketsphinx == 0) {
	err_set_logfp(NULL); // If verbose_pocketsphinx isn't defined, this will quiet the output from Pocketsphinx.
}

	NSArray *commandArray = [self commandArrayForlanguageModel:languageModelPath andDictionaryPath:dictionaryPath isJSGF:languageModelIsJSGF];
	
	char* argv[[commandArray count]]; // We're simulating the command-line run arguments for Pocketsphinx.
	
	for (int i = 0; i < [commandArray count]; i++ ) { // Grab all the set arguments.
        
		char *argument = const_cast<char*> ([[commandArray objectAtIndex:i]UTF8String]);
		argv[i] = argument;
	}
	
	arg_t cont_args_def[] = { // Grab any extra arguments.
		POCKETSPHINX_OPTIONS,
		{ "-argfile", ARG_STRING, NULL, "Argument file giving extra arguments." },
		CMDLN_EMPTY_OPTION
	};
	
	cmd_ln_t *configuration; // The Pocketsphinx run configuration.
	
    if ([commandArray count] == 2) { // Fail if there aren't really any arguments.
		if(openears_logging == 1) NSLog(@"Initial Pocketsphinx command failed because there aren't any arguments in the command");
		NSDictionary *userInfoDictionaryForContinuousSetupFailure = [NSDictionary dictionaryWithObject:@"PocketsphinxContinuousSetupDidFail" forKey:@"OpenEarsNotificationType"];
		NSNotification *notificationForContinuousSetupFailure = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForContinuousSetupFailure];
		[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForContinuousSetupFailure waitUntilDone:NO];			
        configuration = cmd_ln_parse_file_r(NULL, cont_args_def, argv[1], TRUE);
    }  else { // Set the Pocketsphinx run configuration to the selected arguments and values.
        configuration = cmd_ln_parse_r(NULL, cont_args_def, [commandArray count], argv, FALSE);
    }
    
    pocketSphinxDecoder = ps_init(configuration); // Initialize the decoder.
	
    if (ps_start_utt(pocketSphinxDecoder, NULL) < 0) { // Data has been received and recognition is starting.
        if(openears_logging == 1) NSLog(@"ps_start_utt() failed");
        NSDictionary *userInfoDictionaryForContinuousSetupFailure = [NSDictionary dictionaryWithObject:@"PocketsphinxContinuousSetupDidFail" forKey:@"OpenEarsNotificationType"];
        NSNotification *notificationForContinuousSetupFailure = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForContinuousSetupFailure];
        [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForContinuousSetupFailure waitUntilDone:NO];			
    }
    
    BOOL no_search_false = FALSE; // The crashing bug from this in 0.6.1 appears to be fixed now.
    BOOL full_utt_process_raw_false = FALSE;
    
    NSData *originalWavData = [NSData dataWithContentsOfFile:wavPath];

    NSData *wavData = [originalWavData subdataWithRange:NSMakeRange(44, [originalWavData length]-44)];

    NSUInteger dataLength = [wavData length];
    SInt16 *wavSamples = (SInt16*)malloc(dataLength);
    memcpy(wavSamples, [wavData bytes], dataLength);

    ps_process_raw(pocketSphinxDecoder, wavSamples, dataLength /2, no_search_false, full_utt_process_raw_false); // Process the data.
    
    ps_end_utt(pocketSphinxDecoder); // The utterance is ended,
    hypothesis = ps_get_hyp(pocketSphinxDecoder, &recognitionScore, &utteranceID); // Return the hypothesis.
    int32 probability = ps_get_prob(pocketSphinxDecoder, &utteranceID);
    
    if(openears_logging == 1) NSLog(@"Pocketsphinx heard \"%s\" with a score of (%d) and an utterance ID of %s.", hypothesis, probability, utteranceID);
    
    NSString *hypothesisString = [[NSString alloc] initWithFormat:@"%s",hypothesis];
    NSString *probabilityString = [[NSString alloc] initWithFormat:@"%d",probability];
    NSString *uttidString = [[NSString alloc] initWithFormat:@"%s",utteranceID];
    NSArray *hypothesisObjectsArray = [[NSArray alloc] initWithObjects:@"PocketsphinxDidReceiveHypothesis",hypothesisString,probabilityString,uttidString,nil];
    NSArray *hypothesisKeysArray = [[NSArray alloc] initWithObjects:@"OpenEarsNotificationType",@"Hypothesis",@"RecognitionScore",@"UtteranceID",nil];
    NSDictionary *userInfoDictionary = [[NSDictionary alloc] initWithObjects:hypothesisObjectsArray forKeys:hypothesisKeysArray];
    NSNotification *notification = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionary];
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
    [userInfoDictionary release];
    [hypothesisObjectsArray release];
    [hypothesisKeysArray release];
    [hypothesisString release];
    [probabilityString release];
    [uttidString release];
    
    if(self.returnNbest == TRUE) { // Let's get n-best if needed
        
        NSMutableArray *nbestMutableArray = [[NSMutableArray alloc] init];
        
        int32 n;
        nbest = ps_nbest(pocketSphinxDecoder, 0, -1, NULL, NULL);
        n = 1;
        
        while (ps_nbest_next(nbest)) {
            //ps_seg_t *seg;
            hypothesis = ps_nbest_hyp(nbest, &recognitionScore);
            printf("NBEST %d: %s (%d)\n", n, hypothesis, recognitionScore);
            [nbestMutableArray addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%s",hypothesis],[NSNumber numberWithInt:recognitionScore],nil] forKeys:[NSArray arrayWithObjects:@"Hypothesis",@"Score",nil]]];
            //                
            //                for (seg = ps_nbest_seg(nbest, &recognitionScore); seg; seg = ps_seg_next(seg)) { // Probably not needed by most developers.
            //
            //                    char const *word;
            //                    int sf, ef;
            //
            //                    word = ps_seg_word(seg);
            //                    ps_seg_frames(seg, &sf, &ef);
            //                    printf("%s %d %d\n", word, sf, ef);
            //                }
            
            if (n == self.nBestNumber) break;
            
            ++n;
        }
        
        ps_nbest_free(nbest);
        
        NSArray *nBesthypothesisObjectsArray = [[NSArray alloc] initWithObjects:@"PocketsphinxDidReceiveNbestHypothesisArray",nbestMutableArray,nil];
        NSArray *nBesthypothesisKeysArray = [[NSArray alloc] initWithObjects:@"OpenEarsNotificationType",@"NbestHypothesisArray",nil];
        NSDictionary *userInfoDictionary = [[NSDictionary alloc] initWithObjects:nBesthypothesisObjectsArray forKeys:nBesthypothesisKeysArray];
        NSNotification *notification = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionary];
        [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
        [userInfoDictionary release];
        [nBesthypothesisObjectsArray release];
        [nBesthypothesisKeysArray release];
        
        [nbestMutableArray release];
        
    }
    
    cmd_ln_free_r(configuration);
    ps_free(pocketSphinxDecoder); // Free the decoder.

}


@end
