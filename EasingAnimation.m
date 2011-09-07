//
//  EasingAnimation.m
//  BoxScreensaver
//
//  Created by Alex Nichol on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EasingAnimation.h"


@implementation EasingAnimation

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (float)duration {
	@throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"This is an abstract method and must be implemented by a subclass." userInfo:nil];
}

- (BOOL)getValueForCurrentTime:(float *)value {
	@throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"This is an abstract method and must be implemented by a subclass." userInfo:nil];
}

- (void)dealloc {
    [super dealloc];
}

@end
