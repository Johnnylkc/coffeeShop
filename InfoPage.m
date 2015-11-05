//
//  InfoPage.m
//  1105 期末考
//
//  Created by 劉坤昶 on 2015/11/05.
//  Copyright © 2015年 劉坤昶 Johnny. All rights reserved.
//


#import <SafariServices/SafariServices.h>
#import "InfoPage.h"
#import "ZoomPhoto.h"
#import "MapView.h"

@interface InfoPage ()




@end

@implementation InfoPage

- (void)viewDidLoad {
    [super viewDidLoad];

    self.bandPic.image = self.nextDic[@"photo"];
    self.labelName.text = self.nextDic[@"name"];
    self.phoneNumber.text = self.nextDic[@"phone"];
    self.shopIntro.text = self.nextDic[@"intro"];
    self.shopWeb.text = self.nextDic[@"web"];
    self.shopAddress.text = self.nextDic[@"address"];
}




- (IBAction)zoomInPhoto:(id)sender
{

    
    ZoomPhoto *controller =
    [self.storyboard instantiateViewControllerWithIdentifier:@"ZoomPhoto"];
    
    controller.catchImage = self.bandPic.image;
    
    
    [self presentViewController:controller animated:YES completion:nil];

}




- (IBAction)toMap:(id)sender
{

    MapView *controller =
    [self.storyboard instantiateViewControllerWithIdentifier:@"MapView"];

    controller.shopAddress = self.nextDic[@"address"];
    
    [self presentViewController:controller animated:YES completion:nil];

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

@end
