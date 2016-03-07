//
//  CourtesyVideoFrameView.m
//  Courtesy
//
//  Created by Zheng on 3/6/16.
//  Copyright © 2016 82Flex. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVAsset.h>
#import <AVKit/AVKit.h>
#import "CourtesyVideoFrameView.h"

@implementation CourtesyVideoFrameView

- (void)setVideoURL:(NSURL *)videoURL {
    _videoURL = videoURL;
    UIImage *previewImage = [self thumbnailImageForVideo:videoURL atTime:0.0];
    [self setCenterImage:previewImage];
}

- (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL
                            atTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:self.videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, asset.duration.timescale) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef || thumbnailImageGenerationError) {
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
        return nil;
    }
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    if (!thumbnailImage) {
        return nil;
    }
    
    CGRect targetRect = CGRectMake(0, 0, thumbnailImage.size.width, thumbnailImage.size.width * (9.0 / 16));
    CGImageRelease(thumbnailImageRef);
    return [thumbnailImage imageByCropToRect:targetRect];
}

- (NSString *)labelHolder {
    return @"视频描述";
}

- (NSArray *)optionButtons {
    return @[[self deleteBtn],
             [self editBtn],
             [self playBtn]];
}

- (UIImageView *)playBtn {
    if (!_playBtn) {
        _playBtn = [[UIImageView alloc] initWithFrame:CGRectMake(kImageFrameBtnBorderWidth + (kImageFrameBtnWidth + kImageFrameBtnInterval) * 2, kImageFrameBtnBorderWidth, kImageFrameBtnWidth, kImageFrameBtnWidth)];
        _playBtn.backgroundColor = [UIColor clearColor];
        _playBtn.image = [UIImage imageNamed:@"52-unbrella-play"];
        _playBtn.alpha = 0;
        _playBtn.hidden = YES;
        _playBtn.userInteractionEnabled = YES;
        __weak typeof(self) _self = self;
        UITapGestureRecognizer *playGesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(UITapGestureRecognizer *g) {
            __strong typeof(_self) self = _self;
            [self playVideo];
        }];
        [_playBtn addGestureRecognizer:playGesture];
    }
    return _playBtn;
}

- (void)playVideo {
    AVPlayer *player = [[AVPlayer alloc] initWithURL:_videoURL];
    AVPlayerViewController *movie = [[AVPlayerViewController alloc] init];
    if (!player || !movie) {
        return;
    }
    [movie setPlayer:player];
    if (![[self delegate] isKindOfClass:[UIViewController class]]) {
        return;
    }
    UIViewController *superViewController = (UIViewController *)self.delegate;
    [superViewController presentViewController:movie animated:YES completion:^{
        [player play];
    }];
}

@end
