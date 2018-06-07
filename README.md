# ShanNianKaPian

新的项目

闪念卡片

大项目

2018-5-31 更新动画
2018 -6-3修改语音识别

2018 -6-4
https://github.com/rshinich/iCloudDemo

iCloudDemo

2018-6-6 添加另一个项目

https://blog.csdn.net/BAOU1371/article/details/51993581

https://www.jianshu.com/p/91f27205203c


NSString *pcmData = [[NSString alloc] initWithData:model.pcmData encoding:NSUTF8StringEncoding];



================ 简易工程 ==================


[self initOtherUI];
self.navTitleLabel.text = @"设置数字密码";
[self.backBtn setImage:[UIImage imageNamed:@"返回箭头2"] forState:UIControlStateNormal];



- (void)backAction{
[self.navigationController popViewControllerAnimated:YES];
}


[self.view insertSubview:self.titleView aboveSubview:self.tableView];



sw.tintColor = [UIColor blackColor];
sw.onTintColor = [UIColor blackColor];



[self.tableView registerNib:[UINib nibWithNibName:@"MainContentCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
self.tableView.backgroundColor = [UIColor whiteColor];
self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
return 62;
}

