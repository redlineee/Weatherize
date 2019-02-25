//
//  WeatherAPI.h
//  Weatherize
//
//  Created by Varun Jandhyala on 2/6/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "LocationInfo.h"

@interface WeatherAPI : NSObject

@property (strong, nonatomic) NSString* temperatureUnits;

typedef void (^WeatherDataCompletionBlock)(NSData *weatherData);

- (void)queryCurrentWeatherDataWithCompletion:(WeatherDataCompletionBlock)completion;
- (void)queryFiveDayForecastDataWithCompletion:(WeatherDataCompletionBlock)completion;

typedef void (^ImageCompletionBlock)(NSError *error, UIImage *image);

- (void)downloadWeatherIconForID:(NSString *)iconID completion:(ImageCompletionBlock)completion;

@end
