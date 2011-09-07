//
//  ANSlider.m
//  SlideToUnlock
//
//  Created by Alex Nichol on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ANSlider.h"

#define kBaseImageName @"bottom.png"
#define kSlideButtonImage @"default_slider.png"
#define kTextMaskImg @"textmask.png"

#define kButtonOffsetX 2
#define kButtonOffsetY 4

#define kButtonStartX 24
#define kButtonStartY 25

#define kSliderHeight 95
#define kSliderWidth 320

#define kTextStartX 113
#define kTextStartY 35
#define kTextStartWidth 378
#define kTextStartHeight 44
#define kTextScale 2.0

@interface ANSlider (Private)

@property (nonatomic, retain) NSDate * lastSlideDate;

- (void)particleMove;
- (NSDate *)lastSlideDate;
- (void)setLastSlideDate:(NSDate *)newDate;
- (void)setSliderX:(CGFloat)coordX;
- (CGPoint)drawSliderPosition;

@end

@implementation ANSlider

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.lastSlideDate = [NSDate date];
		particleImage = CGImageRetain([[UIImage imageNamed:kTextMaskImg] CGImage]);
		particlePosition.x = 0 - (CGFloat)CGImageGetWidth(particleImage);
		particlePosition.y = frame.size.height / 2 - round(CGImageGetHeight(particleImage) / 2);
		backgroundImage = [[UIImage imageNamed:kBaseImageName] retain];
		sliderImage = [[UIImage imageNamed:kSlideButtonImage] retain];
		sliderCoordinates = CGPointMake(kButtonStartX, kButtonStartY);
		[self setDrawText:@"slide to unlock"];
    }
    return self;
}

- (void)startAnimating:(id)sender {
	if (!particleTimer) {
		// TODO: figure out a good framerate.
		particleTimer = [NSTimer scheduledTimerWithTimeInterval:(1 / 45.0) target:self 
													   selector:@selector(particleMove) 
													   userInfo:nil repeats:YES];
	}
}

- (void)stopAnimating:(id)sender {
	[particleTimer invalidate];
	particleTimer = nil;
}

- (void)setDrawText:(NSString *)someText {
	[drawText autorelease];
	drawText = [someText retain];
	[darkImage release];
	[brightImage release];
	
	UIFont * drawFont = [UIFont systemFontOfSize:45];
	ANImageBitmapRep * darkIrep = [[ANImageBitmapRep alloc] initWithSize:BMPointMake(kTextStartWidth, kTextStartHeight)];
	ANImageBitmapRep * brightIrep = [[ANImageBitmapRep alloc] initWithSize:BMPointMake(kTextStartWidth, kTextStartHeight)];
	[darkIrep drawText:drawText atPoint:BMPointMake(0, 0) font:drawFont color:BMPixelMake(0.7, 0.7, 0.7, 1)];
	[brightIrep drawText:drawText atPoint:BMPointMake(0, 0) font:drawFont color:BMPixelMake(1, 1, 1, 1)];
	darkImage = [[darkIrep image] retain];
	brightImage = [[brightIrep image] retain];
	[darkIrep release];
	[brightIrep release];
}

- (NSString *)drawText {
	return drawText;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	CGFloat totalAlpha;
	CGPoint drawSliderCoords;
	
	drawSliderCoords = [self drawSliderPosition];
	
	totalAlpha = kButtonStartX + 100 - drawSliderCoords.x;
	if (totalAlpha < 0) totalAlpha = 0;
	else {
		totalAlpha /= 100.0;
	}
	if (totalAlpha > 1) totalAlpha = 1;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	[backgroundImage drawInRect:CGRectMake(0, 0, kSliderWidth, kSliderHeight)];
	[darkImage drawInRect:CGRectMake(kTextStartX, kTextStartY, kTextStartWidth / 2, kTextStartHeight / 2) blendMode:kCGBlendModeNormal alpha:totalAlpha];
	if (particleTimer) {
		CGContextSaveGState(context);
		// {
		CGContextClipToMask(context, CGRectMake(particlePosition.x, particlePosition.y,
												CGImageGetWidth(particleImage), CGImageGetHeight(particleImage)),
												particleImage);
		[brightImage drawInRect:CGRectMake(kTextStartX, kTextStartY, kTextStartWidth / 2, kTextStartHeight / 2) blendMode:kCGBlendModeNormal alpha:totalAlpha];
		// }
		CGContextRestoreGState(context);
	}
	[sliderImage drawInRect:CGRectMake(drawSliderCoords.x - (kButtonOffsetX / 2), drawSliderCoords.y - (kButtonOffsetY / 2), 
									   [sliderImage size].width / 2, [sliderImage size].height / 2)];
}

