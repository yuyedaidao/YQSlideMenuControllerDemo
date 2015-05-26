# YQSlideMenuControllerDemo
仿QQ左边菜单侧滑栏

###先上图（gif图片较大，请耐心）
![gif](https://github.com/yuyedaidao/YQSlideMenuControllerDemo/blob/master/slideMenu.gif)

###使用

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
    
**还有许多功能没有完善，有需求的客观烦请告知**
      


