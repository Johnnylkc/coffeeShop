//
//  ZoomPhoto.m
//  1014 table 新增移除
//
//  Created by 劉坤昶 on 2015/11/5.
//  Copyright © 2015年 劉坤昶 Johnny. All rights reserved.
//

#import "ZoomPhoto.h"

@interface ZoomPhoto () <UIScrollViewDelegate>
{
    
    UIImageView *imageView;
    
    
}

@end

@implementation ZoomPhoto

- (void)viewDidLoad {
    [super viewDidLoad];

    self.scroller.contentSize =
    CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    self.scroller.delegate = self;
    float screenWidth;
    
    
    if(screenWidth == 320) {
        
        imageView =
        [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
        
    }else if (screenWidth == 375){
        
        imageView =
        [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 375, 505)];
        
    }else{
        
        imageView =
        [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 414, 494)];
        
    }
    
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = self.catchImage;
    [self.scroller addSubview:imageView];


}




- (IBAction)tap:(id)sender
{

    [self dismissViewControllerAnimated:YES completion:Nil];
    
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
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
