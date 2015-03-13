//
//  ViewController.m
//  guesspicture
//
//  Created by 郎坤也 on 15/2/24.
//  Copyright (c) 2015年 郎坤也. All rights reserved.
//

#import "ViewController.h"
#import "Question.h"

/**問題空欄の幅*/
#define lkyButtonW 35.0
/**問題空欄の高さ*/
#define lkyButtonH 35.0
/**問題空欄と問題空欄の間の距離*/
#define lkyButtonMargin 10.0
/**列*/
#define lkyTotalCol  7

@interface ViewController ()
/**写真数の表示　　%d/10*/
@property (weak, nonatomic) IBOutlet UILabel *noLabel;
/**タイトル*/
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
/**点数*/
@property (weak, nonatomic) IBOutlet UIButton *scoreButton;
/**中央の写真*/
@property (weak, nonatomic) IBOutlet UIButton *iconView;
/**はん透明なカバーボタン*/
@property(nonatomic, strong) UIButton *cover;
/**答え欄の親UIView*/
@property (weak, nonatomic) IBOutlet UIView *answerView;
/**答えの選択ボタン*/
@property (weak, nonatomic) IBOutlet UIView *optionView;


/**『次の問題』のボタン*/
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

/**問題リスト*/
@property(nonatomic,strong) NSArray *questions;
/**問題配列の番号*/
@property(nonatomic,assign) int index;

@end

@implementation ViewController

