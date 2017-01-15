//
//  GPCMediaFilesSelectorPhotoGalleryView.m
//  GameBible
//
//  Created by robertyzli on 16/7/16.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorPhotoGalleryView.h"
#import "GPCMediaFilesSelectorTableView.h"
#import "GPCMediaFilesSelectorGalleryCellView.h"
#import "GPCMediaFilesSelectorUtilityHelper.h"

#define GPC_BOTTOM_CONTENT_VIEW_TAG (10000)

#define GPC_PHOTO_ALBUM_IMAGE_HEIGHT (GPC_WIDTH_RATIO*130/2.0)
#define GPC_PHOTO_ALBUM_FILE_ICON_BOTTOM_GAP (GPC_WIDTH_RATIO*32.0/2)
#define GPC_PHOTO_ALBUM_ARROW_RIGHT_MARGINE (GPC_WIDTH_RATIO*24.0/2)
#define GPC_PHOTO_ALBUM_FILE_NAME_LEFT_MARGINE (GPC_WIDTH_RATIO*20.0/2)
#define GPC_PHOTO_ALBUM_NUM_TOP_MARGINE (16.0/2)
#define GPC_PHOTO_ALBUM_PIC_LEFT_MARGINE (GPC_WIDTH_RATIO*24.0/2)

static NSString* GPCInputAlbumFilesCellLineViewIdentifier = @"gpcInputAlbumFilesCellLineViewIdentifier";

@interface GPCMediaFilesSelectorPhotoGalleryView()<GPCMediaFilesSelectorTableViewDelegate>
@property(nonatomic,strong)GPCMediaFilesSelectorTableView* selectorTableView;

@property(nonatomic,assign)Class caseSourceClass;
@property(nonatomic,assign)Class bridgeClass;
@end

@implementation GPCMediaFilesSelectorPhotoGalleryView
- (instancetype)initWithBridgeClass:(Class)bridgeClass caseSourceClass:(Class)caseSourceClass
{
    return [self initWithFrame:CGRectZero bridgeClass:bridgeClass caseSourceClass:caseSourceClass];
}

- (instancetype)initWithFrame:(CGRect)frame bridgeClass:(Class)bridgeClass caseSourceClass:(Class)caseSourceClass
{
    if(self = [super initWithFrame:frame])
    {
        self.bridgeClass = bridgeClass;
        self.caseSourceClass = caseSourceClass;
    }
    return self;
}

- (GPCMediaFilesSelectorTableView*)selectorTableView
{
    if(_selectorTableView == nil)
    {
        _selectorTableView = [GPCMediaFilesSelectorTableView new];
        _selectorTableView.delegate = self;
        [self addSubview:_selectorTableView];
    }
    return _selectorTableView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.selectorTableView.frame = self.bounds;
}

- (void)reloadData
{
    [self.selectorTableView reloadData];
}

- (void)preLoadAssetsWhenViewDidAppear
{
    [self.selectorTableView preLoadAssetsWhenViewDidAppear];
}

- (GPCMediaFilesSelectorAlbumCase*)getGalleryModelByIndex:(NSIndexPath*)index
{
    GPCMediaFilesSelectorAlbumCase* selectorCase = (GPCMediaFilesSelectorAlbumCase*)[self.galleryDataSource getPictureSelectorModelInPictureListByIndex:index.item / 2];
    return selectorCase;
}

#pragma mark--GPCMediaFilesSelectorTableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.galleryDataSource numberOfPicureModels] * 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0;
    if(indexPath.row % 2 == 1)
    {
        height = GPC_PHOTO_ALBUM_IMAGE_HEIGHT;
    }else
    {
        height = GPC_PHOTO_ALBUM_FILE_ICON_BOTTOM_GAP;
    }
    return height;
}

- (NSString*)tableView:(UITableView *)tableView cellIdentifierForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.row % 2 == 1)
    {
        GPCMediaFilesSelectorAlbumCase* slectorCase = [self getGalleryModelByIndex:indexPath];
    	NSString* indentifier = [GPCMediaFilesSelectorGalleryCaseDataSource getIdentifierByModel:slectorCase];
        return indentifier;
    }else
    {
        return GPCInputAlbumFilesCellLineViewIdentifier;
    }
}

- (UIView*)tableView:(UITableView *)tableView cellContentViewForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.row % 2 == 1)
    {
    	GPCMediaFilesSelectorGalleryCellView* cellView = (GPCMediaFilesSelectorGalleryCellView*)[GPCMediaFilesSelectorAlbumCase createSelectorCaseCellView:self.bridgeClass];
        return cellView;
    }else
    {
        UIView* cellView = [[UIView alloc] initWithFrame:CGRectZero];
        
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(GPC_PHOTO_ALBUM_PIC_LEFT_MARGINE, GPC_PHOTO_ALBUM_FILE_ICON_BOTTOM_GAP/2.0, [GPCMediaFilesSelectorUtilityHelper getMainScreenBounds].size.width - GPC_PHOTO_ALBUM_PIC_LEFT_MARGINE, 0.6)];
        [cellView addSubview:line];
        return cellView;
    }
}

- (GPCMediaFilesSelectorCase*)tableView:(UITableView *)tableView selectorCaseForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getGalleryModelByIndex:indexPath];
}
@end

















