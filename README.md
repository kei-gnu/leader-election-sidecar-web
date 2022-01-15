# leader-election-sidecar-web
## Description
サイドカーを用いたリーダー選出アルゴリズム。
server.jsコンテナに対してリーダー選出アルゴリズムコンテナが起動し、レプリカPodの中でリーダーを選出する。

## Usage
deployフォルダにあるYAMLファイルをデプロイする
```
kubectl apply -f deploy
```

## Requirements
- Kubernetes: v1.22.4+rke2r2
- Docker: 20.10.11
