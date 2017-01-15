//
//  GPCMediaFilesSelectorTableView.h
//  GPCProject
//
//  Created by 李义真 on 2016/12/5.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GPCMediaFilesSelectorCase;

@protocol GPCMediaFilesSelectorTableViewDelegate <NSObject>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIView*)tableView:(UITableView *)tableView cellContentViewForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString*)tableView:(UITableView*)tableView cellIdentifierForRowAtIndexPath:(NSIndexPath*)indexPath;
- (GPCMediaFilesSelectorCase*)tableView:(UITableView*)tableView selectorCaseForRowAtIndexPath:(NSIndexPath*)indexPath;
@end

@interface GPCMediaFilesSelectorTableView : UIView
@property(nonatomic,strong,readonly)UITableView* tableView;
@property(nonatomic,weak)id<GPCMediaFilesSelectorTableViewDelegate> delegate;
- (void)reloadData;
- (void)preLoadAssetsWhenViewDidAppear;
@end
