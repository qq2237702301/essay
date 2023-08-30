### cannot find -l****问题的解决办法

1、使用 `sudo find / -name "lib****.so"`或`ldconfig -p | grep ***`(lib***.so中的\*\*\*)。比如找不到`-lrdmacm`了，


