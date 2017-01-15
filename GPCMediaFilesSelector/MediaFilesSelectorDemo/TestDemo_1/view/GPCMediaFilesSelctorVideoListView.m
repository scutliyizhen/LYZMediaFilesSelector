//
//  GPCPictureSelctorVideoListView.m
//  GPCProject
//
//  Created by 李义真 on 2016/12/1.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelctorVideoListView.h"
#import "GPCMediaFilesSelectorVideoCellView.h"

#define GPC_BOTTOM_CONTENT_VIEW_TAG (10000)

static NSString* GPCInputVideoFilesCellLineViewIdentifier = @"gpcInputVideoFilesCellLineViewIdentifier";

@interface GPCPictureSelctorVideoListView()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,assign)CGRect previorsPreHeatRect;
@end

@implementation GPCPictureSelctorVideoListView
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.previorsPreHeatRect = CGRectZero;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (UITableView*)tableView
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:GPCInputVideoFilesCellLineViewIdentifier];
        
        __weak typeof (_tableView) weakTableView = _tableView;
        [[GPCMediaFilesSelectorPhotoCaseDataSource gridCellIdentifiers] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:obj];
        }];
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

- (void)reloadData
{
    [self.tableView reloadData];
}

- (void)preLoadAssetsWhenViewDidAppear
{
    [self updateCachedVideos];
}

- (void)setGridCaseDataSource:(GPCMediaFilesSelectorPhotoCaseDataSource *)gridCaseDataSource
{
    _gridCaseDataSource = gridCaseDataSource;
}

- (GPCMediaFilesSelectorPhotoCase*)getVideoModelByIndex:(NSIndexPath*)index
{
    GPCMediaFilesSelectorPhotoCase* model = (GPCMediaFilesSelectorPhotoCase*)[self.gridCaseDataSource getPictureSelectorModelInPictureListByIndex:index.item / 2];
    return model;
}

#pragma mark--UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.gridCaseDataSource numberOfPicureModels] * 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0;
    if(indexPath.row % 2 == 1)
    {
        height = 100;
    }else
    {
        height = 20;
    }
    return height;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    GPCMediaFilesSelectorPhotoCase* slectorCase = nil;
    if(indexPath.row %2 == 1)
    {
        slectorCase  = [self getVideoModelByIndex:indexPath];
        NSString* indentifier = [GPCMediaFilesSelectorPhotoCaseDataSource
                                 getIdentifierByModel:slectorCase];
        
        cell = [tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
    }else
    {
        
        cell = [tableView dequeueReusableCellWithIdentifier:GPCInputVideoFilesCellLineViewIdentifier forIndexPath:indexPath];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView* contentView = [cell.contentView viewWithTag:GPC_BOTTOM_CONTENT_VIEW_TAG];
    
    if(contentView == nil)
    {
        if(indexPath.row % 2 == 1)
        {
            GPCMediaFilesSelectorVideoCellView* cellView = [GPCMediaFilesSelectorVideoCellView new];
            contentView = cellView;
            cellView.backgroundColor = [UIColor greenColor];
        }else
        {
            UIView* cellView = [[UIView alloc] initWithFrame:CGRectZero];
            contentView = cellView;
            cellView.backgroundColor = [UIColor redColor];
        }
        
        contentView.frame = cell.contentView.bounds;
        contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        contentView.tag = GPC_BOTTOM_CONTENT_VIEW_TAG;
        [cell.contentView addSubview:contentView];
    }
    
    if(indexPath.row % 2 == 1)
    {
        GPCMediaFilesSelectorVideoCellView* videoCellView = (GPCMediaFilesSelectorVideoCellView*)contentView;
        videoCellView.photoCase = slectorCase;
        videoCellView.photoCase.options.requestPhotoName = YES;
        videoCellView.photoCase.options.requestGalleryTitle = YES;
        videoCellView.photoCase.options.requestCreateTime = YES;
        [slectorCase requestUpdateIconImage:^(UIImage *image,BOOL isFastImage,GPCMediaFilesSelectorCase* selectorCase ,NSDictionary* info) {
            videoCellView.iconImage = image;
            
            videoCellView.photoTile = [info objectForKey:@"filename"];
            videoCellView.galleryTitle = [info objectForKey:@"galleryname"];
            
            NSDate* createDate = [info objectForKey:@"createdate"];
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd";
            videoCellView.createTime = [formatter stringFromDate:createDate];
            [videoCellView setNeedsLayout];
        }];
    }
    
    return cell;
}

#pragma mark--UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateCachedVideos];
}

- (BOOL)isVisibleIndex:(NSUInteger)index
{
    __weak typeof (self) weakSelf = self;
    __block BOOL flag = NO;
    [self.tableView.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath* indexPath = [weakSelf.tableView indexPathForCell:obj];
        if(indexPath.row%2 == 1  && index == indexPath.row/2)
        {
            flag = YES;
            *stop = YES;
        }
    }];
    return flag;
}

- (void)updateCachedVideos
{
    CGRect preHeatRect = self.tableView.bounds;
    preHeatRect = CGRectInset(preHeatRect, 0.0f, -0.5*CGRectGetHeight(preHeatRect));
    
    CGFloat delta = ABS(CGRectGetMidY(preHeatRect) - CGRectGetMidY(self.previorsPreHeatRect));
    if(delta > CGRectGetHeight(self.tableView.bounds))
    {
        for(NSUInteger counter = 0; counter < [self.gridCaseDataSource numberOfPicureModels]; counter++)
        {
            NSIndexPath* indexPath=[NSIndexPath indexPathForRow:counter*2+1 inSection:0];
            
            UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            GPCMediaFilesSelectorVideoCellView* contentView = [cell.contentView viewWithTag:GPC_BOTTOM_CONTENT_VIEW_TAG];
            if([self isVisibleIndex:counter])
            {
                //开始请求加载
//                [contentView.photoCase startRequestIconImage];
            }else
            {
                //停止加载
//                [contentView.photoCase stopRequestIConImage];
            }
        }
        self.previorsPreHeatRect = preHeatRect;
    }
}
@end
