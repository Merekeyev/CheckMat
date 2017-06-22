//
//  TMUser.h
//  CheckMat
//
//  Created by Temirlan Merekeyev on 03.06.17.
//  Copyright © 2017 Temirlan Merekeyev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMUser : NSObject
@property (strong, nonatomic) NSString* statusOfAuthorization;
@property (strong, nonatomic) NSString* userId;
@property (strong, nonatomic) NSString* email;
@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSString* patronymic;
@property (strong, nonatomic) NSString* phone;
@property (strong, nonatomic) NSString* role;
@property (strong, nonatomic) NSString* status;
@property (strong, nonatomic) NSString* createdDate;
@property (strong, nonatomic) NSString* updatedDate;
@property (strong, nonatomic) NSString* username;
+(TMUser*) user;
@end
