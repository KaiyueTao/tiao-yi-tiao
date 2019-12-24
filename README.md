# Verilog版微信“跳一跳”

使用verilog实现了2017年末上线的微信小程序游戏“跳一跳”，为魔术实验设计课程的大作业。
主要以**状态机为核心**，实现了**蓄力、跳动效果、掉落方块、加分、死亡判断**等功能，并且利用rom存储显示图片，简单地做了开始和死亡界面。

大致的示意图如下：

<img><img src = https://tva1.sinaimg.cn/large/006tNbRwly1ga3geq4fotj31as0u0qik.jpg width=80% />

**<span id="rule">游戏规则为：</span>**

> 1. 按键蓄力，松开后小人跳动，落到方块台子上获得加分。
> 2. 台子（stage）有红橙绿蓝四色，对应不同的分数。
> 3. 台子还有不同的宽度（三种），在一开始台子均较宽，随着分数提高难度增高，出现窄的台子，增加跳跃难度。
> 4. 落到台子中心部分，有额外的加分。

**从实验报告里选了部分内容简单介绍下：**

## 状态机

定义了**10**个状态，分别为：

    - START：开始界面
    - WAIT：等待玩家按键蓄力
    - PRESSING：开始蓄力
    - JUMP：蓄力结束
    - CHECK：死亡判断
    - UPDATE：更新方块
    - FALL：用于为新的方块产生从上方落下的动画效果
    - MOVE：移动视角，回到左侧
    - DEAD：死亡状态，rst键重新开始

流程图如下：

<img> <img src="https://cdn.mathpix.com/snip/images/GETWeTC2cDxNljvjmkM6vT1kD664VLIC1cENRBqiVk8.original.fullsize.png" width=80% />

## 模块设计

总设计图：

<img><img src="https://cdn.mathpix.com/snip/images/zswMpPhOe6UmQuqrh5CKB5B-LISChzcM9DYOdmibAmM.original.fullsize.png" />

因为模块间传递信号较多，为了避免杂乱，只标注了control（控制）模块的控制信号以及总体的input、output信号。模块间具体信号传递直接见源码。

**注：**
rom1、rom2以及clk_wiz利用vivado ip核直接生成即可。rom1&2为480000*3，分别载入pic中的start/dead.coe文件；clk生成40MHz。

## 演示

1. 进入开始界面：

    <img src = https://tva1.sinaimg.cn/large/006tNbRwly1ga3f0nbub8j31400u04qq.jpg width=80% />

2. 等待玩家按键：

    <img src = https://tva1.sinaimg.cn/large/006tNbRwly1ga3f3dfe4sj31400u0u0x.jpg width=80% />

3. 蓄力：

    <img src = https://tva1.sinaimg.cn/large/006tNbRwly1ga3f3yhopoj31400u01ky.jpg width=80% />
   
4. 跳动：
   
    由于手机相机快门速度太低，故拍出来有重影，实际运行中动画较为流畅。

    <img src = https://tva1.sinaimg.cn/large/006tNbRwly1ga3fgu30ttj31400u0kjl.jpg width=80% />

5. 分数计算：

    <img src = https://tva1.sinaimg.cn/large/006tNbRwly1ga3fj635qvj31400u0hdu.jpg width=80% />

6. 方块下落效果：

    同样由于手机相机快门速度所限，有重影，实际过程中流畅：

    <img src = https://tva1.sinaimg.cn/large/006tNbRwly1ga3fkpe57rj31400u04qq.jpg width=80% />

7. 死亡界面：
   
    <img src = https://tva1.sinaimg.cn/large/006tNbRwly1ga3fln2w7kj31400u0x6p.jpg width=80% />

8. 随着分数提高调整难度：

    开始出现窄方块。

    <img src = https://tva1.sinaimg.cn/large/006tNbRwly1ga3fniu2ffj31120ku1iw.jpg width=80% />






