//
//  GPCTopNaviHeaderView.m
//  GameBible
//
//  Created by robertyzli on 16/7/12.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCTopNaviHeaderView.h"
#import "GPCMediaFilesSelectorUtilityHelper.h"

#pragma mark--中间点击button
@interface GPCTopViewMiddleButton()
@property(nonatomic,strong,readwrite)UIImageView* midImageView;
@property(nonatomic,strong,readwrite)UILabel* midLable;
@end

@implementation GPCTopViewMiddleButton
- (UIImageView*)midImageView
{
    if(_midImageView == nil)
    {
        _midImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_midImageView];
    }
    return _midImageView;
}

- (UILabel*)midLable
{
    if(_midLable == nil)
    {
        _midLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _midLable.font = [UIFont systemFontOfSize:16];
        _midLable.textColor = RGBColorC(0x4CBEFF);
        [_midLable sizeToFit];
        [self addSubview:_midLable];
    }
    return _midLable;
}


- (CGSize)getSize
{
    CGSize midTitleSize = [GPCMediaFilesSelectorUtilityHelper getFontSizeByFont:self.midLable.font text:self.midLable.text];
    CGFloat textImgWidth = midTitleSize.width + 2.5 + self.midImageView.image.size.width;
    CGSize selfSize;
    selfSize.width = textImgWidth;
    if(midTitleSize.height > self.midImageView.image.size.height)
    {
        selfSize.height = midTitleSize.height;
    }else
    {
        selfSize.height = self.midImageView.image.size.height;
    }
    return selfSize;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize midTitleSize = [GPCMediaFilesSelectorUtilityHelper getFontSizeByFont:self.midLable.font text:self.midLable.text];
    CGFloat textImgWidth = midTitleSize.width + self.midImageView.image.size.width;
    
    if(self.midLable)
    {
        CGFloat x = CGRectGetMidX(self.bounds) - textImgWidth/2.0;
        self.midLable.frame = CGRectMake(x, CGRectGetMidY(self.bounds) - midTitleSize.height/2.0, midTitleSize.width, midTitleSize.height);
    }
    if(self.midImageView)
    {
        CGFloat x = CGRectGetMidX(self.bounds) + textImgWidth/2.0 - self.midImageView.image.size.width + 2.5;
        self.midImageView.frame = CGRectMake(x, CGRectGetMidY(self.bounds) - self.midImageView.image.size.height/2.0,self.midImageView.image.size.width, self.midImageView.image.size.height);
    }
}
@end



#pragma mark--导航view
@interface GPCTopNaviHeaderView()
@property(nonatomic,strong,readwrite)UIButton* leftButton;
@property(nonatomic,strong,readwrite)UIButton* rightButton;
@property(nonatomic,strong,readwrite)UILabel* midTitleLabel;
@property(nonatomic,strong,readwrite)GPCTopViewMiddleButton* midButton;
@end

@implementation GPCTopNaviHeaderView

