## TableViewCell性能优化之 - 懒加载机制

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

[详情介绍](https://www.jianshu.com/p/04457377b48d)
