//
//  ViewController.m
//  Assignment 5
//
//  Created by Michael Gallagher on 2/24/15.
//  Copyright (c) 2015 Michael Gallagher. All rights reserved.
//

#import "ViewController.h"
#import "WeatherForecastCell.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;
@property (nonatomic) NSString* cityName;
@property (nonatomic) UILabel* cityLabel;
@property (nonatomic, strong) NSArray *maxTemps;
@property (nonatomic, strong) NSArray *minTemps;
@property (nonatomic, strong) NSArray *unixDates;
@property (nonatomic, strong) NSMutableArray *daysOfWeek;
@property (nonatomic, strong) NSMutableArray *weatherIcons;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UICollectionView *thing;
@property (weak, nonatomic) IBOutlet UICollectionView *test;
@property (nonatomic, retain) NSDictionary *jsonResponse;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic) int count;
@property BOOL networkBeenCalled;

@end

@implementation ViewController

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.view.backgroundColor = [UIColor whiteColor];
        self.count = 0;
        self.networkBeenCalled = NO;
        [self setUpLocationGetter];
    }
    return self;
}

-(void)getWeatherForecast
{
    self.networkBeenCalled = YES;
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *weatherRequest = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&cnt=7&units=imperial&APPID=3c045718f8871c3007d06f0e24cb09e2", self.latitude, self.longitude];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:weatherRequest]];
//    lat: 41.681599
//    lon: -111.822998
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:
        ^(NSData *data, NSURLResponse *response, NSError *error) {
            // Begin magical block
            self.jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            self.cityName = [self.jsonResponse valueForKeyPath:@"city.name"];
            self.maxTemps = [self.jsonResponse valueForKeyPath:@"list.temp.max"];
            self.minTemps = [self.jsonResponse valueForKeyPath:@"list.temp.min"];
            self.weatherIcons = [[NSMutableArray alloc] init];
            for (NSDictionary *listItems in self.jsonResponse[@"list"])
            {
                [self.weatherIcons addObject:[listItems valueForKeyPath:@"weather.icon"][0]];
            }
            NSArray *unixDates = [self.jsonResponse valueForKeyPath:@"list.dt"];
            [self convertDates:unixDates];
            NSLog(@"Done parsing JSON");
            
            // Collection View
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setUpCollectionView];
                
                // City
                UIFont *labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:45];
                UILabel *city = [[UILabel alloc] initWithFrame:CGRectMake(35, 45, 300, 80)];
                city.text = self.cityName;
                city.font = labelFont;
                city.textAlignment = NSTextAlignmentCenter;
                [self.view addSubview:city];
                
                // High and low temps
                
            });
            
        }];
    [dataTask resume];
}

-(void)setUpCollectionView
{
//    self.numberArray = @[@"1", @"2", @"4", @"3", @"5"];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    // contentInset -> gives a boarder to the collectionview
    self.collectionView.contentInset = UIEdgeInsetsMake(170, 30, 0, 30);
    [self.collectionView registerClass:[WeatherForecastCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];
    NSLog(@"done with collection view");
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.daysOfWeek.count-1;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(145, 145);
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = indexPath.row;
    WeatherForecastCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor grayColor];
    [cell setDayLabel:[self.daysOfWeek objectAtIndex:count]];
    [cell setDayIcon:[self.weatherIcons objectAtIndex:count]];
    int highTemp = [[self.maxTemps objectAtIndex:count] intValue];
    int lowTemp = [[self.minTemps objectAtIndex:count] intValue];
    [cell setHighLowTempLabel:highTemp andLowTemp:lowTemp];
    return cell;
}

-(void)convertDates:(NSArray*) dates
{
    self.daysOfWeek = [[NSMutableArray alloc] init];
    for (id day in dates)
    {
        NSDate *unixTime = [NSDate dateWithTimeIntervalSince1970:[day intValue]];
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"EEEE"];
        NSString *dateString = [dateFormatter stringFromDate:unixTime];
        [self.daysOfWeek addObject:dateString];
    }
}

-(void)setUpLocationGetter
{
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

#pragma mark CLLocationManagerDeleate Methods
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newestLocation = [locations lastObject];
    
    // the property "horizontalAccuracy on a CLLocation object will tell you how accurate it is in meters
    NSLog(@"Accuracy: %@", @(newestLocation.horizontalAccuracy));
    if(newestLocation.horizontalAccuracy <= 100)
    {
        [self.locationManager stopUpdatingLocation];
        self.latitude = newestLocation.coordinate.latitude;
        self.longitude = newestLocation.coordinate.longitude;
        NSLog(@"Latitude: %f", self.latitude);
        NSLog(@"Longitude: %f", self.longitude);
        if (!self.networkBeenCalled)
        {
            [self getWeatherForecast];
        }
    }
    //	NSLog(@"location: %@", newestLocation);
}

// if an error is thrown, the location will STOP being updated.
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}


@end