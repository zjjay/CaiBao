/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import <Foundation/Foundation.h>

#import "ChatListViewController.h"
#import "ContactListViewController.h"
#import "CBMainViewController.h"
#import "ChatViewController.h"

#define kHaveUnreadAtMessage    @"kHaveAtMessage"
#define kAtYouMessage           1
#define kAtAllMessage           2

@interface ChatDemoHelper : NSObject <EMClientDelegate,EMChatManagerDelegate,EMContactManagerDelegate,EMGroupManagerDelegate,EMChatroomManagerDelegate>

@property (nonatomic, weak) ContactListViewController *contactListVC;

@property (nonatomic, weak) ChatListViewController *chatListVC;

@property (nonatomic, weak) CBMainViewController *mainVC;

@property (nonatomic, weak) ChatViewController *chatVC;

+ (instancetype)shareHelper;

- (void)asyncPushOptions;

- (void)asyncGroupFromServer;

- (void)asyncConversationFromDB;

@end
