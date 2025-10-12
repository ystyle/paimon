import webview from '@ohos.web.webview'
import window from '@ohos.window';
import common from '@ohos.app.ability.common';
import router from '@ohos.router';
import {UserAgent } from '../common'

const tips:string[] = [
  '尘歌壶里的菜记得收哦！',
  '每日任务交了吗？',
  '今天的树脂用完了吗？',
  '今天有和壶里的大家说说话吗？'
]

@Entry
@Component
struct Index {
  @State scale1: number = 1
  @State opacity1: number = 1
  @State hide:boolean = false
  @State message: string = 'Hello World';
  controller: webview.WebviewController = new webview.WebviewController()
  context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext
  onPageShow(){
    if (!canIUse('SystemCapability.Web.Webview.Core')) {
      console.log('没有权限')
    }
    window.getLastWindow(this.context, (err, current) => {
      current.setWindowSystemBarEnable([])
      current.setWindowLayoutFullScreen(true)
    })
    let index = Math.random() * 100 % tips.length
    router.showAlertBeforeBackPage({
      message: '旅行者, 你要休息了吗？ ' + tips[index] // 设置询问框的内容
    })
  }
  pageTransition() {
    PageTransitionEnter({ duration: 1200, curve: Curve.Linear })
      .onEnter((type: RouteType, progress: number) => {
        if (type == RouteType.Push||type == RouteType.Pop) {
          this.scale1 = progress
          this.opacity1 = progress
        }
      })
    PageTransitionExit({ duration: 1200, curve: Curve.Ease })
      .onExit((type: RouteType, progress: number) => {
        if (type == RouteType.Push) {
          this.scale1 = 1 - progress
          this.opacity1 = 1 - progress
        }
      })
  }

  build() {
    Row() {
      Column() {
        Web({ src: 'https://ys.mihoyo.com/cloud/#/', controller: this.controller })
          .javaScriptAccess(true)
          .fileAccess(true)
          .domStorageAccess(true)
          .userAgent(UserAgent)
      }
      .scale({ x: this.scale1 })
      .opacity(this.opacity1)
      .width('100%')
    }
    .height('100%')
  }
}