#pragma mark Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint location = [[touches anyObject] locationInView:self];
	isDragging = NO;
	if (location.x >= sliderCoordinates.x - (kButtonOffsetX / 2)) {
		if (location.x <= sliderCoordinates.x - (kButtonOffsetY / 2) + ([sliderImage size].width / 2)) {
			isDragging = YES;
			startTouch = location.x;
			startSliderX = sliderCoordinates.x;
			if (isSlidingBack) {
				isSlidingBack = NO;
				[easeOut release];
				easeOut = nil;
			}
			[self stopAnimating:self];
		}
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (isDragging) {
		CGPoint location = [[touches anyObject] locationInView:self];
		CGFloat offsetX = location.x - startTouch;
		[self setSliderX:(offsetX + startSliderX)];
		[self setNeedsDisplay];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (isDragging) {
		[self startAnimating:self];
		isDragging = NO;
		isSlidingBack = YES;
		[easeOut release];
		easeOut = [[EaseOutSmoothAnimation alloc] initWithDuration:0.25 destinationValue:(sliderCoordinates.x - kButtonStartX)];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	if (isDragging) {
		[self startAnimating:self];
		isDragging = NO;
		isSlidingBack = YES;
		[easeOut release];
		easeOut = [[EaseOutSmoothAnimation alloc] initWithDuration:0.25 destinationValue:(sliderCoordinates.x - kButtonStartX)];
	}
}

#pragma mark Memory Management

- (void)dealloc {
	CGImageRelease(particleImage);
	[drawText release];
	[darkImage release];
	[brightImage release];
	[backgroundImage release];
	[sliderImage release];
	[easeOut release];
	[self stopAnimating:self];
	self.lastSlideDate = nil;
	[super dealloc];
}

#pragma mark Private

- (void)particleMove {
	NSDate * oldDate = self.lastSlideDate;
	self.lastSlideDate = [NSDate date];
	NSTimeInterval timeElapsed = [self.lastSlideDate timeIntervalSinceDate:oldDate];
	CGFloat minPos = 20;
	CGFloat maxPos = self.frame.size.width - 20;
	particlePosition.x += MIN((timeElapsed * 200), 100.0);
	if (particlePosition.x > maxPos) {
		particlePosition.x = (minPos - (CGFloat)CGImageGetWidth(particleImage)) + (particlePosition.x - maxPos);
	}
	[self setNeedsDisplay];
	self.lastSlideDate = [NSDate date];
}

- (NSDate *)lastSlideDate {
	return lastSlideDate;
}

- (void)setLastSlideDate:(NSDate *)newDate {
	[lastSlideDate autorelease];
	lastSlideDate = [newDate retain];
}

- (void)setSliderX:(CGFloat)coordX {
	CGFloat maxX = self.frame.size.width - 23;
	if (coordX < kButtonStartX) {
		coordX = kButtonStartX;
	} else if ((coordX + [sliderImage size].width / 2) - (kButtonOffsetX / 2) >= maxX) {
		coordX = maxX - ([sliderImage size].width / 2 - (kButtonOffsetX / 2));
	}
	sliderCoordinates.x = coordX;
}

- (CGPoint)drawSliderPosition {
	CGPoint drawSliderCoords = sliderCoordinates;
	if (isSlidingBack) {
		CGFloat value;
		if ([easeOut getValueForCurrentTime:&value]) {
			drawSliderCoords.x -= value;
		} else {
			sliderCoordinates.x = kButtonStartX;
			drawSliderCoords = sliderCoordinates;
			[easeOut release];
			easeOut = nil;
			isSlidingBack = NO;
		}
	}
	return drawSliderCoords;
}

@end
