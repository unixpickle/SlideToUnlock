//
//  EaseInAnimation.h
//  BoxScreensaver
//
//  Created by Alex Nichol on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasingAnimation.h"

@interface EaseOutSmoothAnimation : EasingAnimation {
    CGFloat duration;
	CGFloat destination;
	NSDate * startDate;
	// our easing function looks like this:
	// F(t) = k(1/2x^2)
	CGFloat easy_a;
	CGFloat easy_b; // always zero
	CGFloat easy_c;
	CGFloat easy_k; // depends on the destination.
}

- (id)initWithDuration:(CGFloat)theDuration destinationValue:(CGFloat)theDestination;

@end
