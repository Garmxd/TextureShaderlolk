#!/usr/bin/env python3
"""Сделать кнопки диалогов/попапов полностью невидимыми (клики продолжают работать).

Запуск из корня ресурспака:  python3 tools/make_invisible_buttons.py
Откатить (вернуть тестовые бежевые):
  git checkout -- assets/minecraft/textures/gui/sprites/dialog assets/minecraft/textures/gui/sprites/popup
"""
from PIL import Image
import os

SIZE = (20, 20)          # nine-slice спрайт ванильной кнопки
ALPHA = 1                # 1/255 — не видно глазу, но пиксель валиден для атласа
DIRS = ('dialog', 'popup')
NAMES = ('button', 'button_disabled', 'button_highlighted')

root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
im = Image.new('RGBA', SIZE, (0, 0, 0, ALPHA))
for d in DIRS:
    folder = os.path.join(root, 'assets', 'minecraft', 'textures', 'gui', 'sprites', d)
    os.makedirs(folder, exist_ok=True)
    for n in NAMES:
        p = os.path.join(folder, f'{n}.png')
        im.save(p)
        print('written', os.path.relpath(p, root))
