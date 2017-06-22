//
//  TMUser.m
//  CheckMat
//
//  Created by Temirlan Merekeyev on 03.06.17.
//  Copyright © 2017 Temirlan Merekeyev. All rights reserved.
//

#import "TMUser.h"

@implementation TMUser
+(TMUser*) user{
    
    static TMUser* user = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        user = [[TMUser alloc] init];
        
    });
    
    return user;
}
@end
