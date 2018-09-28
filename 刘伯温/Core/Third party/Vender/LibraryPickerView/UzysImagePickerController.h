//
//  UzysImagePickerController.h
//  UzysAssetsPickerController
//
//  Created by ping on 16/3/29.
//  Copyright © 2016年 Uzys. All rights reserved.
//

#import "UzysAssetsPickerController.h"

@protocol UzysImagePickerControllerDelegate <NSObject>

@optional
- (void)UzysImagePickerDidFinishWithImages:(NSArray *)imageArray;

@end

@interface UzysImagePickerController : UzysAssetsPickerController

- (void)showInViewContrller:(UIViewController *)vc maxCount:(NSInteger)maxCount delegate:(id<UzysImagePickerControllerDelegate>)vcdelegate;

@end
