//
//  TEDCoreDataMocker.m
//  TEDxCT
//
//  Created by Carla G on 2014/04/17.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDCoreDataMocker.h"
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
    speaker3.imageURL = @"http://www.tedxcapetown.org/sites/default/files/imagecache/200x200/speakers/R%20Rabana%20Small.jpg";
    speaker3.isActive = [NSNumber numberWithBool:YES];
    speaker3.descriptionHTML = @"Rapelang believes in using mobile technology to re-imagine learning by creating interactive, personalized and adaptive learning platforms that produce data and transparently show levels of knowledge retention.";
    
    TEDSpeaker *speaker4 = (TEDSpeaker *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TEDSpeaker class])
                                                                       inManagedObjectContext:context];
    
    speaker4.fullName = @"Angel Campey";
    speaker4.funkyTitle = @"Comedian";
    speaker4.imageURL = @"http://www.tedxcapetown.org/sites/default/files/imagecache/200x200/speakers/IMG_0814.jpg";
    speaker4.isActive = [NSNumber numberWithBool:YES];
    speaker4.descriptionHTML = @"Angel feels at home on stage with her discuss-it-for-what-it-is comedy approach and shares fresh perspectives on topics we should be talking about.";
    
    TEDSpeaker *speaker5 = (TEDSpeaker *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TEDSpeaker class])
                                                                       inManagedObjectContext:context];
    
    speaker5.fullName = @"Adrian Saville";
    speaker5.funkyTitle = @"Economist";
    speaker5.imageURL = @"http://www.tedxcapetown.org/sites/default/files/imagecache/200x200/speakers/IMG_0829.jpg";
    speaker5.isActive = [NSNumber numberWithBool:YES];
    speaker5.descriptionHTML = @"Adrian demonstrates how mobility on all levels can create win-win outcomes that produce economic inclusion and social upliftment.";
    
    TEDSpeaker *speaker1 = (TEDSpeaker *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TEDSpeaker class])
                                                                       inManagedObjectContext:context];
    
    speaker1.fullName = @"Mary Poppins";
    speaker1.funkyTitle = @"The very best babysitter";
    speaker1.imageURL = @"http://th07.deviantart.net/fs21/PRE/i/2007/308/8/f/Mary_Poppins_2_by_hanakosu.jpg";
    speaker1.isActive = [NSNumber numberWithBool:YES];
    speaker1.descriptionHTML = @"In ev'ry job that must be done. There is an element of fun. You find the fun and snap! The job's a game. And ev'ry task you undertake. Becomes a piece of cake. A lark! A spree! It's very clear to see that. A Spoonful of sugar helps the medicine go down. The medicine go down-wown. The medicine go down. Just a spoonful of sugar helps the medicine go down. In a most delightful way. A robin feathering his nest. Has very little time to res. While gathering his bits of twine and twig. Though quite intent in his pursuit. He has a merry tune to toot. He knows a song will move the job along - for A Spoonful of sugar helps the medicine go down. The medicine go down-wown. The medicine go down. Just a spoonful of sugar helps the medicine go down. In a most delightful way";
    
    TEDSpeaker *speaker2 = (TEDSpeaker *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TEDSpeaker class])
                                                                       inManagedObjectContext:context];
    
    speaker2.fullName = @"Lady Gaga";
    speaker2.funkyTitle = @"I dress super weird";
    speaker2.imageURL = @"http://timenewsfeed.files.wordpress.com/2010/06/lady-gaga-kermit-suit4.jpg?w=480&h=320&crop=1";
    speaker2.isActive = [NSNumber numberWithBool:YES];
    speaker2.descriptionHTML = @"Mum mum mum mah Mum mum mum mah Mum mum mum mah Mum mum mum mum Mum mum mum mah. I wanna hold 'em like they do in Texas, please. Fold 'em, let 'em, hit me, raise it, baby, stay with me (I love it) Love game intuition play the cards with Spades to start. And after he's been hooked I'll play the one that's on his heart. Oh, oh, oh, oh, ohhhh, oh-oh-e-oh-oh-oh. I'll get him hot, show him what I've got. Oh, oh, oh, oh, ohhhh, oh-oh-e-oh-oh-oh, I'll get him hot, show him what I've got. Can't read my, Can't read my. No he can't read my poker face (she's got me like nobody) Can't read my Can't read my";
    
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
@end
