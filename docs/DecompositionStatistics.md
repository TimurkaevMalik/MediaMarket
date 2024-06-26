Куимова Ольга Сергеевна
<br /> Когорта: 14
<br /> Группа: 2
<br /> Эпик: Статистика
<br /> Ссылка: https://github.com/users/olegSprite/projects/1

# Statistics Flow Decomposition


## Module 1:

#### Верстка
- Таблица со списком пользователей (est: 40 min; fact: 25 min).
- Ячейки таблицы со списком пользователей (est: 60 min; fact: 35 min).
- Кнопка сортировки (est: 20 min; fact: 5 min).
- Алерт для выбора способа сортировки (est: 20 min; fact: 15 min).

#### Логика
- Загрузка списка пользователей - место в рейтинге, аватарка, имя пользователя, количество NFT (est: 150 min; fact: 300 min).
- Сохранить способ сортировки (est: 40 min; fact: 0 min).
- Сортировка по имени (est: 20 min; fact: 5 min).
- Сортировка по рейтингу (est: 20 min; fact: 5 min).

`Total:` est: 370 min; fact: 390 min.


## Module 2:
#### Верстка
- UIImageView фото пользователя (est: 30 min; fact: x min).
- UILabel имя пользователя (est: 30 min; fact: x min).
- UILabel описание пользователя (est: 30 min; fact: x min).
- Кнопка перехода на сайт пользователя (est: 30 min; fact: x min).
- Кнопка перехода на экран коллекции пользователя (est: 30 min; fact: x min).

#### Логика
- Переход на экран коллекции пользователя (est: 40 min; fact: x min).
- Открытие сайта пользователя (est: 100 min; fact: x min).

`Total:` est: 290 min; fact: x min.

## Module 3:

#### Верстка
- Таблица c NFT пользователя (est: 40 min; fact: x min).
- Ячейки таблицы с NFT пользователя (est: 60 min; fact: x min).

#### Логика
- Загрузка NFT пользователя - иконка, название, рейтинг, стоимость, сердечко (est: 200 min; fact: x min).
- Добавление NFT в корзину (est: 60 min; fact: x min).

`Total:` est: 360 min; fact: x min.
