# SafeKeyboard

安全键盘  


功能：  
1.支持随机排序 （开启后，每次弹出键盘都是随机排序）  
2.强制密文显示 （与系统UITextField的密文不一样，没有从数字到圆点的过渡动画，直接就是圆点，隐私性更强）  
3.强制纯数字输入 （比如粘贴进来的不是纯数字，会不允许粘贴）   
   
4.使用配套的SafeTextField，即可屏蔽用户的额外操作（复制粘贴等）   
   
   
优点：  
1.（重要）与UITextField解耦，通过查找的方式，而不是直接保存UITextField，来达到破解引用循环  
2.支持后期扩展（修改数据源数组，然后修改xib布局，即可改成字母键盘等）
3.适配刘海屏
   
   
预览图   
  
<div align="center">
<img src="/Assets/IMB_3UVsck.GIF" width="400" height="717" >
</div> 

--------------------------------
[gif1]:/Assets/IMB_3UVsck.GIF
