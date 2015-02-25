//
//  ViewController.m
//  Assignment 5
//
//  Created by Michael Gallagher on 2/24/15.
//  Copyright (c) 2015 Michael Gallagher. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) UILabel *latitude;
@property (nonatomic, strong) UILabel *longitude;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ViewController

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.latitude = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 200, 40)];
        self.latitude.text = @"Latitude:";
        // start adding layout constraitns...
        // more constraints...
        // [self.view addcon...
        [self.view addSubview:self.latitude];
        
        self.longitude = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 200, 40)];
        self.longitude.text = @"Longitude:";
        [self.view addSubview:self.longitude];
        
        //  ------------------- Spinner --------------------
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.spinner.frame = CGRectMake(200, 150, 50, 50);
        [self.view addSubview:self.spinner];
        [self.spinner startAnimating];	// make it spin
        //		[self.spinner stopAnimating];	// make it stop spinning
        
        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;	// the better the accuracy = more battery
        
        // if this 'block' of code runs on a device running iOS >8, then it will CRASH!
        // -- block
        if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse)
        {	// this is required for iOS 8 only!
            // *** NOTE: Make sure to add the key "NSLocationWhenInUseUsageDescription" to your Info.plist! ***
            // ***	  The string value you assign will be displayed when the app asks to use their location ***
            // ***					   To add a new key to the Info.plist, right click and select "Add Row" ***
            [self.locationManager requestWhenInUseAuthorization];
        }
        // -- end block
        
        [self.locationManager startUpdatingLocation];
        
        // NOTE: to stop updating the location, use:
        //		[self.locationManager stopUpdatingLocation];
    }
    return self;
}

-(void)updateLatitude:(CGFloat)latitude
{
    self.latitude.text = [NSString stringWithFormat:@"Latitude: %f", latitude];
}
-(void)updateLongitude:(CGFloat)longitude
{
    self.longitude.text = [NSString stringWithFormat:@"Longitude %f", longitude];
}


#pragma mark CLLocationManagerDeleate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newestLocation = [locations lastObject];
    
    // the property "horizontalAccuracy on a CLLocation object will tell you how accurate it is in meters
    NSLog(@"Accuracy: %@", @(newestLocation.horizontalAccuracy));
    if(newestLocation.horizontalAccuracy <= 100)
    {
        [self.locationManager stopUpdatingLocation];
        [self updateLatitude:newestLocation.coordinate.latitude];
        [self updateLongitude:newestLocation.coordinate.longitude];
        
    }
    //	NSLog(@"location: %@", newestLocation);
}

// if an error is thrown, the location will STOP being updated.
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}


@end