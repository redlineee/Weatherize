//
//  ViewController.h
//  Weatherize
//
//  Created by Varun Jandhyala on 2/6/18.
//

#import <UIKit/UIKit.h>
#import "WeatherData.h"
#import "LocationProtocol.h"

@interface ViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerTemperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerWeatherIcon;

@property (strong, nonatomic) WeatherData *weatherData;

@property (strong, nonatomic) NSDictionary *forecastInfo;
@property (strong, nonatomic) NSDictionary *currentWeatherInfo;

- (void)loadWeatherInfo;

- (void)configureTemperature:(NSString *)temperature inLabel:(UILabel *)label;
- (void)configureWeatherIcon:(NSString *)weatherIcon inImageView:(UIImageView *)imageView;

- (void)configureDay:(NSString *)day inLabel:(UILabel *)label;

@end

