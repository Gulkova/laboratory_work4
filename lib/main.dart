import 'package:flutter/material.dart';

void main() {
  runApp(BooksApp());
}

class Book {
  String title;
  String author;
  String description;

  Book(this.title, this.author, this.description);
}

class BooksApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BooksAppState();
}

class _BooksAppState extends State<BooksApp> {
  BookRouterDelegate _routerDelegate = BookRouterDelegate();
  BookRouteInformationParser _routeInformationParser =
  BookRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Книги',
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}

class BookRouteInformationParser extends RouteInformationParser<BookRoutePath> {
  @override
  Future<BookRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);

    if (uri.pathSegments.length >= 2) {
      var remaining = uri.pathSegments[1];
      return BookRoutePath.details(int.tryParse(remaining));
    } else {
      return BookRoutePath.home();
    }
  }

  @override
  RouteInformation restoreRouteInformation(BookRoutePath path) {
    if (path.isHomePage) {
      return RouteInformation(location: '/');
    }
    if (path.isDetailsPage) {
      return RouteInformation(location: '/book/${path.id}');
    }
    return null;
  }
}

class BookRouterDelegate extends RouterDelegate<BookRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BookRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  Book _selectedBook;

  List<Book> books = [
    Book('Ход королевы', 'Уолтер Тевис', 'В восемь лет Элизабет Хармон потеряла всю семью в дорожном происшествии.Так она очутилась в сиротском приюте «Метуэн-Хоум», где вместо любви и поддержки получала лишь транквилизаторы. Но жизнь обрела смысл, когда девочка открыла для себя шахматы.',
    ),
    Book('Богатый папа, бедный папа', 'Роберт Кийосаки', 'В центре книги – история самого Кийосаки. Его воспитывали два папы. Один – бедный – государственный служащий, второй – богатый – бизнесмен, ставший одним из самых влиятельных людей на Гавайских островах. Маленький Роберт выбрал путь, предложенный Богатым папой, и добился того, что стал финансово обеспеченным человеком. И теперь он готов делиться секретами своего успеха. А они работают, ведь неслучайно его бестселлер считают обязательным чтением для миллионеров!',
    ),
    Book('Институт', 'Стивен Кинг', 'Все произошло мгновенно, за каких-то пару минут. Посреди ночи в доме на тихой улочке в пригороде Миннеаполиса неизвестные зверски убили родителей двенадцатилетнего Люка Эллиса, а его самого увезли на черном внедорожнике в неизвестном направлении. Вскоре Люк проснулся в комнате, похожей на его собственную, но без окон. Ничего удивительного, ведь это вовсе не родной дом мальчика. Это… Институт..',
    ),
    Book('Женщина, у которой есть план: правила счастливой жизни', 'Мэй Маск', 'Перед вами увлекательная и откровенная биография канадско-южноафриканской модели Мэй Маск. Эта удивительная, сильная и независимая женщина – не только одна из самых известных в мире «возрастных» фотомоделей, но еще и дипломированный диетолог с многолетней успешной практикой и мама знаменитого американского предпринимателя и инженера Илона Маска! Жизненный путь Мэй Маск похож на невероятный сценарий: несмотря на множество преград и трудностей, она смогла буквально… все! Она прожила семь десятков лет, добилась успехов в карьере (причем, занималась не одним делом), вырастила троих детей и одиннадцать внуков. Сейчас Мэй востребована в качестве модели и эксперта по ЗОЖ больше, чем когда-либо в жизни.',
    ),
    Book('Ведьмак', 'Анджей Сапковский', 'Геральт из Ривии – ведьмак, один из немногих представителей некогда большого и могущественного дома борцов с нечистью. Он один из лучших в своем деле, с детства наученный убивать упырей, ведьм, леших и всех, кто так или иначе угрожает людям. Но делает он это вовсе не из добрых побуждений. Ведьмак – это работа. А за работу, как известно, нужно платить. И не важно, требуется убить стрыгу в склепе или участвовать в политических интригах и человеческих войнах. Геральт знает цену собственного мастерства и своего не упустит.',
    ),
    Book('Портрет Дориана Грея', 'Оскар Уайльд', 'Юный красавец Дориан Грей приезжает в Лондон и окунается в бездну низменных страстей и преступлений. Известный художник пишет портрет Дориана Грея, и молодой человек страстно влюбляется в собственное изображение – ведь оно навек сохранит красоту юности! Однако выходит иначе: порочные страсти не оставляют никакого следа на юном лице Дориана, зато портрет страшно меняется с каждым новым преступлением своего хозяина – ведь душа Дориана Грея, воплощенная в портрете, становится все более порочной и растленной…',
    ),
    Book('1984', 'Джордж Оруэлл', 'Своеобразный антипод второй великой антиутопии XX века – «О дивный новый мир» Олдоса Хаксли. Что, в сущности, страшнее: доведенное до абсурда «общество потребления» – или доведенное до абсолюта «общество идеи»? По Оруэллу, нет и не может быть ничего ужаснее тотальной несвободы…',
    ),
    Book('Я – легенда (сборник)', 'Ричард Матесон', '«Я – легенда» Ричарда Матесона – книга поистине легендарная, как легендарно имя ее создателя. Роман породил целое направление в литературе, из него выросли такие мощные фигуры современного литературного мира, как Рэй Брэдбери, Стивен Кинг… – двух этих имен достаточно для оценки силы влияния. Лучшие режиссеры планеты – Стивен Спилберг, Роджер Корман и другие – поставили фильмы по произведениям Матесона.',
    ),
    Book('451 градус по Фаренгейту', 'Рэй Брэдбери', '451° по Фаренгейту – температура, при которой воспламеняется и горит бумага. Философская антиутопия Брэдбери рисует беспросветную картину развития постиндустриального общества: это мир будущего, в котором все письменные издания безжалостно уничтожаются специальным отрядом пожарных, а хранение книг преследуется по закону, интерактивное телевидение успешно служит всеобщему оболваниванию, карательная психиатрия решительно разбирается с редкими инакомыслящими, а на охоту за неисправимыми диссидентами выходит электрический пес… Роман, принесший своему творцу мировую известность.',
    ),
    Book(' Гордость и предубеждение', 'Джейн Остин', 'В начале XIX века английская писательница Джейн Остен (1775–1817) писала свои романы с изяществом, глубиной и мудростью, которые избавили жанр романа от клейма «несерьезности» и научили многие поколения читателей и писателей тому, что книге, чтобы быть глубокой, не требуется напыщенная монументальность. Иронизируя, Джейн Остен превращала повседневность в книги. На протяжении уже двух столетий с ней – автором и персонажем истории мировой литературы – сверяют себя и читатели, и писатели.',
    ),
    Book('Десять негритят', 'Агата Кристи', 'Агата Кристи – самый публикуемый автор всех времен и народов после Шекспира. Тиражи ее книг уступают только тиражам его произведений и Библии. В мире продано больше миллиарда книг Кристи на английском языке и столько же – на других языках. Она автор восьмидесяти детективных романов и сборников рассказов, двадцати пьес, двух книг воспоминаний и шести психологических романов, написанных под псевдонимом Мэри Уэстмакотт. Ее персонажи Эркюль Пуаро и мисс Марпл навсегда стали образцовыми героями остросюжетного жанра.',
    ),

  ];

  BookRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  BookRoutePath get currentConfiguration => _selectedBook == null
      ? BookRoutePath.home()
      : BookRoutePath.details(books.indexOf(_selectedBook));

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      transitionDelegate: NoAnimationTransitionDelegate(),
      pages: [
        MaterialPage(
          key: ValueKey('BooksListPage'),
          child: BooksListScreen(
            books: books,
            onTapped: _handleBookTapped,
          ),
        ),
        if (_selectedBook != null) BookDetailsPage(book: _selectedBook)
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        // Update the list of pages by setting _selectedBook to null
        _selectedBook = null;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(BookRoutePath path) async {
    if (path.isDetailsPage) {
      _selectedBook = books[path.id];
    }
  }

  void _handleBookTapped(Book book) {
    _selectedBook = book;
    notifyListeners();
  }
}

