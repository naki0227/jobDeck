# JobDeck 設計書 v0.2

## 1. この設計書の目的

この文書は、JobDeck の MVP を実装するための設計基準をまとめたものです。

最重要方針は次の 3 つです。

1. まずは iOS フロントエンドを完成させる
2. データはローカル保存を基本にする
3. AI は補助機能として Gemini API を安全に中継して使う

## 2. プロダクト概要

### プロダクト名

`JobDeck`

### コンセプト

面接前 10 分で、今日話すことだけ見返せる就活デッキアプリ。

### 解決したい課題

就活では、企業研究、自己分析、逆質問、面接ログ、ES メモが複数の場所に散らばりやすいです。
JobDeck はそれらをただ保存するのではなく、面接直前に見返せる「話すカード」と「面接デッキ」に変換して使える状態にします。

### 差別化ポイント

既存の就活サービスが主に扱うのは次の領域です。

- 企業情報の閲覧
- ES や体験談の閲覧
- 選考状況の管理
- スケジュール管理
- 自己分析診断

JobDeck が狙うのは、次の一点です。

自分の経験、強み、企業情報をつなぎ、面接直前に話す内容へ圧縮すること。

つまり、就活管理アプリではなく、面接準備デッキアプリです。

## 3. MVP の対象範囲

### MVP で作るもの

- 自分カード
- 企業カード
- エピソードカード
- 逆質問カード
- 面接ログ
- 面接前 10 分デッキ
- AI 棚卸しチャット
- AI 企業情報変換
- AI デッキ生成
- AI クレジット管理

### MVP で作らないもの

- 口コミ投稿
- ES 例文共有
- 他人の選考体験談 DB
- 本格カレンダー
- Gmail / Notion / Google Drive 連携
- PDF / OCR 取り込み
- Web 版
- SNS 機能
- 逆求人

## 4. 技術方針

### iOS アプリ

- 言語: Swift
- UI: SwiftUI
- ローカル DB: SwiftData
- 課金: StoreKit 2
- 通知: UserNotifications
- 最低対応 OS: iOS 17 以上

### AI バックエンド

- 実行環境:
  - 第一候補: Rust API サーバー
  - 代替候補: Cloudflare Workers
- AI Provider: Gemini API
- 役割: API キー秘匿、リクエスト検証、利用量検証、AI 応答の整形

Rust を第一候補にする場合、初回実装では Cloudflare Workers に無理に合わせず、通常の Rust API サーバーとして組む方が自然です。
Cloudflare Workers は TypeScript との相性が良く、Rust でも不可能ではありませんが、MVP 学習と実装効率の観点では優先度を下げます。

### バックエンド言語は TypeScript である必要があるか

結論として、TypeScript に固定する必要はありません。
今回の方針では、あなたがバックエンドを後から自分で実装しやすいことを優先し、次のように整理します。

#### TypeScript を選ぶ場合

- Cloudflare Workers の資料や実装例が多い
- JSON API を素直に書きやすい
- MVP の速度は最も出しやすい
- フロントとデータ構造の認識をそろえやすい

#### Go を選ぶ場合

- 文法が比較的素直で、初学者でも追いやすい
- API サーバーの構成が理解しやすい
- 型安全と可読性のバランスが良い
- 将来 API が大きくなっても扱いやすい

#### Rust を選ぶ場合

- 安全性と性能は非常に高い
- 個人情報を扱う設計思想とは相性が良い
- ただし学習コストと実装コストが高い
- MVP 立ち上げでは開発速度が落ちやすい

#### JobDeck での推奨

現時点では、第一候補は `Rust` にします。

理由は次の通りです。

- あなたがすでに `axum`、`sqlx`、JWT、パスワードハッシュを含む API 実装経験を持っている
- 個人情報を扱うアプリとして、安全性を重視する思想と相性が良い
- API サーバーを小さく明確な責務で組めば、MVP でも十分現実的
- フロント実装中に API 契約を固めておけば、後から Rust 側を安全に追実装しやすい

