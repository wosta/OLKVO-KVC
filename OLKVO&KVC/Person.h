//
//  Person.h
//  OLKVO&KVC
//
//  Created by peter on 16/3/30.
//  Copyright © 2016年 olive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cat.h"

@interface Person : NSObject

/** name */
@property (nonatomic, copy)NSString *name;
/** age */
@property (nonatomic, assign)NSInteger age;
/** cat */
@property (nonatomic, strong)Cat *cat;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (void)printSex ;

- (void)printBirthday ;

@end
