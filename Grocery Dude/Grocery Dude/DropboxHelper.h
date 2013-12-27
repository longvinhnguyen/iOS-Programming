//
//  DropboxHelper.h
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/26/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Dropbox/Dropbox.h>
#import "CoreDataHelper.h"

@interface DropboxHelper : NSObject

#pragma mark - DROPBOX ACCOUNT
+ (void)linkToDropboxWithUI:(UIViewController *)controller;
+ (void)unlinkFromDropbox;

#pragma mark - LOCAL FILE MANAGEMENT
+ (NSURL *)renameLastPathComponentOfURL:(NSURL *)url toName:(NSString *)name;
+ (BOOL)deleteFileAtURL:(NSURL *)url;
+ (void)createParentFolderForFile:(NSURL *)url;

#pragma mark - DROPBOX FILE MANAGEMENT
+ (BOOL)fileExistAtDropboxPath:(DBPath *)dropboxPath;
+ (void)listFilesAtDropboxPath:(DBPath *)dropboxPath;
+ (void)deleteFileAtDropboxPath:(DBPath *)dropboxPath;
+ (void)copyFileAtDropboxPath:(DBPath *)dropboxPath toURL:(NSURL *)url;
+ (void)copyFileAtURL:(NSURL *)url toDropboxPath:(DBPath *)dropboxPath;

#pragma mark - BACKUP / RESTORE
+ (NSURL *)zipFolderAtURL:(NSURL *)url withZipfileName:(NSString *)zipFileName;
+ (void)unzipFileAtURL:(NSURL *)zipFileURL toURL:(NSURL *)unzipURL;
+ (void)restoreFromDropboxStoresZip:(NSString *)fileName withCoreDateHelper:(CoreDataHelper *)cdh;

@end
