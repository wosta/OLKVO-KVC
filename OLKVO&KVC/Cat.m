//
//  Cat.m
//  OLKVO&KVC
//
//  Created by peter on 16/3/30.
//  Copyright © 2016年 olive. All rights reserved.
//

#import "Cat.h"

@interface Cat ()
{
    NSString *_birthday;
}
@end

@implementation Cat
- (void)printBirthday{
    NSLog(@"cat.birthday是%@", _birthday);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"wow, how beautiful is %@, how old is it? %@", self.type, _birthday];
}

@end
