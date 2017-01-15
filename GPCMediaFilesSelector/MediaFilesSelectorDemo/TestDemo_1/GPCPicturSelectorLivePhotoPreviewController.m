//
//  GPCPicturSelectorLivePhotoPreviewController.m
//  GPCProject
//
//  Created by 李义真 on 2016/12/22.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCPicturSelectorLivePhotoPreviewController.h"
#import <PhotosUI/PHLivePhotoView.h>

@interface GPCPicturSelectorLivePhotoPreviewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* tableView;
@end

@implementation GPCPicturSelectorLivePhotoPreviewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //解决控制器自动适配UScrollView在导航条隐藏情况下滚动适配的问题
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = NO;
    self.title = @"LivePhoto预览";
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 64.0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64.0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UITableView*)tableView
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark--UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.livePhotoItemList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* identifier = @"tableViewCellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        
    }
    PHLivePhotoView* livePhotoView = [cell.contentView viewWithTag:10000];
    if(livePhotoView == nil)
    {
        livePhotoView = [[PHLivePhotoView alloc] initWithFrame:cell.contentView.bounds];
        livePhotoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        livePhotoView.tag = 10000;
        [cell.contentView addSubview:livePhotoView];
    }
    GPCMediaFilesSelectorLivePhotoItem* item = self.livePhotoItemList[indexPath.row];
    livePhotoView.livePhoto = item.livePhoto;
    
    return cell;
}
@end