+ (CGFloat)getTopNaviHeaderViewHeight:(BOOL)showStatusBar
{
    CGFloat height = 0.0;
    if(showStatusBar)
    {
        CGRect statusFrame = [GPCMediaFilesSelectorUtilityHelper getStatusBarFrame];
        height += statusFrame.size.height;
    }
    
    height += 44.0;
    
    return height;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize leftBtnSize = CGSizeMake(40.0, 40.0);
    CGSize rightBtnSize = CGSizeMake(70.0, 40.0);
    
    CGSize midTextSize = [GPCMediaFilesSelectorUtilityHelper getFontSizeByFont:self.midTitleLabel.font text:self.midTitleLabel.text];
    if(self.statusBarShow)
    {
        CGSize leftImgSize = self.leftButton.imageView.image.size;
        
        self.leftButton.imageEdgeInsets = UIEdgeInsetsMake(leftBtnSize.height - leftImgSize.height, 0, 0, leftBtnSize.width - leftImgSize.width);
        
        self.leftButton.frame = CGRectMake(12, CGRectGetHeight(self.bounds) - 12 - leftBtnSize.height, leftBtnSize.width, leftBtnSize.height);
        
        if(self.rightButton.imageView.image)
        {
            CGSize leftImageSize = self.rightButton.imageView.image.size;
             self.rightButton.imageEdgeInsets = UIEdgeInsetsMake(rightBtnSize.height - leftImageSize.height, rightBtnSize.width - leftImageSize.width - 1, 0, 0);
            
        }else
        {
            CGSize rightBtnTextSize = [GPCMediaFilesSelectorUtilityHelper getFontSizeByFont:self.rightButton.titleLabel.font text:self.rightButton.titleLabel.text];
            self.rightButton.titleEdgeInsets = UIEdgeInsetsMake(rightBtnSize.height - rightBtnTextSize.height, rightBtnSize.width - rightBtnTextSize.width - 1, 0, 0);
        }
        
        self.rightButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - 12 - rightBtnSize.width, CGRectGetMinY(self.leftButton.frame), rightBtnSize.width, rightBtnSize.height);
        
        CGRect tmpRect = CGRectMake(CGRectGetMinX(self.leftButton.frame), CGRectGetMaxY(self.frame) - 12 - leftImgSize.height, leftImgSize.width, leftImgSize.height);

        if(self.isMidButton == NO)
        {
            self.midTitleLabel.frame = CGRectMake(CGRectGetMidX(self.bounds) - midTextSize.width/2.0, CGRectGetMidY(tmpRect) - midTextSize.height/2.0, midTextSize.width, midTextSize.height);
            
            self.midButton.hidden = YES;
            self.midTitleLabel.hidden = NO;
        }
        else
        {
            CGSize midButtonSize = [self.midButton getSize];
            self.midButton.frame = CGRectMake(CGRectGetMidX(self.bounds) - midButtonSize.width/2.0, CGRectGetMidY(tmpRect) - midButtonSize.height/2.0, midButtonSize.width, midButtonSize.height);
            self.midTitleLabel.hidden = YES;
            self.midButton.hidden = NO;
        }
    }else
    {
        CGSize leftImgSize = self.leftButton.imageView.image.size;
        self.leftButton.imageEdgeInsets = UIEdgeInsetsMake(leftBtnSize.height/2.0 - leftImgSize.height/2.0, 0, 0, leftBtnSize.width - leftImgSize.width);
        self.leftButton.frame = CGRectMake(12, CGRectGetMidY(self.bounds) - leftBtnSize.height/2.0, leftBtnSize.width, leftBtnSize.height);
        
        CGSize rightBtnTextSize = [GPCMediaFilesSelectorUtilityHelper getFontSizeByFont:self.rightButton.titleLabel.font text:self.rightButton.titleLabel.text];
        
        self.rightButton.titleEdgeInsets = UIEdgeInsetsMake(rightBtnSize.height/2.0 - rightBtnTextSize.height/2.0, rightBtnSize.width - rightBtnTextSize.width - 1, 0, 0);
        
        self.rightButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - 12 - rightBtnSize.width, CGRectGetMinY(self.leftButton.frame), rightBtnSize.width, rightBtnSize.height);
        
        if(self.isMidButton == NO)
        {
            self.midTitleLabel.frame = CGRectMake(CGRectGetMidX(self.bounds) - midTextSize.width/2.0, CGRectGetMidY(self.leftButton.frame) - midTextSize.height/2.0, midTextSize.width, midTextSize.height);
            self.midButton.hidden = YES;
            self.midTitleLabel.hidden = NO;
        }else
        {
            CGSize midButtonSize = [self.midButton getSize];
            self.midButton.frame = CGRectMake(CGRectGetMidX(self.bounds) - midButtonSize.width/2.0, CGRectGetMidY(self.leftButton.frame) - midButtonSize.height/2.0, midButtonSize.width, midButtonSize.height);
            self.midTitleLabel.hidden = YES;
            self.midButton.hidden = NO;
        }
    }
}

- (void)leftButtonClickEvent:(UIButton*)btn
{
    if(self.leftBtnClick)
    {
        self.leftBtnClick();
    };
}

- (void)rightButtonClickEvent:(UIButton*)btn
{
    if(self.rightBtnClick)
    {
        self.rightBtnClick();
    };
}

- (void)middleButtonClickEvent:(UIButton*)btn
{
    if(self.middleBtnClick)
    {
        self.middleBtnClick();
    }
}

- (UIButton*)leftButton
{
    if(_leftButton == nil)
    {
        _leftButton = [UIButton new];
        [_leftButton setImage:[UIImage imageNamed:@"gpc_pictureSelector_nav_back.png"] forState:UIControlStateNormal];
        [self addSubview:_leftButton];
        
        [_leftButton addTarget:self action:@selector(leftButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton*)rightButton
{
    if(_rightButton == nil)
    {
        _rightButton = [UIButton new];
        [_rightButton setTitle:@"发布" forState:UIControlStateNormal];
        [_rightButton setTitleColor:RGBColorC(0x4CBEFF) forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_rightButton];
        
        [_rightButton addTarget:self action:@selector(rightButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _rightButton;
}

- (UILabel*)midTitleLabel
{
    if(_midTitleLabel == nil)
    {
        _midTitleLabel = [UILabel new];
        _midTitleLabel.font = [UIFont systemFontOfSize:16];
        _midTitleLabel.textColor = RGBColorC(0x4CBEFF);
        _midTitleLabel.text = @"发布视频";
        [self addSubview:_midTitleLabel];
    }
    return _midTitleLabel;
}

- (GPCTopViewMiddleButton*)midButton
{
    if(_midButton == nil)
    {
        _midButton = [[GPCTopViewMiddleButton alloc] initWithFrame:CGRectZero];
        [_midButton addTarget:self action:@selector(middleButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_midButton];
    }
    return _midButton;
}
@end
