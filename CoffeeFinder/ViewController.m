//
//  ViewController.m
//  CoffeeFinder
//
//  Created by Brad Leege on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

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
    [mapView removeAnnotations:[mapView annotations]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"do async loading of data");
        NSData *responseData = [NSData dataWithContentsOfURL: [NSURL URLWithString:@"http://maps.googleapis.com/maps/api/geocode/json?address=18+West+29th+St,+New+York,+NY&sensor=false"]];

        // Parse the response data
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        
        // Send results back to UI for display
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Back to the main thread...");

            if (error != nil)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                NSString *status = [json objectForKey:@"status"];
                NSLog(@"Status = '%@'", status);

                if ([[status uppercaseString] isEqualToString:@"OK"])
                {
                    NSLog(@"good to go...");
                    NSArray *results = [json objectForKey:@"results"];
                    NSDictionary *root = [results objectAtIndex:0];
                    NSDictionary *geometry = [root objectForKey:@"geometry"];
                    NSDictionary *loc = [geometry objectForKey:@"location"];
                    NSDecimalNumber *lat = [loc objectForKey:@"lat"];
                    NSDecimalNumber *lon = [loc objectForKey:@"lng"];
                    NSLog(@"Lat = '%@', Lon = '%@'", lat, lon);
                    
                    MKPointAnnotation *pt = [[MKPointAnnotation alloc] init];
                    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
                    [pt setCoordinate:coord];
                    [pt setTitle:@"Stumptown Coffee"];
                    [pt setSubtitle:[root objectForKey:@"formatted_address"]];

                    [mapView addAnnotation:pt];
                    MKCoordinateSpan span = MKCoordinateSpanMake(0.002401f, 0.003433f);
                    [mapView setRegion:MKCoordinateRegionMake(coord, span) animated:YES];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bad Status From Google" message:status delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
        });
    });
    NSLog(@"done with handleStumptonClick().");
}


@end
