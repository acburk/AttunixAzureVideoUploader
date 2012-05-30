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
#import <MediaPlayer/MediaPlayer.h>

@interface TableListController : UITableViewController <WACloudStorageClientDelegate> {
@private
	WACloudStorageClient *storageClient;
    NSUInteger fetchCount;
	WABlobContainer *selectedContainer;
	WAQueue *selectedQueue;
    WAResultContinuation *_resultContinuation;
    NSMutableArray *_localStorageList;
    BOOL _fetchedResults;
    MPMoviePlayerViewController* mp;
}

@property (nonatomic, retain) WABlobContainer *selectedContainer;
@property (nonatomic, retain) WAQueue *selectedQueue;
@property (nonatomic, retain) WAResultContinuation *resultContinuation;
@property (nonatomic, retain) NSMutableArray *localStorageList;

- (IBAction)modifyStorage:(id)sender;

@end
