import webview from '@ohos.web.webview'
import window from '@ohos.window';
import common from '@ohos.app.ability.common';
import router from '@ohos.router';
import { UserAgent } from '../common'
import { Game } from '../model/model';

const ANIMATION_TIME: number = 1000
const ANIMATION_PROGRESS: number = -600

@Entry
@Component
struct GamePage {
  // PageTransition
  @State topY: number = 0
  @State zoom: number = 0
  @State angle: number = 1
  @State leftX: number = 0
  @State rightX: number = 0
  @State bottomY: number = 0
  @State progress: number = 0
  @State animationType: number = 0
  @State transitionType: SlideEffect = SlideEffect.Left
  @State tipsindex: number = 0
  // data
  @State game: Game = {} as Game
  controller: webview.WebviewController = new webview.WebviewController()
  context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext

  pageTransition() {
    // Entry animation
    PageTransitionEnter({ duration: ANIMATION_TIME, curve: Curve.Linear })
      .slide(this.transitionType)
      .onEnter((type: RouteType, progress: number) => {
        this.topY = (-progress + 1) * this.topY
        this.bottomY = (-progress + 1) * this.bottomY
        this.leftX = (-progress + 1) * this.leftX
        this.rightX = (-progress + 1) * this.rightX
        this.progress = progress
      })

    // Exit animation
    PageTransitionExit({ duration: ANIMATION_TIME, curve: Curve.Ease })
      .slide(this.transitionType)
      .onExit((type: RouteType, progress: number) => {
        this.topY = -ANIMATION_PROGRESS * progress
        this.bottomY = ANIMATION_PROGRESS * progress
        this.leftX = -ANIMATION_PROGRESS * progress
        this.rightX = ANIMATION_PROGRESS * progress
        this.progress = progress
      })
  }

  onPageShow() {
    let index = Math.random() * 100 % this.game.tips.length
    this.tipsindex = Number(index.toFixed(0))
  }

  aboutToAppear() {
    let params = router.getParams() as Record<string, string | number | SlideEffect | Game>;
    this.transitionType = params.type as SlideEffect;
    this.angle = params.angle as number;
    this.zoom = params.zoom as number;
    this.animationType = params.animationType as number;
    this.game = params.data as Game

    window.getLastWindow(this.context, (err, current) => {
      current.setWindowSystemBarEnable([])
      current.setWindowLayoutFullScreen(true)
    })

    router.showAlertBeforeBackPage({
      message: this.game.nickname + ', ' + this.game.tips[this.tipsindex] // 设置询问框的内容
    })
  }

  build() {
    Row() {
      Column() {
        Web({ src: this.game.url, controller: this.controller })
          .fileAccess(true)
          .javaScriptAccess(true)
          .domStorageAccess(true)
          .databaseAccess(true)
          .pinchSmooth(true)
          .backgroundColor(0xFFFFFF)
          .userAgent(UserAgent)
      }
      // .opacity(this.progress)
      .rotate(this.animationType === 3 ? { z: 1, angle: this.progress * this.angle } : { z: 1, angle: 0 })
      .scale(this.animationType === 2 ? {
        x: this.progress * this.zoom / 2,
        y: this.progress * this.zoom / 2,
        centerY: '50%',
        centerX: '50%'
      } : { x: 1, y: 1 })
      .width('100%')
      .backgroundColor(0xFFFFFF)
    }
    .height('100%')
    .backgroundColor(0xFFFFFF)
  }
}