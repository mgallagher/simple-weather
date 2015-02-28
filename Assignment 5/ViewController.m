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

@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;
@property (nonatomic) NSString* cityName;
@property (nonatomic, strong) NSMutableArray *temperatures;
@property (nonatomic, strong) NSMutableArray *weatherIcons;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UICollectionView *thing;
@property (weak, nonatomic) IBOutlet UICollectionView *test;
@property (nonatomic, retain) NSDictionary *jsonResponse;

@end

@implementation ViewController

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.view.backgroundColor = [UIColor whiteColor];
//        [self setUpLocationGetter];
        [self getWeatherForecast];
    }
    NSLog(@"Done with program");
    return self;
}

-(void)getWeatherForecast
{
    self.latitude = 41.681599;
    self.longitude = -111.822998;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *weatherRequest = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&cnt=7&units=imperial&APPID=3c045718f8871c3007d06f0e24cb09e2", self.latitude, self.longitude];
    NSLog(@"URL: %@", weatherRequest);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:weatherRequest]];

//    lat: 41.681599
//    lon: -111.822998

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:
        ^(NSData *data, NSURLResponse *response, NSError *error) {
            self.jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

            self.cityName = [self.jsonResponse valueForKeyPath:@"city.name"];
            self.weatherIcons = [[NSMutableArray alloc] init];
            self.temperatures = [[NSMutableArray alloc] init];
//             NSArray* weatherIDs = [[[[self.jsonResponse valueForKeyPath:@"list.weather"] firstObject] objectForKey:@"icon"] integerValue];
             NSMutableArray *weatherData = [self.jsonResponse objectForKey:@"list"];
            NSDictionary *indexDict = [weatherData objectAtIndex:0];
             NSArray *weatherDataArr = [weatherData valueForKeyPath:@"icon"];
            // NSDictionary *firstItem = [weatherData firstObject];
            // NSDictionary *weatherIcon = [weatherData valueForKey:@"icon"];
            
            // NSString *icon = [weatherDictionaryData objectForKey:@"icon"];
            self.temperatures = [self.jsonResponse valueForKeyPath:@"list.temp.day.0"];

            // NSDictionary *testing = [self.jsonResponse valueForKeyPath:@"list.weather.icon"];
            // NSArray *hellooo = [[[_jsonResponse valueForKey:@"list"] valueForKey:@"weather"] valueForKey:@"id"];
            for (NSDictionary *listItems in self.jsonResponse[@"list"])
            {
                // NSLog(@"id: %@", [listItems valueForKeyPath:@"weather.id"][0]);
                [self.weatherIcons addObject:[listItems valueForKeyPath:@"weather.icon"][0]];
                // NSLog(@"temp: %@", [listItems valueForKeyPath:@"temp.day"]);
                // [self.temperatures addObject:[listItems valueForKeyPath:@"temp.day"]];
            }
    }];
    [dataTask resume];
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
        [self getWeatherForecast];
    }
    //	NSLog(@"location: %@", newestLocation);
}

// if an error is thrown, the location will STOP being updated.
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}


@end