/**問題配列の遅延ロード、questions.plist中に問題ががあれば、問題を読み込み*/
-(NSArray *)questions
{
    if(!_questions){
        _questions = [Question questions];
    }
    return _questions;
}
/**半透明なカバーの遅延ロード、必要の場合、表示されること*/
-(UIButton *)cover
{
    if(!_cover){
        // カバーを追加　親imageViewと同じsize
        //子imageviewを設定する時
        _cover = [[UIButton alloc] initWithFrame:(self.view.bounds)];
        _cover.backgroundColor = [UIColor blackColor];
        _cover.alpha = 0.0f;
        
        
        [self.view addSubview:_cover];
        
        //影の部分をクリックすると、縮みます
        [_cover addTarget:self action:@selector(bigImage) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cover;
}
/**アプリを起動する*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //アプリを起動する時、第一問題から
    self.index = -1;
    //問題配列(-1 + 1 = 0)
    [self nestQuestion];
}

/**一番上に状態欄の修正*/
-(UIStatusBarStyle)preferredStatusBarStyle
{
    //一番上の色を修正（白）
    return UIStatusBarStyleLightContent;
}
/**点数の修正*/
-(void)changeScore:(int)score
{
    int currentScore = [self.scoreButton.currentTitle intValue];
    currentScore += score;
    [self.scoreButton setTitle:[NSString stringWithFormat:@"%d",currentScore] forState:UIControlStateNormal];
}
/**helpボタンが押した時*/
-(IBAction)tips
{
    //1.答え欄：空になる
    for (UIButton *btn in self.answerView.subviews) {
        [self answerClick:btn];
    }
    //2.正しい答えの第一文字が表示すること
    Question *question = self.questions[self.index];
/**____________________________________________________________________________
    
 substringToIndexと substringfromIndexの違い点
    //半沢直樹 1
    //form :  沢直樹
    //to: 半
 ______________________________________________________________________________*/
    NSString *firstWord = [question.answer substringToIndex:1];
    //3.繰返子、正しい答えの第一文字が表示すること
    for (UIButton *btn in self.optionView.subviews) {
        if ([btn.currentTitle isEqualToString:firstWord]) {
            [self optionClick:btn];
            
            // 点数を減らす場合
            //string => int  intValue
            [self changeScore:-1000];
            
            break;
        }
    }
}
/**次の問題*/
- (IBAction)nestQuestion
{
    //1.問題++
    self.index++;
    
    if (self.index >= self.questions.count) {
        //終わった場合、xcodeで表示される
        NSLog(@"勝利！！");
        NSLog(@"勝利！！");
        return;
    }
    //2.問題のタイトル
    Question *question = self.questions[self.index];
    //3.基本情報
    [self setupBasicInfo:question];
    //4.答え欄を作る
    [self createAnwserButtons:question];
    //5.答えの選択ボタンを作る
    [self createOptionButtons:question];
    
}
/**基本情報*/
- (void)setupBasicInfo:(Question *)question
{
    //タイトルの制定　1/10
    self.noLabel.text = [NSString stringWithFormat:@"%d/%d",self.index + 1, self.questions.count];
    self.titleLable.text = question.title;
    [self.iconView setImage:question.image forState:UIControlStateNormal];
    //ボタンの利用を禁止する＝問題リスト-1
    self.nextButton.enabled = (self.index != self.questions.count - 1);
}
/**答えのボタンを作る*/
- (void)createAnwserButtons:(Question *)question
{
    //空欄の全てボタンを削除する
    for (UIButton *btn in self.answerView.subviews) {
        [btn removeFromSuperview];
    }
    //1＞答えの文字数 ==　空欄ボタン数
    int length = question.answer.length;
    //幅
    CGFloat answerViewW = self.answerView.bounds.size.width;
    //開始のx軸 =（UIViewの幅 - 全てボタンの幅 - (全てボタン-1)*ボタンの距離）*0.5
    CGFloat answerX =(answerViewW - length * lkyButtonW - (length - 1) * lkyButtonMargin) * 0.5;
    for (int i = 0; i < length; i++) {
        CGFloat x = answerX + i * (lkyButtonW + lkyButtonMargin);
        UIButton *answerBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, lkyButtonW, lkyButtonH)];
        
        [answerBtn setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
            [answerBtn setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateHighlighted];
        
        [answerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.answerView addSubview:answerBtn];
        
    //javaみたいのリスナーメソッド　ボタン
        [answerBtn addTarget:self action:@selector(answerClick :) forControlEvents:UIControlEventTouchUpInside];
    }
}
/**予備答えのボタンを作る*/
- (void)createOptionButtons:(Question *)question
{
    //もし予備の欄の数　!=　question.options.count、元々のボタンを削除し、新しいボタンを作る
    if (self.optionView.subviews.count != question.options.count) {
            for (UIButton *btn in self.optionView.subviews) {
            [btn removeFromSuperview];
        }
        CGFloat optionViewW = self.optionView.bounds.size.width;
        CGFloat optionX = (optionViewW - lkyTotalCol * lkyButtonW - (lkyTotalCol - 1) * lkyButtonMargin) * 0.5;
    
        for(int i = 0;i < question.options.count;i++){
            //行
            int row = i / lkyTotalCol;
            //列
            int col = i % lkyTotalCol;
        
            CGFloat x = optionX + col * (lkyButtonW + lkyButtonMargin);
            CGFloat y = row * (lkyButtonH + lkyButtonMargin);
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, lkyButtonW, lkyButtonH)];
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_option"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_option_highlighted"] forState:UIControlStateHighlighted];
        
            //文字の色設定　ios7の前は　初期化 黒
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
            [self.optionView addSubview:btn];
            
            //ボタンを実現する
            [btn addTarget:self action:@selector(optionClick :) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    //optionView繰返子，順番で設定する
    int i = 0;
    for (UIButton *btn in self.optionView.subviews) {
        //questionから　予備answerを設定する
        [btn setTitle:question.options[i++] forState:UIControlStateNormal];
        //隠しているボタン、元に戻る
        btn.hidden = NO;
    }
}
/**答えボタンをクリックする場合*/
-(void)answerClick:(UIButton *)btn
{
    //1.文字あるかどうか判断する、文字がないの場合　return する
    if(btn.currentTitle.length == 0) return;
    //2.文字がある場合
    for (UIButton *button in self.optionView.subviews) {
        if ([button.currentTitle isEqualToString:btn.currentTitle] && button.isHidden) {
            //ボタンを表示する
            button.hidden = NO;
            //答え欄　空になる
            [btn setTitle:nil forState:UIControlStateNormal];
            
            break;
        }
    }
    //答えボタンをクリックすると、答えが不足になる、全てのボタンは黒になる
    for (UIButton *btn in self.answerView.subviews) {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}
/**予備答えボタンをクリックする場合*/
-(void)optionClick:(UIButton *)btn
{
    NSLog(@"----------%@",btn.currentTitle);
    //1>把备选按钮中的文字填充到答案区
    //找答案去中第一个按钮文字为空得按钮
    for (UIButton *button in self.answerView.subviews) {
        if(button.currentTitle.length == 0){
            [button setTitle:btn.currentTitle forState:UIControlStateNormal];
            
            break;
        }
    }
    //ボタンを隠し
    btn.hidden = YES;

    //3判断胜负
    //3.1所有的答案按钮都填满,遍历所有答案区的按钮
    BOOL isFUll = YES;
    //临时答案，给现在提供判断
    NSMutableString *strM = [NSMutableString string];
    for (UIButton *btn in self.answerView.subviews) {
        if(btn.currentTitle.length == 0){
            isFUll = NO;
            
            break;
        }else{
            [strM appendString:btn.currentTitle];
        }
    }
    
    if (isFUll) {
        //ユーザーが入力した答え = 正確の答え
        Question *question = self.questions[self.index];
        
        if([question.answer isEqualToString:strM]){
            NSLog(@"正確の場合");
               //正確の場合　ー＞青文字に変換する
            for (UIButton *btn in self.answerView.subviews) {
                [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }
            //点数上がる操作
            //string =>intの場合　　intValue
            [self changeScore:+500];

            //0.5秒を持ち 　次の問題
            [self performSelector:@selector(nestQuestion) withObject:nil afterDelay:0.5];
            
        }else{
            NSLog(@"残念だ");
            //問題が間違しましたの場合　赤い文字に変換する
            for (UIButton *btn in self.answerView.subviews) {
                [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }
    }
}
/**拡大*/
- (IBAction)bigImage
{
//** alpha == 0.0の場合　ボタンが反応なし*/
    //　　　1.半透明なカバーを追加　親imageViewと同じsize
    if(self.cover.alpha == 0.0){
    //    　2。写真は一番上に移動する
    [self.view bringSubviewToFront:self.iconView];
        //    　3.アニメーションで拡大
            //1。位置を計算する
    CGFloat viewW = self.view.bounds.size.width;
    CGFloat imageW = viewW;
    CGFloat imageH = imageW;
    CGFloat imageY = (self.view.bounds.size.height - imageH) * 0.5;
        
    [UIView animateWithDuration:1.0f animations:^{
        self.cover.alpha = 0.5;
        self.iconView.frame = CGRectMake(0, imageY, imageW, imageH);
        }];

    }
    /**縮みます*/
    else{
        //写真既に拡大しました状態
        [UIView animateWithDuration:1.0 animations:^{
            self.iconView.frame = CGRectMake(85, 92, 150, 150);
            //カバー　透明になる
            self.cover.alpha = 0.0f;
            
        }completion:^(BOOL finished){
        }];
    }
}
@end
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:1.0f];
//    self.iconView.frame = CGRectMake(0, imageY, imageW, imageH);
//    [UIView commitAnimations];
//   //子imageviewを設定する時
//    UIButton *cover = [[UIButton alloc] initWithFrame:(self.view.bounds)];
//    cover.backgroundColor = [UIColor blackColor];
//    cover.alpha = 0.5f;
//  
//    
//    [self.view addSubview:cover];
//    
//    //影の部分をクリックすると、縮みます
//    [cover addTarget:self action:@selector(smallImage) forControlEvents:UIControlEventTouchUpInside];
    
  //  [self cover];
//}
/**縮みます*/
//- (void)smallImage
//{
//    [UIView animateWithDuration:1.0 animations:^{
//        self.iconView.frame = CGRectMake(85, 150, 150, 150);
//        self.cover.alpha = 0.0f;
//        
//    }completion:^(BOOL finished){
////    [self.cover removeFromSuperview];
//    }];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:1.0f];
//    //0.アニメーションをインターセプト
//    //Delegate（処理の委譲）
//    [UIView setAnimationDelegate:self];
//    //アニメーションが終わったら removerCoverの方法
//    [UIView setAnimationDidStopSelector:@selector(removeCover)];
    
    //1.アニメーションで縮みます
//    self.iconView.frame = CGRectMake(85, 150, 150, 150);
//    self.cover.alpha = 0.0f;
//    [UIView commitAnimations];
    //透明なボードを隠します
//    self.cover.alpha = 0.0;
 
//}
//-(void)removeCover
//{
//   [self.cover removeFromSuperview];
//}

