//
//  ViewController.m
//  定位功能的实现
//
//  Created by RXL on 16/7/5.
//  Copyright © 2016年 RXL. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

@property (weak, nonatomic) IBOutlet UILabel *jingduLabel;
@property (strong, nonatomic) IBOutlet UILabel *weiDuLabel;
@property (weak, nonatomic) IBOutlet UILabel *address;

/**
 *  定位服务
 */
@property (nonatomic, strong) BMKLocationService *sevice;

@property (nonatomic, strong) BMKGeoCodeSearch *geocodesearch;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sevice.delegate = self;
    [self.sevice startUserLocationService];
    self.geocodesearch.delegate = self;
}

#pragma mark - 开始定位
- (IBAction)start:(id)sender {
    
    NSLog(@"经度为%f    维度为:%f",self.sevice.userLocation.location.coordinate.longitude,self.sevice.userLocation.location.coordinate.latitude);
    
    self.jingduLabel.text = [NSString stringWithFormat:@"%f",self.sevice.userLocation.location.coordinate.longitude];
    self.weiDuLabel.text = [NSString stringWithFormat:@"%f",self.sevice.userLocation.location.coordinate.latitude];
    
    [self.sevice stopUserLocationService];
}

- (void)didStopLocatingUser{
    currentPoint = CLLocationCoordinate2DMake(self.sevice.userLocation.location.coordinate.latitude, self.sevice.userLocation.location.coordinate.longitude);
}
#pragma mark - 反编译

- (IBAction)addressGET:(id)sender {
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};//初始化
    if (self.sevice.userLocation.location.coordinate.longitude!= 0
        && self.sevice.userLocation.location.coordinate.latitude!= 0) {
        //如果还没有给pt赋值,那就将当前的经纬度赋值给pt
        pt = (CLLocationCoordinate2D){self.sevice.userLocation.location.coordinate.latitude,
            self.sevice.userLocation.location.coordinate.longitude};
    }
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];//初始化反编码请求
    reverseGeocodeSearchOption.reverseGeoPoint = pt;//设置反编码的店为pt
    BOOL flag = [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];//发送反编码请求.并返回是否成功
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
}


-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        NSString* titleStr;
        NSString* showmeg;
        titleStr = @"反向地理编码";
        showmeg = [NSString stringWithFormat:@"%@",item.title];
        self.address.text = showmeg;
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
        
        
    }
}



#pragma mark - 懒加载
-(BMKLocationService *)sevice{
    if (_sevice == nil) {
        _sevice = [[BMKLocationService alloc] init];
    }
    return _sevice;
}

-(BMKGeoCodeSearch *)geocodesearch{
    if (_geocodesearch == nil) {
        _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    }
    return _geocodesearch;
}

@end
