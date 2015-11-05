//
//  MyAnnotation.h
//  ACOBJCVersion
//
//  Created by LINCHUNGYAO on 2015/10/25.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject  <MKAnnotation>

-(id)initWithCoordinate:(CLLocationCoordinate2D)argCoordinate
                  title:(NSString*)argTitle subtitle:(NSString*)argSubtitle;

////@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
//@property (nonatomic, readonly, copy, nullable) NSString *title;
//@property (nonatomic, readonly, copy, nullable) NSString *subtitle;
@end
