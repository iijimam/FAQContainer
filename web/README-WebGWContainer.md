# WebGatewayコンテナ版への変更

WebGatewayコンテナ版（2023.1.0）への変更で修正したファイルは以下の通り。

- Dockerfile

    WebGateway用イメージを使用するように修正

    CSP.iniの中身をコンテナビルド時に追記してる（[./webgwfiles/CSP.ini](./webgwfiles/CSP.ini)を使用)

    > [Dockerfile-preWGContainer](/web/Dockerfile-prevWGContainer)は、現在使用中FAQコンテナで使用しているWebGateway用コンテナ作成元。念のため保管

- webgateway.conf

    以下FAQをそのまま使用（元ファイルと1か所除きほぼ一緒）

    https://faq.intersystems.co.jp/csp/faq/result.csp?DocNo=593

    > CSPConfigPath "/opt/webgateway/bin/" がなくて動かなったので、FAQトピックのそのまま使用

- 未使用になるファイル

    - [WebGateway-2020.3.0.221.0-lnxubuntux64.tar.gz](/web/WebGateway-2020.3.0.221.0-lnxubuntux64.tar.gz)
    - [webgateway-entrypoint.sh](/web/webgateway-entrypoint.sh)
    - [webgateway.conf](/web/webgateway.conf)