そのため、この設計書ではバックエンド部分を次のように定義します。

- 現段階のフロント実装は「HTTP API を呼ぶ前提」で疎結合に作る
- バックエンドの実装言語は `Rust を第一候補`
- フレームワークの第一候補は `axum`
- Go は、実装速度や保守性を優先して比較したい場合の代替候補として残す

## 5. 全体アーキテクチャ

### MVP 構成

```txt
iOS App
 ├─ SwiftUI UI
 ├─ SwiftData Local DB
 ├─ StoreKit 2
 ├─ UserNotifications
 └─ AIClient
        ↓
AI Gateway
 ├─ Rust API Server
 ├─ request validation
 ├─ credit validation
 └─ Gemini API
```

### データ保存方針

- 通常データは SwiftData に保存
- 個人情報は初期リリースでは端末内保存を基本とする
- AI API キーはアプリに埋め込まない
- AI 呼び出しは必ず中継 API 経由にする
- 課金状態は StoreKit 2 で扱う
- AI クレジットは MVP ではローカル中心で管理し、将来はサーバー側へ移す

## 6. 画面構成

### タブ構成

1. ホーム
2. 企業
3. 自分カード
4. 面接前
5. 設定

### ホーム画面

目的は、次にやるべき準備をすぐ分かるようにすることです。

表示候補:

- 次の面接
- 未作成の面接デッキ
- 最近更新した企業
- AI クレジット残数
- 面接後ログ未記入の選考

### 企業一覧画面

表示項目:

- 企業名
- 職種
- 選考ステータス
- 次回面接日
- 準備状態
- 志望度

検索・フィルタ:

- 選考中
- 面接予定あり
- デッキ未作成
- 志望度高
- 不採用 / 辞退

### 企業詳細画面

セクション:

- 基本情報
- 企業メモ
- 選考状況
- 紐付けエピソード
- 逆質問
- 面接ログ
- 面接前デッキ

### 自分カード画面

含むもの:

- 価値観カード
- 強みカード
- エピソードカード
- 就活軸カード
- 弱みカード

### 面接前 10 分画面

表示項目:

- 今日の企業
- 面接時間
- 選考フェーズ
- 今日伝える軸
- 使うエピソード 3 つ
- 逆質問 3 つ
- 前回の反省
- 注意点
- 最後のチェックリスト

この画面では、情報を網羅せず、10 分で読める量に圧縮することを優先します。

## 7. データモデル

### Company

```swift
Company
- id: UUID
- name: String
- industry: String?
- jobType: String?
- selectionStatus: SelectionStatus
- priority: Int
- myPageURL: URL?
- recruitPageURL: URL?
- memo: String
- nextInterviewAt: Date?
- createdAt: Date
- updatedAt: Date
```

### Episode

```swift
Episode
- id: UUID
- title: String
- period: String?
- situation: String
- problem: String
- action: String
- ingenuity: String
- result: String
- learning: String
- summaryForInterview: String
- relatedStrengthIds: [UUID]
- questionTypes: [QuestionType]
- createdAt: Date
- updatedAt: Date
```

### Strength

```swift
Strength
- id: UUID
- title: String
- description: String
- evidenceEpisodeIds: [UUID]
- howToUseAtCompany: String
- weaknessSide: String?
- createdAt: Date
- updatedAt: Date
```

### ValueCard

```swift
ValueCard
- id: UUID
- title: String
- originStory: String
- motivatedSituation: String
- avoidEnvironment: String
- interviewExpression: String
- createdAt: Date
- updatedAt: Date
```

### CareerAxis

```swift
CareerAxis
- id: UUID
- title: String
- reason: String
- originEpisodeIds: [UUID]
- mustHaveConditions: [String]
- niceToHaveConditions: [String]
- compromiseConditions: [String]
- companyViewpoints: [String]
- createdAt: Date
- updatedAt: Date
```

### CompanyEpisodeLink

