//  OpenEars _version 1.1_
//  http://www.politepix.com/openears
//
//  ContinuousAudioUnit.mm
//  OpenEars
//
//  ContinuousAudioUnit is a class which handles the interaction between the Pocketsphinx continuous recognition loop and Core Audio.
//
//  Copyright Politepix UG (haftungsbeschränkt) 2012
//  http://www.politepix.com
//  Contact at http://www.politepix.com/contact
//
//  This file is licensed under the Politepix Shared Source license found in the root of the source distribution.

#if defined TARGET_IPHONE_SIMULATOR && TARGET_IPHONE_SIMULATOR // This is the driver for the simulator only, since the low-latency audio unit driver doesn't work with the simulator at all.
#import "AudioQueueFallback.h"

#else

#import "ContinuousAudioUnit.h"

#import "RuntimeVerbosity.h"
extern int openears_logging;

static PocketsphinxAudioDevice *audioDriver;

#pragma mark -
#pragma mark Audio Unit Callback
static OSStatus	AudioUnitRenderCallback (void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData) {
	
	if (inNumberFrames > 0) {

		OSStatus renderStatus = AudioUnitRender(audioDriver->audioUnit, ioActionFlags, inTimeStamp,1, inNumberFrames, ioData);
		
		if(renderStatus != noErr) {
			switch (renderStatus) {
				case kAudioUnitErr_InvalidProperty:
					if(openears_logging == 1) NSLog(@"Audio Unit render error: kAudioUnitErr_InvalidProperty");
					break;
				case kAudioUnitErr_InvalidParameter:
					if(openears_logging == 1) NSLog(@"Audio Unit render error: kAudioUnitErr_InvalidParameter");
					break;
				case kAudioUnitErr_InvalidElement:
					if(openears_logging == 1) NSLog(@"Audio Unit render error: kAudioUnitErr_InvalidElement");
					break;
				case kAudioUnitErr_NoConnection:
					if(openears_logging == 1) NSLog(@"Audio Unit render error: kAudioUnitErr_NoConnection");
					break;
				case kAudioUnitErr_FailedInitialization:
					if(openears_logging == 1) NSLog(@"Audio Unit render error: kAudioUnitErr_FailedInitialization");
					break;
				case kAudioUnitErr_TooManyFramesToProcess:
					if(openears_logging == 1) NSLog(@"Audio Unit render error: kAudioUnitErr_TooManyFramesToProcess");
					break;
				case kAudioUnitErr_InvalidFile:
					if(openears_logging == 1) NSLog(@"Audio Unit render error: kAudioUnitErr_InvalidFile");
					break;
				case kAudioUnitErr_FormatNotSupported:
					if(openears_logging == 1) NSLog(@"Audio Unit render error: kAudioUnitErr_FormatNotSupported");
					break;
				case kAudioUnitErr_Uninitialized:
					if(openears_logging == 1) NSLog(@"Audio Unit render error: kAudioUnitErr_Uninitialized");
					break;
				case kAudioUnitErr_InvalidScope:
					if(openears_logging == 1) NSLog(@"Audio Unit render error: kAudioUnitErr_InvalidScope");
					break;
				case kAudioUnitErr_PropertyNotWritable:
					if(openears_logging == 1) NSLog(@"Audio Unit render error: kAudioUnitErr_PropertyNotWritable");
					break;
				case kAudioUnitErr_CannotDoInCurrentContext:
					if(openears_logging == 1) NSLog(@"Audio Unit render error: kAudioUnitErr_CannotDoInCurrentContext");
					break;
				case kAudioUnitErr_InvalidPropertyValue:
					if(openears_logging == 1) NSLog(@"Audio Unit render error: kAudioUnitErr_InvalidPropertyValue");
					break;
				case kAudioUnitErr_PropertyNotInUse:
					if(openears_logging == 1) NSLog(@"Audio Unit render error: kAudioUnitErr_PropertyNotInUse");
					break;
				case kAudioUnitErr_InvalidOfflineRender:
					if(openears_logging == 1) NSLog(@"Audio Unit render error: kAudioUnitErr_InvalidOfflineRender");
					break;
				case kAudioUnitErr_Unauthorized:
					if(openears_logging == 1) NSLog(@"Audio Unit render error: kAudioUnitErr_Unauthorized");
					break;
				case -50:
					if(openears_logging == 1) NSLog(@"Audio Unit render error: error in user parameter list (-50)");
					break;														
				default:
					if(openears_logging == 1) NSLog(@"Audio Unit render error %d: unknown error", (int)renderStatus);
					break;
			}
			
			return renderStatus;
			
		} else { // if the render was successful,
			
			
			if (inNumberFrames > 0 && (audioDriver->recordData == 1 && audioDriver->recognitionIsInProgress == 1) && audioDriver->endingLoop == FALSE) {
				
				// let's only do the following when we aren't calibrating for now
				
				if(audioDriver->calibrating == FALSE) {
					
					
					SInt16 chunkToWriteTo;
					// Increment indexOfLastWrittenChunk unless it is equal to numberofchunks in which case loop around and set it to zero. 
					// Then use lastchunkwritten as the indicator of what chunk to do stuff to.
					
					if(audioDriver->indexOfLastWrittenChunk == kNumberOfChunksInRingbuffer-1) { // If we're on the last index, loop around to zero.
						chunkToWriteTo = 0;
					} else { // Otherwise increment indexOfLastWrittenChunk.
						chunkToWriteTo = audioDriver->indexOfLastWrittenChunk+1;
					}
					
					// First of all we'll need to add some extra samples if there are any waiting for us.
					if(audioDriver->extraSamples == TRUE) {
						audioDriver->extraSamples = FALSE;
						// add the extra samples from the buffer
						memcpy((SInt16 *)audioDriver->ringBuffer[chunkToWriteTo].buffer,(SInt16 *)audioDriver->extraSampleBuffer,audioDriver->numberOfExtraSamples*2); // Copy this unit's samples into the ringbuffer
						
						memcpy((SInt16 *)audioDriver->ringBuffer[chunkToWriteTo].buffer + audioDriver->numberOfExtraSamples,(SInt16 *)ioData->mBuffers[0].mData,inNumberFrames*2); // Copy this unit's samples into the ringbuffer
						
						audioDriver->ringBuffer[chunkToWriteTo].numberOfSamples = inNumberFrames + audioDriver->numberOfExtraSamples; // set this ringbuffer chunk's numberOfSamples to the unit's inNumberFrames.
						
						audioDriver->ringBuffer[chunkToWriteTo].writtenTimestamp = CFAbsoluteTimeGetCurrent(); // Timestamp when we wrote this so the read function can decide if it's read this chunk already or not.
						
					} else {
						memcpy(audioDriver->ringBuffer[chunkToWriteTo].buffer,(SInt16 *)ioData->mBuffers[0].mData,inNumberFrames*2); // Copy this unit's samples into the ringbuffer
						
						audioDriver->ringBuffer[chunkToWriteTo].numberOfSamples = inNumberFrames; // set this ringbuffer chunk's numberOfSamples to the unit's inNumberFrames.
						
						audioDriver->ringBuffer[chunkToWriteTo].writtenTimestamp = CFAbsoluteTimeGetCurrent(); // Timestamp when we wrote this so the read function can decide if it's read this chunk already or not.
						
					}
					
					if(audioDriver->indexOfLastWrittenChunk == kNumberOfChunksInRingbuffer-1) { // If we're on the last index, loop around to zero.
						audioDriver->indexOfLastWrittenChunk = 0;
					} else { // Otherwise increment indexOfLastWrittenChunk.
						audioDriver->indexOfLastWrittenChunk++;
					}

					SInt16 *samples = (SInt16 *)ioData->mBuffers[0].mData;
					getDecibels(samples,inNumberFrames); // Get the decibels
					
					// That's it.
					
					
				} else { 
					
					if(audioDriver->roundsOfCalibration == 0 || audioDriver->roundsOfCalibration == 1) {
						// Ignore the first couple of buffers, they are sometimes full of null input.
						audioDriver->roundsOfCalibration++;
					} else {
						
						SInt16 *calibrationSamples = (SInt16 *)(ioData->mBuffers[0].mData);
						
						int i;
						for ( i = 0; i < inNumberFrames; i++ ) {  //So when we get here, we loop through the frames and write the samples there to the calibration buffer starting at the last end index we stopped at
							audioDriver->calibrationBuffer[i + audioDriver->availableSamplesDuringCalibration] = calibrationSamples[i];
						}
						audioDriver->availableSamplesDuringCalibration = audioDriver->availableSamplesDuringCalibration + inNumberFrames;
					}
				}
			}
			
			memset(ioData->mBuffers[0].mData, 0, ioData->mBuffers[0].mDataByteSize); // write out silence to the buffer for no-playback times
		}
		
	}
	
	return 0;
}

