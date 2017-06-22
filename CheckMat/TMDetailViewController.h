//
//  TMDetailViewController.h
//  CheckMat
//
//  Created by Temirlan Merekeyev on 13.06.17.
//  Copyright © 2017 Temirlan Merekeyev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *infoText;

-(void)getInfo:(NSAttributedString*) info;
@end
