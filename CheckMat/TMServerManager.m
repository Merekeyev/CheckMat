//
//  TMServerManager.m
//  CheckMat
//
//  Created by Temirlan Merekeyev on 02.06.17.
//  Copyright © 2017 Temirlan Merekeyev. All rights reserved.
//

#import "TMServerManager.h"
#import "AFNetworking.h"
#import "Reachability.h"
@interface TMServerManager ()

@property (strong, nonatomic)AFHTTPSessionManager* requestManager;
@end

@implementation TMServerManager

+(TMServerManager*) sharedManager{
    
    
    static TMServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[TMServerManager alloc] init];
        
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestManager = [[AFHTTPSessionManager alloc] init];
        
        
    }
    return self;
}
#pragma mark - checking Internet connection



#pragma mark - login
-(void) accessToServerWithLogin:(NSString*)login
                       password:(NSString*)password
                      onSuccess:(void(^)(NSDictionary* json)) success
                      onFailure:(void(^)(NSError* error)) failure{
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            login,@"username",
                            password,@"password",
                            nil];
    
    
        
    
    [self.requestManager GET:@"http://app.checkmat.kz/api/user/login/"
                  parameters:params
                     success:^(NSURLSessionTask * _Nonnull operation, id  _Nonnull responseObject) {
                         
                         NSDictionary* json = [NSDictionary dictionaryWithDictionary:responseObject];
                         TMUser* user = [TMUser user];
                         user.statusOfAuthorization = [json objectForKey:@"stat"];
                         user.userId                = [json objectForKey:@"user_id"];
                         
                         if(success){
                             success(json);
                         }
                         
                     } failure:^(NSURLSessionTask * _Nullable operation, NSError * _Nonnull error) {
                         
                         NSLog(@"Error %@", error);
                         
                     }];
    
    
}
#pragma mark - User Data
-(void) getUserData:(NSString*) userId
          onSuccess:(void(^)(NSDictionary* json)) success
          onFailure:(void(^)(NSError* error)) failure{
    
    NSDictionary* params = [NSDictionary dictionaryWithObject: userId
                                                       forKey:@"id"];
    
    [self.requestManager GET:@"http://app.checkmat.kz/api/user/view"
                  parameters:params
                     success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
                         TMUser* user = [TMUser user];
                         user.username    = [responseObject objectForKey:@"username"];
                         user.email       = [responseObject objectForKey:@"email"];
                         user.firstName   = [responseObject objectForKey:@"first_name"];
                         user.lastName    = [responseObject objectForKey:@"last_name"];
                         user.patronymic  = [responseObject objectForKey:@"patronymic"];
                         user.phone       = [responseObject objectForKey:@"phone"];
                         user.role        = [responseObject objectForKey:@"role"];
                         user.status      = [responseObject objectForKey:@"status"];
                         user.createdDate = [responseObject objectForKey:@"created_at"];
                         user.updatedDate = [responseObject objectForKey:@"updated_at"];
                         
                         
                         if(success){
                             success(responseObject);
                         }
                     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error %@", error);
                     }];
}
#pragma mark - Client Data
-(void) getClientData:(NSString*) userId
            onSuccess:(void(^)(NSDictionary* json)) success
            onFailure:(void(^)(NSError* error)) failure{
    
    NSDictionary* params = [NSDictionary dictionaryWithObject: userId
                                                       forKey:@"user_id"];
    
    [self.requestManager GET:@"http://app.checkmat.kz/api/client/get-by-user-id"
                  parameters:params
                     success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
                        
                         TMClient* client = [TMClient client];
                         client.clientId = [responseObject objectForKey:@"id"];
                         client.userId   = [responseObject objectForKey:@"user_id"];
                         client.abonement_id = [responseObject objectForKey:@"abonement_id"];
                         client.gender = [responseObject objectForKey:@"gender"];
                         client.birth_date = [responseObject objectForKey:@"birth_date"];
                         client.days = [responseObject objectForKey:@"days"];
                         client.imageString = [responseObject objectForKey:@"rank_image"];
                         
                         if(success){
                             success(responseObject);
                         }
                     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error %@", error);
                     }];
}

#pragma mark - Info Data
-(void) getInfoDataOnSuccess:(void(^)(NSArray* infoArray, NSArray* titleArray)) success
                   onFailure:(void(^)(NSError* error)) failure{
    
    [self.requestManager GET:@"http://app.checkmat.kz/api/article/get-by-category-slug?slug=info"
                  parameters:nil
                     success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
                         NSArray* dictsArray = responseObject;
                         NSMutableArray* objectsArray = [NSMutableArray array];
                         NSMutableArray* titleArray = [NSMutableArray array];
                         for (NSDictionary* dict in dictsArray){
                             [objectsArray addObject:[dict objectForKey:@"body"]];
                             [titleArray addObject:[dict objectForKey:@"title"]];
                         }
                         if(success){
                             success(objectsArray,titleArray);
                         }
                     }
                     failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error %@", error);
                     }];
    
}

#pragma mark - Home Data
-(void) getHomeDataOnSuccess:(void(^)(NSArray* news, NSArray* titleArray, NSArray* date)) success
                   onFailure:(void(^)(NSError* error)) failure{
    
    [self.requestManager GET:@"http://app.checkmat.kz/api/article/get-by-category-slug?slug=news"
                  parameters:nil
                     success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
                         NSArray* dictsArray = responseObject;
                         NSMutableArray* bodiesArray = [NSMutableArray array];
                         NSMutableArray* titlesArray = [NSMutableArray array];
                         NSMutableArray* createdDate = [NSMutableArray array];
                         for(NSDictionary* dict in dictsArray){
                            [bodiesArray addObject:[dict objectForKey:@"body"]];
                            [titlesArray addObject:[dict objectForKey:@"title"]];
                            [createdDate addObject:[dict objectForKey:@"updated_at"]];
                         }
                         if(success){
                             success(bodiesArray,titlesArray,createdDate);
                         }
                     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error %@", error);
                     }];
}
@end
