import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/auth_controller.dart';
import 'package:lists/controllers/dashboard_controller.dart';
import 'package:lists/controllers/recipes_controller.dart';
import 'package:lists/controllers/items_controller.dart';
import 'package:lists/controllers/settings_controller.dart';
import 'package:lists/controllers/units_controller.dart';
import 'package:lists/views/profile.dart';
import 'package:lists/views/recipes_page.dart';
import 'package:lists/views/settings.dart';
import 'package:lists/views/shopping_list.dart';

class DashboardPage extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    Get.lazyPut<ItemsController>(() => ItemsController(tag: 'shoppingList'), tag: 'shoppingList');
    Get.lazyPut<RecipesController>(() => RecipesController());

    Get.put<UnitsController>(UnitsController());
    Get.lazyPut<SettingsController>(() => SettingsController());
    // Create empty controllers

    return SafeArea(
      child: Scaffold(
        drawer: SafeArea(
          top: false,
          child: Drawer(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                DrawerHeader(
                    padding: EdgeInsets.all(0),
                    child: Container(
                      color: Get.theme.dialogBackgroundColor,
                      child: Center(
                        child: Text(
                          'Shopping List',
                          style: TextStyle(fontSize: 30, color: Get.theme.textTheme.bodyText1!.color),
                        ),
                      ),
                    )),
                ListTile(
                    onTap: () => Get.to(() => Profile()),
                    title: Text(
                      'Profile',
                      style: TextStyle(
                        color: Get.theme.textTheme.bodyText2!.color,
                        fontSize: 16,
                      ),
                    ),
                    leading: Icon(
                      Icons.person,
                      color: Get.theme.textTheme.bodyText2!.color,
                    )),
                ListTile(
                  onTap: () => Get.snackbar(
                    'Unimplimented',
                    'Shared lists is not yet implemented',
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Get.theme.bottomNavigationBarTheme.unselectedItemColor,
                  ),
                  title: Text(
                    'Shared Lists',
                    style: TextStyle(
                      color: Get.theme.textTheme.bodyText2!.color,
                      fontSize: 16,
                    ),
                  ),
                  leading: Icon(
                    Icons.group,
                    color: Get.theme.textTheme.bodyText2!.color,
                  ),
                ),
                ListTile(
                  // onTap: () => Get.snackbar(
                  //   'Unimplimented',
                  //   'Settings is not yet implemented',
                  //   snackPosition: SnackPosition.BOTTOM,
                  //   colorText: Get.theme.bottomNavigationBarTheme.unselectedItemColor,
                  // ),
                  onTap: () => Get.to(() => SettingsPage()),
                  title: Text(
                    'Settings',
                    style: TextStyle(
                      color: Get.theme.textTheme.bodyText2!.color,
                      fontSize: 16,
                    ),
                  ),
                  leading: Icon(
                    Icons.settings,
                    color: Get.theme.textTheme.bodyText2!.color,
                  ),
                ),
                ListTile(
                  onTap: () => AuthController().signOut(),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: Get.theme.errorColor,
                      fontSize: 16,
                    ),
                  ),
                  leading: Icon(
                    Icons.logout,
                    color: Get.theme.errorColor,
                  ),
                )
              ],
            ),
          ),
        ),
        body: PageView(
          controller: controller,
          onPageChanged: (page) => controller.pageIndex.value = page,
          children: [
            ShoppingList(),
            RecipesPage(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              controller.page == 0
                  ? Get.find<ItemsController>(tag: 'shoppingList').createItem()
                  : Get.find<RecipesController>().createRecipe();
            },
            child: Icon(Icons.add)),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () => controller.jumpToPage(0),
                  icon: Icon(
                    Icons.shopping_cart,
                    color: controller.pageIndex.value == 0
                        ? Get.theme.bottomNavigationBarTheme.selectedItemColor!
                        : Get.theme.bottomNavigationBarTheme.unselectedItemColor!,
                  ),
                ),
                IconButton(
                  color: controller.pageIndex.value == 0
                      ? Get.theme.bottomNavigationBarTheme.unselectedItemColor!
                      : Get.theme.bottomNavigationBarTheme.selectedItemColor!,
                  onPressed: () => controller.jumpToPage(1),
                  icon: Icon(Icons.book),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
