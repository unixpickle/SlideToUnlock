//
//  EasingAnimation.h
//  BoxScreensaver
//
//  Created by Alex Nichol on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * This is an abstract class that represents an easing animation.
 */
@interface EasingAnimation : NSObject {
    
}

- (CGFloat)duration;

/**
 * Called to get the value from 0 to destination at the current time.
 * @param value The value that will be returned through reference.
 * @return YES if the animation is not finished, NO if it is.
 */
- (BOOL)getValueForCurrentTime:(CGFloat *)value;

@end
