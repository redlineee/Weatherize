//
//  WeatherData.m
//  Weatherize
//
//  Created by Varun Jandhyala on 2/6/18.
//

#import "WeatherData.h"

@interface WeatherData ()

@end

@implementation WeatherData

- (id)init {
    self = [super init];
    
    if (self) {
        self.weatherAPI = [WeatherAPI new];
    }
    
    return self;
}

- (NSString *)currentDay {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

- (NSArray *)fiveDays {
    NSString *currentDay = [self currentDay];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSArray *weekdays = [dateFormatter weekdaySymbols];
    
    NSMutableArray *daysNeeded = [NSMutableArray arrayWithCapacity:5];
    /* Get the current day as a index of weekdays array, and count forward 5 days from it*/
    NSUInteger currentIndex = [weekdays indexOfObject:currentDay];

    for (int i = currentIndex + 1; i <= 6; i++) {
        if ([daysNeeded count] < 5) {
            [daysNeeded addObject:weekdays[i]];
        }
    }
    
    int daysRemaining = 5 - [daysNeeded count];
    
    for(int i = 0; i < daysRemaining; i++) {
        [daysNeeded addObject:weekdays[i]];
    }
    
    return [NSMutableArray arrayWithArray:daysNeeded];
}

- (void)getCurrentWeatherInfoWithCompletion:(InfoCompletionBlock)completion {
    NSMutableDictionary *currentWeatherInfo = [NSMutableDictionary new];
    
    [self.weatherAPI queryCurrentWeatherDataWithCompletion:^(NSData *weatherData) {
        NSError *error = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:weatherData options:0 error:&error];
                
        NSString *weatherIcon = [[json objectForKey:@"weather"] objectAtIndex:0][@"icon"];
        NSString *temperature = [json objectForKey:@"main"][@"temp"];
        
        currentWeatherInfo[@"weatherIcon"] = weatherIcon;
        currentWeatherInfo[@"temperature"] = temperature;
        
        completion(currentWeatherInfo);
    }];
}

- (void)getFiveDayForecastInfoWithCompletion:(InfoCompletionBlock)completion {
    [self.weatherAPI queryFiveDayForecastDataWithCompletion:^(NSData *weatherData) {
        NSError *error = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:weatherData options:0 error:&error];
        
        NSMutableArray *fiveDayForecastArray = [NSMutableArray arrayWithCapacity:5];
        
        NSMutableDictionary *fiveDayForecastInfo = [NSMutableDictionary new];
        
        NSArray *weatherInfoArray = [json objectForKey:@"list"];
        
        for (NSDictionary *weatherInfo in weatherInfoArray) {
            NSString *timeComponent = [weatherInfo[@"dt_txt"] componentsSeparatedByString:@" "].lastObject;
            
            NSString *expectedTime = @"12:00:00";
            
            if ([timeComponent isEqualToString:expectedTime]) {
                NSMutableDictionary *oneDayWeatherInfo = [NSMutableDictionary new];
                NSString *weatherIcon = [[weatherInfo objectForKey:@"weather"] objectAtIndex: 0][@"icon"];
                NSString *temperature = [weatherInfo objectForKey:@"main"][@"temp"];
                
                oneDayWeatherInfo[@"weatherIcon"] = weatherIcon;
                oneDayWeatherInfo[@"temperature"] = temperature;
                
                [fiveDayForecastArray addObject:oneDayWeatherInfo];
                
                if ([fiveDayForecastArray count] == 5) {
                    for (NSString *day in [self fiveDays]) {
                        int dex = (int)[[self fiveDays] indexOfObject: day];
                        fiveDayForecastInfo[day] = fiveDayForecastArray[dex];
                    }
                    
                    completion(fiveDayForecastInfo);
                }
            }
        }
    }];
}

@end