void getDecibels(SInt16 * samples, UInt32 inNumberFrames) {
	
	Float32 decibels = kDBOffset; // When we have no signal we'll leave this on the lowest setting
	Float32 currentFilteredValueOfSampleAmplitude; 
	Float32 previousFilteredValueOfSampleAmplitude = 0.0; // We'll need these in the low-pass filter
	Float32 peakValue = kDBOffset; // We'll end up storing the peak value here
	
	for (int i=0; i < inNumberFrames; i=i+10) { // We're incrementing this by 10 because there's actually too much info here for us for a conventional UI timeslice and it's a cheap way to save CPU
		
		Float32 absoluteValueOfSampleAmplitude = abs(samples[i]); //Step 2: for each sample, get its amplitude's absolute value.
		
		// Step 3: for each sample's absolute value, run it through a simple low-pass filter
		// Begin low-pass filter
		currentFilteredValueOfSampleAmplitude = kLowPassFilterTimeSlice * absoluteValueOfSampleAmplitude + (1.0 - kLowPassFilterTimeSlice) * previousFilteredValueOfSampleAmplitude;
		previousFilteredValueOfSampleAmplitude = currentFilteredValueOfSampleAmplitude;
		Float32 amplitudeToConvertToDB = currentFilteredValueOfSampleAmplitude;
		// End low-pass filter
		
		Float32 sampleDB = 20.0*log10(amplitudeToConvertToDB) + kDBOffset;
		// Step 4: for each sample's filtered absolute value, convert it into decibels
		// Step 5: for each sample's filtered absolute value in decibels, add an offset value that normalizes the clipping point of the device to zero.
		
		if((sampleDB == sampleDB) && (sampleDB <= DBL_MAX && sampleDB >= -DBL_MAX)) { // if it's a rational number and isn't infinite
			
			if(sampleDB > peakValue) peakValue = sampleDB; // Step 6: keep the highest value you find.
			decibels = peakValue; // final value
		}
	}
	audioDriver->pocketsphinxDecibelLevel = decibels;
}

