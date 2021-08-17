import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/Models/Recipes/newStep.dart';
import 'package:lists/Pages/Dashboard.dart';
import 'package:lists/Pages/Recipes/UploadImage.dart';
import 'package:lists/Pages/login.dart';
import 'package:lists/Pages/Items/newItem.dart';
import 'package:lists/Pages/Recipes/newRecipe.dart';
import 'package:lists/Pages/newUnit.dart';
import 'package:lists/Pages/shoppingList.dart';
import 'package:lists/controllers/Dashboard.dart';
import 'package:lists/controllers/Items/Item.dart';
import 'package:lists/controllers/Recipes/Recipe.dart';
import 'package:lists/controllers/Recipes/Recipes.dart';
import 'package:lists/controllers/shoppingList.dart';

import 'Themes/custom_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final appdata = GetStorage();
  @override
  Widget build(BuildContext context) {
    appdata.writeIfNull('darkmode', false);
    return SimpleBuilder(builder: (_) {
      bool isDarkMode = appdata.read('darkmode');
      return GetMaterialApp(
        theme: isDarkMode ? CustomTheme().darkTheme : CustomTheme().lightTheme,
        initialRoute: '/dashboard',
        getPages: [
          GetPage(
            name: '/dashboard',
            page: () => DashboardPage(),
            binding: DashboardBinding(),
          ),
          GetPage(
            name: '/shoppingList/newItem',
            page: () => NewItem(),
            binding: NewItemBinding(),
            opaque: false,
          ),
          GetPage(
            name: '/RecipeList/newRecipe',
            page: () => NewRecipe(),
            binding: NewRecipeBinding(),
            opaque: false,
          ),
          GetPage(
            name: '/RecipeList/Recipe/newStep',
            page: () => NewStep(),
            opaque: false,
          ),
          GetPage(
            name: '/NewUnit',
            page: () => NewUnit(),
            opaque: false,
          ),
          GetPage(
            name: '/RecipeList/Recipe/AddImage',
            page: () => UploadImage(),
            opaque: true,
          )
        ],
      );
    });
  }

  void toggleTheme() {
    appdata.write('darkmode', !appdata.read('darkmode'));
    Get.changeTheme(appdata.read('darkmode')
        ? CustomTheme().darkTheme
        : CustomTheme().lightTheme);
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool signedIn = false;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) signedIn = true;
    });
    if (signedIn)
      return ShoppingList();
    else
      return LoginPage();
  }
}

class NewItemBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ItemController(null));
  }
}

class NewRecipeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RecipeController());
  }
}

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
    Get.put(SLController());
    Get.put(RecipesController());
  }
}
