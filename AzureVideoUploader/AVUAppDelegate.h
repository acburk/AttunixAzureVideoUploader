//
//  AVUAppDelegate.h
//  AzureVideoUploader
//
//  Created by Adam Burkepile on 5/21/12.
//  Copyright (c) 2012 Adam Burkepile. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WAAuthenticationCredential;

@interface AVUAppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) WAAuthenticationCredential *authenticationCredential;
@property (nonatomic, strong) NSURL* movieUploadLocation;

@end
