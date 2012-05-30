//
//  AVUViewController.h
//  AzureVideoUploader
//
//  Created by Adam Burkepile on 5/21/12.
//  Copyright (c) 2012 Adam Burkepile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WAToolkit.h"

@interface AVUViewController : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, WACloudStorageClientDelegate> {
    UIActionSheet* as;
    UIImagePickerController* ipc;
}
- (IBAction)ibaUploadVideo:(id)sender;
- (IBAction)ibaBrowseVideos:(id)sender;

@end