void setRoute() {
	CFStringRef audioRoute;
	UInt32 audioRouteSize = sizeof(CFStringRef);
	OSStatus getAudioRouteStatus = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &audioRouteSize, &audioRoute); // Get the audio route.
	if (getAudioRouteStatus != 0) {
		if(openears_logging == 1) NSLog(@"Error %d: Unable to get the audio route.", (int)getAudioRouteStatus);
	} else {
		if(openears_logging == 1) NSLog(@"Set audio route to %@", (NSString *)audioRoute);	
	}
	
	audioDriver->currentRoute = audioRoute; // Set currentRoute to the audio route.
}

#pragma mark -
#pragma mark Pocketsphinx driver functionality

PocketsphinxAudioDevice *openAudioDevice(const char *dev, int32 samples_per_sec) {
    
	if(openears_logging == 1) NSLog(@"Starting openAudioDevice on the device.");
					
	if(audioDriver != NULL) { // Audio unit wrapper has already been created
		closeAudioDevice(audioDriver);
	}
	
	if ((audioDriver = (PocketsphinxAudioDevice *) calloc(1, sizeof(PocketsphinxAudioDevice))) == NULL) {
		if(openears_logging == 1) NSLog(@"There was an error while creating the device, returning null device.");
		return NULL;
	} else {
		if(openears_logging == 1) NSLog(@"Audio unit wrapper successfully created.");
	}
	
	audioDriver->audioUnitIsRunning = 0;
	audioDriver->recording = 0;
	audioDriver->sps = kSamplesPerSecond;
	audioDriver->bps = 2;
	audioDriver->pocketsphinxDecibelLevel = 0.0;

	AURenderCallbackStruct inputProc;
	inputProc.inputProc = AudioUnitRenderCallback;
	inputProc.inputProcRefCon = audioDriver;
	
	AudioComponentDescription auDescription;
	
	auDescription.componentType = kAudioUnitType_Output;
	auDescription.componentSubType = kAudioUnitSubType_RemoteIO;
	auDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
	auDescription.componentFlags = 0;
	auDescription.componentFlagsMask = 0;
	
	AudioComponent component = AudioComponentFindNext(NULL, &auDescription);
	
	OSStatus newAudioUnitComponentInstanceStatus = AudioComponentInstanceNew(component, &audioDriver->audioUnit);
	if(newAudioUnitComponentInstanceStatus != noErr) {
		if(openears_logging == 1) NSLog(@"Couldn't get new audio unit component instance: %d",(int)newAudioUnitComponentInstanceStatus);
		audioDriver->unitIsRunning = 0;
		return NULL;
	}

	UInt32 maximumFrames = 4096;
	OSStatus maxFramesStatus = AudioUnitSetProperty(audioDriver->audioUnit, kAudioUnitProperty_MaximumFramesPerSlice, kAudioUnitScope_Global, 0, &maximumFrames, sizeof(maximumFrames));
	if(maxFramesStatus != noErr) {
		if(openears_logging == 1) NSLog(@"Error %d: unable to set maximum frames property.", (int)maxFramesStatus);
	}
	
	UInt32 enableIO = 1;
	
	OSStatus setEnableIOStatus = AudioUnitSetProperty(audioDriver->audioUnit, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Input, 1, &enableIO, sizeof(enableIO));
	if(setEnableIOStatus != noErr) {
		if(openears_logging == 1) NSLog(@"Couldn't enable IO: %d",(int)setEnableIOStatus);
		audioDriver->unitIsRunning = 0;
		return NULL;
	}
	
	OSStatus setRenderCallbackStatus = AudioUnitSetProperty(audioDriver->audioUnit, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, 0, &inputProc, sizeof(inputProc));
	if(setRenderCallbackStatus != noErr) {
		if(openears_logging == 1) NSLog(@"Couldn't set render callback: %d",(int)setRenderCallbackStatus);
		audioDriver->unitIsRunning = 0;
		return NULL;
	}
	
	audioDriver->thruFormat.mChannelsPerFrame = 1; 
	audioDriver->thruFormat.mSampleRate = kSamplesPerSecond; 
	audioDriver->thruFormat.mFormatID = kAudioFormatLinearPCM;
	audioDriver->thruFormat.mBytesPerPacket = audioDriver->thruFormat.mChannelsPerFrame * audioDriver->bps;
	audioDriver->thruFormat.mFramesPerPacket = 1;
	audioDriver->thruFormat.mBytesPerFrame = audioDriver->thruFormat.mBytesPerPacket;
	audioDriver->thruFormat.mBitsPerChannel = 16; 
	audioDriver->thruFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
	
	OSStatus setInputFormatStatus = AudioUnitSetProperty(audioDriver->audioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &audioDriver->thruFormat, sizeof(audioDriver->thruFormat));
	if(setInputFormatStatus != noErr) {
		if(openears_logging == 1) NSLog(@"Couldn't set stream input format: %d",(int)setInputFormatStatus);
		audioDriver->unitIsRunning = 0;
		return NULL;
	}
	
	OSStatus setOutputFormatStatus = AudioUnitSetProperty(audioDriver->audioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 1, &audioDriver->thruFormat, sizeof(audioDriver->thruFormat));
	if(setOutputFormatStatus != noErr) {
		if(openears_logging == 1) NSLog(@"Couldn't set stream output format: %d",(int)setOutputFormatStatus);
		audioDriver->unitIsRunning = 0;
		return NULL;
	}
	
	OSStatus audioUnitInitializeStatus = AudioUnitInitialize(audioDriver->audioUnit);
	if(audioUnitInitializeStatus != noErr) {
		
		if(openears_logging == 1) NSLog(@"Couldn't initialize audio unit: %d", (int)audioUnitInitializeStatus);
		audioDriver->unitIsRunning = 0;
		return NULL;
	}
	
	audioDriver->unitIsRunning = 1;			
	audioDriver->deviceIsOpen = 1;
	
	setRoute();
	
    return audioDriver;
}

