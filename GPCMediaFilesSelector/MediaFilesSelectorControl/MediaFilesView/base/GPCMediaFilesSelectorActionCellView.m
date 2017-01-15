//
//  GPCMediaFilesSelectorActionCellView.m
//  GPCProject
//
//  Created by 李义真 on 2016/12/4.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorActionCellView.h"
#import "GPCMediaFilesSelectorUtilityHelper.h"
#import "GPCMediaFilesSelectorActionCase.h"
#import "GPCMediaFilesSelectorActionViewResponder.h"

#define GPC_CONTROL_ICON_TEXT_GAP (24.0/2)

@interface GPCMediaFilesSelectorActionCellView()
@property(nonatomic,strong,readwrite)UIImageView* picImgView;
@property(nonatomic,strong,readwrite)UILabel* textLable;
@end

@implementation GPCMediaFilesSelectorActionCellView
- (instancetype)initWithResponderClass:(Class)responderClass frame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = RGBColor(0x3c, 0x3e, 0x45);
        [responderClass bindActionCellViewResponder:self];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize textSize = [GPCMediaFilesSelectorUtilityHelper getFontSizeByFont:self.textLable.font text:self.textLable.text];
    CGFloat totalHeight = textSize.height + GPC_CONTROL_ICON_TEXT_GAP + self.picImgView.image.size.height;
    
    CGFloat imgFrameY = self.center.y - totalHeight/2.0 + 18.0/2;
    CGFloat imgFrameX = self.center.x - self.picImgView.image.size.width/2.0;
    self.picImgView.frame = CGRectMake(imgFrameX, imgFrameY, self.picImgView.image.size.width, self.picImgView.image.size.width);
    
    CGFloat textFrameY = self.center.y + totalHeight/2.0 - textSize.height;
    CGFloat textFrameX = self.center.x - textSize.width/2.0;
    self.textLable.frame = CGRectMake(textFrameX, textFrameY, textSize.width, textSize.height);
}

- (void)setActionCase:(GPCMediaFilesSelectorActionCase *)actionCase
{
    _actionCase = actionCase;
    self.picImgView.image = actionCase.iconImage;
    self.textLable.text = actionCase.viewState.actionTitle;
    
//    [actionCase.viewResponder setActionCellContentView:self];
    [self setNeedsLayout];
}

- (UIImageView*)picImgView
{
    if(_picImgView == nil)
    {
        _picImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_picImgView];
    }
    return _picImgView;
}

- (UILabel*)textLable
{
    if(_textLable == nil)
    {
        _textLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLable.font = [UIFont systemFontOfSize:24.0/2];
        _textLable.textColor = RGBColor(0xbe, 0xbe, 0xc0);
        [_textLable sizeToFit];
        [self addSubview:_textLable];
    }
    return _textLable;
}

@end
