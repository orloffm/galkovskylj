# ЖЖ Галковского

Сохранение ЖЖ Дмитрия Евгеньевича Галковского в читаемых форматах.

Все записи со всеми изображениями, а также все комментарии автора сохраняются по годам
в отдельные файлы. Также для полноты архива архивируются mp3-файлы.

## Структура проекта

1. Специальная программа сохраняет каждый пост в собственном XML-формате
в файл `book\YYYY\NNNN\dump.xml`, где `YYYY` --- год, а `NNNN` --- номер поста.
После скачивания поста анализируется, какие комментарии войдут в книгу,
и все изображения и юзерпики из самого поста и этих комментариев сохраняются рядом.
Изображения --- в папке `book\YYYY\NNNN\Files`, юзерпики --- в общей для
всех постов папке `book\userpics`.
2. Далее отдельная программа на основе `dump.xml` также анализирует список
комментариев, после чего сохраняет текст поста в формате `AsciiDoc`
в файл `book\YYYY\NNNN\fragment.asc`. Эти файлы совместно составляют
целую книгу.

## Как скачивать и готовить очередной пост

### Подготовка

1. Собрать солюшен [meta/LiveJournal/LiveJournalGrabber.sln](meta/LiveJournal/LiveJournalGrabber.sln).
    1. Для этого требуется Visual Studio, можно
    скачать [бесплатную 2015 Community Edition](https://www.visualstudio.com/en-us/downloads/download-visual-studio-vs.aspx).
    2. При установке потребуется минимальная конфигурация, только C#-компоненты.
    3. После установки можно попробовать запустить файл [meta/LiveJournal/build.bat](meta/LiveJournal/build.bat).
         1. Если он не заработает, то нужно открыть .sln-файл, выбрать Release-конфигурацию и затем Build -> Build Solution.
    4. В результате сборки появится папка `bin` с файлами.
2. Купить платный аккаунт в ЖЖ: http://www.livejournal.com/shop/paidaccount.bml.
3. Переключить на страницу выбора стиля журнала,
http://www.livejournal.com/customize/,
ввести в поиске `SimpleXML`, переключиться на этот layer. Его исходный код
приведён в файле [meta/LiveJournal/Data/layer.txt](meta/LiveJournal/Data/layer.txt)
Теперь ЖЖ будет выдавать специально сформированный XML для вашего журнала.
Возможно выдавать любой журнал в таком XML-виде путём добавления `?style=mine` 
к адресу. Этим мы и пользуемся.
4. Открыть любой пост в ЖЖ. Включить в браузере по F12 консоль разработчика.
Посмотреть, с каким cookie открывается страница.

### Собственно скачивание

1. Открыть консоль.
2. Зайти в `bin\`.
3. Запустить `dumper /url=<адрес поста> /root=<путь к папке book> /cookie=<cookie>`.
Здесь:
    * Адрес поста --- полный его адрес, например, http://galkovsky.livejournal.com/15915.html.
    * Путь к папке book --- например, `C:\galkovskylj\book`. Если в пути есть пробелы, он должен быть обрамлён кавычками.
    * Cookie --- то, что мы скопировали из консоли разработчика. В кавычках
    
Пример.

`dumper /url=http://galkovsky.livejournal.com/15915.html /root="C:\galkovsky lj\book" /cookie="__utma=48425145..."`

#### Примечания

1. Можно добавить параметр `/continue`, тогда будут скачаны посты далее.
2. В следующий раз можно указывать только `/url=...`, путь и куки будут запомнены.
3. Программа автоматически вытаскивает год и номер поста из заголовка. Так что 
в результате приведённой команды будет создан файл `book\2004\0061\dump.xml`,
возможные файлы будут сохранены в `book\2004\0061\Files`, а нужные юзерпики ---
в `book\userpics`.
4. Программу можно запускать подряд, в этом случае файл дампа не переписывается,
а дополняется.
5. Также при сборке компилируется графическая программа
`meta\LiveJournal\OrlovMikhail.LJ.Grabber.Client\bin\Release\GrabberClient.exe`,
которая позволяет делать то же, но которая требует явного указания папки
а-ля `2004\0061`.

### Завершение после скачивания

1. Вернуться на страницу http://www.livejournal.com/customize/ и переключить
журнал обратно в обычную тему.

### Как делать фрагменты книг.

Под "фрагментом" подразумевается один `.asc`-файл с одним постом и комментариями к нему.

1. Открыть консоль.
2. Зайти в `bin\`.
3. Выполнить `bookmaker /source=<путь к dump.xml> /root=<путь к папке book>`.
Здесь:
    * Путь к dump.xml - например, `C:\galkovsky lj\book\2014\0869\dump.xml`.
    * Путь к папке book - например, `C:\galkovsky lj\book`.
    
Пример.

`bookmaker /root="C:\galkovsky lj\book" /source="C:\galkovsky lj\book\2014\0869\dump.xml"`

#### Примечания

1. В результате на основании `dump.xml` будет создан `fragment.asc`.
3. Аналогично программе `dumper`, значение `root` запоминается
   до следующего раза и его можно не повторять.
2. Если создан новый фрагмент (для нового поста), нужно:
    1. Зайти в папку `book`.
    2. Запустить оттуда `fillbyyear.bat`. Это обновит ссылки в файлах `book\YYYY\fullyear.asc`.

## Как собирать книги

### Windows

#### Подготовка
1. Установить Ruby, версию >= 2.2 с http://rubyinstaller.org/downloads/. Возможно, рабочая ссылка --- http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.2.2.exe. При установке нужно отметить добавление программ в переменную PATH.
1. Скачать Ruby Dev Kit оттуда же. Опять же, возможно рабочая ссылка --- http://dl.bintray.com/oneclick/rubyinstaller/DevKit-mingw64-32-4.7.2-20130224-1151-sfx.exe. Распаковать в произвольную папку, например, `C:\RubyDevKit`.
1. Открыть командную строку.
1. Перейти в эту папку (`cd C:\RubyDevKit`).
1. `ruby dk.rb init`.
1. `ruby dk.rb install`.
1. Перейти в папку `book` проекта.
1. Установить bundler: `gem install bundle`.
1. Установить всё нужное для сбора книг: `bundle install`.

#### Собственно сборка
1. Перейти в папку `book\` проекта.
1. Собрать книги: `build.bat`.
1. Готовые файлы будут помещены в папку `book\output\`.