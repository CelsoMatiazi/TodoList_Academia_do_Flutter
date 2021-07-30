import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_af/app/database/connection.dart';
import 'app/modules/home/home_controller.dart';
import 'app/modules/home/home_page.dart';
import 'app/modules/new_task/new_task_controller.dart';
import 'app/modules/new_task/new_task_page.dart';
import 'app/repositories/todos_repository.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver{


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    var connection = Connection();
    switch(state){
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        connection.closeConnection();
        break;
      case AppLifecycleState.paused:
        connection.closeConnection();
        break;
      case AppLifecycleState.detached:
        connection.closeConnection();
        break;
    }
    super.didChangeAppLifecycleState(state);
  }


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => TodosRepository()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo List',
        theme: ThemeData(
          primaryColor: Colors.amber[800],
          buttonColor: Colors.amber[800],
          textTheme: GoogleFonts.robotoTextTheme(),
        ),

        routes: {
          NewTaskPage.routerName : (_) => ChangeNotifierProvider(
              create: (context) {
                var day = ModalRoute.of(_)!.settings.arguments;

                return NewTaskController(repository: context.read<TodosRepository>(), day: day.toString());
              },
            child: NewTaskPage(),
          )
        },

        home: ChangeNotifierProvider(
          create: (context) {
            //var repository = Provider.of<TodoRepository>(context);
            var repository = context.read<TodosRepository>();
            return HomeController(repository: repository);
          },
            child: HomePage()
        ),
      ),
    );
  }
}

