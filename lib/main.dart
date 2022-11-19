import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luciddreams/bloc/auth/auth_cubit.dart';
import 'package:luciddreams/common/loading_status.dart';
import 'package:luciddreams/ui/auth/login.dart';
import 'package:luciddreams/ui/editor.dart';
import 'package:luciddreams/ui/image_browser.dart';
import 'package:luciddreams/ui/txt2img.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthCubit _authCubit = AuthCubit();

  @override
  void initState() {
    super.initState();
    _authCubit.autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _authCubit,
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: "/",
          routes: {
            // When navigating to the "/" route, build the FirstScreen widget.
            "/ImageBrowser": (final context) => const ImageBrowser(),
            // When navigating to the "/second" route, build the SecondScreen widget.
            "/txt2img": (final context) => const Txt2img(),
          },
          home: BlocBuilder<AuthCubit, AuthState>(
            builder: ((context, state) {
              if (state.loadingStatus is LoadingInProgress) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (state.loggedIn) {
                  return MainScreen();
                } else {
                  return LoginScreen();
                }
              }
            }),
          ),
        ));
  }
}

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PersistentTabController? _controller;
  bool? _hideNavBar;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;
  }

  List<Widget> _buildScreens() {
    return [
      Editor(),
      ImageBrowser(),
      ImageBrowser(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.flare),
        title: "Dream",
        activeColorPrimary: Colors.teal,
        inactiveColorPrimary: Colors.grey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {
            '/first': (context) => ImageBrowser(),
            '/second': (context) => ImageBrowser(),
          },
        ),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.image),
        title: "Gallery",
        activeColorPrimary: Colors.teal,
        inactiveColorPrimary: Colors.grey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {
            '/first': (context) => ImageBrowser(),
            '/second': (context) => ImageBrowser(),
          },
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.search),
        title: "Search",
        activeColorPrimary: Colors.teal,
        inactiveColorPrimary: Colors.grey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {
            '/first': (context) => ImageBrowser(),
            '/second': (context) => ImageBrowser(),
          },
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      navBarHeight: kBottomNavigationBarHeight,
      hideNavigationBarWhenKeyboardShows: true,
      margin: EdgeInsets.all(0.0),
      popActionScreens: PopActionScreensType.all,
      bottomScreenMargin: 0.0,
      onWillPop: (context) async {
        await showDialog(
          context: context!,
          useSafeArea: true,
          builder: (context) => Container(
            height: 50.0,
            width: 50.0,
            color: Colors.white,
            child: ElevatedButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        );
        return false;
      },
      hideNavigationBar: _hideNavBar,

      popAllScreensOnTapOfSelectedTab: true,
      itemAnimationProperties: ItemAnimationProperties(
        duration: Duration(milliseconds: 400),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style6, // Choose the nav bar style with this property
    );
  }
}
