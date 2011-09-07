//
//  EaseInAnimation.m
//  BoxScreensaver
//
//  Created by Alex Nichol on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EaseOutSmoothAnimation.h"


@implementation EaseOutSmoothAnimation

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithDuration:(CGFloat)theDuration destinationValue:(CGFloat)theDestination {
	if ((self = [super init])) {
		easy_a = -0.3;
		easy_b = 0.9;
		easy_c = 0.0;
		CGFloat baseK = 1.0 / ((easy_a * pow(1, 2)) + (easy_b * 1) + easy_c);
		easy_k = theDestination * baseK;
		// easy_k = theDestination / ((easy_a * pow(theDuration, 2)) + (easy_b * theDuration));
		startDate = [[NSDate date] retain];
		duration = theDuration;
		destination = theDestination;
	}
	return self;
}

- (CGFloat)duration {
	return duration;
}

- (BOOL)getValueForCurrentTime:(CGFloat *)value {
	NSTimeInterval timeElapsed = [[NSDate date] timeIntervalSinceDate:startDate];
	if (timeElapsed >= duration) {
		*value = destination;
		return NO;
	}
	*value = easy_k * ((easy_a * pow(timeElapsed / duration, 2)) + (easy_b * (timeElapsed / duration)) + easy_c);
	if (*value > destination) {
		NSLog(@"OHSHIT BRO!");
	}
	return YES;
}

- (void)dealloc {
	[startDate release];
    [super dealloc];
}

@end
