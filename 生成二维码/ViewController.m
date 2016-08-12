//
//  ViewController.m
//  生成二维码
//
//  Created by zhang on 16/8/12.
//  Copyright © 2016年 zhang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
 
    //1 创建滤镜对象
    CIFilter * fiter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //2设置相关属性
    [fiter setDefaults];
    
    //3设置输入数据
    NSString * inputData = @"https://www.baidu.com";
    NSData * data = [inputData dataUsingEncoding:NSUTF8StringEncoding];
    [fiter setValue:data forKeyPath:@"inputMessage"];
    
    //4获取输出结果
    CIImage * outputImage = [fiter outputImage];
    
   // self.myImageView.image = [UIImage imageWithCIImage:outputImage];
    
    self.myImageView.image=[self createNoInterpolatedUIImageFormCIImage:outputImage withSize:200];
}
/**
 *  生成高清的Image
 *
 *  @param image 传入的图片
 *  @param size  图片的大小
 *
 *  @return image
 */
-(UIImage * )createNoInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat )size{

    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    //创建bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs=CGColorSpaceCreateDeviceGray();
    CGContextRef bitmaptef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext * context = [CIContext contextWithOptions:nil];
    CGImageRef bitmaoImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmaptef, kCGInterpolationNone);
    CGContextScaleCTM(bitmaptef, scale, scale);
    CGContextDrawImage(bitmaptef, extent, bitmaoImage);
    
    //保存bitmao图片
    CGImageRef scaledImge = CGBitmapContextCreateImage(bitmaptef);
    CGContextRelease(bitmaptef);
    CGImageRelease(bitmaoImage);
    return [UIImage imageWithCGImage:scaledImge];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