int32 startRecording(PocketsphinxAudioDevice * audioDevice) {
	
	if (audioDriver->recording == 1) {
		if(openears_logging == 1) NSLog(@"This driver is already recording, returning.");
        return -1;
	}
	
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetAllAudioSessionSettings" object:nil]; // We'll first check that all the audio session settings are correct for recognition and fix them if not.
    
	if(openears_logging == 1) NSLog(@"Setting the variables for the device and starting it.");
	
	audioDriver->roundsOfCalibration = 0;
	audioDriver->endingLoop = FALSE;
	
	audioDriver->extraSamples = FALSE;
	audioDriver->numberOfExtraSamples = 0;
	
	if(audioDriver->extraSampleBuffer == NULL) {
		audioDriver->extraSampleBuffer = (SInt16 *)malloc(kExtraSampleBufferSize);		
	} else {
		audioDriver->extraSampleBuffer = (SInt16 *)realloc(audioDriver->extraSampleBuffer, kExtraSampleBufferSize); // ~16000 is the probable number coming in, x4 for safety and device independence.		
	}

	if(openears_logging == 1) NSLog(@"Looping through ringbuffer sections and pre-allocating them.");

	int i;
	for ( i = 0; i < kNumberOfChunksInRingbuffer; i++ ) { // malloc each individual buffer in the ringbuffer in advance to an overall size with some wiggle room.
		
		if(audioDriver->ringBuffer[i].buffer == NULL) {
			audioDriver->ringBuffer[i].buffer = (SInt16 *)malloc(kChunkSizeInBytes);
		} else {
			audioDriver->ringBuffer[i].buffer = (SInt16 *)realloc(audioDriver->ringBuffer[i].buffer, kChunkSizeInBytes);
		}

		audioDriver->ringBuffer[i].numberOfSamples = 0;
		audioDriver->ringBuffer[i].writtenTimestamp = CFAbsoluteTimeGetCurrent();
	}
	
	int j;
	for ( j = 0; j < kNumberOfChunksInRingbuffer; j++ ) { // set the consumed time stamps to now.
		audioDriver->consumedTimeStamp[j] = CFAbsoluteTimeGetCurrent();
	}
	
	audioDriver->indexOfLastWrittenChunk = kNumberOfChunksInRingbuffer-1;
	audioDriver->indexOfChunkToRead = 0;
	
	audioDriver->calibrating = 0;

	
	OSStatus startAudioUnitOutputStatus = AudioOutputUnitStart(audioDriver->audioUnit);
	if(startAudioUnitOutputStatus != noErr) {
		if(openears_logging == 1) NSLog(@"Couldn't start audio unit output: %d", (int)startAudioUnitOutputStatus);	
		return -1;
	} else {
		if(openears_logging == 1) NSLog(@"Started audio output unit.");		
	}

	audioDriver->audioUnitIsRunning = 1; // Set audioUnitIsRunning to true.
	
	audioDriver->recording = 1;
	
    return 0;
}

