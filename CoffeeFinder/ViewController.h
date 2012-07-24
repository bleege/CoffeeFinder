//
//  ViewController.h
//  CoffeeFinder
//
//  Created by Brad Leege on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController


@property (nonatomic, retain) IBOutlet MKMapView *mapView;

- (IBAction)handleStumptownClick:(id)sender;

@end
