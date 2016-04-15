# OLKVO-KVC
参照： KVC & KVO [来源一:](http://www.jianshu.com/p/f1393d10109d "Title")  很基础的一篇
       KVO入门 [来源二:](http://blog.csdn.net/yuquan0821/article/details/6646400)    
       KVO进阶 [来源三:](http://www.cnblogs.com/wengzilin/p/4346775.html)  这篇比较深入，考虑也很周全  
               [来源四:](http://www.jianshu.com/p/742b4b248da9)   
       
### KVO的常见错误  
* 1.remove观察者
```objc
*** Terminating app due to uncaught exception 'NSRangeException', reason: 'Cannot remove an observer <SubViewController 0x7ff158707f80> for the key path "age" from <SubViewController 0x7ff158707f80> because it is not registered as an observer.'
```
修改前代码
```objc 
// 添加观察者
    Person *person = [[Person alloc] init];
    person.name = @"hello";
    person.age = 23;
    self.subPersonKVO = person;
    [self.subPersonKVO addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"SubViewController"];
```
```objc
// 移除观察者 在dealloc中
    [self removeObserver:self forKeyPath:@"age" context:@"SubViewController"];
```
=============
解决方案
```objc
// 移除观察者 在dealloc中
    [self.subPersonKVO removeObserver:self forKeyPath:@"age" context:@"SubViewController"];
```
`self` -> `self.subPersonKVO` 关键点就在这里，观察谁，谁就应该移除

* 2.值修改了，但是并没有接收到
```objc
*** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: '<SubViewController: 0x7fc273d13450>: An -observeValueForKeyPath:ofObject:change:context: message was received but not handled.
Key path: age
```
解决方案：添加该方法
```objc
`- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    NSLog(@"keyPath=%@", keyPath);
    self.subLabelKVO.text = [NSString stringWithFormat:@"%@现在的年龄是: %zd", self.subPersonKVO.name, self.subPersonKVO.age];
}
```

* 3.context上下文不一致，也可以理解为标识符不统一
```objc
*** Terminating app due to uncaught exception 'NSRangeException', reason: 'Cannot remove an observer <SubViewController 0x7fc175001d60> for the key path "age" from <Person 0x7fc172da5be0> because it is not registered as an observer.'
```
修改前
```objc
`- (void) kvo {
Person *person = [[Person alloc] init];
    person.name = @"hello";
    person.age = 23;
    self.subPersonKVO = person;
    [self.subPersonKVO addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"SubViewController"];
}
`- (void)dealloc {
    [self.subPersonKVO removeObserver:self forKeyPath:@"age" context:nil];
}
```
======
解决方案：context 统一
```objc
`- (void)dealloc {
    [self.subPersonKVO removeObserver:self forKeyPath:@"age" context:@"SubViewController"];
}
```
一般来说context都是`nil`,但是个人还是觉得区别开来为好
