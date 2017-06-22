//
//  TMDetailViewController.m
//  CheckMat
//
//  Created by Temirlan Merekeyev on 13.06.17.
//  Copyright © 2017 Temirlan Merekeyev. All rights reserved.
//

#import "TMDetailViewController.h"

@interface TMDetailViewController ()
@property(strong,nonatomic)NSMutableAttributedString* info;



@end

@implementation TMDetailViewController

@synthesize infoText;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self textView:self.info];
    
    
    // Do any additional setup after loading the view.
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

#pragma mark - Methods

-(void)getInfo:(NSAttributedString*) info{
    
    
    self.info = (NSMutableAttributedString*)info;
    [self textView:self.info];
    
}

-(void)textView :(NSMutableAttributedString*) info{
    [self.infoText setText:[info string]];
}

@end
