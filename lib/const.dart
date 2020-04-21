import 'package:flutter/material.dart';

Image createImage(String path) {
  return Image.asset(
    path,
    cacheWidth: 250,
    cacheHeight: 250,
  );
}

Image defaultCategoryImage =
    createImage("assets/images/categories/not_found.png");

Map<String, Image> categoryNameImageMapping = {
  "Fruits": createImage("assets/images/categories/fruits.png"),
  "Vegetables": createImage("assets/images/categories/vegetables.png"),
  "Bread": createImage("assets/images/categories/bread.png"),
  "Pasta & Ceral": createImage("assets/images/categories/pasta_and_cereal.png"),
  "Spices": createImage("assets/images/categories/spicies.png"),
  "Snacks & Sweets":
      createImage("assets/images/categories/snack_and_sweets.png"),
  "Meat & Fish": createImage("assets/images/categories/meat_and_fish.png"),
  "Diary": createImage("assets/images/categories/diary.png"),
  "Beverages": createImage("assets/images/categories/beverages.png"),
  "Detergent": createImage("assets/images/categories/detergents.png"),
  "Cosmetics": createImage("assets/images/categories/cosmetics.png"),
  "Others": createImage("assets/images/categories/others.png"),
};
