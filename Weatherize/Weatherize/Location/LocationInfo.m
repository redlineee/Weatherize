//
//  LocationInfo.m
//  Weatherize
//
//  Created by Varun Jandhyala on 2/6/18.
//
#import "LocationInfo.h"

@implementation LocationInfo

@synthesize locationManager;

- (id)init {
    self = [super init];
    
    if(self) {
        self.locationManager = [CLLocationManager new];
        [self.locationManager setDelegate:self];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestLocation];
    }
    return self;
}

+ (LocationInfo*)sharedSingleton {
    static LocationInfo* sharedSingleton;
    
    if(!sharedSingleton) {
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            sharedSingleton = [LocationInfo new];
        });
    }
    
    return sharedSingleton;
 }

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"didUpdateToLocation: %@", [locations firstObject]);
    CLLocationCoordinate2D coordinate = [[locations firstObject] coordinate];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    NSNumber *latitude = [NSNumber numberWithDouble:coordinate.latitude];
    NSNumber *longitude = [NSNumber numberWithDouble:coordinate.longitude];
    
    NSDictionary *userInfo = @{@"latitude" : latitude, @"longitude" : longitude};
    
    NSNotification *locationNotification = [[NSNotification alloc] initWithName:@"LocationNotification" object:nil userInfo:userInfo];
    
    [defaultCenter postNotification:locationNotification];
    
    [locationManager stopUpdatingLocation];
}

 - (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
 }

  - (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
      NSLog(@"didUpdateToLocation: %@", newLocation);
      [self.locationManager stopUpdatingLocation];
  }

  @end
