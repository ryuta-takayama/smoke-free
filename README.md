# アプリケーション名
 smoke free

# アプリケーション概要
## 概要
本アプリケーションは、喫煙者のための長期禁煙支援アプリである。

## 機能
1 ユーザ管理機能<br>
2 禁煙本数・節約額・経過時間のリアルタイム／累計可視化<br>
3 日々のアクションプラン作成とタイムライン共有（いいね・コメントも可能）<br>
4 禁煙を手段とした目標逆算設定<br>
5 喫煙後、特定の条件（24時間禁煙）で禁煙継続を再開できる設定<br>

## 特徴
ユーザーごとに情報を管理することはもちろんのこと<br>
従来の禁煙本数・節約額・経過時間のリアルタイムの表示に加え<br>

①禁煙の累計を可視化<br>
②日々の禁煙達成のための行動指針作成および各ユーザー共有<br>
③特定の条件下で禁煙継続の再開可能（リセットされない）<br>

これらにより、禁煙初挑戦者はもちろんのこと<br>
再挑戦者の方にも長期禁煙の継続支援ができるように設計した。

# URL
https://smoke-free.onrender.com

# テスト用アカウント
## basic認証
・basic認証ID: smoke<br>
・basic認証パスワード: free81536<br>

## アカウント①
・メールアドレス:test1@test.com<br>
・パスワード：test1234<br>
・ニックネーム：test1<br>
・1日の喫煙本数：40本<br>
・タバコ1箱の値段：580円<br>
・一箱の本数：20本
## アカウント②
・メールアドレス:test2@test.com<br>
・パスワード：test1234<br>
・ニックネーム：test2<br>
・1日の喫煙本数：10本<br>
・タバコ1箱の値段：580円<br>
・一箱の本数：20本
# 利用方法
## アカウント登録
1 ニックネーム、メールアドレス、パスワード、禁煙開始日（日付選択）、1日の喫煙本数、喫煙歴、年齢、禁煙理由を登録<br>
2 任意で、目標商品・やりたいこと、目標金額を設定可能
## 現在の禁煙成果のリアルタイム表示
上記のアカウント登録にて必須事項記載後、ダッシュボードに遷移し現在地点での禁煙成果のリアルタイム表示を確認可能

## 日々のアクションプラン作成
禁煙するための日々の行動指針を気軽に作成可能<br>
作成後、ダッシュボードおよびタイムラインに自動投稿される

## タイムライン機能（いいね・コメント・削除・編集）
各利用ユーザーのアクションプラン投稿の閲覧および<br>
自身の投稿内容の編集・削除が可能<br>
さらに、各投稿にいいね・コメントができる機能付き<br>
※現在は、削除のみ可能

# アプリケーションを作成した背景
近年は世界で健康意識が高まる中、日本では禁煙希望者が約2割にとどまり、加熱式タバコの“低害”認知や価格の痛みの弱さ、職場コミュニケーションなどにより「やめる必要性」が薄れ、挫折経験の蓄積で自己効力感も下がっている。<br>
これらの課題を解決するために、開発者自身の長期禁煙成功の経験も活かしながら
禁煙初挑戦者・再挑戦者を対象に、<br>
①紙巻・加熱式を含む完全禁煙の継続<br>
②ラプス後の早期リカバリーを支援するアプリ<br>
を開発することにした。
※ラプス（Lapse）とは<br>
一時的な喫煙意欲が再発する現象であり、完全再喫煙（Relapse）に至る前段階である。<br>よくあることが、ラプス後に「自分はダメだ」という【Abstinence Violation Effect（禁欲違反効果）】が生じると、自己非難→投げやり→全面再喫煙に進みやすい。

# 要件定義書

## users
| Column | Type | Options |
|---|---|---|
| email | string | null: false, unique: true, index: true |
| encrypted_password | string | null: false |
| nickname | string | null: false |
| age | integer | null: false |
| reason_to_quit | integer | null: false |

