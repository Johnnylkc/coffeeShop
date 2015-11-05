//
//  MapView.m
//  1014 table 新增移除
//
//  Created by 劉坤昶 on 2015/11/5.
//  Copyright © 2015年 劉坤昶 Johnny. All rights reserved.
//

#import "MapView.h"

#import "MapKit/MapKit.h"
#import "MyAnnotation.h"
#import <CoreLocation/CoreLocation.h>

@interface MapView ()<MKMapViewDelegate , CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLGeocoder *geoCoder;
    __weak IBOutlet MKMapView *myMapView;
    CLPlacemark *storePlaceMark;
    CLLocationCoordinate2D coordinate;
    
    
}

@property (weak, nonatomic) IBOutlet MKMapView *myMap;



@end

@implementation MapView

- (void)viewDidLoad {
    [super viewDidLoad];

    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    locationManager.delegate =self;
    geoCoder = [[CLGeocoder alloc] init];
    [locationManager startUpdatingLocation];
    
    [self getCoordinateFromAddress];
    
}


-(void)getCoordinateFromAddress
{
    
    NSLog(@"%@",self.shopAddress);
    [geoCoder geocodeAddressString:self.shopAddress completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
       
        
        
        if (error == nil && placemarks.count > 0) {
            CLPlacemark *placeMark =placemarks[0];
            storePlaceMark = placeMark;
            
            coordinate = storePlaceMark.location.coordinate;
           
            MyAnnotation *annotation1 =
            [[MyAnnotation alloc] initWithCoordinate:coordinate title:self.shopAddress subtitle:@""];
            
            [myMapView addAnnotation:annotation1];
            
        
            [myMapView setCenterCoordinate:storePlaceMark.location.coordinate animated:YES];
        
        
        
            MKCoordinateRegion region;
            region.center = storePlaceMark.location.coordinate;
            MKCoordinateSpan mapSpan;
            mapSpan.latitudeDelta = 0.005;
            mapSpan.longitudeDelta = 0.005;
            region.span = mapSpan;
            myMapView.region = region;
            
            [myMapView setRegion:region animated:YES];
        
    
        }
        
    }];
 
    
}




- (IBAction)back:(id)sender
{

    [self dismissViewControllerAnimated:YES completion:nil];


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
