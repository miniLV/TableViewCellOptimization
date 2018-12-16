## TableViewCell性能优化之 - 懒加载机制

#### ScrollView滚动时-代理方法执行流程

![ScrollView滚动时-代理方法执行流程](https://github.com/miniLV/github_images_miniLV/blob/master/2018Year/TableViewCellOptimization/%E6%B5%81%E7%A8%8B%E5%9B%BE.png)

以最常见的cell加载webImage为例:

#### 直接加载全部的图片
```
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    DemoModel *model = self.datas[indexPath.row];
    cell.textLabel.text = model.text;
   
    [cell.imageView setYy_imageURL:[NSURL URLWithString:model.user.avatar_large]];
    
    return cell;
}
```

#### 滚动过程中不加载

```
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    DemoModel *model = self.datas[indexPath.row];
    cell.textLabel.text = model.text;
   
    //判断该图片是否已下载
    if (model.iconImage) {
        cell.imageView.image = model.iconImage;
    }else{
        cell.imageView.image = [UIImage imageNamed:@"placeholder"];

        //拖动的时候不显示
        if (!tableView.dragging && !tableView.decelerating) {
        
            //下载图片数据 - 并缓存
            [self p_loadImgeWithIndexPath:indexPath];
        }
    }
    return cell;
}
```

#### 滚动结束后加载cell图片
```
//手一直在拖拽控件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    NSLog(@"scrollView - DidEndDecelerating");
    [self p_loadImage];
}

//手放开了-使用惯性-产生的动画效果
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    if(!decelerate){
        NSLog(@"scrollView - EndDragging - 无decelerate");
        //直接停止-无动画
        [self p_loadImage];
    }
}
```

#### 获取滚动结束后，界面内的所有cell
```
- (void)p_loadImage{
    
    //拿到界面内-所有的cell的indexpath
    NSArray *visableCellIndexPaths = self.tableView.indexPathsForVisibleRows;
    
    for (NSIndexPath *indexPath in visableCellIndexPaths) {
        
        DemoModel *model = self.datas[indexPath.row];
        
        if (model.iconImage) {
            continue;
        }
        
        [self p_loadImgeWithIndexPath:indexPath];
    }
}
```

<br>

#### 最终实现的懒加载效果

![懒加载效果](https://github.com/miniLV/github_images_miniLV/blob/master/2018Year/TableViewCellOptimization/demo.gif)

[详情介绍](https://www.jianshu.com/p/04457377b48d)
