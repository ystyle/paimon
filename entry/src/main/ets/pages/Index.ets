import router from '@ohos.router';
import window from '@ohos.window';
import common from '@ohos.app.ability.common';
import { Game } from '../model//model'

@Entry
@Component
struct Index {
  @State hide: boolean = false
  private gameList: Game[] = [
    {
      name: '原神',
      url: 'https://ys.mihoyo.com/cloud',
      icon: $r('app.media.genshin'),
      nickname: '旅行者',
      tips: [
        '你要休息了吗？ 尘歌壶里的菜记得收哦！',
        '你要休息了吗？ 每日任务交了吗？',
        '你要休息了吗？ 今天的树脂用完了吗？',
        '你要休息了吗？ 今天有和壶里的大家说说话吗？'
      ]
    },
    {
      name: '崩坏·星穹铁道',
      url: 'https://sr.mihoyo.com/cloud',
      icon: $r('app.media.star_rail'),
      nickname: '开拓者',
      tips: [
        '你要休息了帕？'
      ]
    }
  ]
  context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext

  onPageShow() {
    if (!canIUse('SystemCapability.Web.Webview.Core')) {
      console.log('没有权限')
    }
    window.getLastWindow(this.context, (err, current) => {
      current.setWindowSystemBarEnable(['status', 'navigation'])
      current.setWindowLayoutFullScreen(false)
    })
  }

  build() {
    Column() {
      Navigation() {
        List({ space: 20  }) {
          ForEach(this.gameList, (item: Game) => {
            ListItem() {
              Row({space: 10}) {
                Image(item.icon)
                  .width(100)
                  .height(100)
                Text(item.name)
                  .width('calc(100% - 100vp - 10vp)')
                  .height(100)
                  .fontSize(16)
                  .padding({ left: 20 })
                  .borderRadius(10)
                  .backgroundColor(0xFFFFFF)
              }
              .width('100%')
              .layoutWeight('100%')
            }
            .width('100%')
            .backgroundColor(0xC0C0C0)
            .layoutWeight('100%')
            .borderRadius({topRight: 10, bottomRight: 10})
            .onClick((e) => {
              router.pushUrl({
                url: 'pages/Game',
                params: { type: SlideEffect.Top, animationType: 1, data: item }
              }, router.RouterMode.Single)
            })
          })
        }
        .listDirection(Axis.Vertical) // 排列方向
        .scrollBar(BarState.Off)
        .friction(0.6)
        .divider({ strokeWidth: 0, color: 0xFFFFFF, startMargin: 20, endMargin: 20 }) // 每行之间的分界线
        .edgeEffect(EdgeEffect.Spring) // 边缘效果设置为Spring
        .chainAnimation(true)
        .width('90%')
      }
      .title('游戏列表')
      .titleMode(NavigationTitleMode.Free)
      .mode(NavigationMode.Stack)
      .hideBackButton(true)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(0xC0C0C0)
    // .padding({ top: 5, bottom: 15 })
  }
}