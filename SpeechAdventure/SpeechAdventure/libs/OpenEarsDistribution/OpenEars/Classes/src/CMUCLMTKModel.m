
//
//  CMUCLMTKModel.m
//  OpenEars _version 1.1_
//  http://www.politepix.com/openears
//
//  CMUCLMTKModel is a class which abstracts the conversion of vocabulary into language models
//  OpenEars
//
//  Copyright Politepix UG (haftungsbeschränkt) 2012. All rights reserved.
//  http://www.politepix.com
//  Contact at http://www.politepix.com/contact
//
//  This file is licensed under the Politepix Shared Source license found in the root of the source distribution.


#import "CMUCLMTKModel.h"

#import "AudioConstants.h"

#include "ac_lmfunc_impl.h"
#include "text2wfreq.h"
#include "text2idngram.h"
#include "idngram2lm.h"
#include "sphinx_lm_convert.h"

#import "RuntimeVerbosity.h"

@implementation CMUCLMTKModel
@synthesize pathToDocumentsDirectory;
@synthesize verbosity;
@synthesize algorithmType;


extern int openears_logging;
extern int verbose_cmuclmtk;

- (id) init
{
    if ( self = [super init] ) {
        
    
        
        
        
    }
    return self;
}

- (void)dealloc {
    [algorithmType release];
    [pathToDocumentsDirectory release];
    [super dealloc];
}

- (NSString *)pathToDocumentsDirectory {
    if (pathToDocumentsDirectory == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
        NSString *documentsDirectory = [NSString stringWithFormat:@"%@/",[paths objectAtIndex:0]]; // Get documents directory
        pathToDocumentsDirectory = [[NSString alloc] initWithString:documentsDirectory];
    }
    return pathToDocumentsDirectory;
};