int32 stopRecording(PocketsphinxAudioDevice * audioDevice) {
	
	if (audioDriver->recording == 0) {
		if(openears_logging == 1) NSLog(@"Can't stop audio device because it isn't currently recording, returning instead.");	
		return -1; // bail if this ad doesn't think it's recording
	}
	
	if(audioDriver->audioUnitIsRunning == 1) { // only stop recording if there is actually a unit
		if(openears_logging == 1) NSLog(@"Stopping audio unit.");	

		OSStatus stopAudioUnitStatus = AudioOutputUnitStop(audioDriver->audioUnit);
		if(stopAudioUnitStatus != noErr) {
			if(openears_logging == 1) NSLog(@"Couldn't stop audio unit: %d", (int)stopAudioUnitStatus);
			return -1;
		} else {
			if(openears_logging == 1) NSLog(@"Audio Output Unit stopped, cleaning up variable states.");	
		}
		
	} else {
		if(openears_logging == 1) NSLog(@"Cleaning up driver variable states.");	
	}

	audioDriver->extraSamples = FALSE;
	audioDriver->numberOfExtraSamples = 0;
	audioDriver->endingLoop = FALSE;
	audioDriver->calibrating = 0;
	audioDriver->recording = 0;
	
    return 0;
}

Float32 pocketsphinxAudioDeviceMeteringLevel(PocketsphinxAudioDevice * audioDriver) { // Function which returns the metering level of the AudioUnit input.

	if(audioDriver != NULL && audioDriver->pocketsphinxDecibelLevel && audioDriver->pocketsphinxDecibelLevel > -161 && audioDriver->pocketsphinxDecibelLevel < 1) {
		return audioDriver->pocketsphinxDecibelLevel;
	}
	return 0.0;	
}

