# raspberry_ap_decrypt
利用树莓派自带的wifi创建热点，解密连接到该热点的https加密数据流量

# 原理
利用了sslsplit和raspap（创建热点）项目

# 使用方法
手机或电脑链接到AP，安全信任CA根证书，运行安装后可以使用tcpdump保存接口流量或sslsplit自带保存pcap功能

# 注意事项
该脚本未完全编写完成，脚本应体现的时解密HTTPS的思路

# 参考网址
https://blog.kchung.co/recording-and-decrypting-ssl-encrypted-traffic/
