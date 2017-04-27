//
//  CBAlertHelper.h
//  CaiBao
//
//  Created by LC on 2017/4/12.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "CBObject.h"

@interface CBAlertHelper : CBObject

/**
 * 一个Action
 */
+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
            actionName:(NSString *)actionName
        viewController:(UIViewController *)viewController
                action:(void(^)())oneAction;

/**
 * 两个Action
 */
+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
             rightName:(NSString *)rightName
              leftName:(NSString *)leftName
        viewController:(UIViewController *)viewController
           rightAction:(void (^)())rightAction
            leftAction:(void (^)())leftAction;
/**
 * 有输入框
 */
+ (void)addTextFieldWithTitle:(NSString *)title
                      message:(NSString *)message
                    rightName:(NSString *)rightName
                     leftName:(NSString *)leftName
                  placeholder:(NSString *)placeholder
               viewController:(UIViewController *)viewController
                  rightAction:(void (^)(NSString *text))rightAction
                   leftAction:(void (^)(NSString *text))leftAction;
/**
 * sheet，有提醒
 */
+ (void)sheetAlertWithTitle:(NSString *)title
                    message:(NSString *)message
                        one:(NSString *)one
                        two:(NSString *)two
             viewController:(UIViewController *)viewController
                  oneAction:(void(^)())oneAction
                  twoAction:(void(^)())twoAction;

/**
 * sheet，无提醒
 */
+ (void)sheetAlertWithOne:(NSString *)one
                      two:(NSString *)two
           viewController:(UIViewController *)viewController
                oneAction:(void(^)())oneAction
                twoAction:(void(^)())twoAction;
@end
