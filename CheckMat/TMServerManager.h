//
//  TMServerManager.h
//  CheckMat
//
//  Created by Temirlan Merekeyev on 02.06.17.
//  Copyright © 2017 Temirlan Merekeyev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMUser.h"
#import "TMClient.h"
@interface TMServerManager : NSObject
@property (assign,nonatomic)BOOL hasInternet;
-(void) accessToServerWithLogin:(NSString*) login
                       password:(NSString*)password
                      onSuccess:(void(^)(NSDictionary* json)) success
                      onFailure:(void(^)(NSError* error)) failure;
+(TMServerManager*) sharedManager;

-(void) getUserData:(NSString*) userId
          onSuccess:(void(^)(NSDictionary* json)) success
          onFailure:(void(^)(NSError* error)) failure;

-(void) getClientData:(NSString*) userId
            onSuccess:(void(^)(NSDictionary* json)) success
            onFailure:(void(^)(NSError* error)) failure;

-(void) getInfoDataOnSuccess:(void(^)(NSArray* infoArray, NSArray* titleArray)) success
                   onFailure:(void(^)(NSError* error)) failure;

-(void) getHomeDataOnSuccess:(void(^)(NSArray* news, NSArray* titleArray, NSArray* date)) success
                   onFailure:(void(^)(NSError* error)) failure;
@end
