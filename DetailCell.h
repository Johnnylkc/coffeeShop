//
//  DetailCell.h
//  1105 期末考
//
//  Created by 劉坤昶 on 2015/11/05.
//  Copyright © 2015年 劉坤昶 Johnny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *bandPhoto;

@property (weak, nonatomic) IBOutlet UILabel *bandName;

@property (weak, nonatomic) IBOutlet UILabel *bandCountry;


@property (weak, nonatomic) IBOutlet UILabel *shopAddress;



@end
