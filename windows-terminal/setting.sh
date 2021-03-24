`wordDelimiters: "()'-:,.;<>~!@#$%^&*|+=[]{}~?"`
#https://stackoverflow.com/questions/60441221/double-click-to-select-text-in-windows-terminal-selects-only-one-word

vscode双击选择连字符
在设置里面添加代码：
"editor.wordSeparators": "`~!@#$%^&*()-=+[{]}\\|;:'\",.<>/?",
其中 - 去掉就行了