int32 closeAudioDevice(PocketsphinxAudioDevice * audioDevice) {
	

	
	if (audioDriver->recording == 1) {
		if(openears_logging == 1) NSLog(@"This device is recording, so we will first stop it");
		stopRecording(audioDriver);
		audioDriver->recording = 0;

	} else {
		if(openears_logging == 1) NSLog(@"This device is not recording, so first we will set its recording status to 0");
		audioDriver->recording = 0;
	}

	if(audioDriver->audioUnitIsRunning == 1) {
		if(openears_logging == 1) NSLog(@"The audio unit is running so we are going to dispose of its instance");		
		OSStatus instanceDisposeStatus = AudioComponentInstanceDispose(audioDriver->audioUnit);
		
		if(instanceDisposeStatus != noErr) {
			if(openears_logging == 1) NSLog(@"Couldn't dispose of audio unit instance: %d", (int)instanceDisposeStatus);
			return -1;
		}

		audioDriver->audioUnit = nil;
	}
	
	if(audioDriver->extraSampleBuffer != NULL) {
		free(audioDriver->extraSampleBuffer); // Let's free the extra sample buffer now.
		audioDriver->extraSampleBuffer = NULL;
	}
		
	int i;
	for ( i = 0; i < kNumberOfChunksInRingbuffer; i++ ) { // free each individual chunk in the ringbuffer
		if(audioDriver->ringBuffer[i].buffer != NULL) {
			free(audioDriver->ringBuffer[i].buffer);
			audioDriver->ringBuffer[i].buffer = NULL;
		}
	}
	
	if(audioDriver != NULL) {
		audioDriver->deviceIsOpen = 0;	
		free(audioDriver); 	// Finally, free the Sphinx audio device.
		audioDriver = NULL;
	}
	
    return 0;
}

