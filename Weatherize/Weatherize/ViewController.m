//
//  ViewController.m
//  Weatherize
//
//  Created by Varun Jandhyala on 2/6/18.
//
#import "ViewController.h"
#import "WeatherTableViewCell.h"
    
@interface ViewController () {
    double latitude;
    double longitude;
}

@end

@implementation ViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    
    if (self) {
        self.forecastInfo = [NSDictionary new];
        self.currentWeatherInfo = [NSDictionary new];
        self.weatherData = [WeatherData new];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationWasUpdated:) name:@"LocationNotification" object:nil];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)locationWasUpdated:(NSNotification *)notification {
    [self loadWeatherInfo];
}

- (void)configureTemperature:(NSString *)temperature inLabel:(UILabel *)label {
    dispatch_async(dispatch_get_main_queue(), ^{
        [label setFont:[UIFont systemFontOfSize:16.0]];
        [label setText:[NSString stringWithFormat:@"%.02f°", [temperature floatValue]]];
    });
}

- (void)configureDay:(NSString *)day inLabel:(UILabel *)label {
    [label setFont:[UIFont systemFontOfSize:14.0 weight:UIFontWeightBold]];
    [label setText:day];
}

- (void)configureWeatherIcon:(NSString *)weatherIcon inImageView:(UIImageView *)imageView {
    [[[self weatherData] weatherAPI] downloadWeatherIconForID:weatherIcon completion:^(NSError *error, UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageView setImage:image];
        });
    }];
}

- (void)loadWeatherInfo {
    [[self weatherData] getCurrentWeatherInfoWithCompletion:^(NSDictionary *info) {
        self.currentWeatherInfo = info;
        NSLog(@"This is the current weather info\n\n: %@", self.currentWeatherInfo);
        
        [self configureWeatherIcon:self.currentWeatherInfo[@"weatherIcon"] inImageView:[self headerWeatherIcon]];
        [self configureTemperature:self.currentWeatherInfo[@"temperature"] inLabel:[self headerTemperatureLabel]];
    }];
    
    [[self weatherData] getFiveDayForecastInfoWithCompletion:^(NSDictionary *info) {
        self.forecastInfo = info;
        NSLog(@"This is the current forecast info\n\n: %@", self.forecastInfo);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self tableView] reloadData];
        });
    }];
    
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self forecastInfo] count];
}

- (WeatherTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weatherCell"];
    
    if (cell == nil) {
        cell = [[WeatherTableViewCell new] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"weatherCell"];
    }
    
    NSString *currentDay = [[self weatherData] fiveDays][indexPath.row];
    NSLog(@"This is the data structure: %@", self.forecastInfo[currentDay]);
    
    NSDictionary *dayForecast = self.forecastInfo[currentDay];
    
    NSString *weatherIcon = dayForecast[@"weatherIcon"];
    NSString *temperature = dayForecast[@"temperature"];
    
    [self configureDay:currentDay inLabel:cell.dayLabel];
    [self configureWeatherIcon:weatherIcon inImageView:cell.weatherIcon];
    [self configureTemperature:temperature inLabel:cell.temperatureLabel];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
