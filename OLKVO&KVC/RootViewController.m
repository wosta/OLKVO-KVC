//
//  RootViewController.m
//  OLKVO&KVC
//
//  Created by peter on 16/3/30.
//  Copyright © 2016年 olive. All rights reserved.
//

#import "RootViewController.h"
#import "Person.h"
#import "Cat.h"
#import "SubViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    // KVC
    Person *person = [[Person alloc] init];
    [person setValue:@"Kitty" forKey:@"name"];
    [person setValue:@20 forKey:@"age"];
    [person setValue:@1 forKey:@"sex"];
    [person setValue:@"2016年03月30日" forKeyPath:@"birthday"];
    [person printSex];
    [person printBirthday];
    person.cat = [[Cat alloc] init];
    [person setValue:@"Tom" forKeyPath:@"cat.type"]; // forKeyPath 可以有高级作用，会先找cat的属性，然后再找type，如果没有type这个属性，赋值也不会报错。所以尽量使用forKeyPath这个方法来代替forKey
    [person setValue:@"2016年03月30日" forKeyPath:@"cat.birthday"];
    [person.cat printBirthday];
    NSLog(@"person.name = %@, person.age = %zd, person.cat.type = %@", person.name, person.age, person.cat.type);
//
    
    NSDictionary *dic = @{@"name":@"peter",
                          @"age":@22,
                          @"cat":person.cat};
//    @"cat":person.cat
    Person *person01 = [[Person alloc] initWithDictionary:dic];
    [person01.cat printBirthday];
    NSLog(@"person01.name = %@, person01.age = %zd", person01.name, person01.age);
    
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
