//
//  GPCMediaFilesSelectorGalleryCellView.m
//  GPCProject
//
//  Created by 李义真 on 2016/12/4.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorGalleryCellView.h"
#import "GPCMediaFilesSelectorUtilityHelper.h"
#import "GPCMediaFilesSelectorAlbumCase.h"
#import "GPCMediaFilesSelectorGalleryViewState.h"
#import "GPCMediaFilesSelectorGalleryViewResponder.h"

#define GPC_PHOTO_ALBUM_PIC_LEFT_MARGINE (GPC_WIDTH_RATIO*24.0/2)
#define GPC_PHOTO_ALBUM_ARROW_RIGHT_MARGINE (GPC_WIDTH_RATIO*24.0/2)
#define GPC_PHOTO_ALBUM_FILE_NAME_LEFT_MARGINE (GPC_WIDTH_RATIO*20.0/2)
#define GPC_PHOTO_ALBUM_NUM_TOP_MARGINE (16.0/2)

@interface GPCMediaFilesSelectorGalleryCellView()
@property(nonatomic,strong,readwrite)UIImageView* imageView;
@property(nonatomic,strong)UIImageView* arrowImgView;
@property(nonatomic,strong)UILabel* fileNameLable;
@property(nonatomic,strong)UILabel* numLable;
@end

@implementation GPCMediaFilesSelectorGalleryCellView
- (instancetype)initWithResponderClass:(Class)responderClass frame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        [responderClass bindGalleryCellViewResponder:self];
    }
    return self;
}

- (void)setGalleryCase:(GPCMediaFilesSelectorAlbumCase *)galleryCase
{
    _galleryCase = galleryCase;
    galleryCase.viewState.photosCount = galleryCase.photosCount;
    galleryCase.viewState.galleryTitle = galleryCase.galleryTitle;
    self.fileNameLable.text = galleryCase.viewState.galleryTitle;
    self.numLable.text = [NSString stringWithFormat:@"%lu",(unsigned long)galleryCase.viewState.photosCount];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    if(self.imageView)
    {
        self.imageView.frame = CGRectMake(GPC_PHOTO_ALBUM_PIC_LEFT_MARGINE, 0, height, height);
    }
    if(self.arrowImgView)
    {
        CGFloat frameY = self.center.y - self.arrowImgView.image.size.height/2.0;
        CGFloat frameX = width - GPC_PHOTO_ALBUM_ARROW_RIGHT_MARGINE - self.arrowImgView.image.size.width;
        self.arrowImgView.frame = CGRectMake(frameX, frameY, self.arrowImgView.image.size.width, self.arrowImgView.image.size.height);
    }
    
    CGSize fileNameSize = [GPCMediaFilesSelectorUtilityHelper getFontSizeByFont:self.fileNameLable.font text:self.fileNameLable.text];
    CGSize numSize = [GPCMediaFilesSelectorUtilityHelper getFontSizeByFont:self.fileNameLable.font text:self.fileNameLable.text];
    CGFloat totalHeight = numSize.height + GPC_PHOTO_ALBUM_NUM_TOP_MARGINE + fileNameSize.height;
    if(self.fileNameLable)
    {
        CGFloat frameY = self.center.y - totalHeight/2.0;
        self.fileNameLable.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + GPC_PHOTO_ALBUM_FILE_NAME_LEFT_MARGINE, frameY, fileNameSize.width, fileNameSize.height);
    }
    
    if(self.numLable)
    {
        CGFloat frameY = self.center.y + totalHeight/2.0 - numSize.height;
        self.numLable.frame = CGRectMake(CGRectGetMinX(self.fileNameLable.frame), frameY, numSize.width, numSize.height);
    }
}

- (UIImageView*)imageView
{
    if(_imageView == nil)
    {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UIImageView*)arrowImgView
{
    if(_arrowImgView == nil)
    {
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.image = [UIImage imageNamed:@"GPC_photo_indictor_arrow.png"];
        [self addSubview:_arrowImgView];
    }
    return _arrowImgView;
}

- (UILabel*)fileNameLable
{
    if(_fileNameLable == nil)
    {
        _fileNameLable = [[UILabel alloc] init];
        _fileNameLable.font = [UIFont systemFontOfSize:32.0/2];
        _fileNameLable.textColor = RGBColor(0xbe, 0xbe, 0xc0);
        [_fileNameLable sizeToFit];
        [self addSubview:_fileNameLable];
    }
    return _fileNameLable;
}

- (UILabel*)numLable
{
    if(_numLable == nil)
    {
        _numLable = [[UILabel alloc] init];
        _numLable.font = [UIFont systemFontOfSize:28.0/2];
        _numLable.textColor = RGBColor(0x7f, 0x7f, 0x7f);
        [_numLable sizeToFit];
        [self addSubview:_numLable];
    }
    return _numLable;
}
@end
