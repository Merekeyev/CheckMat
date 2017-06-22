//
//  TMCabinetViewController.m
//  CheckMat
//
//  Created by Temirlan Merekeyev on 03.06.17.
//  Copyright © 2017 Temirlan Merekeyev. All rights reserved.
//

#import "TMCabinetViewController.h"
#import "TMUser.h"
#import "TMServerManager.h"
#import "TMClient.h"
#import "ViewController.h"
@interface TMCabinetViewController ()
- (IBAction)actionShow:(id)sender;
@property (strong, nonatomic)TMUser* user;
@property (strong, nonatomic)TMClient* client;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *patronymic;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet UILabel *abonementLabel;
@property (strong, nonatomic)NSDate* dateOfEnd;
@property (strong,nonatomic)ViewController* vc;
@end

typedef void(^ getUserCompletion)(BOOL) ;

@implementation TMCabinetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [TMUser user];
    self.client = [TMClient client];
    self.dateOfEnd = [[NSDate alloc] init];
    NSDateFormatter* dateFormatterFromServer = [[NSDateFormatter alloc] init];
    NSDateFormatter* correctDateFormatter = [[NSDateFormatter alloc] init];
    NSCalendar *cal = [NSCalendar currentCalendar];
    [dateFormatterFromServer setDateFormat:@"yyyy-MM-dd"];
    [correctDateFormatter setDateStyle:NSDateFormatterLongStyle];
    [correctDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
     [self getUserData:^(BOOL finished) {
               if(finished){
                   self.firstNameLabel.text    = self.user.firstName;
                   self.lastNameLabel.text     = self.user.lastName;
                   self.patronymic.text        = self.user.patronymic;
                   self.phoneLabel.text        = self.user.phone;
                   self.emailLabel.text        = self.user.email;
                   self.numberOfCardLabel.text = self.user.username;
                   
               }
               
           }];
    
     [self getClientData:^(BOOL finished) {
         if(finished){
             self.dateOfEnd = [dateFormatterFromServer dateFromString:self.client.birth_date];
             self.dateOfEnd = [cal dateByAddingUnit:NSCalendarUnitMonth
                                              value:1
                                             toDate:self.dateOfEnd
                                            options:0];
             if([self.client.abonement_id isEqual:[NSNumber numberWithInt:3]]){
                 self.abonementLabel.text = @"Безлимит до ";
                // self.daysLabel.text = [NSString stringWithFormat:@"%@", self.client.birth_date];
                 [self.daysLabel setText:[correctDateFormatter stringFromDate:self.dateOfEnd]];
             }else{
                 self.abonementLabel.text = @"Количество тренировок - ";
                 self.daysLabel.text = [NSString stringWithFormat:@"%@", self.client.days];
             }
             
         }
     }];
        
   
        
        
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - API
-(void) getUserData:(getUserCompletion) complblock{
    

    
   [[TMServerManager sharedManager] getUserData:self.user.userId
                                      onSuccess:^(NSDictionary *json) {
                                          self.user.username    = [json objectForKey:@"username"];
                                          self.user.email       = [json objectForKey:@"email"];
                                          self.user.firstName   = [json objectForKey:@"first_name"];
                                          self.user.lastName    = [json objectForKey:@"last_name"];
                                          self.user.patronymic  = [json objectForKey:@"patronymic"];
                                          self.user.phone       = [json objectForKey:@"phone"];
                                          self.user.role        = [json objectForKey:@"role"];
                                          self.user.status      = [json objectForKey:@"status"];
                                          self.user.createdDate = [json objectForKey:@"created_at"];
                                          self.user.updatedDate = [json objectForKey:@"updated_at"];
                                          complblock(YES);
                                      } onFailure:^(NSError *error) {
                                          NSLog(@"Error %@", error);
                                      }];
    
}

-(void) getClientData:(getUserCompletion) complblock{
    
    [[TMServerManager sharedManager] getClientData:self.user.userId
                                         onSuccess:^(NSDictionary *json) {
                                             self.client.clientId = [json objectForKey:@"id"];
                                             self.client.userId = [json objectForKey:@"user_id"];
                                             self.client.abonement_id = [json objectForKey:@"abonement_id"];
                                             self.client.gender = [json objectForKey:@"gender"];
                                             self.client.birth_date = [json objectForKey:@"birth_date"];
                                             self.client.days = [json objectForKey:@"days"];
                                             complblock(YES);
                                         } onFailure:^(NSError *error) {
                                             NSLog(@"Error %@", error);
                                         }];
    
}

#pragma mark - Action
- (IBAction)actionShow:(id)sender {
    
    [self presentViewController:[self vc] animated:YES completion:nil];
    
}
@end
