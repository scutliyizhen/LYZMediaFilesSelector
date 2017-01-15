//
//  GPCTopNaviHeaderView.h
//  GameBible
//
//  Created by robertyzli on 16/7/12.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPCTopViewMiddleButton : UIControl
@property(nonatomic,strong,readonly)UIImageView* midImageView;
@property(nonatomic,strong,readonly)UILabel* midLable;
@end


typedef void(^leftButtonClickBlock)();
typedef void(^rightButtonClickBlock)();
typedef void(^middleButtonClickBlock)();

@interface GPCTopNaviHeaderView : UIView
@property(nonatomic,assign)BOOL statusBarShow;
@property(nonatomic,assign)BOOL isMidButton;//默认中间是一个titleLabel
@property(nonatomic,strong,readonly)UIButton* leftButton;
@property(nonatomic,strong,readonly)UIButton* rightButton;
@property(nonatomic,strong,readonly)UILabel* midTitleLabel;
@property(nonatomic,strong,readonly)GPCTopViewMiddleButton* midButton;

@property(nonatomic,copy)leftButtonClickBlock leftBtnClick;
@property(nonatomic,copy)rightButtonClickBlock rightBtnClick;
@property(nonatomic,copy)middleButtonClickBlock middleBtnClick;
+ (CGFloat)getTopNaviHeaderViewHeight:(BOOL)showStatusBar;
@end
