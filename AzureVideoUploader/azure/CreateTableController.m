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

#import "CreateTableController.h"
#import "UIViewController+ShowError.h"

@implementation CreateTableController

@synthesize newItemName;
@synthesize createButton;
@synthesize uploadDefaultImageButton;
@synthesize nameLabel;
@synthesize selectedContainer;
@synthesize selectedQueue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    RELEASE(newItemName);
    RELEASE(createButton);
    RELEASE(uploadDefaultImageButton);
    RELEASE(nameLabel);
	storageClient.delegate = nil;
    RELEASE(storageClient);
    RELEASE(selectedContainer);
    RELEASE(selectedQueue);
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	AVUAppDelegate *appDelegate = (AVUAppDelegate *)[[UIApplication sharedApplication] delegate];
	
    storageClient = [[WACloudStorageClient storageClientWithCredential:appDelegate.authenticationCredential] retain];
	storageClient.delegate = self;

	if ([self.navigationItem.title hasSuffix:@"Table"]) {
		nameLabel.text = @"Table Name:";
	} else if ([self.navigationItem.title hasSuffix:@"Container"]) {
		nameLabel.text = @"Container Name:";
	} else if ([self.navigationItem.title hasSuffix:@"Blob"]) {
		nameLabel.text = @"Blob Name:";
		[createButton setTitle:@"Pick Image" forState:UIControlStateNormal];
	} else if ([self.navigationItem.title hasSuffix:@"Queue"]) {
		nameLabel.text = @"Queue Name:";
	} else if ([self.navigationItem.title hasSuffix:@"QueueMessage"]) {
		nameLabel.text = @"Queue Message Name:";
	}

	[newItemName becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    storageClient.delegate = nil;
    
    [super viewWillDisappear:animated];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if (![self.navigationItem.title hasSuffix:@"Table"] &&
		![self.navigationItem.title hasSuffix:@"Container"] &&
		![self.navigationItem.title hasSuffix:@"Queue"] &&
		![self.navigationItem.title hasSuffix:@"Blob"]) {
		createButton.enabled = YES;
		return YES;
	}
	
	NSString *newStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
	
	if (!newStr.length) {
		createButton.enabled = NO;
		return YES;
	}
	
	if ([newStr rangeOfString:@"^[A-Za-z][A-Za-z0-9\\-\\_]*" 
					 options:NSRegularExpressionSearch].length == newStr.length) {
		createButton.enabled = YES;
		return YES;
	}
		 
	return NO;
}

- (void)viewDidUnload
{
    self.newItemName = nil;
    self.createButton = nil;
    self.uploadDefaultImageButton = nil;
    self.nameLabel = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Action Methods

- (IBAction)createItem:(id)sender
{
    [newItemName resignFirstResponder];
	
	if ([[newItemName text] length] == 0) {
		return;
	}
	
	if (![self.navigationItem.title hasSuffix:@"Blob"]) {
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:view] autorelease];
		[view startAnimating];
		[view release];
	}
	
	if ([self.navigationItem.title hasSuffix:@"Table"]) {
		[storageClient createTableNamed:newItemName.text];
	} else if ([self.navigationItem.title hasSuffix:@"Container"]) {
		[storageClient addBlobContainerNamed:newItemName.text];
	} else if ([self.navigationItem.title hasSuffix:@"Blob"]) {
		if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			[self actionSheet:nil didDismissWithButtonIndex:1];
			return;
		}
		
		UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil 
														   delegate:self 
												  cancelButtonTitle:@"Cancel"
											 destructiveButtonTitle:nil 
												  otherButtonTitles:@"Take Photo", @"Choose Existing", nil];
		[sheet showInView:self.view];
		[sheet release];
	} else if ([self.navigationItem.title hasSuffix:@"Queue"]) {
		[storageClient addQueueNamed:newItemName.text];
	}
}

- (IBAction)uploadDefaultImage:(id)sender
{
	[storageClient addBlobToContainer:self.selectedContainer 
							 blobName:@"windows_azure.jpg" 
						  contentData:UIImageJPEGRepresentation([UIImage imageNamed:@"windows_azure.jpg"], 1.0) 
						  contentType:@"image/jpeg"
                withCompletionHandler:^(NSError* error) {
         if(error) {
             [self showError:error];
             return;
         }
         
         [self.navigationController popViewControllerAnimated:YES];
	 }];
}

#pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.delegate = self;
	
	if (buttonIndex == 0) {
		imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
    
	[self presentModalViewController:imagePicker animated:YES];
	[imagePicker release];
}

#pragma mark - CloudStorageClientDelegate Methods

- (void)storageClient:(WACloudStorageClient *)client didFailRequest:request withError:(NSError*)error
{
	[self showError:error];
}

- (void)storageClient:(WACloudStorageClient *)client didCreateTableNamed:(NSString *)tableName
{
	self.navigationItem.rightBarButtonItem = nil;
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)storageClient:(WACloudStorageClient *)client didAddBlobContainerNamed:(NSString *)name
{
	self.navigationItem.rightBarButtonItem = nil;
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)storageClient:(WACloudStorageClient *)client didAddBlobToContainer:(WABlobContainer *)container blobName:(NSString *)blobName
{
	self.navigationItem.rightBarButtonItem = nil;
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)storageClient:(WACloudStorageClient *)client didAddQueueNamed:(NSString *)queueName
{
	self.navigationItem.rightBarButtonItem = nil;
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)selectedImage editingInfo:(NSDictionary *)editingInfo
{
    NSString *imageName = newItemName.text;

	if ([imageName hasSuffix:@".jpg"] == NO && [imageName hasSuffix:@".jpeg"] == NO) {
		imageName = [newItemName.text stringByAppendingString:@".jpg"];
	}
	
    [storageClient addBlobToContainer:self.selectedContainer 
							 blobName:imageName 
						  contentData:UIImageJPEGRepresentation(selectedImage, 1.0)
						  contentType:@"image/jpeg" 
                withCompletionHandler:^(NSError* error)  {
                    if(error) {
                        [self showError:error];
                        return;
                    }
		 
                    [self dismissModalViewControllerAnimated:NO];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissModalViewControllerAnimated:YES];
}

@end
