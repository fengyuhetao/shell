#!/bin/bash
#使用内建变量

gawk 'BEGIN {testing="This is a test";  print testing; testing=45;  print testing}'

#处理数字值

gawk 'BEGIN{x=4; x= x*2+3; printx}'

#处理数组
gawk 'BEGIN{capital["Ill"] = "SprintField"; print capital["Ill"]}'

#遍历数组变量
gawk 'BEGIN{
var["a"] = 1
var["g"] = 2
var["m"] = 3
for( test in var)
{
	print "Index:",test,"- Value:",var[test]
}
}'

print "------"

#删除数组变量
gawk 'BEGIN{
var["a"] = 1
var["g"] = 2
for (test in var)
{
	print "Index:",test," - Value:", var[test]
}
delete var["g"]

print "----"

for (test in var)
{
	print "Index;",test," - Value:", var[test]
}
}'
