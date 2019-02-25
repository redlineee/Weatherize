//
//  LocationProtocol.h
//  Weatherize
//
//  Created by Varun Jandhyala on 2/21/19.
//

#ifndef LocationProtocol_h
#define LocationProtocol_h

@protocol LocationProtocol <NSObject>
-(void)locationDidUpdate: (void (^)(CLLocationCoordinate2D coordinate))completion;
@end


#endif /* LocationProtocol_h */