- (void) runCMUCLMTKOnCorpusFile:(NSString *)fileName {
  
    if(verbose_cmuclmtk == 1) {
        self.verbosity = 10;
    } else {
        self.verbosity = -1;
    }
    
    NSRange rangeOfSubstring = [fileName rangeOfString:@".corpus"];
    
    NSString *modelName = [fileName substringToIndex:rangeOfSubstring.location];


    NSString *corpusfileName = fileName;
        
    NSString *textfileNameToPipe = [NSString stringWithFormat:@"%@_pipe.txt",modelName];
        
    NSString *vocabFileName = [NSString stringWithFormat:@"%@.vocab",modelName];
        
    NSString *idngramFileName = [NSString stringWithFormat:@"%@.idngram",modelName];
        
    NSString *arpaFileName = [NSString stringWithFormat:@"%@.arpa",modelName];
        
    NSString *dmpFileName = [NSString stringWithFormat:@"%@.DMP",modelName];
    
    NSString *contextCuesFileName = [NSString stringWithFormat:@"%@.ccs",modelName];
    
    FILE *ifp_text2wfreq, *ofp_text2wfreq;
    
    if ((ifp_text2wfreq = fopen([corpusfileName UTF8String], "r")) == NULL) {
        if(openears_logging == 1) NSLog(@"Error: unable to open %s for reading, error:", [corpusfileName UTF8String]);
        if(openears_logging == 1) perror("fopen");

    } else {
        if(openears_logging == 1) NSLog(@"Able to open %s for reading", [corpusfileName UTF8String]);
    }

    if ((ofp_text2wfreq = fopen([textfileNameToPipe UTF8String], "wrb")) == 0) {
        if(openears_logging == 1) NSLog(@"Error: unable to open %s for writing, error:", [textfileNameToPipe UTF8String]);
        if(openears_logging == 1) perror("fopen");


    } else {
        if(openears_logging == 1) NSLog(@"Able to open %s for writing", [textfileNameToPipe UTF8String]);
    }

    if(openears_logging == 1) NSLog(@"Starting text2wfreq_impl");
    
    text2wfreq_impl(ifp_text2wfreq,ofp_text2wfreq,7500,self.verbosity); //7500 is the hash size to use instead of default hash
    
    if(openears_logging == 1) NSLog(@"Done with text2wfreq_impl");
    
    int vocab_size;
    int cutoff;
    int num_recs;
    FILE *ifp_wfreq2vocab, *ofp_wfreq2vocab;
    
    // Process command line 
    
    
    
    cutoff = -1;
    vocab_size = -1;
    num_recs = 64000;
    // verbosity = DEFAULT_VERBOSITY;
    
    // pc_report_unk_args(&argc,argv,verbosity);
    
    if ((ifp_wfreq2vocab=fopen([textfileNameToPipe UTF8String], "rb")) == NULL) {
        if(openears_logging == 1) NSLog(@"Error: unable to open %s for reading. error:", [textfileNameToPipe UTF8String]);

        if(openears_logging == 1) perror("fopen");

    } else {
        if(openears_logging == 1) NSLog(@"Able to open %s for reading.", [textfileNameToPipe UTF8String]);
    }

    if ((ofp_wfreq2vocab=fopen([vocabFileName UTF8String], "wrb")) == NULL) {
        if(openears_logging == 1) NSLog(@"Error: unable to open %s for writing error:", [vocabFileName UTF8String]);

        if(openears_logging == 1) perror("fopen");

    } else {
        if(openears_logging == 1) NSLog(@"Able to open %s for reading.", [vocabFileName UTF8String]);
    }
    
    // ifp2=fopen([[self.pathToDocumentsDirectory stringByAppendingPathComponent:textfileNameToPipe]UTF8String], "rb");    
    // ofp2=fopen([[self.pathToDocumentsDirectory stringByAppendingPathComponent:vocabFileName]UTF8String], "wrb");
    
    if(openears_logging == 1) NSLog(@"Starting wfreq2vocab");
    
    
    
    

    
    
    
    
    wfreq2vocab_impl(ifp_wfreq2vocab,ofp_wfreq2vocab,cutoff, vocab_size,num_recs,self.verbosity);
    
    
    
        if(openears_logging == 1) NSLog(@"Done with wfreq2vocab");
    
    
//     fprintf(stderr,"text2idngram - Convert a text stream to an id n-gram stream.\n");
//     fprintf(stderr,"Usage : text2idngram  -vocab .vocab \n");
//     fprintf(stderr,"                      -idngram .idngram\n");
//     fprintf(stderr,"                    [ -buffer 100 ]\n");
//     fprintf(stderr,"                    [ -hash %d ]\n",DEFAULT_HASH_SIZE);
//     fprintf(stderr,"                    [ -files %d ]\n",DEFAULT_MAX_FILES);
//     fprintf(stderr,"                    [ -gzip | -compress ]\n");
//     fprintf(stderr,"                    [ -verbosity %d ]\n",DEFAULT_VERBOSITY);
//     fprintf(stderr,"                    [ -n 3 ]\n");
//     fprintf(stderr,"                    [ -write_ascii ]\n");
//     fprintf(stderr,"                    [ -fof_size 10 ]\n");
//     fprintf(stderr,"                    [ -version ]\n");
//     fprintf(stderr,"                    [ -help ]\n");
     
    
    
    
    NSMutableArray *commandArray_text2idngram = [[NSMutableArray alloc] init]; // This is an array that is used to set up the run arguments
    
    [commandArray_text2idngram addObject: @"-vocab" ];
    [commandArray_text2idngram addObject: vocabFileName];
    [commandArray_text2idngram addObject:@"-idngram" ];
    
    [commandArray_text2idngram addObject: idngramFileName];
    [commandArray_text2idngram addObject: @"-textfile" ];
    [commandArray_text2idngram addObject:corpusfileName]; 
    [commandArray_text2idngram addObject: @"-temp_directory" ];
    [commandArray_text2idngram addObject:[self.pathToDocumentsDirectory stringByAppendingPathComponent:@"cmuclmtk-XXXXXX"]];     
    
    
    
    
    
    [commandArray_text2idngram insertObject:@"text2idngram" atIndex:0]; // This gets everything at the expected index
    
    char* argv[[commandArray_text2idngram count]]; // 
    
    for (int i = 0; i < [commandArray_text2idngram count]; i++ ) { // Grab all the set arguments.
        
        char *argument = (char *) ([[commandArray_text2idngram objectAtIndex:i]UTF8String]);
        argv[i] = argument;
    }

    if(openears_logging == 1) NSLog(@"Starting text2idngram");
    
    text2idngram_main([commandArray_text2idngram count],argv);
    
    [commandArray_text2idngram release];
    
    if(openears_logging == 1) NSLog(@"Done with text2idngram");
    
    
    // idngram2lm -vocab_type 0 -idngram weather.idngram -vocab \
    // weather.vocab -arpa weather.arpa
     
     
    
    NSString *corpusString = @"<s>\n</s>";

    
    NSError *error;
    BOOL successfulWrite = [corpusString writeToFile:contextCuesFileName atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (!successfulWrite){
        // Handle error here
        if(openears_logging == 1) NSLog(@"Error: context cues file was not written out, %@", [error description]);
    }
    
//    fprintf(stderr,"idngram2lm : Convert an idngram file to a language model file.\n");
//    fprintf(stderr,"Usage : \n");
//    fprintf(stderr,"idngram2lm -idngram .idngram\n");
//    fprintf(stderr,"           -vocab .vocab\n");
//    fprintf(stderr,"           -arpa .arpa | -binary .binlm\n");
//    fprintf(stderr,"         [ -context .ccs ]\n");
//    fprintf(stderr,"         [ -calc_mem | -buffer 100 | -spec_num y ... z ]\n");
//    fprintf(stderr,"         [ -vocab_type 1 ]\n");
//    fprintf(stderr,"         [ -oov_fraction 0.5 ]\n");
//    fprintf(stderr,"         [ -two_byte_bo_weights   \n              [ -min_bo_weight nnnnn] [ -max_bo_weight nnnnn] [ -out_of_range_bo_weights] ]\n");
//    fprintf(stderr,"         [ -four_byte_counts ]\n");
//    fprintf(stderr,"         [ -linear | -absolute | -good_turing | -witten_bell ]\n");
//    fprintf(stderr,"         [ -disc_ranges 1 7 7 ]\n");
//    fprintf(stderr,"         [ -cutoffs 0 ... 0 ]\n");
//    fprintf(stderr,"         [ -min_unicount 0 ]\n");
//    fprintf(stderr,"         [ -zeroton_fraction ]\n");
//    fprintf(stderr,"         [ -ascii_input | -bin_input ]\n");
//    fprintf(stderr,"         [ -n 3 ]  \n");
//    fprintf(stderr,"         [ -verbosity %d ]\n",DEFAULT_VERBOSITY);
    
    
    NSMutableArray *commandArray_idngram2lm = [[NSMutableArray alloc] init]; // This is an array that is used to set up the run arguments
    
    [commandArray_idngram2lm addObject: @"-vocab_type" ];
    [commandArray_idngram2lm addObject: @"0"];
    [commandArray_idngram2lm addObject:@"-idngram" ];
    
    [commandArray_idngram2lm addObject: idngramFileName];
    [commandArray_idngram2lm addObject: @"-vocab" ];
    [commandArray_idngram2lm addObject:vocabFileName]; 
    [commandArray_idngram2lm addObject: @"-arpa" ];
    [commandArray_idngram2lm addObject:arpaFileName];     
    [commandArray_idngram2lm addObject: @"-context" ];
    [commandArray_idngram2lm addObject:contextCuesFileName];
    if(self.algorithmType == nil)self.algorithmType = @"-witten_bell"; // Witten-Bell seems to be the method that is the most flexible across large and small vocabs
    [commandArray_idngram2lm addObject:self.algorithmType];
    [commandArray_idngram2lm addObject:@"-verbosity"];
    [commandArray_idngram2lm addObject:[NSString stringWithFormat:@"%d",self.verbosity]];
    
    [commandArray_idngram2lm insertObject:@"idngram2lm" atIndex:0]; // This gets everything at the expected index
    
    char* argv2[[commandArray_idngram2lm count]]; // 
    
    for (int i = 0; i < [commandArray_idngram2lm count]; i++ ) { // Grab all the set arguments.
        
        char *argument = (char *) ([[commandArray_idngram2lm objectAtIndex:i]UTF8String]);
        argv2[i] = argument;
    }

    if(openears_logging == 1) NSLog(@"Starting idngram2lm");

    
    idngram2lm_main([commandArray_idngram2lm count],argv2);
    
    [commandArray_idngram2lm release];
    
    
    if(openears_logging == 1) NSLog(@"Done with idngram2lm");

    
    
    NSMutableArray *commandArray_sphinx_lm_convert = [[NSMutableArray alloc] init]; // This is an array that is used to set up the run arguments
    
    [commandArray_sphinx_lm_convert addObject: @"-i" ];
    [commandArray_sphinx_lm_convert addObject: arpaFileName];
    [commandArray_sphinx_lm_convert addObject:@"-o" ];
    
    [commandArray_sphinx_lm_convert addObject: dmpFileName];
    if(verbose_cmuclmtk == 1) {
         [commandArray_sphinx_lm_convert addObject:@"-debug" ];
        [commandArray_sphinx_lm_convert addObject:@"10" ];
    }
    
    //dmpFileName
    //-i weather.arpa -o weather.lm.DMP
    
    [commandArray_sphinx_lm_convert insertObject:@"sphinx_lm_convert" atIndex:0]; // This gets everything at the expected index
    
    char* argv3[[commandArray_sphinx_lm_convert count]]; // 
    
    for (int i = 0; i < [commandArray_sphinx_lm_convert count]; i++ ) { // Grab all the set arguments.
        
        char *argument = (char *) ([[commandArray_sphinx_lm_convert objectAtIndex:i]UTF8String]);
        argv3[i] = argument;
    }

    if(openears_logging == 1) NSLog(@"Starting sphinx_lm_convert");
    
    sphinx_lm_convert_main([commandArray_sphinx_lm_convert count],argv3);
    
    if(openears_logging == 1) NSLog(@"Starting sphinx_lm_convert");
    
    [commandArray_sphinx_lm_convert release];
    
    // Remove the working files
    
    if (remove([textfileNameToPipe UTF8String]) == -1) { 
        NSLog(@"couldn't delete the file %@\n", textfileNameToPipe);
    }
    if (remove([vocabFileName UTF8String]) == -1) { 
        NSLog(@"couldn't delete the file %@\n", vocabFileName);
    }
    if (remove([idngramFileName UTF8String]) == -1) { 
        NSLog(@"couldn't delete the file %@\n", idngramFileName);
    }
    if (remove([contextCuesFileName UTF8String]) == -1) {
        NSLog(@"couldn't delete the file %@\n", contextCuesFileName);
    }
   
}




@end
