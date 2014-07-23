//
//  TEDImageDownloader.m
//  TEDxCT
//
//  Created by Daniel Galasko on 5/27/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDImageDownloader.h"
#import "TEDStorageService.h"
@interface TEDImageDownloader()
@property (strong,nonatomic) NSOperationQueue *imageDownloadQueue;
@property (strong,nonatomic) NSMutableDictionary *imageRequestsKeyedByURL;
@end
@implementation TEDImageDownloader

#define IMAGEDOWNLOADER_LOGGER 0

#if IMAGEDOWNLOADER_LOGGER == 1
#	define IDLog(fmt, ...) NSLog((fmt), ##__VA_ARGS__);
#else
#	define IDLog(...)
#endif

- (id)init {
    if (self=[super init]) {
        _imageDownloadQueue = [[NSOperationQueue alloc] init];
        _imageRequestsKeyedByURL = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)downloadImageWithURL:(NSString *)imageURL
                forEventName:(NSString *)eventName
           completionHandler:(void (^)(UIImage *image, NSError *error))completion {
    if (!self.imageRequestsKeyedByURL[imageURL]) {
        IDLog(@"%s REQUEST IMAGE WITH URL: %@", __PRETTY_FUNCTION__, imageURL);

        [self.imageRequestsKeyedByURL setObject:[NSNumber numberWithBool:YES] forKey:imageURL];
        NSString *fileURL = [TEDStorageService pathForImageWithURL:imageURL eventName:eventName createIfNeeded:YES];
        NSBlockOperation *imageDownloadOperation = [NSBlockOperation blockOperationWithBlock:^{
            NSError *error = nil;
            NSData *imageData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]]
                                                  returningResponse:nil
                                                              error:&error];
            [imageData writeToFile:fileURL atomically:NO];
            UIImage *image = [UIImage imageWithData:imageData];

            if (completion) {
                IDLog(@"%s IMAGE DOWNLOAD COMPLETED WITH ERROR: %@", __PRETTY_FUNCTION__, error);

                completion(image,error);
            }
            [self.imageRequestsKeyedByURL removeObjectForKey:imageURL];
        }];
        [self.imageDownloadQueue addOperation:imageDownloadOperation];
    } else {
        if (completion) {
            completion(nil,nil);
        }
        
        IDLog(@"%s IMAGE WITH URL: %@ ALREADY REQUESTED", __PRETTY_FUNCTION__, imageURL);
    }
}

- (void)cancelAllRequests {
    [self.imageDownloadQueue cancelAllOperations];
}

@end