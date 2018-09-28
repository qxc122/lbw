//
//  UzysImagePickerController.m
//  UzysAssetsPickerController
//
//  Created by ping on 16/3/29.
//  Copyright © 2016年 Uzys. All rights reserved.
//


#import "UzysImagePickerController.h"
@interface UzysImagePickerController ()<UzysAssetsPickerControllerDelegate>

@property (nonatomic, strong) id<UzysImagePickerControllerDelegate> vcdelegate;
@property (nonatomic, strong) NSMutableArray *imageArray;


@end

@implementation UzysImagePickerController


-(void)showInViewContrller:(UIViewController *)vc maxCount:(NSInteger)maxCount delegate:(id<UzysImagePickerControllerDelegate>)vcdelegate
{
    self.delegate = self;
    self.maximumNumberOfSelectionPhoto = maxCount;
//    自己定义的代理
    self.vcdelegate = vcdelegate;
    self.imageArray = [NSMutableArray array];
    
    [vc presentViewController:self animated:YES completion:nil];
    
}


#pragma mark - UzysAssetsPickerControllerDelegate methods
- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{

    for (ALAsset *asset in assets) {
        if([[asset valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"]) //Photo
        {
            UIImage * image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
            if(image){
                [self.imageArray addObject:image];
            }
        }
    }
    if([self.vcdelegate respondsToSelector:@selector(UzysImagePickerDidFinishWithImages:)]){
        [self.vcdelegate UzysImagePickerDidFinishWithImages:self.imageArray];
    }

    
}

- (void)uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController *)picker
{
    [MBProgressHUD showMessage:[NSString stringWithFormat:@"最多选择 %ld 张图片",(long)self.maximumNumberOfSelectionPhoto] finishBlock:nil];
}



@end