```swift
CompanyEpisodeLink
- id: UUID
- companyId: UUID
- episodeId: UUID
- reasonToUse: String
- expectedQuestion: String?
- priority: Int
- createdAt: Date
- updatedAt: Date
```

### ReverseQuestion

```swift
ReverseQuestion
- id: UUID
- companyId: UUID?
- question: String
- intent: String
- phase: InterviewPhase
- answerMemo: String?
- nextDeepDive: String?
- usedAt: Date?
- createdAt: Date
- updatedAt: Date
```

### InterviewLog

```swift
InterviewLog
- id: UUID
- companyId: UUID
- interviewAt: Date
- phase: InterviewPhase
- askedQuestions: [String]
- myAnswersMemo: String
- stuckPoints: String
- interviewerReaction: String?
- reverseQuestionsAsked: [String]
- learnedInfo: String
- nextImprovement: String
- createdAt: Date
- updatedAt: Date
```

### InterviewDeck

```swift
InterviewDeck
- id: UUID
- companyId: UUID
- interviewAt: Date
- phase: InterviewPhase
- mainAxis: String
- openingSelfIntro: String
- selectedEpisodeIds: [UUID]
- reverseQuestionIds: [UUID]
- cautionPoints: [String]
- previousReflection: String?
- checklist: [String]
- generatedByAI: Bool
- createdAt: Date
- updatedAt: Date
```

### AIUsage

```swift
AIUsage
- id: UUID
- actionType: AIActionType
- creditCost: Int
- usedAt: Date
- inputSummary: String
- outputSummary: String
```

## 8. AI 機能方針

AI は文章の代筆ではなく、構造化支援に使います。

### AI 機能一覧

- 自己分析チャット
- エピソードカード化
- 強み候補抽出
- 企業情報貼り付け変換
- 逆質問候補生成
- 企業とエピソードの接続提案
- 面接前 10 分デッキ生成
- 面接後ログ整理

### AI にやらせないこと

- 嘘の経験を作る
- 内定可能性を断定する
- 企業評価を断定する
- 丸暗記用の長文回答を作る
- 他人の ES を模倣した文章を作る

### Gemini 採用方針

費用面を重視し、MVP の AI Provider は Gemini を第一候補とします。

その前提でフロント側は次のように実装します。

- Provider 固有のレスポンス形状を UI に直接持ち込まない
- `AIClient` ではアプリ内共通の DTO を使う
- バックエンド側で Gemini の応答をアプリ向け JSON に整形する

これにより、将来 OpenAI などへ切り替える場合も影響を限定できます。

## 9. AI クレジット設計

### 基本方針

- 企業カード数ではなく AI 使用量に対して課金する
- 手動利用の価値は無料でも成立させる
- 原価のかかる部分だけを制限対象にする

### クレジット消費案

- 自己分析チャット 1 往復: 1 credit
- エピソードカード化: 5 credits
- 企業情報変換: 8 credits
- 逆質問生成: 5 credits
- 企業とエピソードの接続: 8 credits
- 面接前デッキ生成: 10 credits
- 面接後ログ整理: 5 credits
- 長文インポート変換: 15 credits

### プラン案

#### Free

- 価格: 無料
- 企業カード: 無制限
- エピソードカード: 無制限
- 逆質問カード: 無制限
- 面接ログ: 無制限
- 面接前デッキ: 手動作成
- AI credits: 月 20

#### Plus

- 価格: 月額 300 円から 500 円
- AI credits: 月 200
- AI 自己分析
- 企業情報変換
- 逆質問生成
- 面接デッキ生成

MVP 時点では `Free + Plus` を対象にします。

## 10. API 設計

### エンドポイント案

```txt
POST /ai/self-analysis/chat
POST /ai/episode/structure
POST /ai/company/parse
POST /ai/reverse-questions/generate
POST /ai/company-episode/connect
POST /ai/interview-deck/generate
POST /ai/interview-log/structure
POST /billing/verify
POST /usage/consume
```