**Associations**  
- has_one :smoking_setting, dependent: :destroy  
- has_many :abstinence_sessions, dependent: :destroy  
- has_one :goal, -> { where(status: 0) }, class_name: "Goal"  
- has_many :restart_challenges, dependent: :destroy  
- has_many :posts, dependent: :destroy  
- has_many :comments, dependent: :destroy  
- has_many :likes, dependent: :destroy  
- has_many :liked_posts, through: :likes, source: :post  
---

## smoking_settings
| Column | Type | Options |
|---|---|---|
| user | references | null: false, unique: true, index: true, foreign_key: true |
| daily_cigarettes | integer | null: false |
| pack_price_jpy | integer | null: false |
| cigs_per_pack | integer | null: false |
| quit_start_datetime | datetime | null: false|

**Associations**  
- belongs_to :user  

---

## abstinence_sessions
| Column | Type | Options |
|---|---|---|
| user | references | null: false, index: true, foreign_key: true |
| started_at | datetime | null: false |
| ended_at | datetime | null: true |

**Indexes**  
- index: [:user, :started_at]

**Associations**  
- belongs_to :user  

---

## goals
| Column | Type | Options |
|---|---|---|
| user | references | null: false, index: true, foreign_key: true |
| target_item | string | null: false |
| target_amount_jpy | integer | null: false |
| started_on | date | null: false |
| status | integer | null: false, default: 0, comment: "0=active,1=achieved" |
| achieved_at | datetime | null: true |

**Associations**  
- belongs_to :user  

---

## restart_challenges
| Column | Type | Options |
|---|---|---|
| user | references | null: false, index: true, foreign_key: true |
| started_at | datetime | null: false |
| expires_at | datetime | null: false |
| status | integer | null: false, default: 0, comment: "0=pending,1=success,2=failed,3=cancelled" |
| completed_at | datetime | null: true |

**Indexes**  
- index: [:user, :started_at]

**Associations**  
- belongs_to :user  

---

## quotes
| Column | Type | Options |
|---|---|---|
| text | text | null: false |
| author | string | null: true |
| lang | string | null: false, default: "ja" |

---

## posts
| Column | Type | Options |
|---|---|---|
| user | references | null: false, index: true, foreign_key: true |
| body | text | null: false |

**Associations**  
- belongs_to :user  
- has_many :comments, dependent: :destroy  
- has_many :likes, dependent: :destroy  
- has_many :liked_users, through: :likes, source: :user  

---


## comments
| Column | Type | Options |
|---|---|---|
| post | references | null: false, index: true, foreign_key: true |
| user | references | null: false, index: true, foreign_key: true |
| body | text | null: false |

**Associations**  
- belongs_to :post  
- belongs_to :user  

---

## likes
| Column | Type | Options |
|---|---|---|
| post | references | null: false, index: true, foreign_key: true |
| user | references | null: false, index: true, foreign_key: true |

**Indexes / Constraints**  
- unique: [:post, :user]

**Associations**  
- belongs_to :post  
- belongs_to :user  

---

# 実装した機能についての画像やGIFおよびその説明
## アカウント登録機能
![alt text](image-2.png)
![alt text](image-1.png)
![alt text](image.png)
一つの画面で項目ごとに入力できるよう設計
## 現在の禁煙成果のリアルタイム表示機能
![alt text](image-3.png)
例:<br>
ユーザー名:bbb<br>
タバコ一箱の値段:500円<br>
一箱の本数:20本<br>
一日の喫煙本数:20本<br>
禁煙開始日:2025/10/30<br>

禁煙時間を秒までリアルタイムで表示するよう設計

## 日々のアクションプラン作成
![alt text](image-4.png)
気軽に投稿できるよう設計※300文字以内
<br>
<br>

![alt text](image-6.png)
①作成したアクションプランはダッシュボードに自動表示<br>
②日をまたぐと表示がリセットされる仕様に設計


