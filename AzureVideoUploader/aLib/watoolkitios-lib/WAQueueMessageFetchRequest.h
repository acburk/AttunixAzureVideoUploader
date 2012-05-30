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

#import <Foundation/Foundation.h>

/**
 A class that represents a Windows Azure Queue Message Container Storage fetch request.
 
 The request is used with the WACloudStorageClient when working with blobs.
 */
@interface WAQueueMessageFetchRequest : NSObject

/**
 The name of the queue to fetch
 */
@property (nonatomic, copy) NSString *queueName;

/**
 A nonzero integer value that specifies the number of messages to retrieve from the queue, up to a maximum of 32. By default, a single message is retrieved from the queue with this operation.
 */
@property (nonatomic, assign) NSUInteger fetchCount;

/**
 Specifies the new visibility timeout value, in seconds, relative to server time. The new value must be larger than or equal to 0, and cannot be larger than 7 days, or larger than 2 hours on REST protocol versions prior to version 2011-08-18. The visibility timeout of a message can be set to a value later than the expiry time.
 */
@property (nonatomic, assign) NSUInteger visibilityTimeout;

/**
 Create a new WAQueueFetchRequest with a result continuation.
 
 @param queueName The name of the queue.
 
 @returns The newly initialized WAQueueFetchRequest object.
 */
+ (WAQueueMessageFetchRequest *)fetchRequestWithQueueName:(NSString *)queueName;

@end
