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

@property CGFloat latitude;
@property CGFloat longitude;
@property BOOL weHaveCoordinates;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UICollectionView *thing;
@property (weak, nonatomic) IBOutlet UICollectionView *test;

@end

@implementation ViewController

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.view.backgroundColor = [UIColor whiteColor];
        self.weHaveCoordinates = NO;
        [self setUpLocationGetter];
        while (self.weHaveCoordinates)
        {
            [self getWeatherForecast];
        }
        
    }
    return self;
}

-(void)getWeatherForecast
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *weatherRequest = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&cnt=7&units=imperial&APPID=3c045718f8871c3007d06f0e24cb09e2", self.latitude, self.longitude];
    NSLog(@"URL: %@", weatherRequest);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:weatherRequest]];
    // for form post data do the following:
    //	@"key1=param1&key2=param2...ect"
//    NSData *postData = [@"username=user1&password=pass1" dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:postData];
//    request.HTTPMethod = @"POST";
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    }];
    // to make the call to the endpoint, you must call "resume" on the DataTask
    [dataTask resume];
    NSLog(@"Done");
}

-(void)setUpLocationGetter
{
//    self.latitude = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 200, 40)];
//    self.latitude.text = @"Latitude:";
//
//    [self.view addSubview:self.latitude];
//    self.longitude = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 200, 40)];
//    self.longitude.text = @"Longitude:";
//    [self.view addSubview:self.longitude];
    
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
        [self.locationManager requestWhenInUseAuthorization];
    }
    // -- end block
    [self.locationManager startUpdatingLocation];
    
    // NOTE: to stop updating the location, use:
    //		[self.locationManager stopUpdatingLocation];
}

-(void)updateLatitude:(CGFloat)latitude
{
//    self.latitude.text = [NSString stringWithFormat:@"Latitude: %f", latitude];
    NSLog(@"Latitude: %f", latitude);
}
-(void)updateLongitude:(CGFloat)longitude
{
//    self.longitude.text = [NSString stringWithFormat:@"Longitude %f", longitude];
    NSLog(@"Longitude: %f", longitude);
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
//        [self updateLatitude:newestLocation.coordinate.latitude];
//        [self updateLongitude:newestLocation.coordinate.longitude];
        self.latitude = newestLocation.coordinate.latitude;
        self.longitude = newestLocation.coordinate.longitude;
        NSLog(@"Latitude: %f", self.latitude);
        NSLog(@"Longitude: %f", self.longitude);
        self.weHaveCoordinates = YES;
    }
    //	NSLog(@"location: %@", newestLocation);
}

// if an error is thrown, the location will STOP being updated.
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}


@end