int32 readBufferContents(PocketsphinxAudioDevice * audioDevice, int16 * buffer, int32 maximum) { // Scan the buffer for speech.
	
	// Only read if we're recording.
	
	if(audioDevice->recording == 0) {
		return -1;
	}
	
	// let's only do the following when we aren't calibrating
	
	if(audioDriver->calibrating == FALSE) {
		
		// So, we have a ringbuffer that may or may not have fresh data for us to read.
		// We want to start out with the first read at chunk zero and sample zero, so this has to be set in StartRecording().
		// We will know if there is nothing there yet to read if chunk index zero has a read datestamp that is fresher than its written datestamp. If that happens it should return zero samples.
		// If that doesn't happen it should read the contents of the chunk for the full reported number of its samples (or max, whichever is smaller) and return the number of samples or max, datestamp the chunk 
		// and then increment the current chunk index.  SIMPLES!
		
		// For the current chunk, compare its timestamp to the timestamp of that chunk index in the ringbuffer and see which is fresher:
		
		if(audioDriver->ringBuffer[audioDriver->indexOfChunkToRead].writtenTimestamp>=audioDriver->consumedTimeStamp[audioDriver->indexOfChunkToRead]) { // If this chunk was written to more recently than it was read, it can be read.
			
			// What we're gonna do:
			// Read the whole chunk, return its number of samples, timestamp the index for this chunk.	
			// Put the total number of samples or max, whichever is smaller, in the pointer to the buffer which is an argument of this function.
			// Return the number of samples we put in there or maximum
			// Put the read timestamp in the index of chunk read timestamps.
			// increment indexOfChunkToRead or if it is on the last index, loop it around to zero.
			
			
			
			// OK, if max is bigger than the number of samples in the chunk, set max to the number of samples in the chunk:
			
			if(maximum >= audioDriver->ringBuffer[audioDriver->indexOfChunkToRead].numberOfSamples) {
				maximum = audioDriver->ringBuffer[audioDriver->indexOfChunkToRead].numberOfSamples;
			} else {
				// Put the rest into the extras buffer
				
				SInt16 numberOfUncopiedSamples = audioDriver->ringBuffer[audioDriver->indexOfChunkToRead].numberOfSamples - maximum;
				UInt32 startingSampleIndexForExtraSamples = maximum;
				audioDriver->extraSamples = TRUE;
				audioDriver->numberOfExtraSamples = numberOfUncopiedSamples;				
				memcpy((SInt16 *)audioDriver->extraSampleBuffer, (SInt16 *)audioDriver->ringBuffer[audioDriver->indexOfChunkToRead].buffer + startingSampleIndexForExtraSamples, audioDriver->numberOfExtraSamples * 2);
			}
			
			memcpy(buffer,audioDriver->ringBuffer[audioDriver->indexOfChunkToRead].buffer, maximum * 2); // memcpy copies bytes, so this needs to be max times 2 which is how many bytes are in one of our samples
			
			audioDriver->consumedTimeStamp[audioDriver->indexOfChunkToRead] = CFAbsoluteTimeGetCurrent(); // Timestamp to the current time.
			
			if(audioDriver->indexOfChunkToRead == kNumberOfChunksInRingbuffer - 1) { // If this is the last chunk index, loop around to zero.
				audioDriver->indexOfChunkToRead = 0;
			} else { // Otherwise increment the index of the chunk to read.
				audioDriver->indexOfChunkToRead++;
			}
			
	
			return maximum; // Return max and that's actually it.
			
		} else { // if it was read more recently than it was written to, return 0.
			
			return 0;
		}
		
	} else {
		
		int j;	// next, read the samples starting from the point of already read and going to 256 more, then return 256
		for ( j = 0; j < 256; j++ ) { // until 256 packets have been copied,
			buffer[j] = audioDriver->calibrationBuffer[j + audioDriver->samplesReadDuringCalibration];
            
		}
		
		audioDriver->samplesReadDuringCalibration = audioDriver->samplesReadDuringCalibration + 256; // next, increase samplesReadDuringCalibration by the amount read
		
		maximum = 256; // set max to 256
		
	
		return maximum;
		
	}
	
	return 0;
}

#endif