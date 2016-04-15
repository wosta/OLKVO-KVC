//
//  SubViewController.m
//  OLKVO&KVC
//
//  Created by peter on 16/3/30.
//  Copyright © 2016年 olive. All rights reserved.
//

#import "SubViewController.h"
#import "Person.h"

@interface SubViewController ()
@property (nonatomic, strong) Person *subPersonKVO;
@property (nonatomic, strong) UILabel *subLabelKVO;
@end

@implementation SubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self subKVO];
}

- (void)subKVO {
    Person *person = [[Person alloc] init];
    person.name = @"hello";
    person.age = 23;
    self.subPersonKVO = person;
    [self.subPersonKVO addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"SubViewController"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(120, 200, 100, 35)];
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    [btn setTitle:@"增加5岁" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    self.subLabelKVO = [[UILabel alloc] initWithFrame:CGRectMake(40, 150, 200, 35)];
    self.subLabelKVO.text = [NSString stringWithFormat:@"%@现在的年龄是: %zd", person.name, person.age];
    self.subLabelKVO.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.subLabelKVO];
}

- (void)buttonPressed {
    self.subPersonKVO.age += 10;
}

- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    NSLog(@"keyPath=%@", keyPath);
    self.subLabelKVO.text = [NSString stringWithFormat:@"%@现在的年龄是: %zd", self.subPersonKVO.name, self.subPersonKVO.age];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    NSLog(@"keyPath=%@", keyPath);
    self.subLabelKVO.text = [NSString stringWithFormat:@"%@现在的年龄是: %zd", self.subPersonKVO.name, self.subPersonKVO.age];
}

- (void)dealloc {
    [self.subPersonKVO removeObserver:self forKeyPath:@"age" context:@"SubViewController"];
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
