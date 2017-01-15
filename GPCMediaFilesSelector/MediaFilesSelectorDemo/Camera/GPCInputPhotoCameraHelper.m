//
//  GPCInputPhotoCameraHelper.m
//  SybPlatform
//
//  Created by robertyzli on 15/11/16.
//  Copyright © 2015年 Tencent. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "GPCInputPhotoCameraHelper.h"
#import "GPCMediaFilesSelectorUtilityHelper.h"
#import "UIImage+ImageOrientation.h"

@interface GPCInputPhotoCameraHelper()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImagePickerController* _cameraViewController;
}
@end

@implementation GPCInputPhotoCameraHelper
+ (instancetype)shareInstance
{
    static dispatch_once_t pred;
    static GPCInputPhotoCameraHelper* camera =  nil;
    dispatch_once(&pred, ^{
        camera = [GPCInputPhotoCameraHelper new];
    });
    
    return camera;
}

- (instancetype)init
{
    if(self = [super init])
    {
        _cameraViewController = [[UIImagePickerController alloc] init];
        [_cameraViewController.view setBackgroundColor:[UIColor whiteColor]];
        _cameraViewController.delegate = self;   // 设置委托
        _cameraViewController.allowsEditing = NO;
        
        BOOL isCameraSupport = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        if (isCameraSupport)
        {
            _cameraViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        
    }
    return self;
}

- (void)showPhotoCameraViewController:(UIViewController*)currentViewController
{
    //数据上报
    //判断是否拥有权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted)
                {
                   
                }
                else
                {
                    
                }
            }];
            break;
        }
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:
        {
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"相机授权" message:@"没有权限访问您的相机，请在“设置－隐私－相机”中允许使用" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alterView show];
            break;
        }
            
        default:
        {
            //拍照
            //从相册获取
            [currentViewController.navigationController
             presentViewController:_cameraViewController animated:YES completion:nil];
            
            break;
            
        }
    }
}

#pragma mark--UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if(info == nil)
    {
        return;
    }
    
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    image = [image fixOrientation];

    //将照相的页面dismiss掉
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if(self.takingPhotoBlock)
    {
        self.takingPhotoBlock(YES,image);
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [GPCMediaFilesSelectorUtilityHelper executeInIOS:SYB_iOS_7 withCode:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }];
}
@end
