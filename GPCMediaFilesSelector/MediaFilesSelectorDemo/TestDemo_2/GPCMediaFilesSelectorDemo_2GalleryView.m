//
//  GPCMediaFilesSelectorDemo_2GalleryView.m
//  GameBible
//
//  Created by robertyzli on 16/7/17.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorDemo_2GalleryView.h"
#import "GPCMediaFilesSelectorPhotoGalleryView.h"
#import "GPCMediaFilesSelectorUtilityHelper.h"
#import "GPCMediaFilesSelectorWithTwoActionBridge.h"

@interface GPCNaviTopControl : UIControl
@property(nonatomic,strong)UIImageView* iconImageView;
@end

@implementation GPCNaviTopControl
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize iconSize = self.iconImageView.image.size;
    self.iconImageView.frame = CGRectMake(12, CGRectGetMidY(self.bounds) - iconSize.height/2.0, iconSize.width, iconSize.height);
}

- (UIImageView*)iconImageView
{
    if(_iconImageView == nil)
    {
        _iconImageView = [UIImageView  new];
        _iconImageView.image = [UIImage imageNamed:@"GPC_photo_go_back.png"];
        [self addSubview:_iconImageView];
    }
    return _iconImageView;
}
@end

@interface GPCMediaFilesSelectorDemo_2GalleryView()
@property(nonatomic,strong)GPCMediaFilesSelectorPhotoGalleryView* galleryView;
@property(nonatomic,strong)GPCNaviTopControl* naviControl;
@end

@implementation GPCMediaFilesSelectorDemo_2GalleryView
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = RGBColor(0x30, 0x30, 0x38);
        self.galleryView.backgroundColor = RGBColor(0x30, 0x30, 0x38);
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.naviControl.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 40.0);
    
    self.galleryView.frame = CGRectMake(0, CGRectGetMaxY(self.naviControl.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - CGRectGetHeight(self.naviControl.frame));
}

- (void)reloadGalleryView
{
    [self.galleryView reloadData];
}

- (void)preLoadAssetsWhenViewDidAppear
{
    [self.galleryView preLoadAssetsWhenViewDidAppear];
}

- (void)setGalleryDataSource:(GPCMediaFilesSelectorGalleryCaseDataSource *)galleryDataSource
{
    _galleryDataSource = galleryDataSource;
    self.galleryView.galleryDataSource = galleryDataSource;
}

- (GPCMediaFilesSelectorPhotoGalleryView*)galleryView
{
    if(_galleryView == nil)
    {
        _galleryView = [[GPCMediaFilesSelectorPhotoGalleryView alloc] initWithBridgeClass:[GPCMediaFilesSelectorWithTwoActionBridge class]
                                                                          caseSourceClass:[GPCMediaFilesSelectorGalleryCaseDataSource class]];
        [self addSubview:_galleryView];
    }
    return _galleryView;
}

- (GPCNaviTopControl*)naviControl
{
    if(_naviControl == nil)
    {
        _naviControl = [GPCNaviTopControl new];
        [_naviControl addTarget:self action:@selector(naviGoBackClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_naviControl];
    }
    return _naviControl;
}

- (void)naviGoBackClickEvent:(UIControl*)control
{
    if(self.goBackBlock)
    {
        self.goBackBlock();
    }
}
@end















