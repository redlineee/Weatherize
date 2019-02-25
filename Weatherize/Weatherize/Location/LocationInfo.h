//
//  LocationInfo.h
//  Weatherize
//
//  Created by Varun Jandhyala on 2/6/18.
//

#import <CoreLocation/CoreLocation.h>
#import "LocationProtocol.h"


@interface LocationInfo : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;

+ (LocationInfo*)sharedSingleton;

@end
