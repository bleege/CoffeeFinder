//
//  ViewController.m
//  CoffeeFinder
//
//  Created by Brad Leege on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)handleStumptownClick:(id)sender
{
    NSLog(@"handleStumptownClick() called...");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"do async loading of data");
        NSData *responseData = [NSData dataWithContentsOfURL: [NSURL URLWithString:@"http://maps.googleapis.com/maps/api/geocode/json?address=18+West+29th+St,+New+York,+NY&sensor=false"]];

        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        
//        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];

        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Back to the main thread...");
            NSLog(@"Status = '%@'", [json objectForKey:@"status"]);
        });
        
    });
    NSLog(@"done with handleStumptonClick().");
}


@end
