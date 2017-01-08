//
//  TEDCoreDataMocker.m
//  TEDxCT
//
//  Created by Carla G on 2014/04/17.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDCoreDataMocker.h"
#import "TEDSession.h"
#import "TEDTalk.h"
#import "TEDSpeaker.h"
#import "TEDCoreDataManager.h"

@implementation TEDCoreDataMocker

- (void)create2Speakers {
    
    NSManagedObjectContext *context = [[TEDCoreDataManager sharedManager] uiContext];
    [self cleanSpeakersTableInContext:context];
    

    
    TEDSpeaker *speaker3 = (TEDSpeaker *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TEDSpeaker class])
                                                                       inManagedObjectContext:context];
    
    speaker3.fullName = @"Rapelang Rabana";
    speaker3.funkyTitle = @"Technology Entrepeneur";
    speaker3.imageURL = @"http://old.tedxcapetown.org/sites/default/files/imagecache/200x200/speakers/R%20Rabana%20Small.jpg";
    speaker3.descriptionHTML = @"Rapelang believes in using mobile technology to re-imagine learning by creating interactive, personalized and adaptive learning platforms that produce data and transparently show levels of knowledge retention.";
    
    TEDSpeaker *speaker4 = (TEDSpeaker *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TEDSpeaker class])
                                                                       inManagedObjectContext:context];
    
    speaker4.fullName = @"Angel Campey";
    speaker4.funkyTitle = @"Comedian";
    speaker4.imageURL = @"http://old.tedxcapetown.org/sites/default/files/imagecache/200x200/speakers/IMG_0814.jpg";
    speaker4.descriptionHTML = @"Angel feels at home on stage with her discuss-it-for-what-it-is comedy approach and shares fresh perspectives on topics we should be talking about.";
    
    TEDSpeaker *speaker5 = (TEDSpeaker *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TEDSpeaker class])
                                                                       inManagedObjectContext:context];
    
    speaker5.fullName = @"Adrian Saville";
    speaker5.funkyTitle = @"Economist";
    speaker5.imageURL = @"http://old.tedxcapetown.org/sites/default/files/imagecache/200x200/speakers/IMG_0829.jpg";
    speaker5.descriptionHTML = @"Adrian demonstrates how mobility on all levels can create win-win outcomes that produce economic inclusion and social upliftment.";
    
//    TEDSpeaker *speaker1 = (TEDSpeaker *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TEDSpeaker class])
//                                                                       inManagedObjectContext:context];
//    
//    speaker1.fullName = @"Karen Dudley";
//    speaker1.funkyTitle = @"The Kitchen";
//    speaker1.imageURL = @"http://old.tedxcapetown.org/sites/default/files/imagecache/200x200/speakers/IMG_0521.jpg";
//    speaker1.descriptionHTML = @"Karen uses food and sharing thereof as a metaphor for embracing our diversity and creating spaces for people to find comfort and nourishment.";
//    
//    TEDSpeaker *speaker2 = (TEDSpeaker *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TEDSpeaker class])
//                                                                       inManagedObjectContext:context];
//    
//    speaker2.fullName = @"Nic Haralambous";
//    speaker2.funkyTitle = @"Mobile Entrepreneur";
//    speaker2.imageURL = @"http://old.tedxcapetown.org/sites/default/files/imagecache/200x200/speakers/IMG_0499.jpg";
//    speaker2.descriptionHTML = @"Nic believes in embracing incompetence and how it allows for situations of learning and discovery, and often the emergence of the innovation and success.";
//    
    NSError *error;
    [context save:&error];
}

