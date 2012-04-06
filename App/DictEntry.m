//
//  DictEntry.m
//  Draw Cheats
//
//  Created by Haohua Huang on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DictEntry.h"

@implementation DictEntry

@synthesize word = mWord;
@synthesize desc = mDesc;

- (void)dealloc {
    [mWord release];
    mWord = nil;
    [mDesc release];
    mDesc = nil;
    [super dealloc];
}

- (id)init: (NSString*)_word desc:(NSString*)_desc
{
    if ((self = [super init])) {
         mWord = [_word copy];
        mDesc = [_desc copy];

    }
    return self;
}

@end
