# YQSlideMenuControllerDemo
仿QQ左边菜单侧滑栏

###先上图（已换小图）
![gif](https://github.com/yuyedaidao/YQSlideMenuControllerDemo/blob/master/menu.gif)

###使用

####导入
    pod 'YQSlideMenController'

####初始化
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    MainViewController *contentViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:contentViewController];
    LeftMenuController  *leftMenuViewController = [[LeftMenuController alloc] init];
    YQSlideMenuController *sideMenuController = [[YQSlideMenuController alloc] initWithContentViewController:navigationController
                                                                    leftMenuViewController:leftMenuViewController];
    sideMenuController.backgroundImage = [UIImage imageNamed:@"slide_bg"];
  
    self.window.rootViewController = sideMenuController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
####菜单中显示新视图
    [self.slideMenuController showViewController:viewController];
    
**还有许多功能没有完善，有需求的客官烦请告知**
      


