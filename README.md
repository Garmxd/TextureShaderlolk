# UI Menu Pack (Minecraft 26.3, vanilla)

Ресурс-пак для кастомного GUI-меню поверх `/dialog`.

## Что внутри
| Файл | Назначение |
|---|---|
| `assets/minecraft/post_effect/texture_overlay.json` + `shaders/post/texture_overlay.fsh` | Накладывает картинку `textures/effect/gui_overlay.png` на экран |
| `assets/minecraft/post_effect/blur.json` | Заглушка вместо размытия меню (просто блит без блюра) |
| `assets/minecraft/shaders/core/position_tex_color.*`, `position_color.*` | ЧИСТЫЕ ванильные копии (см. ниже — почему это важно) |
| `assets/minecraft/textures/gui/sprites/dialog/button*.png` | Спрайты кнопок **только для диалогов** |
| `assets/minecraft/textures/gui/sprites/popup/button*.png` | Спрайты кнопок для попапов |

## Почему шейдерами кнопки убрать нельзя
В 26.3 у GUI-шейдеров есть только UBO `DynamicTransforms` (ModelViewMat, TextureMat,
ColorModulator, ModelOffset), `Projection` и `Globals` (GameTime, ScreenSize,
MenuBlurRadius...). Флага «открыт ли dialog» там нет, а свои uniform-передавать неоткуда.
Поэтому шейдер физически не может отличить кнопку в диалоге от кнопки в меню паузы.

Правильный путь — переопределение спрайтов по адресу (`dialog/*` и `popup/*` используются
только диалогами/попапами, а меню паузы использует `widget/*` и `pause_menu/*`).

## Про спрайты кнопок
Сейчас там заглушки, стилизованные под ванильную кнопку (бежевые, 20x20, nine-slice border=2).
Они нужны, чтобы понять, что адрес рабочий: если кнопки в диалоге стали другими — ресы применяются.

### Как сделать кнопки полностью невидимыми (клики работают!)
Mojang вырезает пиксели с альфой ровно 0 (`if (color.a == 0.0) discard;`), поэтому обычный
полностью прозрачный PNG иногда ломает загрузку атласа. Надёжный способ — «почти прозрачная»
альфа 1/255 (невидима глазу, но пиксель считается валидным):

```python
from PIL import Image
im = Image.new('RGBA', (20, 20), (0, 0, 0, 1))   # a=1 -> не видно, атлас не ломается
for d in ('dialog', 'popup'):
    for n in ('button', 'button_disabled', 'button_highlighted'):
        im.save(f'assets/minecraft/textures/gui/sprites/{d}/{n}.png')
```

Если после этого atlas не собирается (кнопки остались серыми квадратами или игра ругается) —
оставь минимальную рамку с альфой 2-3 px по краю, либо просто сделай свой дизайн: эти же PNG
заменяются на любую твою картинку меню.

## Важно про core-шейдеры
Твой прежний `position_tex_color.fsh` содержал `#include <minecraft:...>` и цветовые `discard`-и.
Два проблемы:
1. Ванильные core-шейдеры **не используют `#include`** (они компилируются до загрузки ресурспаков,
   Mojang инлайнит туда копии UBO). Неверный include = ошибка компиляции = весь GUI может стать белым.
2. Отсечение по цвету (`abs(r-g)<0.15 ...`) удаляло пиксели **во всём GUI**: текст, рамки, предметы.
   Теперь эти файлы — точные копии ванилы из `mcasset.cloud/26.3` (проверено по исходникам).

Если снова захочешь шейдером резать тёмную обводку — делай это только в position_color.fsh и только по vertexColor (залишка/рамка), а не по текстуре в position_tex_color.fsh.


## Тест-диалог для датапака
Положи в свой датапак `data/<ns>/dialog/test_buttons.json`:

```json
{
  "type": "minecraft:notice",
  "title": "TEST BUTTONS",
  "body": [{"type": "minecraft:single_option", "prompt": "Кнопки должны быть чистыми"}],
  "action": {"label": "PRESS ME", "action": {"type": "minecraft:noop"}}
}
```
Открой: `/dialog show <ns>:test_buttons` → кнопки диалога без рамок/заливки, Esc-меню не тронут.

## Установка
Папка = ресурспак целиком (рядом `pack.mcmeta`). Скопируй в `.minecraft/resourcepacks/`, включи в
Настройки → Наборы ресурсов. После любых правок PNG/FSH — F3+T.
