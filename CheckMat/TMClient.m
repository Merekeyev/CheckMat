//
//  TMClient.m
//  CheckMat
//
//  Created by Temirlan Merekeyev on 05.06.17.
//  Copyright © 2017 Temirlan Merekeyev. All rights reserved.
//

#import "TMClient.h"

@implementation TMClient
+(TMClient*) client{
    
    static TMClient* client = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        client = [[TMClient alloc] init];
        
    });
    
    return client;
}
@end
