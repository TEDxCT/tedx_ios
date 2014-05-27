//
//  TEDDownloadOperation.h
//  TEDxCT
//
//  Created by Carla G on 2014/05/19.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEDDownloadOperation : NSOperation

+(TEDDownloadOperation *)operationWithRemoteURL:(NSURL *)url
                                        success:(void (^)(NSOperation *operation, id responseObject))success
                                        failure:(void (^)(NSOperation *operation, NSError *error))failure;

@end
