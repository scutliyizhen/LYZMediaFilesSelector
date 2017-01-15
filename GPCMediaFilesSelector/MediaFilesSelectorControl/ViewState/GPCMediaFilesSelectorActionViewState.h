//
//  GPCMediaFilesSelectorActionViewState.h
//  GPCProject
//
//  Created by 李义真 on 2016/12/4.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPCMediaFilesSelectorBaseViewState.h"

typedef NS_ENUM(NSUInteger,ACTION_PICTURE_SELECTOR_TYPE)
{
    ACTION_PICTURE_SELECTOR_TYPE_GALLERY,
    ACTION_PICTURE_SELECTOR_TYPE_TAKING_PHOTO,
};

@interface GPCMediaFilesSelectorActionViewState : GPCMediaFilesSelectorBaseViewState
@property(nonatomic,strong)NSString* actionTitle;
@property(nonatomic,strong)UIImage* actionICon;
@property(nonatomic,assign)ACTION_PICTURE_SELECTOR_TYPE actionType;
@end
