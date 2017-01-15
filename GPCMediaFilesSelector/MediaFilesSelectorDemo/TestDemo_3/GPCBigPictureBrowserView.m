//  GPCBigPictureBrowserView.m
//  GameBible
//
//  Created by robertyzli on 16/3/25.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCBigPictureBrowserView.h"
#import "GPCMediaFilesSelectorUtilityHelper.h"

#define GPC_BIG_PICTURE_MAX_RATIO (3.0)
#define GPC_BIG_PICTURE_MIN_RATIO (0.7)

@interface GPCBigPictureBrowserView ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIImageView* bigImgView;
@end


@implementation GPCBigPictureBrowserView
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = RGBColorC(0x9E9092);
        
        _bigImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bigImgView.contentMode = UIViewContentModeScaleAspectFit;
        _bigImgView.backgroundColor = [UIColor clearColor];
        _bigImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self addSubview:_bigImgView];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)setImage:(UIImage*)image
{
    _image = image;
    self.bigImgView.image = image;
    [self setNeedsLayout];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _bigImgView.frame = self.bounds;
}
@end
