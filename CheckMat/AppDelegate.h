//
//  AppDelegate.h
//  CheckMat
//
//  Created by Temirlan Merekeyev on 02.06.17.
//  Copyright © 2017 Temirlan Merekeyev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;
@end

