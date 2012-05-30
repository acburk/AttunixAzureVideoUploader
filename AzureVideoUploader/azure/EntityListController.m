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

#import "EntityListController.h"
#import "EntityTableViewCell.h"
#import "UIViewController+ShowError.h"

#define ENTITY_TYPE_TABLE				1
#define ENTITY_TYPE_QUEUE				2
#define QUEUE_MESSAGE_NUMBER_FIELDS		6

#define TOP_ROWS 6

@interface EntityListController()

- (void)fetchEntities;
- (void)editEntity:(NSUInteger)index;

@end

@implementation EntityListController

@synthesize entityType;
@synthesize resultContinuation=_resultContinuation;
@synthesize localEntityList = _localEntityList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    storageClient.delegate = nil;
    RELEASE(storageClient);
    RELEASE(_resultContinuation);
    RELEASE(_localEntityList);
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	AVUAppDelegate *appDelegate = (AVUAppDelegate *)[[UIApplication sharedApplication] delegate];
	
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
																							target:self 
																							action:@selector(addEntity:)] autorelease];
	storageClient = [[WACloudStorageClient storageClientWithCredential:appDelegate.authenticationCredential] retain];
	storageClient.delegate = self;
    
    _localEntityList = [[NSMutableArray alloc] initWithCapacity:20];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	if (self.entityType == ENTITY_TYPE_TABLE && self.localEntityList.count == 0) {
		[self fetchEntities];
	} else if (self.entityType == ENTITY_TYPE_QUEUE) {
		[storageClient peekQueueMessages:self.navigationItem.title fetchCount:1000];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
    storageClient.delegate = self;
    
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Private methods

- (void)fetchEntities
{
    WATableFetchRequest *fetchRequest = [WATableFetchRequest fetchRequestForTable:self.navigationItem.title];
    fetchRequest.resultContinuation = self.resultContinuation;
    fetchRequest.topRows = TOP_ROWS;
    [storageClient fetchEntitiesWithContinuation:fetchRequest];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSUInteger count = fetchCount;
    NSUInteger localCount = self.localEntityList.count;
    
    if (count >= TOP_ROWS &&
        self.resultContinuation.nextPartitionKey != nil &&
        self.resultContinuation.nextRowKey != nil) {
        localCount += 1;
    }
    
    return localCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* CellIdentifier = @"Cell2";
    
    EntityTableViewCell *cell = (EntityTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (indexPath.row != self.localEntityList.count) {
        if (cell == nil) {
            cell = [[[EntityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
	
        if (self.entityType == ENTITY_TYPE_TABLE) {
            WATableEntity *entity = [self.localEntityList objectAtIndex:indexPath.row];
            [cell setKeysAndObjects:@"PartitionKey", [entity partitionKey], @"RowKey", [entity rowKey], entity, nil];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        } else if (self.entityType == ENTITY_TYPE_QUEUE) {
            WAQueueMessage *queueMessage = [self.localEntityList objectAtIndex:indexPath.row];
            [cell setKeysAndObjects:queueMessage, nil];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
	
    if (indexPath.row == self.localEntityList.count) {   
        if (fetchCount == TOP_ROWS) {
            UITableViewCell *loadMoreCell = [tableView dequeueReusableCellWithIdentifier:@"LoadMore"];
            if (loadMoreCell == nil) {
                loadMoreCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LoadMore"] autorelease];
            }
            
            UILabel *loadMore =[[UILabel alloc] initWithFrame:CGRectMake(0,0,362,40)];
            loadMore.textColor = [UIColor blackColor];
            loadMore.highlightedTextColor = [UIColor darkGrayColor];
            loadMore.backgroundColor = [UIColor clearColor];
            loadMore.textAlignment = UITextAlignmentCenter;
            loadMore.font = [UIFont boldSystemFontOfSize:20];
            loadMore.text = @"Show more results...";
            [loadMoreCell addSubview:loadMore];
            [loadMore release];
            return loadMoreCell;
        }
    }
    
	return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int count = 0;
	
    if (indexPath.row >= self.localEntityList.count) {
        return 40;  
    } else if (self.entityType == ENTITY_TYPE_TABLE) {
		WATableEntity *entity = [self.localEntityList objectAtIndex:indexPath.row];
		count = entity.keys.count + 2;
	} else if (self.entityType == ENTITY_TYPE_QUEUE) {
		count = 6;
	} else {
		return 44;
	}
	
	return 12 + count * 25;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (self.entityType == ENTITY_TYPE_TABLE) {
        if (fetchCount == TOP_ROWS && indexPath.row == self.localEntityList.count) {
            [tableView beginUpdates];
            fetchCount--;
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                                  withRowAnimation:UITableViewScrollPositionBottom];
            [tableView endUpdates];
            [self fetchEntities];
        } else {
            [self editEntity:indexPath.row];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (fetchCount == TOP_ROWS && indexPath.row == self.localEntityList.count) {
        return NO;
    }
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	void(^block)(NSError*) = ^(NSError* error) 
	{
		if (error) {
			[self showError:error withTitle:@"Deleting Entry"];
			return;
		}
		
		[_localEntityList removeObjectAtIndex:indexPath.row];
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
							  withRowAnimation:UITableViewScrollPositionBottom];
		
		if (entityType == ENTITY_TYPE_TABLE && !_localEntityList.count) {
			self.navigationItem.rightBarButtonItem = nil;
		}
	};	
	
	if (entityType == ENTITY_TYPE_TABLE) {
		WATableEntity *entity = [self.localEntityList objectAtIndex:indexPath.row];
		[storageClient deleteEntity:entity withCompletionHandler:block];
	} else if (entityType == ENTITY_TYPE_QUEUE) {
		WAQueueMessage *queueMessage = [self.localEntityList objectAtIndex:indexPath.row];
		
		[storageClient deleteQueueMessage:queueMessage 
							  queueName:self.navigationItem.title 
				  withCompletionHandler:block];
	}

}

#pragma mark - CloudStorageClientDelegate methods

- (void)storageClient:(WACloudStorageClient *)client didFailRequest:request withError:error
{
	[self showError:error];
}

- (void)storageClient:(WACloudStorageClient *)client didFetchEntities:(NSArray *)entities fromTableNamed:(NSString *)tableName withResultContinuation:(WAResultContinuation *)resultContinuation
{
    fetchCount = [entities count];
    self.resultContinuation = resultContinuation;
	if ([entities count] == 0) {
		self.navigationItem.rightBarButtonItem = nil;
	}
    [self.localEntityList addObjectsFromArray:entities];    
	[self.tableView reloadData];
}

- (void)storageClient:(WACloudStorageClient *)client didPeekQueueMessages:(NSArray *)queueMessages
{
    fetchCount = [queueMessages count];
    [self.localEntityList addObjectsFromArray:queueMessages];
	[self.tableView reloadData];
}

@end
