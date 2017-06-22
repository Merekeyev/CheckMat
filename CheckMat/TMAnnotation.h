//
//  TMAnnotation.h
//  CheckMat
//
//  Created by Temirlan Merekeyev on 19.06.17.
//  Copyright © 2017 Temirlan Merekeyev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface TMAnnotation : NSObject <MKAnnotation>
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


@end
