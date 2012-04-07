//
//  DictEntry.m
//  Draw Cheats
//
//  Created by Haohua Huang on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DictEntry.h"

@implementation DictEntry

@synthesize word;
@synthesize desc;


- (id)init: (NSString*)_word desc:(NSString*)_desc
{
    if ((self = [super init])) {
        self.word = [_word copy];
        self.desc = [_desc copy];

    }
    return self;
}

@end
