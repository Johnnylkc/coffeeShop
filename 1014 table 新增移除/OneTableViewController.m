//
//  OneTableViewController.m
//  1105 期末考
//
//  Created by 劉坤昶 on 2015/11/05.
//  Copyright © 2015年 劉坤昶 Johnny. All rights reserved.
//

#import "OneTableViewController.h"
#import "DetailCell.h"
#import "InfoPage.h"
#import "Parse/Parse.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface OneTableViewController ()
{
    
    NSMutableArray  *bandArray;
    UIRefreshControl *refreshControl;
}

@property (strong, nonatomic) IBOutlet UITableView *myTable;


@end

@implementation OneTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    
    //給bandArray一個記憶體位置 之後會用到 目前還是空的NSMutableArray
    bandArray = [[NSMutableArray alloc] init];

    
    //接收來自viewcontroller.m的廣播 接收後執行addMovieNoti這個方法
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(addMovieNoti:)
                                                name:@"AddBandNoti"
                                              object:nil];
    
    //在navbar左側新增按鈕
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    //執行下載
    [self downloadFormParse];

    //檢查網路連線
    [self checkInternet];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.myTable addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
}


- (void)refreshTable {
    [bandArray removeAllObjects];
    [self downloadFormParse];
    [refreshControl endRefreshing];
    [self.myTable reloadData];
    NSLog(@"reload完成");
}


//從parse下載資料 在viewdidload裡執行這方法 一開啟就執行下載
-(void)downloadFormParse
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"bandArray"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        for (PFObject *newStuff in objects) {
           
            NSString *name = newStuff[@"name"];
        
            NSString *country = newStuff[@"country"];
            
            PFFile *dataPhoto = newStuff[@"image"];
            
            NSString *shopAddress = newStuff[@"address"];
            
            
      ///以下是第一頁沒有 第二頁才有的 只是在第一頁先下載下來
            NSString *phoneNumber = newStuff[@"phone"];
            NSString *shopIntro = newStuff[@"intro"];
            NSString *shopWeb = newStuff[@"web"];
            
            [dataPhoto getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
               
                if (error == nil) {
                
                    UIImage *image = [[UIImage alloc] initWithData:data];
                    
                    NSLog(@"image data over");
                    
                    NSDictionary *dic01 = [NSDictionary dictionaryWithObjectsAndKeys:
                                         name, @"name",
                                         country, @"country",
                                         image, @"photo",
                                          shopAddress,@"address",
                                           phoneNumber,@"phone",
                                           shopIntro,@"intro",
                                           shopWeb,@"web",
                                          newStuff.objectId,@"localObjectId"
                                         , nil];
                    
                    [bandArray addObject:dic01];
                }
                
                [self.tableView reloadData];///////重點！！ 記得reloadData
            }];
            
        }
    }];
    
}





//執行ViewController.m 所廣播要求的方法
-(void)addMovieNoti:(NSNotification*)noti
{
    
    //這裡先新增一個字典叫movieDic 字典裡有之前textField輸入而成的字典
    NSDictionary *movieDic = noti.userInfo;
    
    //把新資訊加在bandArray的第一個位置
    [bandArray insertObject:movieDic atIndex:0];
    
    
    //其實是可以直接用reloaddata 來重整頁面
    //[self.tableView reloadData];
    
    
    //這是一個動畫設定 insert將新資料殺入在第一行
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
   
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];

}




//刪除資料的方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //移動表格位置
    self.editing = YES;

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        PFQuery *deleteObject = [PFQuery queryWithClassName:@"bandArray"];
        
        [deleteObject whereKey:@"name" equalTo:bandArray[indexPath.row][@"name"]];
        
        [deleteObject getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            
            if (!object) {
                NSLog(@"無資料");
            
            } else {
                
                [object deleteInBackground];

                NSLog(@"刪除成功");
                
            }
        }];
        

        [bandArray removeObjectAtIndex:indexPath.row];
        
        //其實也可以只用reloaddata就好 但就沒有動畫
        //[self.tableView reloadData]
        
        [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationFade];
    }
}





//移動表格順序位置
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES; }

//移動表格順序位置
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:
(NSIndexPath *)toIndexPath
{
    NSDictionary *dic = bandArray[fromIndexPath.row];
    [bandArray removeObjectAtIndex:fromIndexPath.row];
    [bandArray insertObject:dic atIndex:toIndexPath.row];
}


//傳遞cell資料到下一頁
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoPage *controller =
    [self.storyboard instantiateViewControllerWithIdentifier:@"InfoPage"];
    
    NSDictionary *oldDic = bandArray[indexPath.row];
    
    controller.nextDic = oldDic ;

    [self.navigationController pushViewController:controller animated:YES];
    
}








- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return bandArray.count;
}


//cell內容
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
    
    NSDictionary *bandInfo = bandArray[indexPath.row];
    

    cell.bandPhoto.image = bandInfo[@"photo"];
    cell.bandName.text = bandInfo[@"name"];
    cell.bandCountry.text = bandInfo[@"phone"];
    cell.shopAddress.text = bandInfo[@"address"];
    
    
    return cell;
}




///檢查網路連線
-(void)checkInternet
{

    NSString *host = @"www.google.com";
    
    SCNetworkReachabilityRef  reachability = SCNetworkReachabilityCreateWithName(nil,host.UTF8String);
    SCNetworkReachabilityFlags flags;
    BOOL result = NO;
    if(reachability) {
    
        result = SCNetworkReachabilityGetFlags(reachability, &flags);
    
        CFRelease(reachability);
 }
    
    NSLog(@"%d %d", result, flags);
   
    if(!result || !flags) {
        NSLog(@"無網路");
   
    }else {
    
        NSLog(@"有網路"); }

}















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