## タイムライン機能（いいね・コメント・削除・編集）
![alt text](image-5.png)
各ユーザーの投稿内容の閲覧・いいね・コメント可能<br>
自身の投稿内容の編集・削除が可能

# 実装予定の機能
現在、アクションプラン設定を実装中
今後は、
・タイムライン機能（編集・コメント・いいね）<br>
・目標設定機能<br>
・マイページ機能<br>
・条件付き禁煙復帰機能<br>
・今までの禁煙履歴合計成果の表示機能<br> 
などを実装予定

# データベース設計図
```mermaid
erDiagram

  USERS ||--|| SMOKING_SETTINGS : "has_one"
  USERS ||--o{ ABSTINENCE_SESSIONS : "has_many"
  USERS ||--|| GOALS : "has_one (active:1)"
  USERS ||--o{ RESTART_CHALLENGES : "has_many"
  USERS ||--o{ POSTS : "has_many"
  USERS ||--o{ COMMENTS : "has_many"
  USERS ||--o{ LIKES : "has_many"

  POSTS ||--o{ COMMENTS : "has_many"
  POSTS ||--o{ LIKES : "has_many"

  USERS {
    email string
    encrypted_password string
    nickname string
    age integer
    reason_to_quit text
  }

  SMOKING_SETTINGS {
    user_id references
    daily_cigarettes integer
    pack_price_jpy integer
    cigs_per_pack integer
    quit_start_datetime datetime
  }

  ABSTINENCE_SESSIONS {
    user_id references
    started_at datetime
    ended_at datetime
  }

  GOALS {
    user_id references
    target_item string
    target_amount_jpy integer
    started_on date
    status integer
    achieved_at datetime
  }

  RESTART_CHALLENGES {
    user_id references
    started_at datetime
    expires_at datetime
    status integer
    completed_at datetime
  }

  POSTS {
    user_id references
    body text
  }

  COMMENTS {
    post_id references
    user_id references
    body text
  }

  LIKES {
    post_id references
    user_id references
  }

  QUOTES {
    text text
    author string
    lang string
  }

```
# 画面遷移図
![alt text](画面遷移図ver2.png)
# 開発環境
・フロントエンド: HTML/CSS/JavaScript<br>
・バックエンド: Ruby on Rails/Ruby<br>
・インフラ：MySQL/PostgreSQL<br>
・テスト: Rspec<br>
・テキストエディタ: VS Code<br>
・タスク管理: GitHub Projects<br>
# ローカルでの動作方法
git clone https://github.com/ryuta-takayama/smoke-free.git<br>
cd smoke-free<br>
bundle install<br>
rails db:create<br>
rails db:migrate<br>
rails s
# 工夫したポイント
## UI/UX設計
1 人の心理に優しい配色（緑・青）を中心に作成し、背景は白にすることで、シンプルで見やすいように設計した<br>
## アカウント登録機能
1 javascriptを使って記入が多いところを3ステップに分けてアカウント登録できるようにすることで、登録負荷をあまりかけないよう工夫<br>
2 Toggleを使ってパスワードを一時的に可視化し、確認用も含め一致をスムーズに行えるよう工夫<br>
3 新規登録後に禁煙成果を表示できるよう、ネスト構造を使い、usersテーブル以外のエンティティを保存できるよう工夫
## 現在の禁煙成果のリアルタイム表示機能
1 現在進行で禁煙している体験をしてほしく、時間・秒までをリアルタイム表示するように工夫<br>
2 禁煙経過日数により報酬メッセージの表示方法を工夫<br>
## 日々のアクションプラン作成機能
1 作成しやすいようにシンプルな画面に設計
2 ダッシュボードへの表示は24時間でリセットされるよう工夫

# 改善点
アクションプラン投稿に、ハッシュタグがなく文字ベースだけなため、postsテーブルにtagカラムを追加する等で設計する

# 製作時間
1か月半
