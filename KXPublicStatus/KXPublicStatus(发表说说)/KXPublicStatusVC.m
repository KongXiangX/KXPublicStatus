//
//  KXPublicStatusVC.m
//  KXPublicStatus
//
//  Created by apple on 2017/10/16.
//  Copyright © 2017年 KX. All rights reserved.
//

//！！！！！
//---------  警告  ---------

//1.内部使用了  UIAlerView 需要替换
//2.部分UIAlertView提示  可以使用SV 或者 MB替换
//3.发布 按钮 
//！！！！


#import "KXPublicStatusVC.h"
#import "KXPublicPhotoView.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


#define iOS8  ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
#define KXSCREENW_test [UIScreen mainScreen].bounds.size.width
#define KXSCREENH_test [UIScreen mainScreen].bounds.size.height



@interface KXPublicStatusVC ()<UITextViewDelegate,CLLocationManagerDelegate>

//1.发文章TextView
@property (nonatomic, strong) UITextView * textView;
@property (nonatomic, strong) UILabel * lab;  //textView占位提示文字

//2.地址
@property (nonatomic, strong) UIButton * selBtn;   //地址栏 对号按钮
@property (nonatomic, strong) UILabel * addressLab; //地址
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) KXPublicPhotoView * photoView;
@end

@implementation KXPublicStatusVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    //1.导航栏
    [self setupNav];
    
    //2.发文章
    [self setupTextView];
    
    //3.地址
    [self setupAddress];
    [self locationStart];

    //4.发表照片
    [self configCollectionView];
}
#pragma mark - 1.设置导航栏
- (void)setupNav
{
    //1.标题
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 64)];
    titleLab.font = [UIFont boldSystemFontOfSize:19];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor blackColor];
    titleLab.text = @"发表心情";
    self.navigationItem.titleView = titleLab;
    
//    //2.左侧侧按钮
//    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftBtn setImage:[UIImage imageNamed:@"navItem_back"] forState:UIControlStateNormal];
//    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    leftBtn.frame = CGRectMake(0, 0, 25,46);
//
//    UIBarButtonItem * leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    //3.右侧按钮
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"发表" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(0, 0, 40,22);
    UIBarButtonItem * rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
}


//- (void)leftBtnClick
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)rightBtnClick
{
   
    NSLog(@"gg---%ld",self.photoView.seletctedAssetArr.count);
}


