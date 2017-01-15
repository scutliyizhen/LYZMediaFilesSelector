//
//  GPCMediaFilesSelectorPhotoCellView.m
//  GPCProject
//
//  Created by ä¹ on 2016/12/4.
//  Copyright Â© 2016å¹ Tencent. All rights reserved.
//

#import "YYAsyncLayer.h"
#import <ImageIO/ImageIO.h>
#import <CoreGraphics/CGImage.h>
#import <AVFoundation/AVUtilities.h>
#import <CoreGraphics/CGContext.h>
#import <CoreFoundation/CoreFoundation.h>
#import "GPCMediaFilesSelectorPhotoCellView.h"
#import "GPCMediaFilesSelectorUtilityHelper.h"
#import "GPCMediaFilesSelectorPhotoViewResponder.h"

#define GPC_ICON_SELECT_ICON_RIGHT_MARGINE (10.0/2)
#define GPC_ICON_SELECT_ICON_TOP_MARGINE (10.0/2)

@interface GPCMediaFilesSelectorImageView()<YYAsyncLayerDelegate>
@property(nonatomic,strong)YYAsyncLayerDisplayTask* task;
@end

@implementation GPCMediaFilesSelectorImageView
+ (Class)layerClass
{
    return YYAsyncLayer.class;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    [[YYTransaction transactionWithTarget:self selector:@selector(contentsNeedUpdated)] commit];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [[YYTransaction transactionWithTarget:self selector:@selector(contentsNeedUpdated)] commit];
}

- (void)contentsNeedUpdated {
    // do update
    [self.layer setNeedsDisplay];
}

- (CGRect)cropImageRect
{
    float scaleFactor = [[UIScreen mainScreen] scale];
    CGSize imageSize = CGSizeMake(self.image.size.width * scaleFactor, self.image.size.height * scaleFactor);
    CGSize selfSize = CGSizeMake(self.bounds.size.width * scaleFactor, self.bounds.size.height * scaleFactor);
    
    CGFloat rationSelf = selfSize.width/selfSize.height;
    CGFloat rationImg = imageSize.width/imageSize.height;
    
    if(rationSelf < rationImg)
    {
        CGFloat newWidth = rationSelf * imageSize.height;
        
        return CGRectMake((imageSize.width - newWidth)/2.0, 0, newWidth, imageSize.height);
    }else if(rationSelf > rationImg)
    {
        CGFloat newHeight = imageSize.width / rationSelf;
        
        return CGRectMake(0, (imageSize.height - newHeight)/2.0, imageSize.width, newHeight);
    }else
    {
        return CGRectMake(0, 0, imageSize.width, imageSize.height);
    }
}

- (YYAsyncLayerDisplayTask*)newAsyncDisplayTask
{
    if(self.task == nil)
    {
        self.task = [YYAsyncLayerDisplayTask new];
        __weak typeof (self) weakSelf = self;
        self.task.display = ^(CGContextRef context, CGSize size, BOOL(^isCancelled)(void))
        {
            if (isCancelled()) return;
            UIImage* inputImage = weakSelf.image;
            if(inputImage == nil) return;
            
            CGRect contextRect = CGRectMake(0, 0, size.width, size.height);
            CGContextTranslateCTM(context, 0, size.height);
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextClearRect(context, contextRect);
            
            //ç»¶å°éè®context
            CGRect centerArea = [weakSelf cropImageRect];
            CGImageRef  cropImageRef  = CGImageCreateWithImageInRect(inputImage.CGImage, CGRectIntegral(centerArea));
            CGContextClearRect(context, CGRectIntegral(contextRect));
            CGContextDrawImage(context, CGRectIntegral(contextRect), cropImageRef);
            CGImageRelease(cropImageRef);
        };
    }
    return self.task;
}
@end

@interface GPCMediaFilesSelectorPhotoCellView()
@property(nonatomic,strong,readwrite)GPCMediaFilesSelectorImageView* fastImgView;
@property(nonatomic,strong,readwrite)UIImageView* highQualityImgView;
@property(nonatomic,strong,readwrite)UILabel* numLable;
@property(nonatomic,strong,readwrite)UIImageView* iconSelect;
@property(nonatomic,strong)UIImage* unSelctedImg;
@property(nonatomic,strong)UIImage* selectedImg;
@end


@implementation GPCMediaFilesSelectorPhotoCellView
- (instancetype)initWithResponderClass:(Class)responderClass frame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
    	self.backgroundColor = RGBColorC(0x4CBEFF);
        [responderClass bindPhotoCellViewResponder:self];
    }
    return self;
}