- (void)create2Sessions {
    
    NSManagedObjectContext *context = [[TEDCoreDataManager sharedManager] uiContext];
    [self cleanSessionsTableInContext:context];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MMM-yyyy hh:mm";
    
    TEDSession *session1 = (TEDSession *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TEDSession class])inManagedObjectContext:context];
    
    session1.startTime = [dateFormatter dateFromString:@"02-05-2014 09:00"];
    session1.endTime = [dateFormatter dateFromString:@"06-05-2014 00:00"];
    session1.name = @"My Session 1";
    
    TEDTalk *talk1 = (TEDTalk *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TEDTalk class])                                                                       inManagedObjectContext:context];
    
    talk1.name = @"Love Sandwich";
    talk1.genre = @"Business";
    talk1.descriptionHTML = @"Karen uses food and sharing thereof as a metaphor for embracing our diversity and creating spaces for people to find comfort and nourishment.";
    talk1.imageURL = @"http://lorempixel.com/400/200";
    talk1.videoURL = @"http://google.com/video.flv";
    talk1.orderInSession = 0;
    
    [session1 addTalksObject:talk1];
    
    TEDSpeaker *speaker1 = (TEDSpeaker *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TEDSpeaker class])
                                                                       inManagedObjectContext:context];
    
    speaker1.fullName = @"Karen Dudley";
    speaker1.funkyTitle = @"The Kitchen";
    speaker1.imageURL = @"http://old.tedxcapetown.org/sites/default/files/imagecache/200x200/speakers/IMG_0521.jpg";
    speaker1.descriptionHTML = @"Karen uses food and sharing thereof as a metaphor for embracing our diversity and creating spaces for people to find comfort and nourishment.";
    speaker1.contactDetailsBlob = [NSKeyedArchiver archivedDataWithRootObject:@[[NSDictionary dictionaryWithObjectsAndKeys:@"email", @"karen", nil]]];
    
    talk1.speaker = speaker1;
    
    
    
    TEDTalk *talk2 = (TEDTalk *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TEDTalk class])                                                                       inManagedObjectContext:context];
    
    talk2.name = @"Living at the forefront of incompetence";
    talk2.genre =@"Another Genre";
    talk2.descriptionHTML = @"Nic believes in embracing incompetence and how it allows for situations of learning and discovery, and often the emergence of the innovation and success.";
    talk2.imageURL = @"http://lorempixel.com/400/200";
    talk2.videoURL = @"http://google.com/video.flv";
    talk2.orderInSession = 0;
    
    [session1 addTalksObject:talk2];
    
    TEDSpeaker *speaker2 = (TEDSpeaker *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TEDSpeaker class])
                                                                       inManagedObjectContext:context];
    speaker2.fullName = @"Nic Haralambous";
    speaker2.funkyTitle = @"Mobile Entrepreneur";
    speaker2.imageURL = @"http://old.tedxcapetown.org/sites/default/files/imagecache/200x200/speakers/IMG_0499.jpg";
    speaker2.descriptionHTML = @"Nic believes in embracing incompetence and how it allows for situations of learning and discovery, and often the emergence of the innovation and success.";

    talk2.speaker = speaker2;
    
    NSError *error;
    [context save:&error];
}

- (void)cleanSpeakersTableInContext:(NSManagedObjectContext *)context {
    
    NSFetchRequest * allSpeakers = [[NSFetchRequest alloc] init];
    
    [allSpeakers setEntity:[NSEntityDescription entityForName:NSStringFromClass([TEDSpeaker class]) inManagedObjectContext:context]];
    [allSpeakers setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * existingTitles = [context executeFetchRequest:allSpeakers error:&error];
    
    //error handling goes here
    for (NSManagedObject * title in existingTitles) {
        [context deleteObject:title];
    }
    NSError *saveError = nil;
    [context save:&saveError];
}

- (void)cleanSessionsTableInContext:(NSManagedObjectContext *)context {
    
    NSFetchRequest * allSessions = [[NSFetchRequest alloc] init];
    
    [allSessions setEntity:[NSEntityDescription entityForName:NSStringFromClass([TEDSession class]) inManagedObjectContext:context]];
    [allSessions setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * existingTitles = [context executeFetchRequest:allSessions error:&error];
    
    //error handling goes here
    for (NSManagedObject * title in existingTitles) {
        [context deleteObject:title];
    }
    NSError *saveError = nil;
    [context save:&saveError];
}
@end
