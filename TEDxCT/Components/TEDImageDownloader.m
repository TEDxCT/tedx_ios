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
                completion(image,error);
            }
            [self.imageRequestsKeyedByURL removeObjectForKey:imageURL];
        }];
        [self.imageDownloadQueue addOperation:imageDownloadOperation];
    }
}

- (void)cancelAllRequests {
    [self.imageDownloadQueue cancelAllOperations];
}

@end