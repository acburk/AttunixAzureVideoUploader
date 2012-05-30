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

extern NSString * const WAContainerPropertyKeyEtag;
extern NSString * const WAContainerPropertyKeyLastModified;

/**
 A class that represents a Windows Azure blob container.
 */
@interface WABlobContainer : NSObject {
    NSMutableDictionary *_metadata;
}

/**
 The name of the container.
 */
@property (copy) NSString *name;

/**
 Create the container if it doesn't exist.
 */
@property (assign) BOOL createIfNotExists;

/**
 Create the container as public.
 */
@property (assign) BOOL isPublic;

/**
 The address of the container.
 */
@property (readonly) NSURL *URL;

/**
 The shared access signiture for the container.
 
 @discussion This value is only valid when using a proxy
 */
@property (readonly) NSString *sharedAccessSigniture;

/**
 The metadata for the container.
 */
@property (readonly) NSDictionary *metadata;

/**
 The properties for the container.
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
 Initializes a newly created WABlobContainer with a name.
 
 @param name The name of the container.
	
 @returns The newly initialized WABlobContainer object.
 */
- (id)initContainerWithName:(NSString *)name;

/**
 Initializes a newly created WABlobContainer with a name.
 
 @param name The name of the container.
 @param URL The address of the container.
 
 @returns The newly initialized WABlobContainer object.
 */
- (id)initContainerWithName:(NSString *)name URL:(NSString *)URL;

/**
 Initializes a newly created WABlobContainer with a name, address and metadata for the container.
 
 @param name The name of the container.
 @param URL The address of the container.
 @param sharedAccessSigniture The container's shared access signiture.
 
 @discussion This sharedAccessSigniture is only valid when using a proxy
 
 @returns The newly initialized WABlobContainer object.
 */
- (id)initContainerWithName:(NSString *)name URL:(NSString *)URL sharedAccessSigniture:(NSString *)sharedAccessSigniture;

/**
 Initializes a newly created WABlobContainer with a name, address, metadata for the container.
 
 @param name The name of the container.
 @param URL The address of the container.
 @param sharedAccessSigniture The container's shared access signiture.
 @param properties The properties for the container.
 
 @discussion This sharedAccessSigniture is only valid when using a proxy
 
 @returns The newly initialized WABlobContainer object.
 */
- (id)initContainerWithName:(NSString *)name URL:(NSString *)URL sharedAccessSigniture:(NSString *)sharedAccessSigniture properties:(NSDictionary *)properties;

@end
