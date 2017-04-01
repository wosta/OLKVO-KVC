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
#import <objc/runtime.h>

typedef enum : NSUInteger {
    RootViewKVC,
    RootViewKVO,
} RootViewENUM;

static NSDictionary *layer_style(RootViewENUM rootViewEnum) {
    NSDictionary *dict = nil;
    switch (RootViewKVC) {
        case RootViewKVC:
//            dict
            break;
            
        default:
            break;
    }
}

@interface RootViewController ()
@property (nonatomic, strong) UILabel *kvoAgeLabel;
@property (nonatomic, strong) Person *kvoPerson;
@property (nonatomic, strong) SubViewController *subView; // 绑定view太重了
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
    [self kvo01];
    [self addSubView];
    
//    [self shark];
    
    
    Class obj = [NSObject class];
    Class cls = object_getClass(obj); // 这是返回的实例
    Class cls2 = [obj class]; // 这是返回的类
    NSLog(@"cls  %p", cls); // 0x107111e08
    NSLog(@"cls2 %p", cls2);// 0x107111e58
    
    
    
}

- (void)kvc {
    Person *person = [[Person alloc] init];
    person.name = @"peter";
    person.age = 20;
//    NSLog(@"%@", [person description]);
    
    Person *person01 = [[Person alloc] init];
    [person01 setValue:@"kitty" forKey:@"name"];
    [person01 setValue:@20 forKeyPath:@"age"];
//    [person01 setValue:@"2017年03月31日" forKeyPath:@"birthday"];
    // setValue-forKey  && setValue-forKeyPath 在这里两者是没有区别的
    [person01 setValue:@"2017年03月31日" forKey:@"_birthday"];
    [person01 setValue:@"2017年03月31日" forKey:@"birthday"];
    // 我们传入的字符串key是birthday,但是定义的属性是_birthday,但是通过kvc还是可以给_birthday属性赋到值。说明对某一个属性进行赋值,可以不用加下划线,而且它的查找规则应该是:先查找和直接写入的字符串相同的成员变量,如果找不到就找以下划线开头的成员变量。
//    NSLog(@"person01 descript: %@", person01);
    
    Cat *aCat = [[Cat alloc] init];
    person01.cat = aCat;
//    [person01 setValue:@"bingo" forKey:@"cat.type"];
    [person01 setValue:@"bingo" forKeyPath:@"cat.type"];
//    [person01 setValue:@"bingo" forKeyPath:@"acat.type"];
    // [<Person 0x608000254ca0> valueForUndefinedKey:]: this class is not key value coding-compliant for the key acat.'
    // 如果这里没有找到对应的key的话也会crash掉
    // setValue-forKey  && setValue-forKeyPath 在这里就有区别了，前者就会造成crash
//    NSLog(@"the cat of person01 is %@", [person01.cat description]);
    
    NSLog(@"person01.name = %@, person01.age = %@, person01.cat.type=%@", [person01 valueForKeyPath:@"name"], [person01 valueForKeyPath:@"birthday"], [person01 valueForKeyPath:@"cat.type"]);
    // 既然能通过kvc赋值，那么就可以通过kvc获值。
    
    
    // kvc 另外一个用处是setValuesForKeysWithDictionary
    NSDictionary *dic = @{@"name":@"peter",
                          @"age":@22,
                          @"cat":person.cat};
    //    @"cat":person.cat
    Person *person02 = [[Person alloc] initWithDictionary:dic];
    [person01.cat printBirthday];
    NSLog(@"person01.name = %@, person01.age = %zd", person02.name, person02.age);
}

- (void)kvo {
    Person *person = [[Person alloc] init];
    person.name = @"hello";
    person.age = 23;
    self.kvoPerson = person;
    [person addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:@"RootViewController"];
    
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

- (void)kvo01 {
    
}

- (void)addSubView {
    SubViewController *sub = [[SubViewController alloc] init];
    [sub addObserver:self forKeyPath:@"subAge" options:NSKeyValueObservingOptionNew context:nil];
    self.subView = sub;
}

- (void)shark {
    Shark *shark = [Shark new];
    // breakpoint 1
    [shark addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:@"RootViewController"];
    // breakpoint 2
    shark.name = @"萨萨萨";
    [shark removeObserver:self forKeyPath:@"name"];
    
}

- (void)buttonPressed {
    self.kvoPerson.age += 5;
}

- (void)nextButton {
#warning 为何这里不行？
//    SubViewController *sub = [[SubViewController alloc] init];
//    [sub addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];
//    self.subView = sub;
    [self.navigationController pushViewController:self.subView animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"subAge"]) {
        self.kvoAgeLabel.text = [NSString stringWithFormat:@"%@现在的年龄是: %zd", self.kvoPerson.name, self.subView.subAge];
    }
    self.kvoAgeLabel.text = [NSString stringWithFormat:@"%@现在的年龄是: %zd", self.kvoPerson.name, self.kvoPerson.age];
}

- (void)dealloc {
    [self.kvoPerson removeObserver:self forKeyPath:@"age" context:@"RootViewController"];
    [self.subView removeObserver:self forKeyPath:@"subAge"];
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
