/*
 Copyright 2010 Microsoft Corp
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <UIKit/UIKit.h>
#import "WAToolkit.h"

@interface CreateTableController : UIViewController <WACloudStorageClientDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
{
@private
	UITextField *newItemName;
	UIButton *createButton;
	UIButton *uploadDefaultImageButton;
	UILabel *nameLabel;
	WACloudStorageClient *storageClient;
	WABlobContainer *selectedContainer;
	WAQueue *selectedQueue;
}

@property (nonatomic, retain) IBOutlet UITextField *newItemName;
@property (nonatomic, retain) IBOutlet UIButton *createButton;
@property (nonatomic, retain) IBOutlet UIButton *uploadDefaultImageButton;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) WABlobContainer *selectedContainer;
@property (nonatomic, retain) WAQueue *selectedQueue;

- (IBAction)createItem:(id)sender;
- (IBAction)uploadDefaultImage:(id)sender;
@end