- (void)setPhotoCase:(GPCMediaFilesSelectorPhotoCase *)photoCase
{
    _photoCase = photoCase;
    self.highQualityImage = photoCase.iconImage;
    self.numLable.text = [NSString stringWithFormat:@"%ld",(unsigned long)photoCase.viewState.indexOfSelected];
    self.iconSelect.hidden = photoCase.viewState.selectIconHidden;
    self.numLable.hidden = photoCase.viewState.numOfSelectedHidden;
    if(self.photoCase.viewState.isSelected)
    {
        self.iconSelect.image = self.selectedImg;
    }else
    {
        self.iconSelect.image = self.unSelctedImg;
    }
    [self setNeedsLayout];
}

- (void)setFastImage:(UIImage *)fastImage
{
    _fastImage = fastImage;
    self.fastImgView.image = fastImage;
    self.fastImgView.hidden = NO;
    self.highQualityImgView.hidden = YES;
}

- (void)setHighQualityImage:(UIImage *)highQualityImage
{
    _highQualityImage = highQualityImage;
    self.highQualityImgView.image = highQualityImage;
    self.highQualityImgView.hidden = NO;
    
    self.fastImgView.hidden = YES;
}

- (void)updateSelectorCellState
{
    self.numLable.text = [NSString stringWithFormat:@"%ld",(unsigned long)self.photoCase.viewState.indexOfSelected];
    self.iconSelect.hidden = self.photoCase.viewState.selectIconHidden;
    self.numLable.hidden = self.photoCase.viewState.numOfSelectedHidden;
    if(self.photoCase.viewState.isSelected)
    {
        self.iconSelect.image = self.selectedImg;
    }else
    {
        self.iconSelect.image = self.unSelctedImg;
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize iconSize = CGSizeZero;
    
    if(self.photoCase.viewState.isSelected)
    {
        iconSize = self.selectedImg.size;
    }else
    {
        iconSize = self.unSelctedImg.size;
    }
    
    self.iconSelect.frame = CGRectMake(self.bounds.size.width - (GPC_WIDTH_RATIO)*GPC_ICON_SELECT_ICON_RIGHT_MARGINE - iconSize.width, (GPC_WIDTH_RATIO)*GPC_ICON_SELECT_ICON_TOP_MARGINE , iconSize.width, iconSize.height);
    
    if(self.photoCase.viewState.isPreviewIng)
    {
        self.fastImgView.frame = CGRectMake(1.5, 1.5, self.bounds.size.width - 3, self.bounds.size.height - 3);
        self.highQualityImgView.frame = CGRectMake(1.5, 1.5, self.bounds.size.width - 3, self.bounds.size.height - 3);
    }else
    {
        self.fastImgView.frame = self.bounds;
        self.highQualityImgView.frame = self.bounds;
    }
    self.numLable.frame = self.iconSelect.bounds;
}

- (GPCMediaFilesSelectorImageView*)fastImgView
{
    if(_fastImgView == nil)
    {
        _fastImgView = [[GPCMediaFilesSelectorImageView alloc] initWithFrame:CGRectZero];
        _fastImgView.contentMode = UIViewContentModeScaleAspectFill;
        _fastImgView.clipsToBounds = YES;
        [self addSubview:_fastImgView];
    }
    return _fastImgView;
}

- (UIImageView*)highQualityImgView
{
    if(_highQualityImgView == nil)
    {
        _highQualityImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _highQualityImgView.contentMode = UIViewContentModeScaleAspectFill;
        _highQualityImgView.clipsToBounds = YES;
        [self insertSubview:_highQualityImgView aboveSubview:self.fastImgView];
    }
    return _highQualityImgView;
}

- (UIImageView*)iconSelect
{
    if(_iconSelect == nil)
    {
        _iconSelect = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self insertSubview:_iconSelect aboveSubview:self.highQualityImgView];
    }
    return _iconSelect;
}

- (UILabel*)numLable
{
    if(_numLable == nil)
    {
        _numLable = [[UILabel alloc] init];
        _numLable.textColor = RGBColorC(0xFFFFFF);
        _numLable.backgroundColor = [UIColor clearColor];
        _numLable.font = [UIFont systemFontOfSize:16];
        _numLable.textAlignment = NSTextAlignmentCenter;
        [_numLable sizeToFit];
        
        [self.iconSelect addSubview:_numLable];
    }
    return _numLable;
}

- (UIImage*)unSelctedImg
{
    if(_unSelctedImg == nil)
    {
        _unSelctedImg = [UIImage imageNamed:@"gpc_pictureSelector_photo_unSelected.png"];
    }
    
    if(self.photoCase.viewState.unSelectedIconImage)
    {
        return self.photoCase.viewState.unSelectedIconImage;
    }else
    {
    	 return _unSelctedImg;
    }
}

- (UIImage*)selectedImg
{
    if(_selectedImg == nil)
    {
        _selectedImg = [UIImage imageNamed:@"gpc_pictureSelector_photo_selected.png"];
    }
    
    if(self.photoCase.viewState.selectedIconImage)
    {
        return self.photoCase.viewState.selectedIconImage;
    }else
    {
        return _selectedImg;
    }
}
@end