#pragma mark  - 2.发文章TextView
- (void)setupTextView
{
    //1.textView
    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, KXSCREENW_test, 120)];
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:16];
    textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textView];
    self.textView = textView;
    
    //2. lab
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(5, 6, KXSCREENW_test, 20);
    lab.font = [UIFont systemFontOfSize:16];
    lab.text = @"  写点什么吧...";
    lab.textColor = [UIColor grayColor];
    [self.view addSubview:lab];
    self.lab = lab;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.lab.hidden = NO;
        self.lab.text = @"  写点什么吧...";
    }else{
        self.lab.hidden = YES;
        self.lab.text = @"";
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


#pragma mark - 3.地址
- (void)setupAddress
{
    //1.bg
    CGFloat subH = 50;
    UIImageView * imgView = [[UIImageView alloc] init];
    imgView.userInteractionEnabled = YES;
    imgView.frame = CGRectMake(0, 120+4, KXSCREENW_test, subH);
    imgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imgView];
    
    //2.定位图片
    UIImageView * img = [[UIImageView alloc] init];
    img.frame = CGRectMake(10, 15, 16, 20);
    [img setImage:[UIImage imageNamed:@"EMOrderVC_location"]];
    [imgView addSubview:img];
    

    //3.地址lab
    UILabel * addressLab = [[UILabel alloc] init];
    addressLab.text = @"";
    addressLab.userInteractionEnabled = YES;
    addressLab.numberOfLines = 2;
    addressLab.font = [UIFont systemFontOfSize:15];
    addressLab.frame = CGRectMake(30,5, KXSCREENW_test-80, 40);
    [imgView addSubview:addressLab];
    self.addressLab = addressLab;
    
    //4.对号按钮
    UIButton * selBtn = [[UIButton alloc] init];
    selBtn.tag = 155;
    [selBtn setImage:[UIImage imageNamed:@"patientVC_public_yes"] forState:UIControlStateNormal];
    [selBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    selBtn.frame = CGRectMake(KXSCREENW_test-50, 0, 50, subH);
    [imgView addSubview:selBtn];
    self.selBtn = selBtn;
}


#pragma mark -- 3.1 定位
//开始定位
-(void)locationStart{
    //判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        //        [SVProgressHUD showWithStatus:@"定位中..."];
        self.locationManager = [[CLLocationManager alloc] init] ;
        self.locationManager.delegate = self;
        //设置定位精度
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;//每隔多少米定位一次（这里的设置为每隔百米)
        if (iOS8) {
            //使用应用程序期间允许访问位置数据
            [self.locationManager requestWhenInUseAuthorization];
        }
        // 开始定位
        [self.locationManager startUpdatingLocation];
    }else {
        //提示用户无法进行定位操作
//        [SVProgressHUD showWithStatus:@"您尚未开启定位权限\n请到手机<设置>--><好赚帮>--><位置>-->中设置"];
        NSLog(@"您尚未开启定位权限\n请到手机<设置>--><xxx>--><位置>-->中设置");
        
    }
}
#pragma mark -- 3.2 CoreLocation Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    //1.停止定位
    [self.locationManager stopUpdatingLocation];
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
//    self.location = currentLocation;
    //获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         
         if (array.count >0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //获取城市
             NSString *currCity = placemark.locality;
             if (!currCity) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 currCity = placemark.administrativeArea;
             }
             self.addressLab.text = currCity;
             
             //1.区 是否存在
             if (placemark.subLocality != nil  ) {
                 self.addressLab.text = [NSString stringWithFormat:@"%@ %@",placemark.locality,placemark.subLocality];
             }
             
             //2.街道是否存在
             if (placemark.thoroughfare != nil  ) {
                 self.addressLab.text = [NSString stringWithFormat:@"%@ %@ %@",placemark.locality,placemark.subLocality,placemark.thoroughfare];
             }
             
              //3.具体地址是否存在
              if (placemark.name != nil ) {
                   self.addressLab.text = [NSString stringWithFormat:@"%@ %@ %@ %@",placemark.locality,placemark.subLocality,placemark.thoroughfare,placemark.name];
              }
             
         } else if (error ==nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }else if (error !=nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
         
     }];
   ;
    
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    if (error.code ==kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
//        [SVProgressHUD showErrorWithStatus:@"定位失败！"];
//        [self performSelector:@selector(progressDismiss) withObject:nil afterDelay:1.5];
        NSLog(@"定位失败");
        
    }
    
}

- (void)selectBtnClick
{
    if (self.selBtn.tag == 155) {
        [self.selBtn setImage:[UIImage imageNamed:@"patientVC_public_no"] forState:UIControlStateNormal];
        
        self.selBtn.tag = 156;
    }else{
        [self.selBtn setImage:[UIImage imageNamed:@"patientVC_public_yes"] forState:UIControlStateNormal];
        
        self.selBtn.tag = 155;
    }
}

#pragma mark - 4.UICollectionView
- (void)configCollectionView
{
    KXPublicPhotoView * photoView = [[KXPublicPhotoView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.textView.frame) + 65, KXSCREENW_test, 200)];
    [self.view addSubview:photoView];
    self.photoView = photoView;
    
}


//如果 不封装 有关 展示选中图片的代码 如下。
//KXPublicPhotoView 为封装视图