class BookDetailsPage extends Page {
  final Book book;

  BookDetailsPage({
    this.book,
  }) : super(key: ValueKey(book));

  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return BookDetailsScreen(book: book);
      },
    );
  }
}

class BookRoutePath {
  final int id;

  BookRoutePath.home() : id = null;

  BookRoutePath.details(this.id);

  bool get isHomePage => id == null;

  bool get isDetailsPage => id != null;
}

class BooksListScreen extends StatelessWidget {
  final List<Book> books;
  final ValueChanged<Book> onTapped;

  BooksListScreen({
    @required this.books,
    @required this.onTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Популярные книги'),
      ),
      body: ListView(
        children: [
          for (var book in books)
            ListTile(
              title: Text(book.title),
              subtitle: Text(book.author),
              onTap: () => onTapped(book),
            )
        ],
      ),
    );
  }
}

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  BookDetailsScreen({
    @required this.book,
  });

  @override
  Widget build(BuildContext context) {
    final _sizeTextTitle = const TextStyle(fontSize: 25.0, color: Color(0xFF155E7D), fontWeight: FontWeight.bold, fontFamily: 'Hind',);
    final _sizeTextDescription = const TextStyle(fontSize: 15.0, fontFamily: 'Hind',);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (book != null) ...[

              Text(book.title, style:  _sizeTextTitle),
              Text(book.author, style: Theme.of(context).textTheme.subtitle1),
              Container(
                margin: const EdgeInsets.only(top: 10),),
              Text(book.description, style: _sizeTextDescription,),

            ],
          ],
        ),
      ),
    );
  }
}

class NoAnimationTransitionDelegate extends TransitionDelegate<void> {
  @override
  Iterable<RouteTransitionRecord> resolve({
    List<RouteTransitionRecord> newPageRouteHistory,
    Map<RouteTransitionRecord, RouteTransitionRecord>
    locationToExitingPageRoute,
    Map<RouteTransitionRecord, List<RouteTransitionRecord>>
    pageRouteToPagelessRoutes,
  }) {
    final results = <RouteTransitionRecord>[];

    for (final pageRoute in newPageRouteHistory) {
      if (pageRoute.isWaitingForEnteringDecision) {
        pageRoute.markForAdd();
      }
      results.add(pageRoute);
    }

    for (final exitingPageRoute in locationToExitingPageRoute.values) {
      if (exitingPageRoute.isWaitingForExitingDecision) {
        exitingPageRoute.markForRemove();
        final pagelessRoutes = pageRouteToPagelessRoutes[exitingPageRoute];
        if (pagelessRoutes != null) {
          for (final pagelessRoute in pagelessRoutes) {
            pagelessRoute.markForRemove();
          }
        }
      }

      results.add(exitingPageRoute);
    }
    return results;
  }
}
