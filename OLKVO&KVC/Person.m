//
//  Person.m
//  OLKVO&KVC
//
//  Created by peter on 16/3/30.
//  Copyright © 2016年 olive. All rights reserved.
//

#import "Person.h"

@interface Person (){
    NSString *_birthday;
}
// 私有成员变量 外部不能直接访问
@property (nonatomic, assign)NSInteger sex;
@end

@implementation Person

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)printSex {
    NSLog(@"person.sex是%@", _sex==0?@"男":@"女");
}

- (void)printBirthday{
    NSLog(@"person.birthday是%@", _birthday);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"person.name = %@, person.age = %ld, person.birthday = %@", self.name, (long)self.age, _birthday];
}
@end
