//
//  ZXDownLoadManager.m
//  CartoonStar
//
//  Created by 尤锐 on 15/8/25.
//  Copyright (c) 2015年 尤锐. All rights reserved.
//

#import "ZXDownLoadManager.h"


@interface ZXDownLoadManager ()<NSURLConnectionDataDelegate>

@property (nonatomic,strong)NSURLConnection *connection;

@property (nonatomic,assign)long long downloadSize;

@property (nonatomic,assign)long long totalSize;

@property (nonatomic,strong)NSFileHandle *fileHandle;

@end
@implementation ZXDownLoadManager
- (void)start{
    if (_connection==nil) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url];
        [request setValue:[NSString stringWithFormat:@"bytes=%lld-",self.downloadSize] forHTTPHeaderField:@"Range"];
        self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    }
}
- (void)stop{
    [self.connection cancel];
    self.connection=nil;
}
#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if ([self.delegate respondsToSelector:@selector(fileDownloader:failWithError:)]) {
        [self.delegate fileDownloader:self failWithError:error];
    }
    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    if (self.downloadSize>=self.totalSize && self.downloadSize>0) {
        [self.connection cancel];
        self.connection = nil;
        [self.delegate fileDownloaderDidFinish:self];
    }
    
    if (self.totalSize) {
        return;
    }
    self.totalSize = response.expectedContentLength;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:self.pathString]) {
        [fileManager createFileAtPath:self.pathString contents:nil attributes:nil];
    }
    self.fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:self.pathString];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.fileHandle seekToEndOfFile];
    [self.fileHandle writeData:data];
    self.downloadSize +=data.length;
    if ([self.delegate respondsToSelector:@selector(fileDownloader:didDownloadSize:totalSize:)]) {
        [self.delegate fileDownloader:self didDownloadSize:self.downloadSize totalSize:self.totalSize];
    }
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self.fileHandle closeFile];
    if ([self.delegate respondsToSelector:@selector(fileDownloaderDidFinish:)]) {
        [self.delegate fileDownloaderDidFinish:self];
    }
}
@end
