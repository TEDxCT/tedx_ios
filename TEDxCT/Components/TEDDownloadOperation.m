//
//  TEDDownloadOperation.m
//  TEDxCT
//
//  Created by Carla G on 2014/05/19.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDDownloadOperation.h"
#import "TEDApplicationConfiguration.h"

@interface TEDDownloadOperation ()

@property (nonatomic, strong) NSURL *remoteURL;
@property (nonatomic, weak) NSError *error;
@property (nonatomic, strong) NSDictionary *responseJSON;

@end

@implementation TEDDownloadOperation

- (void)main {
    if ([self isCancelled]) {
        return;
    }
    
    //use a dispatch semaphore to make sure that
    //the thread that initiated the asynchronous process waits for a
    //signal from the completion block of the asynchronous operation before continuing.
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:self.remoteURL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if(!error){
                                                        NSDictionary *json = [NSJSONSerialization
                                                                              JSONObjectWithData:data
                                                                              options:kNilOptions
                                                                              error:&error];
                                                        
                                                        self.error = error;
                                                        self.responseJSON = json;
                                                    }
                                                    
                                                    //process the semaphore
                                                    dispatch_semaphore_signal(semaphore);

                                                    
                                                }];
    
    [dataTask resume];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

}

+(TEDDownloadOperation *)operationWithRemoteURL:(NSURL *)url
                                success:(void (^)(NSOperation *operation, id responseObject))success
                              failure:(void (^)(NSOperation *operation, NSError *error))failure
{
    TEDDownloadOperation *downloadOperation = [[TEDDownloadOperation alloc]init];
    downloadOperation.remoteURL = url;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
#pragma clang diagnostic ignored "-Wgnu"
    
    downloadOperation.completionBlock = ^{
        if (downloadOperation.error) {
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(downloadOperation, downloadOperation.error);
                });
            }
        } else {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(downloadOperation, downloadOperation.responseJSON);
                });
            }
        }
    };
    
    return downloadOperation;
#pragma clang diagnostic pop
}

- (void)setCompletionBlock:(void (^)(void))block {
    if (!block) {
        [super setCompletionBlock:nil];
    } else {
        __weak __typeof(&*self)weakSelf = self;
        [super setCompletionBlock:^ {
            __strong __typeof(&*weakSelf)strongSelf = weakSelf;
            
            block();
            [strongSelf setCompletionBlock:nil];
        }];
    }
}

@end
