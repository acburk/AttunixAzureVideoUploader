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

extern NSString * const WABlobPropertyKeyBlobType;
extern NSString * const WABlobPropertyKeyCacheControl;
extern NSString * const WABlobPropertyKeyContentEncoding;
extern NSString * const WABlobPropertyKeyContentLanguage;
extern NSString * const WABlobPropertyKeyContentLength;
extern NSString * const WABlobPropertyKeyContentMD5;
extern NSString * const WABlobPropertyKeyContentType;
extern NSString * const WABlobPropertyKeyEtag;
extern NSString * const WABlobPropertyKeyLastModified;
extern NSString * const WABlobPropertyKeyLeaseStatus;
extern NSString * const WABlobPropertyKeySequenceNumber;

@class WABlobContainer;

/**
 A class that represents a Windows Azure Blob. 
 */
@interface WABlob : NSObject {
    NSMutableDictionary *_metadata;
}

/**
 The name of the blob.
 */
@property (readonly) NSString *name;

/**
 The address that identifies the blob.
 */
@property (readonly) NSURL *URL;

/**
 The content data for the blob.
 */
@property (nonatomic, retain) NSData *contentData;

/**
 The content type for the blob.
 */
@property (nonatomic, copy) NSString *contentType;

/**
 A WABlobContainer object representing the blob's container.
 
 @deprecated This will be deprecated in the next release.
 
 @see WABlobContainer
 */
// TODO: Remove this before release
@property (readonly) WABlobContainer *container DEPRECATED_ATTRIBUTE;

/**
 The container name of the blob.
 */
@property (readonly) NSString *containerName;

/**
 The metadata for the container.
 */
@property (readonly) NSDictionary *metadata;

/**
 The properties for the blob.
 */
@property (readonly) NSDictionary *properties;

/**
 Sets a value to the container metadata dictionary.
 
 @param value The value for the key.
 @param key The key for the value.
 
 @discussion Raises an NSInvalidArgumentException if aKey or anObject is nil. If you need to represent a nil value in the dictionary, use NSNull. If aKey already exists in the dictionary, the dictionary’s previous value object for that key is sent a release message and anObject takes its place.
 */
- (void)setValue:(NSString *)value forMetadataKey:(NSString *)key;


/**
 Removes a given key and its associated value from the dictionary.
 
 @param key The key to remove.
 
 @discussion Does nothing if key does not exist.
 */
- (void)removeMetadataForKey:(NSString *)key;

/**
 Initializes a newly created WABlob with an name and address URL.
 
 @param name The name of the blob.
 @param URL The address of the blob.
 
 @returns The newly initialized WABlob object.
 */
- (id)initBlobWithName:(NSString *)name URL:(NSString *)URL;

/**
 Initializes a newly created WABlob with a name, address URL and a container.
 
 @param name The name of the blob.
 @param URL The address of the blob.
 @param container The container for the blob.
 
 @returns The newly initialized WABlob object.
 
 @see WABlobContainer
 */
// TODO: Remove this before release
- (id)initBlobWithName:(NSString *)name URL:(NSString *)URL container:(WABlobContainer *)container DEPRECATED_ATTRIBUTE;

/**
 Initializes a newly created WABlob with a name, address URL and a container.
 
 @param name The name of the blob.
 @param URL The address of the blob.
 @param containerName The container name for the blob.
 
 @returns The newly initialized WABlob object.
 */
- (id)initBlobWithName:(NSString *)name URL:(NSString *)URL containerName:(NSString *)containerName;

/**
 Initializes a newly created WABlob with a name, address URL, the container and properties.
 
 @param name The name of the blob.
 @param URL The address of the blob.
 @param container The container for the blob.
 @param properties The properties for the blob.
 
 @returns The newly initialized WABlob object.
 
 @see WABlobContainer
 */
// TODO: Remove this before release
- (id)initBlobWithName:(NSString *)name URL:(NSString *)URL container:(WABlobContainer *)container properties:(NSDictionary *)properties DEPRECATED_ATTRIBUTE;


/**
 Initializes a newly created WABlob with a name, address URL, the container and properties.
 
 @param name The name of the blob.
 @param URL The address of the blob.
 @param containerName The container name for the blob.
 @param properties The properties for the blob.
 
 @returns The newly initialized WABlob object.
 */
- (id)initBlobWithName:(NSString *)name URL:(NSString *)URL containerName:(NSString *)containerName properties:(NSDictionary *)properties;
@end
