import webview from '@ohos.web.webview'
import window from '@ohos.window';
import common from '@ohos.app.ability.common';
import router from '@ohos.router';
import { UserAgent } from '../common'
import { Game } from '../model/model';

const ANIMATION_TIME: number = 300

@Entry
@Component
struct GamePage {
  // 页面状态
  @State isLoading: boolean = true
  @State hasError: boolean = false
  @State errorMessage: string = ''
  @State tipsindex: number = 0
  @State game: Game = {} as Game
  @State loadTimer: number = 0
  @State webViewReady: boolean = false

  // 动画状态
  @State transitionType: SlideEffect = SlideEffect.Top

  controller: webview.WebviewController = new webview.WebviewController()
  context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext

  pageTransition() {
    // 快速滑入动画
    PageTransitionEnter({ duration: ANIMATION_TIME, curve: Curve.EaseInOut })
      .slide(this.transitionType)

    // 快速滑出动画
    PageTransitionExit({ duration: ANIMATION_TIME, curve: Curve.EaseInOut })
      .slide(this.transitionType)
  }

  onPageShow() {
    if (this.game.tips && this.game.tips.length > 0) {
      let index = Math.random() * 100 % this.game.tips.length
      this.tipsindex = Number(index.toFixed(0))
    }

    // 设置超时机制
    this.loadTimer = setTimeout(() => {
      if (this.isLoading) {
        console.log('WebView加载超时，自动显示内容')
        this.isLoading = false
        this.webViewReady = true
      }
    }, 10000) // 10秒超时
  }

  aboutToDisappear() {
    // 清理定时器
    if (this.loadTimer) {
      clearTimeout(this.loadTimer)
    }
  }

  aboutToAppear() {
    const params = router.getParams() as Record<string, string | number | SlideEffect | Game>;
    this.transitionType = params.type as SlideEffect;
    this.game = params.data as Game;

    window.getLastWindow(this.context, (err, current) => {
      current.setWindowSystemBarEnable([])
      current.setWindowLayoutFullScreen(true)
    })

    if (this.game.nickname && this.game.tips && this.game.tips.length > 0) {
      router.showAlertBeforeBackPage({
        message: this.game.nickname + ', ' + this.game.tips[this.tipsindex]
      })
    }

    console.log('游戏页面初始化完成:', this.game.name, this.game.url)
  }

  build() {
    Stack() {
      if (this.hasError) {
        // 错误状态
        Column() {
          Text('加载失败')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 10 })
          Text(this.errorMessage)
            .fontSize(14)
            .textAlign(TextAlign.Center)
            .margin({ bottom: 20 })
          Button('重试')
            .onClick(() => {
              this.hasError = false
              this.isLoading = true
              this.controller.refresh()
            })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor(0xF5F5F5)
        .padding(20)
      } else {
        // 游戏内容 - 始终显示WebView
        Row() {
          Column() {
            Web({ src: this.game.url, controller: this.controller })
              .fileAccess(true)
              .javaScriptAccess(true)
              .domStorageAccess(true)
              .databaseAccess(true)
              .mixedMode(MixedMode.All)
              .onlineImageAccess(true)
              .zoomAccess(true)
              .pinchSmooth(true)
              .backgroundColor(0xFFFFFF)
              .userAgent(UserAgent)
              .onPageBegin(() => {
                console.log('页面开始加载:', this.game.url)
                this.isLoading = false
                this.hasError = false
                this.webViewReady = true

                // 清理超时定时器
                if (this.loadTimer) {
                  clearTimeout(this.loadTimer)
                  this.loadTimer = 0
                }
              })
              .onPageEnd(() => {
                console.log('页面加载完成:', this.game.url)
                this.isLoading = false
                this.webViewReady = true
              })
              .onHttpErrorReceive((event) => {
                console.error('HTTP错误:', event.response.getResponseCode(), event.response.getReasonMessage())
                if (!this.webViewReady) {
                  this.hasError = true
                  this.errorMessage = '页面加载失败，请检查网络连接'
                }
              })
          }
          .width('100%')
          .height('100%')
        }
        .height('100%')
        .backgroundColor(0xFFFFFF)
      }
    }
    .width('100%')
    .height('100%')
  }
}