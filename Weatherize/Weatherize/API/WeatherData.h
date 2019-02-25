//
//  WeatherData.h
//  Weatherize
//
//  Created by Varun Jandhyala on 2/6/18.
//

#import <Foundation/Foundation.h>
#import "WeatherAPI.h"

@interface WeatherData : NSObject

@property (strong, nonatomic) WeatherAPI* weatherAPI;
@property (strong, nonatomic) NSDictionary* cache;

typedef void (^InfoCompletionBlock)(NSDictionary *information);

- (NSString *)currentDay;
- (NSArray *)fiveDays;

- (void)getCurrentWeatherInfoWithCompletion:(InfoCompletionBlock)completion;
- (void)getFiveDayForecastInfoWithCompletion:(InfoCompletionBlock)completion;

@end
