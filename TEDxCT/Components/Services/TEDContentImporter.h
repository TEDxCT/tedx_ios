//
//  TEDContentImporter.h
//  TEDxCT
//
//  Created by Carla G on 2014/05/12.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEDContentImporter : NSObject<NSURLSessionTaskDelegate>


+ (TEDContentImporter *)sharedImporter;
+ (void)initialiseSharedImporter;

- (void)requestContentImportForAllContent;

@end
