//
//  WLViewController.m
//  WLPickerView
//
//  Created by nomeqc@gmail.com on 06/03/2018.
//  Copyright (c) 2018 nomeqc@gmail.com. All rights reserved.
//

#import "WLViewController.h"
#import "WLPickerView.h"

@interface WLViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation WLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textField.placeholder = @"点击选择省、市、区";
    self.textField.layer.cornerRadius = 0;
    NSArray<NSDictionary *> *data = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"]];
    NSMutableArray<WLPickerViewNode *> *nodes = [NSMutableArray array];
    [data enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WLPickerViewNode *node = [[WLPickerViewNode alloc] init];
        node.nodeName = obj[@"state"];
        node.childNodes = ({
            NSMutableArray<WLPickerViewNode *> *nodes = [NSMutableArray array];
            [obj[@"cities"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                WLPickerViewNode *node = [[WLPickerViewNode alloc] init];
                node.nodeName = obj[@"city"];
                node.childNodes = ({
                    NSMutableArray<WLPickerViewNode *> *nodes = [NSMutableArray array];
                    [obj[@"areas"] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        WLPickerViewNode *node = [[WLPickerViewNode alloc] init];
                        node.nodeName = obj;
                        [nodes addObject:node];
                    }];
                    nodes.count > 0? [nodes copy] : nil;
                });
                [nodes addObject:node];
            }];
            nodes.count > 0? [nodes copy] : nil;
        });
        [nodes addObject:node];
    }];
    
    
    WLPickerView *pickerView = [[WLPickerView alloc] initWithNodes:nodes];
    __weak typeof(self) weakSelf = self;
    [pickerView setCancelBarButtonTapHandler:^(WLPickerView *pickerView){
        typeof(weakSelf) self = weakSelf;
        [self.textField endEditing:YES];
    }];
    [pickerView setDoneBarButtonTapHandler:^(WLPickerView *pickerView, NSArray<NSNumber *> *selectedRowIndexes, NSString *selectionDescription) {
        typeof(weakSelf) self = weakSelf;
        [self.textField endEditing:YES];
        self.textField.text = selectionDescription;
        NSLog(@"选中的行索引%@",selectedRowIndexes);
        NSLog(@"选中结果:%@",selectionDescription);
    }];

    pickerView.backgroundColor = [UIColor whiteColor];
    //显示三列
    pickerView.columnCount = 3;
    
    ///设置选中第0列选中索引为8,第1列选中索引为1,第2列选中索引为4
    [pickerView updateSelectionWithRowIndexes:@[@(8),
                                                @(1),
                                                @(4)]];
    self.textField.inputView = pickerView;
}

@end
