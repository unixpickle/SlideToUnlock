//
//  SlideToUnlockViewController.m
//  SlideToUnlock
//
//  Created by Alex Nichol on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SlideToUnlockViewController.h"

@implementation SlideToUnlockViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	ANSlider * slider = [[ANSlider alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 95, 320, 95)];
	[slider startAnimating:self];
	[self.view addSubview:[slider autorelease]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