### フロントエンド側の前提

- API ベース URL は設定値から注入する
- エンドポイントごとに request / response DTO を分ける
- ネットワーク失敗と AI 生成失敗を分けて扱う
- 送信前に「何を AI に送るか」を確認できる UI を入れる

## 11. セキュリティ・プライバシー方針

JobDeck は個人情報に近いデータを扱うため、MVP 段階から堅牢性を意識して実装します。

### 原則

- 端末保存を基本とする
- 不要な外部送信をしない
- AI 送信対象は明示的に選択させる
- API キーはクライアントに置かない
- ログに機微情報を出しすぎない
- UI テストやデバッグ用のダミーデータと実データを分離する

### AI 送信確認モーダル

AI 実行前には、少なくとも次を確認表示する想定です。

- 企業名
- 企業メモ
- 選択エピソード
- 選択した逆質問
- 面接ログ

## 12. 開発フェーズ

### Phase 0: プロトタイプ

- SwiftUI プロジェクト作成
- SwiftData モデル作成
- 企業カード CRUD
- エピソードカード CRUD
- 逆質問 CRUD
- 面接前デッキ手動作成

### Phase 1: AI なし MVP

- ホーム画面
- 企業一覧 / 詳細
- 自分カード
- エピソード棚卸しフォーム
- 逆質問ストック
- 面接ログ
- 面接前 10 分モード
- 通知

### Phase 2: AI 連携

- API 契約定義
- AIClient 実装
- Rust 製 AI バックエンドとの接続
- 自己分析チャット
- エピソードカード化
- 企業情報変換
- 逆質問生成
- 面接デッキ生成
- AI クレジット消費

### Phase 3: 課金

- StoreKit 2
- Free / Plus
- AI credits 月次付与
- Paywall
- 使用履歴画面

## 13. 推奨ディレクトリ構成

```txt
JobDeck/
 ├─ docs/
 ├─ workflow/
 ├─ App/
 │   └─ JobDeckApp.swift
 ├─ Models/
 │   ├─ Company.swift
 │   ├─ Episode.swift
 │   ├─ Strength.swift
 │   ├─ ValueCard.swift
 │   ├─ CareerAxis.swift
 │   ├─ ReverseQuestion.swift
 │   ├─ InterviewLog.swift
 │   ├─ InterviewDeck.swift
 │   └─ AIUsage.swift
 ├─ Features/
 │   ├─ Home/
 │   ├─ Companies/
 │   ├─ SelfCards/
 │   ├─ Episodes/
 │   ├─ ReverseQuestions/
 │   ├─ InterviewDeck/
 │   ├─ InterviewLogs/
 │   ├─ AI/
 │   └─ Settings/
 ├─ Services/
 │   ├─ AIClient.swift
 │   ├─ CreditService.swift
 │   ├─ NotificationService.swift
 │   └─ PurchaseService.swift
 ├─ Components/
 ├─ Resources/
 └─ Tests/
```

## 14. MVP 完成条件

### AI なし MVP

- 企業を登録できる
- エピソードを登録できる
- 企業にエピソードを紐付けられる
- 逆質問を登録できる
- 面接ログを残せる
- 面接前 10 分デッキを手動で作れる
- 次回面接がホームに表示される

### AI あり MVP

- 自己分析チャットからエピソードカードを生成できる
- 企業情報の貼り付けから企業メモを構造化できる
- 逆質問候補を生成できる
- 面接前 10 分デッキを AI 生成できる
- AI クレジットが減る
- クレジット不足時に課金導線が出る

## 15. 最重要な設計思想

JobDeck は AI が就活を代行するアプリではありません。

JobDeck が支えるのは次の行動です。

- 自分の経験を整理する
- 企業ごとに話す内容を選ぶ
- 面接前の不安を減らす
- 面接後の改善を残す

AI はその補助です。
この軸を崩さないことを、今後の実装判断の基準にします。
