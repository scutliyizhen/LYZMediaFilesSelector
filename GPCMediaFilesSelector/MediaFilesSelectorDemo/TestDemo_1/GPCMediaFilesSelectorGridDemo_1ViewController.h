//
//  GPCMediaFilesSelectorGridDemo_1ViewController.h
//  GPCMediaFilesSelector
//
//  Created by robertyzli on 2016/11/24.
//  Copyright © 2016年 robertyzli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPCMediaFilesSelectorEngine.h"
#import "GPCMediaFilesSelectorPhotoCaseDataSource.h"

typedef NS_ENUM(NSUInteger,GridViewType) {
	GridViewType_Photo,
    GridViewType_Video,
    GridViewType_LivePhoto,
    GridViewType_DownloadPicture,
};

@interface GPCMediaFilesSelectorGridDemo_1ViewController : UIViewController
@property(nonatomic,strong)GPCMediaFilesSelectorEngine* selectorEngine;
//指定当前九宫格的GridDataSource，如果没有指定则默认使用selectorEngine加载默认DataSource
@property(nonatomic,strong)GPCMediaFilesSelectorPhotoCaseDataSource* gridDataSource;
@property(nonatomic,assign)GridViewType gridViewType;
@end
