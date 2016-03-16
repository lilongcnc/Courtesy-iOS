//
//  CourtesyCardDataModel.h
//  Courtesy
//
//  Created by Zheng on 3/10/16.
//  Copyright © 2016 82Flex. All rights reserved.
//

#import "JSONModel.h"
#import "CourtesyCardAttachmentModel.h"
#import "CourtesyCardStyleManager.h"

@interface CourtesyCardDataModel : JSONModel
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSArray<NSDictionary *> *attachments;
@property (nonatomic, assign) CourtesyCardStyleID styleID;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CourtesyFontType fontType;
@property (nonatomic, assign) NSTextAlignment alignmentType;
@property (nonatomic, strong) CourtesyCardStyleModel<Ignore> *style;
@property (nonatomic, assign) BOOL shouldAutoPlayAudio;

@end
