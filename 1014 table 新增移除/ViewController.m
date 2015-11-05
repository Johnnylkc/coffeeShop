//
//  ViewController.m
//  1105 期末考
//
//  Created by 劉坤昶 on 2015/11/05.
//  Copyright © 2015年 劉坤昶 Johnny. All rights reserved.
//

#import "ViewController.h"
#import "Parse/Parse.h"

@interface ViewController () <UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *addressText;
@property (weak, nonatomic) IBOutlet UITextField *webText;
@property (weak, nonatomic) IBOutlet UITextField *commandText;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}



//完成資料並存檔
- (IBAction)buttonDone:(id)sender {
    
  
    PFObject *updateParse = [PFObject objectWithClassName:@"bandArray"];
    
    NSData *imageData = UIImageJPEGRepresentation(self.photoChosen.image, 1);
    
    PFFile *imageFile = [PFFile fileWithName:@"new photo" data:imageData];
    
    
    updateParse[@"name"] = self.nameText.text ;
    updateParse[@"phone"] = self.phoneText.text ;
    updateParse[@"image"] = imageFile ;
    updateParse[@"address"] = self.addressText.text;
    updateParse[@"web"] = self.webText.text;
    updateParse[@"intro"] = self.commandText.text;
    
   
    __block NSMutableDictionary *newDic =
    [@{@"name":self.nameText.text ,
       @"phone":self.phoneText.text ,
       @"photo":self.photoChosen.image ,
       @"address":self.addressText.text ,
       @"web":self.webText.text ,
       @"intro":self.commandText.text} mutableCopy ];
    
    [updateParse saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        if (succeeded) {
          
            [newDic setObject:updateParse.objectId forKey:@"localObjectId"];
          
            NSLog(@"上傳成功");
            
        }else{
            
            NSLog(@"上傳失敗");
            
        };
    }];
    
    
    
        //這裡”發布“廣播 廣播代號AddBandNoti  自己就是物件 這廣播有包含哪些資訊呢？ 包含剛剛textFiled輸入的資訊集合而成的字典
    [[NSNotificationCenter defaultCenter]postNotificationName:@"AddBandNoti"
                                                       object:nil
                                                     userInfo:newDic];
    
        //完成後回到前一頁
    [self.navigationController popViewControllerAnimated:YES];
  
    
   

}
    





//啟動相機
- (IBAction)openCamera:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
       
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.delegate = self;
        
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        picker.allowsEditing = false;
        
        
        [self presentViewController:picker animated:true completion:nil];
    
    }

}







//選擇照片
- (IBAction)pickImage:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.allowsEditing = YES;///變正方形！？
        
        picker.delegate = self;
        
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        picker.allowsEditing = true;
        
        [self presentViewController:picker animated:true completion:nil];
    }

}





//在view上顯示你選的照片 當然你得先啦個imageview property
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.photoChosen.image = image;
    
    [self dismissViewControllerAnimated:true completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
