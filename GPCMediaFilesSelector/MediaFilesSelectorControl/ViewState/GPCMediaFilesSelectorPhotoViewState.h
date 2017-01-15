//
//  GPCMediaFilesSelectorPhotoViewState.h
//  GPCProject
//
//  Created by 李义真 on 2016/12/4.
//  Copyright © 2016年 Tencent. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GPCMediaFilesSelectorBaseViewState.h"

@interface GPCMediaFilesSelectorPhotoViewState : GPCMediaFilesSelectorBaseViewState
@property(nonatomic,assign)BOOL isSelected;//是否被选中
@property(nonatomic,assign)BOOL isPreviewIng;//是否正在预览
@property(nonatomic,assign)BOOL selectIconHidden;//隐藏选中图标
@property(nonatomic,assign)BOOL numOfSelectedHidden;//隐藏选中序号
@property(nonatomic,assign)NSUInteger indexOfSelected;//选中索引
@property(nonatomic,strong)UIImage* selectedIconImage;//选中图标
@property(nonatomic,strong)UIImage* unSelectedIconImage;//未选中图标
@end
