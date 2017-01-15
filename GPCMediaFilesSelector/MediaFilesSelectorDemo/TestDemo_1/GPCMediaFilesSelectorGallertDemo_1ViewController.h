//
//  GPCMediaFilesSelectorGallertDemo_1ViewController.h
//  GPCMediaFilesSelector
//
//  Created by robertyzli on 2016/11/24.
//  Copyright © 2016年 robertyzli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPCMediaFilesSelectorEngine.h"

typedef NS_ENUM(NSUInteger, GalleryListType){
	GalleryListType_Photo,
    GalleryListType_Video,
};

@interface GPCMediaFilesSelectorGallertDemo_1ViewController : UIViewController
@property(nonatomic,strong)GPCMediaFilesSelectorEngine* selectorEngine;
@property(nonatomic,assign)GalleryListType galleryListType;
@end
