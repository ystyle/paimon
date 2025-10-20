import router from '@ohos.router';
import window from '@ohos.window';
import common from '@ohos.app.ability.common';
import { Game } from '../model//model'

@Entry
@Component
struct Index {
  @State isDarkMode: boolean = false
  @State refreshKey: number = 0

  // 游戏列表数据
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
        '你要休息了帕？',
        '开拓者，今天的模拟宇宙打了没有？',
        '开拓者，今天的委托完成了吗？'
      ]
    }
  ]
  context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext

  onPageShow() {
    if (!canIUse('SystemCapability.Web.Webview.Core')) {
      console.error('WebView权限不可用')
    }
    window.getLastWindow(this.context, (err, current) => {
      current.setWindowSystemBarEnable(['status', 'navigation'])
      current.setWindowLayoutFullScreen(false)
    })
  }

  // 游戏卡片点击事件
  private onGameClick(game: Game) {
    try {
      router.pushUrl({
        url: 'pages/Game',
        params: {
          type: SlideEffect.Top,
          data: game
        }
      }, router.RouterMode.Single)
    } catch (error) {
      console.error('页面跳转失败:', error)
    }
  }

  // 创建游戏卡片组件
  @Builder GameCard(game: Game) {
    Row({ space: 15 }) {
      // 游戏图标
      Image(game.icon)
        .width(80)
        .height(80)
        .borderRadius(12)
        .objectFit(ImageFit.Cover)
        .shadow({ radius: 2, color: '#20000000', offsetX: 0, offsetY: 1 })

      // 游戏名称
      Text(game.name)
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
        .fontColor('#333333')
        .layoutWeight(1)
        .textAlign(TextAlign.Start)
        .alignSelf(ItemAlign.Center)

      // 箭头指示器
      Text('>')
        .fontSize(20)
        .fontColor('#999999')
        .fontWeight(FontWeight.Bold)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .shadow({ radius: 4, color: '#10000000', offsetX: 0, offsetY: 1 })
    .onClick(() => this.onGameClick(game))
  }

  build() {
    Column() {
      Navigation() {
        // 游戏列表
        Column({ space: 24 }) {
          ForEach(this.gameList, (item: Game, index: number) => {
            this.GameCard(item)
          })
        }
        .padding({top: 20})
        .width('90%')
        .height('100%')
      }
      .title('游戏列表')
      .titleMode(NavigationTitleMode.Free)
      .mode(NavigationMode.Stack)
      .hideBackButton(true)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}