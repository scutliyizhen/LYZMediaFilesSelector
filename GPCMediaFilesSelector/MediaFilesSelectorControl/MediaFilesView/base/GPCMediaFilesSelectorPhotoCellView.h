//
//  GPCMediaFilesSelectorPhotoCellView.h
//  GPCProject
//
//  Created by 李义真 on 2016/12/4.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorCellView.h"
#import "GPCMediaFilesSelectorPhotoCase.h"

@interface GPCMediaFilesSelectorImageView : UIView
@property(nonatomic,strong)UIImage* image;
@end

@interface GPCMediaFilesSelectorPhotoCellView : GPCMediaFilesSelectorCellView
@property(nonatomic,strong,readonly)UILabel* numLable;
@property(nonatomic,strong,readonly)UIImageView* iconSelect;
@property(nonatomic,strong)UIImage* fastImage;
@property(nonatomic,strong)UIImage* highQualityImage;
@property(nonatomic,strong)GPCMediaFilesSelectorPhotoCase* photoCase;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithResponderClass:(Class)responderClass frame:(CGRect)frame;
@end
