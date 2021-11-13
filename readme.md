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


## リモートのtfstateを確認する
```shell
terraform state list
```

## より詳細にリソースを調べたい
```shell
terraform state show
```

## リソース情報の移動
```shell
terrafrom state mv ソース 移動先のソース
```

## リモートから取り込み
```shell
terraform import 取り込み先のリソース名 iD
```

## リモートのリソースを削除する

```shell
terraform state rm リソース名
```

## 実際のクラウド上の状態をステートファイルへ反映するか
```shell
terraform refresh
```
これをするとAWSとローカルのtfstateが一致していて
ソースコードだけがズレているようになる。
terraform planから差分を確認する。