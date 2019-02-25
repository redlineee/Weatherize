//
//  WeatherAPI.m
//  Weatherize
//
//  Created by Varun Jandhyala on 2/6/18.
//

#import "WeatherAPI.h"
#import "WeatherData.h"

@interface WeatherAPI () {
    double latitude;
    double longitude;
}

@end

@implementation WeatherAPI

static NSString* const apiKey = @"85bac986e143c41ef673e970154dc7fb";
static NSString* const baseURL = @"https://api.openweathermap.org/data/2.5/weather?";
static NSString* const forecastURL = @"https://api.openweathermap.org/data/2.5/forecast?";
static NSString* const iconURL = @"https://openweathermap.org/img/w/";

- (id)init {
    self = [super init];
    
    if(self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationWasUpdated:) name:@"LocationNotification" object:nil];
    }
    return self;
}

-(void)locationWasUpdated:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    latitude = [info[@"latitude"] doubleValue];
    longitude = [info[@"longitude"] doubleValue];
}

- (void)queryCurrentWeatherDataWithCompletion:(WeatherDataCompletionBlock)completion {
    NSString *query = [NSString stringWithFormat:@"lat=%f&lon=%f&units=imperial&appid=%@", latitude, longitude, apiKey];

    NSString* queryPath = [baseURL stringByAppendingString:query];
    NSString *path = [queryPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"path: %@", path);
    NSURL *url = [NSURL URLWithString:path];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            completion(data);
        }
    }] resume];
}

- (void)queryFiveDayForecastDataWithCompletion:(WeatherDataCompletionBlock)completion {
    NSString* query = [NSString stringWithFormat:@"cnt=40&lat=%f&lon=%f&units=imperial&appid=%@", latitude, longitude, apiKey];

    NSString* queryPath = [forecastURL stringByAppendingString:query];
    NSString *path = [queryPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"path: %@", path);
    NSURL *url = [NSURL URLWithString:path];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            completion(data);
        }
    }] resume];
}

- (void)downloadWeatherIconForID:(NSString *)iconID completion:(ImageCompletionBlock)completion
{
    NSString* query = [NSString stringWithFormat:@"%@.png", iconID];
    NSString* queryPath = [iconURL stringByAppendingString:query];
    NSString *path = [queryPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"path: %@", path);
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:path] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            UIImage *image = [[UIImage alloc] initWithData:data];
            completion(nil, image);
        } else {
            completion(error, nil);
        }
    }] resume];
}

@end
