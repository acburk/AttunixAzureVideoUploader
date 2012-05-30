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

@class WAResultContinuation;
@class WABlobContainer;

/**
 A class that represents a Windows Azure Blob Storage fetch request.
 
 The request is used with the WACloudStorageClient when working with blobs.
 */
@interface WABlobFetchRequest : NSObject

/**
 The container for the fetch request.
 */
@property (readonly) WABlobContainer *container;

/**
 Filters the results to return only blobs whose names begin with the specified prefix. 
 */
@property (nonatomic, copy) NSString *prefix;

/**
 A value indicating whether the blob listing operation will list all blobs in a container in a flat listing, or whether it will list blobs hierarchically, by virtual directory. 
 */
@property (nonatomic, assign) BOOL useFlatListing;

/**
 Specifies the maximum number of blobs to return, including all BlobPrefix elements. If the request does not specify maxresults or specifies a value greater than 5,000, the server will return up to 5,000 items.
 */
@property (nonatomic, assign) NSUInteger maxResult;

/**
 The continuation to use in the fetch request.
 */
@property (nonatomic, retain) WAResultContinuation *resultContinuation;

/**
 Create a new WABlobFetchRequest with a container name.
 
 @param container The container for the fetch request.
 
 @returns The newly initialized WABlobFetchRequest object.
 */
+ (WABlobFetchRequest *)fetchRequestWithContainer:(WABlobContainer *)container;

/**
 Create a new WABlobFetchRequest with a container name.
 
 @param container The container for the fetch request.
 @param resultContinuation The continuation to use in the fetch request.
 
 @returns The newly initialized WABlobFetchRequest object.
 */
+ (WABlobFetchRequest *)fetchRequestWithContainer:(WABlobContainer *)container resultContinuation:(WAResultContinuation *)resultContinuation;

@end
