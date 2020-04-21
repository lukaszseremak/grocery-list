import 'package:flutter/material.dart';

Image createImage(String path) {
  return Image.asset(
    path,
    cacheWidth: 250,
    cacheHeight: 250,
  );
}

Image dedaultCategoryImage = createImage("assets/images/categories/fruits.jpg");

Map<String, Image> categoryNameImageMapping = {
  "Fruits": createImage("assets/images/categories/fruits.jpg"),
  "Vegetables": createImage("assets/images/categories/fruits.jpg"),
  "Bread": createImage("assets/images/categories/fruits.jpg"),
  "Pasta & Ceral": createImage("assets/images/categories/fruits.jpg"),
  "Spices": createImage("assets/images/categories/fruits.jpg"),
  "Snacks & Sweets": createImage("assets/images/categories/fruits.jpg"),
  "Meat & Fish": createImage("assets/images/categories/fruits.jpg"),
  "Diary": createImage("assets/images/categories/fruits.jpg"),
  "Beverages": createImage("assets/images/categories/fruits.jpg"),
  "Detergent": createImage("assets/images/categories/fruits.jpg"),
  "Cosmetics": createImage("assets/images/categories/fruits.jpg"),
  "Others": createImage("assets/images/categories/fruits.jpg"),
};
