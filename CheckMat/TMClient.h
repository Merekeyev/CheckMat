//
//  TMClient.h
//  CheckMat
//
//  Created by Temirlan Merekeyev on 05.06.17.
//  Copyright © 2017 Temirlan Merekeyev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMClient : NSObject
+(TMClient*) client;
@property (strong, nonatomic)NSNumber* clientId;
@property (strong, nonatomic)NSNumber* userId;
@property (strong, nonatomic)NSNumber* abonement_id;
@property (strong, nonatomic)NSString* gender;
@property (strong, nonatomic)NSString* birth_date;
@property (strong, nonatomic)NSNumber* days;
@end
