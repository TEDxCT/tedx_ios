//
//  TEDImageDownloader.h
//  TEDxCT
//
//  Created by Daniel Galasko on 5/27/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEDImageDownloader : NSObject
- (void)downloadImageWithURL:(NSString *)imageURL
                forEventName:(NSString *)eventName
           completionHandler:(void(^)(UIImage *image, NSError *error))completion;
- (void)cancelAllRequests;
@end
