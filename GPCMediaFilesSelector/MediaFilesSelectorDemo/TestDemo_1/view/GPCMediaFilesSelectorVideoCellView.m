//
//  GPCMediaFilesSelectorVideoCellView.m
//  GPCProject
//
//  Created by robertyzli on 2016/12/1.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorVideoCellView.h"

@interface GPCMediaFilesSelectorVideoCellView()
@property(nonatomic,strong)UIImageView* imageView;
@property(nonatomic,strong)UILabel* photoTitleLabel;
@property(nonatomic,strong)UILabel* galleryTitleLabel;
@property(nonatomic,strong)UILabel* createTimeLabel;
@end

@implementation GPCMediaFilesSelectorVideoCellView
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize iconSize = CGSizeMake(60.0, 60.0);
    self.imageView.frame = CGRectMake(16.0, CGRectGetHeight(self.bounds)/2.0 - iconSize.height/2.0, iconSize.width, iconSize.height);
    
    CGFloat width = CGRectGetWidth(self.bounds) - 16.0 - iconSize.width - 10.0 - 16.0;
    self.photoTitleLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 10.0, 10.0, width, 20.0);
    self.galleryTitleLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 10.0, CGRectGetMaxY(self.photoTitleLabel.frame) + 5.0, width, 20.0);
    self.createTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 10.0, CGRectGetMaxY(self.galleryTitleLabel.frame) + 5.0, width, 20.0);
}

- (void)setPhotoTile:(NSString *)photoTile
{
    _photoTile = photoTile;
    self.photoTitleLabel.text = photoTile;
}

- (void)setGalleryTitle:(NSString *)galleryTitle
{
    _galleryTitle = galleryTitle;
    self.galleryTitleLabel.text = galleryTitle;
}

- (void)setCreateTime:(NSString *)createTime
{
    _createTime = createTime;
    self.createTimeLabel.text = createTime;
}

- (void)setIconImage:(UIImage *)iconImage
{
    _iconImage = iconImage;
    self.imageView.image = iconImage;
}

- (UILabel*)createTimeLabel
{
	if(_createTimeLabel == nil)
    {
        _createTimeLabel = [UILabel new];
        [self addSubview:_createTimeLabel];
    }
    return _createTimeLabel;
}

- (UILabel*)galleryTitleLabel
{
    if(_galleryTitleLabel == nil)
    {
        _galleryTitleLabel = [UILabel new];
        [self addSubview:_galleryTitleLabel];
    }
    return _galleryTitleLabel;
}

- (UILabel*)photoTitleLabel
{
    if(_photoTitleLabel == nil)
    {
        _photoTitleLabel = [UILabel new];
        [self addSubview:_photoTitleLabel];
    }
    return _photoTitleLabel;
}

- (UIImageView*)imageView
{
	if(_imageView == nil)
    {
        _imageView = [UIImageView new];
        [self addSubview:_imageView];
    }
    return _imageView;
}
@end
