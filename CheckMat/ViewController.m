//
//  ViewController.m
//  CheckMat
//
//  Created by Temirlan Merekeyev on 02.06.17.
//  Copyright © 2017 Temirlan Merekeyev. All rights reserved.
//

#import "ViewController.h"
#import "TMUser.h"
#import "TMServerManager.h"
#import "Reachability.h"
@interface ViewController () <UITextFieldDelegate>
@property (strong,nonatomic)NSDictionary* json;
@property (strong,nonatomic)NSString* login;
@property (strong,nonatomic)NSString* password;
@property (strong,nonatomic)TMUser* user;
@property (weak, nonatomic) IBOutlet UITextField *loginField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)signIn:(UIButton *)sender;
- (IBAction)actionTextDidEnd:(UITextField* )sender;
@property (strong,nonatomic) UITabBarController* tabBarController;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (strong, nonatomic)UIAlertController* alert;
@property (strong,nonatomic)UIActivityIndicatorView* spinner;


@end

typedef void(^logCompletion)(BOOL);

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.user = [TMUser user];
    self.json = [NSDictionary dictionary];
    
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController* tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    self.tabBarController = tabBarController;
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Activity Indicator

- (void)activity{
    
    self.alert= [UIAlertController alertControllerWithTitle:nil
                                                                  message:@"Подключаюсь... \n\n"
                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    self.spinner.center = CGPointMake(130.5, 75.5);
    self.spinner.color = [UIColor blackColor];
    [self.spinner startAnimating];
    
    [self.alert.view addSubview:self.spinner];
    [self presentViewController:self.alert
                       animated:YES
                     completion:nil];
    
}

-(void) stopActivity{
    
    [self.spinner stopAnimating];
    [self.alert dismissViewControllerAnimated:YES
                                   completion:nil];
}
#pragma mark - Internet status

-(BOOL)IsConnectionAvailable
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    return !(networkStatus == NotReachable);
}


#pragma mark - API

-(void) getAccess:(logCompletion) compblock{

    if([self IsConnectionAvailable]){
        [[TMServerManager sharedManager] accessToServerWithLogin:self.login
                                                        password:self.password
                                                       onSuccess:^(NSDictionary *json) {
                                                           self.json = [NSDictionary dictionaryWithDictionary:json];
                                                           
                                                           self.user.statusOfAuthorization = [self.json objectForKey:@"stat"];
                                                           self.user.userId = [self.json objectForKey:@"user_id"];
                                                          
                                                           compblock (YES);
                                                           
                                                       } onFailure:^(NSError *error) {
                                                           
                                                           [self alertTitle:@"Проблема с доступом к интернету" Message:@"Подключите интернет" Button:@"Назад"];
                                                           
                                                       }];
    }else{
        
        [self alertTitle:@"Проблема с доступом к интернету" Message:@"Подключите интернет" Button:@"Назад"];
    }
    

   
   
    
    
}
#pragma mark - Action
- (IBAction)signIn:(UIButton *)sender {
    
    [self actionTextDidEnd:self.passwordField];
    
    [self activity];
   
        [self getAccess:^(BOOL finished) {
            
            [self stopActivity];
            if (finished){
                
                
                
                    if([self.user.statusOfAuthorization isEqualToString:@"ok"]){
                        [self presentViewController:[self tabBarController] animated:YES completion:nil];
                    }else{
                        
                        [self alertTitle:@"Неверный вход"
                                 Message:@"Пожалуйста проверьте свой логин и пароль"
                                  Button:@"Назад"];
                        
                    }
                }

            
        }];
        
}

- (IBAction)actionTextDidEnd:(UITextField*)sender {
    
    if([sender isEqual:self.loginField]){
        self.login = [sender text];
        
    }else{
        self.password = [sender text];
        
        
        
        
    }
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if([textField isEqual:self.loginField]){
        
        [self.passwordField becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
        
       
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if([textField isEqual:self.loginField]){
        self.login = [textField text];
    }else{
        self.password = [textField text];
    }
    
}
#pragma mark - Alert

- (void) alertTitle:(NSString*) title
            Message:(NSString*) message
             Button:(NSString*) buttonText{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction actionWithTitle:buttonText
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    [alert addAction:okButton];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
    
    
}
@end
