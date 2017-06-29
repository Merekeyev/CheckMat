//
//  TMNewsCell.h
//  CheckMat
//
//  Created by Temirlan Merekeyev on 24.06.17.
//  Copyright © 2017 Temirlan Merekeyev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMNewsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsLabel;

@end
