# XTYQRCode
仿微信二维码扫描界面

调用系统识别二维码

该代码主要是模仿微信扫描界面

XTYScranView
使用方法:
XTYScanView * _xtyScranView = [[XTYScanView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _xtyScranView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_xtyScranView];
扫描完成后调用
 [_xtyScranView stopTimer];
 停止扫描条的上下移动
    
