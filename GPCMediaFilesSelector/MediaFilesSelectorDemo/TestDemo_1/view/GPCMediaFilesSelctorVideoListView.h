//
//  GPCPictureSelctorVideoListView.h
//  GPCProject
//
//  Created by 李义真 on 2016/12/1.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPCMediaFilesSelectorPhotoCaseDataSource.h"

@interface GPCPictureSelctorVideoListView : UIView
@property(nonatomic,strong,readonly)UITableView* tableView;
@property(nonatomic,strong)GPCMediaFilesSelectorPhotoCaseDataSource* gridCaseDataSource;
- (void)reloadData;
- (void)preLoadAssetsWhenViewDidAppear;
@end
