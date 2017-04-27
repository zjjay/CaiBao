//
//  CBAlertHelper.m
//  CaiBao
//
//  Created by LC on 2017/4/12.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "CBAlertHelper.h"

@implementation CBAlertHelper
/**
 * 一个Action
 */
+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
            actionName:(NSString *)actionName
        viewController:(UIViewController *)viewController
                action:(void(^)())oneAction
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *right=[UIAlertAction actionWithTitle:actionName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        if (oneAction) {
            oneAction();
        }
    }];
    
    
    [alertController addAction:right];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

/**
 * 两个Action
 */
+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
             rightName:(NSString *)rightName
              leftName:(NSString *)leftName
        viewController:(UIViewController *)viewController
           rightAction:(void (^)())rightAction
            leftAction:(void (^)())leftAction
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *right=[UIAlertAction actionWithTitle:rightName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        if (rightAction) {
            rightAction();
        }
    }];
    UIAlertAction *left=[UIAlertAction actionWithTitle:leftName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        if (leftAction) {
            leftAction();
        }
    }];
    
    [alertController addAction:right];
    [alertController addAction:left];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

/**
 * 有输入框
 */
+ (void)addTextFieldWithTitle:(NSString *)title
                      message:(NSString *)message
                    rightName:(NSString *)rightName
                     leftName:(NSString *)leftName
                  placeholder:(NSString *)placeholder
               viewController:(UIViewController *)viewController
                  rightAction:(void (^)(NSString *))rightAction
                   leftAction:(void (^)(NSString *))leftAction
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeholder;
    }];
    
    UIAlertAction *right=[UIAlertAction actionWithTitle:rightName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        UITextField *textField = alertController.textFields.firstObject;
        if (rightAction) {
            rightAction(textField.text);
        }
    }];
    
    UIAlertAction *left=[UIAlertAction actionWithTitle:leftName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        UITextField *textField = alertController.textFields.firstObject;
        if (leftAction) {
            leftAction(textField.text);
        }
    }];
    
    [alertController addAction:right];
    [alertController addAction:left];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

/**
 * sheet，有提醒
 */
+ (void)sheetAlertWithTitle:(NSString *)title
                    message:(NSString *)message
                        one:(NSString *)one
                        two:(NSString *)two
             viewController:(UIViewController *)viewController
                  oneAction:(void(^)())oneAction
                  twoAction:(void(^)())twoAction
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:one style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (oneAction) {
            oneAction();
        }
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:two style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (twoAction) {
            twoAction();
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

/**
 * sheet，无提醒
 */
+ (void)sheetAlertWithOne:(NSString *)one
                      two:(NSString *)two
           viewController:(UIViewController *)viewController
                oneAction:(void(^)())oneAction
                twoAction:(void(^)())twoAction
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:one style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (oneAction) {
            oneAction();
        }
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:two style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (twoAction) {
            twoAction();
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

@end
