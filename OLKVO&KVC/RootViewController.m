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
#import "Shark.h"
#import "SubViewController.h"

@interface RootViewController ()
@property (nonatomic, strong) UILabel *kvoAgeLabel;
@property (nonatomic, strong) Person *kvoPerson;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // KVC
//    [self kvc];
    
    // KVO
//    [self kvo];
    
    [self shark];
    
 }

- (void)kvc {
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

- (void)kvo {
    Person *person = [[Person alloc] init];
    person.name = @"hello";
    person.age = 23;
    self.kvoPerson = person;
    [person addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(120, 200, 100, 35)];
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    [btn setTitle:@"增加5岁" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    self.kvoAgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 150, 200, 35)];
    self.kvoAgeLabel.text = [NSString stringWithFormat:@"%@现在的年龄是: %zd", person.name, person.age];
    self.kvoAgeLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.kvoAgeLabel];
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(btn.frame)+50, 50, 50)];
    [nextButton setTitle:@"next" forState:UIControlStateNormal];
    nextButton.backgroundColor = [UIColor lightGrayColor];
    [nextButton addTarget:self action:@selector(nextButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
}

- (void)shark {
    Shark *shark = [Shark new];
    // breakpoint 1
    [shark addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    // breakpoint 2
    shark.name = @"萨萨萨";
    [shark removeObserver:self forKeyPath:@"name"];
    
}

- (void)buttonPressed {
    self.kvoPerson.age += 5;
}

- (void)nextButton {
    SubViewController *sub = [[SubViewController alloc] init];
    [self.navigationController pushViewController:sub animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    self.kvoAgeLabel.text = [NSString stringWithFormat:@"%@现在的年龄是: %zd", self.kvoPerson.name, self.kvoPerson.age];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"age" context:nil];
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
