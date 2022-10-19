import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/models/item.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/views/recipe_form.dart';

class RecipesController extends GetxController {
  late DatabaseReference database;
  String user;

  RxList<Recipe> recipes = RxList<Recipe>([]);

  RxBool editMode = RxBool(false);
  RxInt selectedIndex = RxInt(0);

  RecipesController({required this.user});

  @override
  void onInit() {
    database = FirebaseDatabase.instance.ref('$user/recipes');
    _activateListeners();
    super.onInit();
  }

  void _activateListeners() {
    database.onChildAdded.listen((event) {
      Recipe recipe = Recipe.fromJson(event.snapshot.value as Map);
      recipes.add(recipe);
    });

    database.onChildChanged.listen((event) {
      Recipe databaseRecipe = Recipe.fromJson(event.snapshot.value as Map);
      int index = recipes.indexWhere((Recipe recipe) => recipe.id == databaseRecipe.id);
      recipes[index] = databaseRecipe;
    });
  }

  void uncheck(Item item) {}

  void createRecipe() async {
    Recipe? recipe = await Get.dialog(RecipeForm());

    if (recipe != null) {
      recipes.add(recipe);
      updateStorage(recipe);
    }
  }

  void updateStorage(Recipe recipe) {
    String id = recipe.id;
    final recipeRef = database.child(id);
    Map<String, dynamic> jsonItem = recipe.toJson();
    recipeRef.set(jsonItem);
  }

  void removeRecipe(Recipe recipe) {
    database.child(recipe.id).remove();
    recipes.removeWhere((element) => element.id == recipe.id);
  }

  void storeLocally(Recipe recipe) async {
    DatabaseReference localDatabase =
        FirebaseDatabase.instance.ref('${FirebaseAuth.instance.currentUser!.uid}/recipes');

    DatabaseReference recipeReference = database.child(recipe.id);
    DatabaseReference stepsReference = recipeReference.child('steps');
    DatabaseReference ingredientsReference = recipeReference.child('ingredients');

    DatabaseReference localRecipeReference = localDatabase.child(recipe.id);
    DatabaseReference localStepsReference = localRecipeReference.child('steps');
    DatabaseReference localIngredientsReference = localRecipeReference.child('ingredients');

    localRecipeReference.set(recipe.toJson());

    ingredientsReference.get().then((ingredients) => localIngredientsReference.set(ingredients.value as Map));

    stepsReference.get().then((steps) => localStepsReference.set(steps.value));
  }
}