/*
//#pragma mark - 5.初始化 CollectionView
//- (void)configCollectionView {
//   
//    //1. 照片 数据
//    _selectedPhotos = [NSMutableArray array];
//    _selectedAssets = [NSMutableArray array];
//    
//    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
//    //1.layout
//    _layout = [[LxGridViewFlowLayout alloc] init];
//    _margin = 4;
//    _itemWH = (self.view.tz_width - 2 * _margin - 4) / 3 - _margin;
//    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
//    _layout.minimumInteritemSpacing = _margin;
//    _layout.minimumLineSpacing = _margin;
//    
//    //2.UICollectionView 初始化
//    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
//    CGFloat rgb = 244 / 255.0;
//    _collectionView.alwaysBounceVertical = YES;
//    _collectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
//    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
//    _collectionView.dataSource = self;
//    _collectionView.delegate = self;
//    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
//    [self.view addSubview:_collectionView];
//    [_collectionView registerClass:[KXPublicStatusCell class] forCellWithReuseIdentifier:CollectionCellID];
//    
//    [self.collectionView setCollectionViewLayout:_layout];
//    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.textView.frame) + 125 , self.view.tz_width, _itemWH + 10);
//}
//
//
//#pragma mark -- 5.1 UICollectionViewDelegate
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return _selectedPhotos.count + 1;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    KXPublicStatusCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionCellID forIndexPath:indexPath];
//    cell.videoImageView.hidden = YES;
//    
//    //1.只用 添加按钮
//    if (indexPath.row == _selectedPhotos.count) {
//        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
//        cell.deleteBtn.hidden = YES;
//        cell.gifLable.hidden = YES;
//    } else {
//        cell.imageView.image = _selectedPhotos[indexPath.row];
//        cell.asset = _selectedAssets[indexPath.row];
//        cell.deleteBtn.hidden = NO;
//    }
//
//    cell.deleteBtn.tag = indexPath.row;
//    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
//    return cell;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    //1.根据 个数 判定是否 选择为 添加图片按钮
//    if (indexPath.row == _selectedPhotos.count) {
//
//        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"相册" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//        //1.拍照
//        //UIAlertActionStyleDestructive有着重的意思，使用这个常量标题变为红色
//        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//            [self pushTZImagePickerController];
//            
//        }];
//        //2.相册
//        UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//            [self takePhoto];
//        }];
//        //3.取消
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//        
//        [alertVC addAction:cancelAction];
//        [alertVC addAction:firstAction];
//        [alertVC addAction:secondAction];
//        [self presentViewController:alertVC animated:YES completion:nil];
//        
//    } else {
//        //2.预览照片或者视频
//        id asset = _selectedAssets[indexPath.row];
//        BOOL isVideo = NO;
//        if ([asset isKindOfClass:[PHAsset class]]) {
//            PHAsset *phAsset = asset;
//            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
//        } else if ([asset isKindOfClass:[ALAsset class]]) {
//            ALAsset *alAsset = asset;
//            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
//        }
//        
//        //2.1 gif
//        if ([[asset valueForKey:@"filename"] tz_containsString:@"GIF"] ) {
//            TZGifPhotoPreviewController *vc = [[TZGifPhotoPreviewController alloc] init];
//            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypePhotoGif timeLength:@""];
//            vc.model = model;
//            [self presentViewController:vc animated:YES completion:nil];
//        } else if (isVideo) {
//            //2.2预览视频
//            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
//            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
//            vc.model = model;
//            [self presentViewController:vc animated:YES completion:nil];
//        } else {
//            // 2.3预览照片
//            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
//            imagePickerVc.maxImagesCount = 9;
//            imagePickerVc.allowPickingGif = YES;
//            imagePickerVc.allowPickingOriginalPhoto = YES;
//            imagePickerVc.allowPickingMultipleVideo = NO;
//            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
//            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//                _selectedPhotos = [NSMutableArray arrayWithArray:photos];
//                _selectedAssets = [NSMutableArray arrayWithArray:assets];
//                _isSelectOriginalPhoto = isSelectOriginalPhoto;
//                [_collectionView reloadData];
//                _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
//            }];
//            [self presentViewController:imagePickerVc animated:YES completion:nil];
//        }
//    }
//}
//
//#pragma mark --5.2  LxGridViewDataSource
///// 以下三个方法为长按排序相关代码
//- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
//    return indexPath.item < _selectedPhotos.count;
//}
//
//- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
////   destinationIndexPath  移动到位置
//    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
//}
//
//- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
//    //1.替换 原来 位置的图片
//    //1.1  img数据 中的数据图片
//    UIImage *image = _selectedPhotos[sourceIndexPath.item];
//    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
//    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
//    
//    //1.2  asset 中的数据图片
//    id asset = _selectedAssets[sourceIndexPath.item];
//    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
//    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
//    
//    //2.刷新
//    [_collectionView reloadData];
//}
//
//#pragma mark -- 5.3 初始化 TZImagePickerController
//- (void)pushTZImagePickerController {
//  
//    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
//    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
//    // 1.设置目前已经选中的图片数组
//    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
//    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
//    
//    // 2. Set the appearance
//    // 2. 在这里设置imagePickerVc的外观
//    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
//    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
//    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
//    // imagePickerVc.navigationBar.translucent = NO;
//    
//    // 3. Set allow picking video & photo & originalPhoto or not
//    // 3. 设置是否可以选择视频/图片/原图
//    imagePickerVc.allowPickingVideo = NO;
//    imagePickerVc.allowPickingImage = YES;
//    imagePickerVc.allowPickingOriginalPhoto = YES;
//    imagePickerVc.allowPickingGif = NO;
//    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
//    
//    // 4. 照片排列按修改时间升序
//    imagePickerVc.sortAscendingByModificationDate = YES;
//    /// 5. 单选模式,maxImagesCount为1时才生效
//    imagePickerVc.showSelectBtn = NO;
//    imagePickerVc.allowCrop = NO;
//    imagePickerVc.needCircleCrop = NO;
//    imagePickerVc.isStatusBarDefault = NO;
//
//    
//    [self presentViewController:imagePickerVc animated:YES completion:nil];
//}
//
//
//
//#pragma mark -- 5.4  拍照 - UIImagePickerController
//- (void)takePhoto {
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
//        // 无相机权限 做一个友好的提示
//        if (iOS8Later) {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
//            [alert show];
//        } else {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
//        }
//    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
//        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
//        if (iOS7Later) {
//            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
//                if (granted) {
//                    dispatch_sync(dispatch_get_main_queue(), ^{
//                        [self takePhoto];
//                    });
//                }
//            }];
//        } else {
//            [self takePhoto];
//        }
//        // 拍照之前还需要检查相册权限
//    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
//        if (iOS8Later) {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
//            [alert show];
//        } else {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
//        }
//    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
//        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
//            [self takePhoto];
//        }];
//    } else {
//        [self pushImagePickerController];
//    }
//}
//
//// 调用相机
//- (void)pushImagePickerController {
//    // 提前定位
//    __weak typeof(self) weakSelf = self;
//    [[TZLocationManager manager] startLocationWithSuccessBlock:^(CLLocation *location, CLLocation *oldLocation) {
//        weakSelf.location = location;
//    } failureBlock:^(NSError *error) {
//        weakSelf.location = nil;
//    }];
//    
//    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
//    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
//        self.imagePickerVc.sourceType = sourceType;
//        if(iOS8Later) {
//            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//        }
//        [self presentViewController:_imagePickerVc animated:YES completion:nil];
//    } else {
//        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
//    }
//}
//
//- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
//    if ([type isEqualToString:@"public.image"]) {
//        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
//        tzImagePickerVc.sortAscendingByModificationDate = YES;
//        [tzImagePickerVc showProgressHUD];
//        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//        
////         save photo and get asset / 保存图片，获取到asset
//        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(NSError *error){
//            if (error) {
//                [tzImagePickerVc hideProgressHUD];
//                NSLog(@"图片保存失败 %@",error);
//            } else {
//                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
//                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
//                        [tzImagePickerVc hideProgressHUD];
//                        TZAssetModel *assetModel = [models firstObject];
//                        if (tzImagePickerVc.sortAscendingByModificationDate) {
//                            assetModel = [models lastObject];
//                        }
//                        else {
//                            [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
//                        }
//                    }];
//                }];
//            }
//        }];
//    }
//}
//
//- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
//    [_selectedAssets addObject:asset];
//    [_selectedPhotos addObject:image];
//    [_collectionView reloadData];
//    
//    if ([asset isKindOfClass:[PHAsset class]]) {
//        PHAsset *phAsset = asset;
//        NSLog(@"location:%@",phAsset.location);
//    }
//}
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    if ([picker isKindOfClass:[UIImagePickerController class]]) {
//        [picker dismissViewControllerAnimated:YES completion:nil];
//    }
//}
//#pragma mark -- 5.5 TZImagePickerControllerDelegate
//// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
//// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
//// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
//// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
//- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
//    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
//    _selectedAssets = [NSMutableArray arrayWithArray:assets];
//    _isSelectOriginalPhoto = isSelectOriginalPhoto;
//    [_collectionView reloadData];
//    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
//    
//    // 1.打印图片名字
//    [self printAssetsName:assets];
//    // 2.图片位置信息
//    if (iOS8Later) {
//        for (PHAsset *phAsset in assets) {
//            NSLog(@"location:%@",phAsset.location);
//        }
//    }
//}
//
//// If user picking a gif image, this callback will be called.
//// 如果用户选择了一个gif图片，下面的handle会被执行
//- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset {
//    _selectedPhotos = [NSMutableArray arrayWithArray:@[animatedImage]];
//    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
//    [_collectionView reloadData];
//}
//
//
//#pragma mark - Click Event
//- (void)deleteBtnClik:(UIButton *)sender {
//    [_selectedPhotos removeObjectAtIndex:sender.tag];
//    [_selectedAssets removeObjectAtIndex:sender.tag];
//    
//    [_collectionView performBatchUpdates:^{
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
//        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
//    } completion:^(BOOL finished) {
//        [_collectionView reloadData];
//    }];
//}
//
//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.view endEditing:YES];
//}
//
//#pragma mark - Private
//
///// 打印图片名字
//- (void)printAssetsName:(NSArray *)assets {
//    NSString *fileName;
//    for (id asset in assets) {
//        if ([asset isKindOfClass:[PHAsset class]]) {
//            PHAsset *phAsset = (PHAsset *)asset;
//            fileName = [phAsset valueForKey:@"filename"];
//        } else if ([asset isKindOfClass:[ALAsset class]]) {
//            ALAsset *alAsset = (ALAsset *)asset;
//            fileName = alAsset.defaultRepresentation.filename;;
//        }
//        // NSLog(@"图片名字:%@",fileName);
//    }
//}
//
//
//#pragma mark - UIActionSheetDelegate
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 0) { // take photo / 去拍照
//        [self takePhoto];
//    } else if (buttonIndex == 1) {
//        [self pushTZImagePickerController];
//    }
//}
//
//#pragma mark - UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
//        if (iOS8Later) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//        }
//    }
//}
//
//#pragma mark - 懒加载
////手动忽略 编译器 的一些警告
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//- (UIImagePickerController *)imagePickerVc {
//    if (_imagePickerVc == nil) {
//        _imagePickerVc = [[UIImagePickerController alloc] init];
//        _imagePickerVc.delegate = self;
//        // set appearance / 改变相册选择页的导航栏外观
//        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
//        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
//        UIBarButtonItem *tzBarItem, *BarItem;
//        if (iOS9Later) {
//            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
//            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
//        } else {
//            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
//            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
//        }
//        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
//        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
//        
//    }
//    return _imagePickerVc;
//}
//


#pragma clang diagnostic pop
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/


@end
