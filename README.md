## 発生した事象（エラー）

ディズニーのサイトに対してスクレイピングが行えない。

---

## 期待した結果

このアプリは、自動的にディズニーのレストランのキャンセル待ちを行うことを目的として作成したアプリである。  
アプリの主な機能は次の3つに分かれる：

1. **ユーザ登録機能**  
　フォーム入力、データ保存、バリデーション  
2. **キャンセル検知機能**  
　Seleniumによる操作、Sidekiqによる定期実行  
3. **メール通知機能**  
　登録確認メール、キャンセル通知メール

---

## 再現手順

1. リポジトリのクローンを作成  
2. 依存関係をインストール  
   ```bash
   bundle install
   ```
3. データベースの作成と初期データ投入  
   ```bash
   rails db:migrate  
   rails db:seed
   ```
4. `.env` ファイルを作成し、以下を設定  
   ```bash
   GMAIL_USERNAME=Gmailアドレス  
   GMAIL_PASSWORD=アプリパスワード
   ```
5. Redis（ver 6 以上）をインストール・起動  
   ```bash
   redis-server
   ```
6. Sidekiq の起動  
   ```bash
   bundle exec sidekiq
   ```
7. サーバーを起動

---

## 実行環境

| 項目 | バージョン |
|------|-------------|
| Rails | ~> 7.2.1 |
| Ruby | ~> 3.3.5 |
| SQLite | 使用 |
| Redis | ver 6 以上 |

---

## 補足資料

各機能に対してテストを実施した結果は以下の通り。

###  ユーザ登録機能
- エラーなし

###  キャンセル検知機能
- Selenium の起動は確認できたが、白い画面のままスタック。  
- 他のサイトでの動作確認では問題なし。  
- 原因として、ディズニー公式サイトの bot 対策によるブロックが考えられる。  
- Sidekiq による定期実行は問題なし。

### メール通知機能
- 登録確認メールは正常に送信されることを確認。  
- キャンセル通知メールは、検知機能のエラーにより未確認。


## スクリーンショット
<img width="681" height="426" alt="image" src="https://github.com/user-attachments/assets/9a9c3710-c8db-42d8-8c93-94de1dc1409d" />
↑登録フォーム

<img width="784" height="528" alt="image" src="https://github.com/user-attachments/assets/3787df71-afd8-4663-9e55-f8d5e1afb1a4" />
↑予約完了画面

<img width="831" height="465" alt="image" src="https://github.com/user-attachments/assets/b7433a77-56fe-405a-b535-88a8a602a02a" />
↑sidekiq 画面。チェック機能が完了せず、再実行に２つタスクがたまっている。 

<img width="308" height="642" alt="image" src="https://github.com/user-attachments/assets/286e3939-6e91-4606-826a-855d5e74b102" />
↑予約確認メール受け取り

<img width="482" height="508" alt="image" src="https://github.com/user-attachments/assets/89849ddd-6e0f-49ba-b29d-61aa255277e9" />
↑他サイトへのseleniumでのアクセス成功画面

<img width="538" height="303" alt="image" src="https://github.com/user-attachments/assets/1139ac52-c457-4fc3-85b9-4cd0b83f886a" />
↑ディズニーサイトトップへのアクセス画面エラーが発生し、白い画面のままスタック

