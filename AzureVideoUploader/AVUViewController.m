//
//  AVUViewController.m
//  AzureVideoUploader
//
//  Created by Adam Burkepile on 5/21/12.
//  Copyright (c) 2012 Adam Burkepile. All rights reserved.
//

#import "AVUViewController.h"
#import "TableListController.h"
#import "MobileCoreServices/MobileCoreServices.h"
#import "WAConfiguration.h"
#import "WAToolkit.h"
#import "AVUAppDelegate.h"

@interface AVUViewController ()

@end

@implementation AVUViewController

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    ipc = [[UIImagePickerController alloc] init];
    [ipc setDelegate:self];
    [ipc setAllowsEditing:NO];
    [ipc setMediaTypes:[NSArray arrayWithObject:(NSString*)kUTTypeMovie]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (IBAction)ibaUploadVideo:(id)sender {
    as = [[UIActionSheet alloc] initWithTitle:@"Upload from where?" 
                                     delegate:self
                            cancelButtonTitle:@"Cancel" 
                       destructiveButtonTitle:nil
                            otherButtonTitles:@"Record New", @"Choose From Library", nil];
    [as showInView:[self view]];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [ipc setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self presentModalViewController:ipc animated:YES];
            break;
        case 1:
            [ipc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [self presentModalViewController:ipc animated:YES];
            break;
        case 2:
            break;
            
        default:
            NSLog(@"%d",buttonIndex);
            break;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSURL* movieUrl = [info  objectForKey:UIImagePickerControllerMediaURL];
    
    [(AVUAppDelegate*)[[UIApplication sharedApplication] delegate] setMovieUploadLocation:movieUrl];
    
    [self dismissModalViewControllerAnimated:YES];
    
    WAConfiguration *config = [WAConfiguration sharedConfiguration];	
    
    AVUAppDelegate *appDelegate = (AVUAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.authenticationCredential = [WAAuthenticationCredential credentialWithAzureServiceAccount:config.accountName 
                                                                                               accessKey:config.accessKey];
    
    TableListController *newController = [[TableListController alloc] initWithNibName:@"TableListController" bundle:nil];
	
	newController.navigationItem.title = @"Blob Storage";
	[self.navigationController pushViewController:newController animated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)ibaBrowseVideos:(id)sender {
    WAConfiguration *config = [WAConfiguration sharedConfiguration];	

    AVUAppDelegate *appDelegate = (AVUAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.authenticationCredential = [WAAuthenticationCredential credentialWithAzureServiceAccount:config.accountName 
                                                                                               accessKey:config.accessKey];
    [appDelegate setMovieUploadLocation:nil];
    
    TableListController *newController = [[TableListController alloc] initWithNibName:@"TableListController" bundle:nil];
	
	newController.navigationItem.title = @"Blob Storage";
	[self.navigationController pushViewController:newController animated:YES];
}
@end
