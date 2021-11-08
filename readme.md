### awsCLIの初期化
- aws configure
- IAMuserでアクセスキーを作成

###　最初の初期化コマンド
- terraform init

### プランコマンド
- terraform plan

### 適応
- terraform apply -auto-approve

### フォーマットコマンド
- terraform fmt

### 削除コマンド
- terraform destory



## プレフィックスリスト
複数のciderブロックの塊のことを表す

## RDSのデータ構造
- RDSインスタンス
  - パラメータグループ
  - オプショングループ
  - サブネットグループ
    - サブネット
- 後からパスワードを変更する
```shell
aws rds modify-db-instance --db-instance-identifier 'インスタンスID' 
--master-user-password '新しいパスワード'
```


## キーベア作成
```shell
ssh-keygen -t rsa -b 2048 -f tastlog-dev-keypair
```