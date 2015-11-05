//
//  InfoPage.h
//  1105 期末考
//
//  Created by 劉坤昶 on 2015/11/05.
//  Copyright © 2015年 劉坤昶 Johnny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoPage : UIViewController




@property NSDictionary *nextDic ;

@property (weak, nonatomic) IBOutlet UIImageView *bandPic;

@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UITextView *bandTextView;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;

@property (weak, nonatomic) IBOutlet UITextView *shopIntro;

@property (weak, nonatomic) IBOutlet UITextView *shopWeb;

@property (weak, nonatomic) IBOutlet UITextView *shopAddress;


@end
