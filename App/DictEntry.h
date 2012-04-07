//
//  DictEntry.h
//  Draw Cheats
//
//  Created by Haohua Huang on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DictEntry : NSObject;

@property (copy) NSString * word;
@property (copy) NSString * desc;

- (id)init: (NSString*)_word desc:(NSString*)_desc;

@end
