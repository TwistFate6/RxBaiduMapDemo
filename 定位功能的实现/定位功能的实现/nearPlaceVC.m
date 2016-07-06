//
//  nearPlaceVC.m
//  定位功能的实现
//
//  Created by RXL on 16/7/5.
//  Copyright © 2016年 RXL. All rights reserved.
//

#import "nearPlaceVC.h"
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"
@interface nearPlaceVC ()<BMKPoiSearchDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, assign) int curPage;
@property (nonatomic, strong) BMKPoiSearch *searcher;

@end
@implementation nearPlaceVC

-(void)viewDidLoad{
    //初始化检索对象
    _searcher =[[BMKPoiSearch alloc]init];
    _searcher.delegate = self;
    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = self.curPage;
    option.pageCapacity = 10;
    option.location = CLLocationCoordinate2DMake(31.486132, 120.381090);
    
//    option.location = currentPoint;
    
    option.keyword = @"东南大学";
    BOOL flag = [_searcher poiSearchNearBy:option];
//    [option release];
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
}

//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        
        for (BMKPoiInfo *PoiInfo in poiResultList.poiInfoList) {
            
            [self.dataArr addObject:PoiInfo];
        }
        
        [self.tableView reloadData];
        
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}

- (void)onGetPoiDetailResult:(BMKPoiSearch*)searcher result:(BMKPoiDetailResult*)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode{
    
    if (errorCode == 0) {
        NSLog(@"详细信息");
        
    }
    
}

#pragma mark - tableView的代理方法及数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nearByPlace"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nearByPlace"];
    }
    
//    取得对应的数据
    BMKPoiInfo *currentData = self.dataArr[indexPath.row];
    
    cell.textLabel.text = currentData.name;
    return cell;
}

#pragma mark - 懒加载
-(NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}
@end
