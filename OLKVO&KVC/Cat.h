//
//  Cat.h
//  OLKVO&KVC
//
//  Created by peter on 16/3/30.
//  Copyright © 2016年 olive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cat : NSObject
/** type */
@property (nonatomic, copy)NSString *type;

- (void)printBirthday;
- (NSString *)description;
@end
